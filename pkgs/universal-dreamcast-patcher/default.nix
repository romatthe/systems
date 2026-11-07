{ lib
, stdenv
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, autoPatchelfHook
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
, xz
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

  # nixpkgs packages xdelta as the `xdelta3` command line tool only, so the
  # shared library the app imports is compiled here out of the xdelta3 source
  # vendored in `native/`. That tree is newer than the `xdelta` package's
  # 3.1.0 tag and is what upstream validated the P/Invoke signatures against
  libxdelta3 = stdenv.mkDerivation {
    pname = "libxdelta3";
    inherit version src;

    sourceRoot = "${src.name}/native/xdelta3";

    buildInputs = [ xz ];

    # Upstream only ships a build script for win-x64, so its macro set is
    # reused here. LZMA secondary compression has to be in, or the .xdelta
    # streams written by Universal Dreamcast Patch Builder 1.8 stop decoding;
    # upstream links it statically, this one picks up the xz from nixpkgs.
    # `SIZEOF_*` would normally come from configure, and a wrong guess trips a
    # `static_assert` in `xdelta3.h` rather than silently miscompiling
    buildPhase = ''
      runHook preBuild

      $CC -shared -fPIC -O2 -o libxdelta3.so xdelta3.c -llzma \
        -DNDEBUG=1 \
        -DSIZEOF_SIZE_T=8 \
        -DSIZEOF_UNSIGNED_LONG_LONG=8 \
        -DXD3_USE_LARGEFILE64=1 \
        -DSECONDARY_DJW=1 \
        -DSECONDARY_FGK=1 \
        -DSECONDARY_LZMA=1 \
        -DHAVE_LZMA_H=1 \
        -DEXTERNAL_COMPRESSION=0 \
        -DREGRESSION_TEST=0 \
        -DSHELL_TESTS=0 \
        -DXD3_MAIN=0

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm555 -t $out/lib libxdelta3.so
      runHook postInstall
    '';

    meta = {
      description = "xdelta3 VCDIFF codec as a shared library, for Universal Dreamcast Patcher";
      homepage = "https://github.com/jmacd/xdelta";
      license = lib.licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };
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
    # The prebuilt `libchdw.so` is C++ and wants the matching runtime
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
  # putting the libraries there is all the `UdpNatives` package did. libchdr is
  # a stock build of rtissera/libchdr, so nixpkgs' copy serves; the hardcoded
  # `chd_header` offsets in `ChdReader.cs` agree with its headers.
  #
  # libchdw stays prebuilt. It is upstream's own C ABI over the
  # `chd_file_compressor` of a MAME 0.238 chdman fork, and nothing in nixpkgs
  # exposes that as a library
  postInstall = ''
    install -Dm755 -t $out/lib/${pname} \
      src/UniversalDreamcastPatcher.Core/runtimes/linux-x64/native/libchdw.so
    ln -s ${lib.getLib libchdr}/lib/libchdr.so $out/lib/${pname}/libchdr.so
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
    # The prebuilt libchdw is only vendored for linux-x64
    platforms = [ "x86_64-linux" ];
  };
}
