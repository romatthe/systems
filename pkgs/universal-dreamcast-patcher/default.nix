{ lib
, stdenv
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, autoPatchelfHook
, cmake
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

  # `native/` in the application's own tree carries the sources for the two
  # libraries it P/Invokes that are not packaged anywhere else
  native = "${src}/native";

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

  # MAME 0.238 reduced to a standalone CMake build of chdman, which is the tree
  # `native/libchdw/build-libchdw.sh` clones. It carries no tags, so the
  # revision upstream built against is pinned by hash
  chdman = fetchFromGitHub {
    owner = "charlesthobe";
    repo = "chdman";
    rev = "64e7213902c24e02f44ff9c3cf66ac8c4a8fdc05";
    hash = "sha256-yo6eqcysZanfxTF78A9H8MIms9dr7JGAAT0nJifWeWk=";
  };

  # `libchdw_api.cpp` is upstream's C ABI over MAME's `chd_file_compressor`, so
  # it has to be compiled against that tree. Upstream does this by hand and
  # commits the result; `build-libchdw.sh` is the same build, run here instead
  libchdw = stdenv.mkDerivation {
    pname = "libchdw";
    inherit version;

    src = chdman;

    # The script's `#include <mutex>` fixups for `unzip.cpp` and `un7z.cpp` are
    # not applied: this revision already has them. What is left is the target
    # definition, reduced to the branch that builds on Linux
    patches = [ ./libchdw-target.patch ];

    nativeBuildInputs = [ cmake ];

    # expat, 7-Zip, zlib, FLAC and utf8proc are all vendored under `3rdparty/`.
    # They build as static libraries, so the position independent code flag has
    # to be set for the whole project before the shared `chdw` target can link
    cmakeFlags = [
      (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true)
      (lib.cmakeFeature "LIBCHDW_SOURCE_DIR" "${native}/libchdw")
    ];

    # The default target would build the chdman command line tool as well
    buildFlags = [
      "chdw"
      "chdw_smoke"
    ];

    doCheck = true;

    # Upstream's own smoke test, run over a 64 sector MODE1/2352 track. What is
    # on the track does not matter, only that the CUE parses and that the hunks
    # come back out of the codec stack, so any non-uniform filler will do
    checkPhase = ''
      runHook preCheck

      seq 0 40000 > filler
      head -c 150528 filler > track01.bin
      printf 'FILE "track01.bin" BINARY\n  TRACK 01 MODE1/2352\n    INDEX 01 00:00:00\n' > track01.cue
      ./chdw_smoke track01.cue track01.chd

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      install -Dm555 -t $out/lib libchdw.so
      runHook postInstall
    '';

    meta = {
      description = "CHD writer of MAME 0.238 as a shared library, for Universal Dreamcast Patcher";
      homepage = "https://github.com/charlesthobe/chdman";
      # MAME is GPL-2.0-or-later, the wrapper around it comes from the
      # GPL-3.0-only application
      license = with lib.licenses; [
        gpl2Plus
        gpl3Only
      ];
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
  # build of rtissera/libchdr, so nixpkgs' own serves, and the other two are
  # built from source above
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
