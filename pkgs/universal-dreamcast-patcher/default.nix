{ lib
, stdenv
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, autoPatchelfHook
, callPackage
, copyDesktopItems
, libicns
, makeDesktopItem
, fontconfig
, icu
, krb5
, libchdr
, libGL
, libxcursor
, libxext
, libxi
, libxrandr
, openssl
, nix-update-script
}:

let
  pname = "universal-dreamcast-patcher";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "DerekPascarella";
    repo = "UniversalDreamcastPatcher";
    tag = version;
    hash = "sha256-Ozce0vVgK8sg+coTpRxQZ1JqIe3Tbq3nrG2q9UsvDTc=";
  };

  # The two libraries the application P/Invokes that nixpkgs has no package
  # for, both built from the sources upstream keeps under `native/`
  libchdw = callPackage ./libchdw.nix { inherit version; patcherSrc = src; };
  libxdelta3 = callPackage ./libxdelta3.nix { inherit version; patcherSrc = src; };
in

buildDotnetModule {
  inherit pname version src;

  patches = [
    # Upstream keeps `settings.json` next to the executable on Linux
    ./user-settings-dir.patch
  ];

  postPatch = ''
    # The three native libraries are consumed through `UdpNatives`, a NuGet
    # package upstream builds locally out of `native/` right before publishing
    # and fills with prebuilt binaries. They are put in the application
    # directory by hand instead, see `postInstall` below
    substituteInPlace src/UniversalDreamcastPatcher.Core/UniversalDreamcastPatcher.Core.csproj \
      --replace-fail '<PackageReference Include="UdpNatives" Version="$(NumericVersion)" />' ""
    substituteInPlace NuGet.config \
      --replace-fail '<add key="udp-local" value="_localpkg" />' ""

    # The startup update check offers to download a release over the running
    # installation, which only ever lives in the store here
    substituteInPlace src/UniversalDreamcastPatcher.App/MainWindow.axaml.cs \
      --replace-fail "_ = CheckForUpdateAsync();" "// Updates are handled by Nix."
  '';

  projectFile = "src/UniversalDreamcastPatcher.App/UniversalDreamcastPatcher.App.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  executables = [ "UniversalDreamcastPatcher" ];

  # Upstream publishes a compressed single-file bundle that extracts itself to
  # a temporary directory on every launch, which would put the native libraries
  # out of reach of `autoPatchelfHook`
  dotnetFlags = [ "-p:PublishSingleFile=false" ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    libicns
  ];

  buildInputs = [
    # `libSkiaSharp.so` arrives from NuGet with its own reference to fontconfig
    fontconfig
    # The apphost links against the usual set of .NET host dependencies
    icu
    krb5
    openssl
    (lib.getLib stdenv.cc.cc)
  ];

  # Avalonia's X11 backend resolves these by SONAME at runtime. libX11, libICE
  # and libSM are contributed by the `Avalonia.X11` package itself
  runtimeDeps = [
    libGL
    libxcursor
    libxext
    libxi
    libxrandr
  ];

  # .NET resolves `DllImport` names against the application directory, so
  # linking the libraries in there is all the `UdpNatives` package did. The
  # prebuilt copies under `runtimes/linux-x64/` go unused: libchdr is a stock
  # build of rtissera/libchdr, so nixpkgs' own serves, and the other two come
  # from the derivations beside this one
  postInstall = ''
    ln -s ${lib.getLib libchdr}/lib/libchdr.so $out/lib/${pname}/libchdr.so
    ln -s ${libchdw}/lib/libchdw.so $out/lib/${pname}/libchdw.so
    ln -s ${libxdelta3}/lib/libxdelta3.so $out/lib/${pname}/libxdelta3.so

    icns2png -x -s 256 -o . src/UniversalDreamcastPatcher.App/Assets/icon.icns
    install -Dm444 icon_256x256x32.png \
      $out/share/icons/hicolor/256x256/apps/${pname}.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Universal Dreamcast Patcher";
      comment = "Patch, convert and inspect Sega Dreamcast disc images";
      exec = "UniversalDreamcastPatcher";
      icon = pname;
      categories = [ "Utility" ];
      keywords = [ "Dreamcast" "GDI" "CDI" "CHD" "xdelta" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Patcher, patch builder, IP.BIN editor and image converter for Sega Dreamcast disc images";
    longDescription = ''
      Applies and builds xdelta3 patches for Dreamcast disc images, edits the
      IP.BIN boot sector and converts between TOSEC style GDI, Redump style
      CUE/BIN and compressed CHD, identifying discs against bundled TOSEC and
      Redump DAT files along the way.
    '';
    homepage = "https://github.com/DerekPascarella/UniversalDreamcastPatcher";
    license = lib.licenses.gpl3Only;
    mainProgram = "UniversalDreamcastPatcher";
    # `libxdelta3` hardcodes the 64 bit `SIZEOF_*` values that configure would
    # otherwise detect, and nothing but x86_64 has been exercised
    platforms = [ "x86_64-linux" ];
  };
}
