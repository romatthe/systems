{ lib
, callPackage
, cmake
, cubeb
, curl
, extra-cmake-modules
, fetchFromGitHub
, ffmpeg
, libXrandr
, libaio
, libbacktrace
, libpcap
, libwebp
, llvmPackages
, lz4
, makeWrapper
, pkg-config
, qt6
, SDL2
, shaderc
, soundtouch
, strip-nondeterminism
, vulkan-headers
, vulkan-loader
, wayland
, zip
, zstd
}:  

let
  inherit (qt6) qtbase qtsvg qttools qtwayland wrapQtAppsHook;
in
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "pcsx2-pgs";
  version = "2.5.216";

  srcs = [
    (fetchFromGitHub {
      owner = "romatthe";
      repo = "pcsx2-pgs";
      rev = "v2.5.216-pgs";
      name = "pcsx2";
      hash = "sha256-Vt9sgK5QnU4zMIPHuvXnVTrChYacgETWcue+N5I8eD8=";
      fetchSubmodules = true;
    })
    (fetchFromGitHub {
      owner = "PCSX2";
      repo = "pcsx2_patches";
      rev = "5cc1d09a72c0afcd04e2ca089a6b279108328fda";
      name = "pcsx2_patches";
      hash = "sha256-or77ZsWU0YWtxj9LKJ/m8nDvKSyiF1sO140QaH6Jr64=";
    })
  ];

  sourceRoot = "pcsx2";

  patches = [
    # Remove PCSX2_GIT_REV
    ./0000-define-rev.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "PACKAGE_MODE" true)
    (lib.cmakeBool "DISABLE_ADVANCE_SIMD" true)
    (lib.cmakeBool "USE_LINKED_FFMPEG" true)
    (lib.cmakeFeature "PCSX2_GIT_REV" "v${finalAttrs.version}-parallel-gs")
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    strip-nondeterminism
    wrapQtAppsHook
    zip
  ];

  buildInputs = [
    curl
    extra-cmake-modules
    ffmpeg
    libaio
    libbacktrace
    libpcap
    libwebp
    libXrandr
    lz4
    qtbase
    qtsvg
    qttools
    qtwayland
    SDL2
    shaderc
    soundtouch
    vulkan-headers
    wayland
    zstd
  ] ++ cubeb.passthru.backendLibs;

  strictDeps = true;

  postInstall = ''
    install -Dm644 ../pcsx2-qt/resources/icons/AppIcon64.png $out/share/pixmaps/PCSX2.png
    install -Dm644 ../.github/workflows/scripts/linux/pcsx2-qt.desktop $out/share/applications/${finalAttrs.pname}.desktop

    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Name=PCSX2' 'Name=PCSX2 PGS'

    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Exec=pcsx2-qt' 'Exec=pcsx2-pgs'

    mkdir -p $out/share/PCSX2/resources

    zip -jq $out/share/PCSX2/resources/patches.zip ../../pcsx2_patches/patches/*
    strip-nondeterminism $out/share/PCSX2/resources/patches.zip
  '';

  qtWrapperArgs =
    let
      libs = lib.makeLibraryPath (
        [
          vulkan-loader
          shaderc
        ]
        ++ cubeb.passthru.backendLibs
      );
    in
    [ "--prefix LD_LIBRARY_PATH : ${libs}" ];

  # https://github.com/PCSX2/pcsx2/pull/10200
  # Can't avoid the double wrapping, the binary wrapper from qtWrapperArgs doesn't support --run
  postFixup = ''
    source "${makeWrapper}/nix-support/setup-hook"

    mv $out/bin/pcsx2-qt $out/bin/pcsx2-pgs

    wrapProgram $out/bin/pcsx2-pgs \
      --run 'if [[ -z $I_WANT_A_BROKEN_WAYLAND_UI ]]; then export QT_QPA_PLATFORM=xcb; fi'
  '';

  meta = {
    homepage = "https://pcsx2.net";
    description = "Playstation 2 emulator";
    longDescription = ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose is
      to emulate the PS2 hardware, using a combination of MIPS CPU Interpreters,
      Recompilers and a Virtual Machine which manages hardware states and PS2
      system memory. This allows you to play PS2 games on your PC, with many
      additional features and benefits.
    '';
    changelog = "https://github.com/PCSX2/pcsx2/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/PCSX2/pcsx2";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    mainProgram = "pcsx2-qt";
    platforms = lib.systems.inspect.patternLogicalAnd
      lib.systems.inspect.patterns.isLinux
      lib.systems.inspect.patterns.isx86_64;
  };
})
