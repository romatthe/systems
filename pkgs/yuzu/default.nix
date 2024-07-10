{ lib
, stdenv
, fetchurl
, fetchzip
# , wrapQtAppsHook
, autoconf
, boost
, catch2_3
, cmake
, cpp-jwt
, cubeb
, discord-rpc
, enet
, fmt
, glslang
, libopus
, libusb1
, libva
, lz4
, nlohmann_json
, nv-codec-headers-12
, pkg-config
, qt6
# , qtbase
# , qtmultimedia
# , qttools
# , qtwayland
# , qtwebengine
, SDL2
, unzip
, vulkan-headers
, vulkan-loader
, yasm
, zlib
, zstd
}:

let
  compat-list = stdenv.mkDerivation {
    pname = "compat-list";
    version = "unstable-2024-03-04";

    src = ./compatibility_list.zip;

    nativeBuildInputs = [ unzip ];

    buildCommand = ''
      unzip $src -d $out
    '';
  };
  nx-tzdb = stdenv.mkDerivation rec {
    pname = "nx-tzdb";
    version = "221202";

    src = fetchurl {
      url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/${version}/${version}.zip";
      hash = "sha256-mRzW+iIwrU1zsxHmf+0RArU8BShAoEMvCz+McXFFK3c=";
    };

    nativeBuildInputs = [ unzip ];

    buildCommand = ''
      unzip $src -d $out
    '';
  };
in
  stdenv.mkDerivation(finalAttrs: {
    pname = "yuzu";
    version = "1734";

    src = fetchurl {
      url = "https://archive.softwareheritage.org/api/1/vault/flat/swh:1:dir:e75e9e2441dc3f8657cc42f2daaae08737949c2b/raw/";
      hash = "sha256-dVOX3PbR6rQT7vslj8m6Je0twwlM0WK1LCvvdqZkLoU=";
      postFetch = ''
        ls -lah .
        mv raw source.tar.gz
      '';
    };

    preUnpack = ''
      ls -lah .
      mv raw source.tar.gz
    '';

    setSourceRoot = "sourceRoot=$(echo ./*)";

    nativeBuildInputs = [
      cmake
      glslang
      pkg-config
      qt6.qttools
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      # vulkan-headers must come first, so the older propagated versions
      # don't get picked up by accident
      vulkan-headers

      boost
      catch2_3
      cpp-jwt
      cubeb
      discord-rpc
      # intentionally omitted: dynarmic - prefer vendored version for compatibility
      enet

      # vendored ffmpeg deps
      autoconf
      yasm
      libva  # for accelerated video decode on non-nvidia
      nv-codec-headers-12  # for accelerated video decode on nvidia
      # end vendored ffmpeg deps

      fmt
      # intentionally omitted: gamemode - loaded dynamically at runtime
      # intentionally omitted: httplib - upstream requires an older version than what we have
      libopus
      libusb1
      # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
      lz4
      nlohmann_json
      qt6.qtbase
      qt6.qtmultimedia
      qt6.qtwayland
      qt6.qtwebengine
      # intentionally omitted: renderdoc - heavy, developer only
      SDL2
      # not packaged in nixpkgs: simpleini
      # intentionally omitted: stb - header only libraries, vendor uses git snapshot
      # not packaged in nixpkgs: vulkan-memory-allocator
      # intentionally omitted: xbyak - prefer vendored version for compatibility
      zlib
      zstd
    ];

    # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
    # making the build fail, as that path does not exist
    dontFixCmake = true;

    cmakeFlags = [
      # actually has a noticeable performance impact
      "-DYUZU_ENABLE_LTO=ON"

      # build with qt6
      "-DENABLE_QT6=ON"
      "-DENABLE_QT_TRANSLATION=ON"

      # use system libraries
      # NB: "external" here means "from the externals/ directory in the source",
      # so "off" means "use system"
      "-DYUZU_USE_EXTERNAL_SDL2=OFF"
      "-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF"

      # don't use system ffmpeg, yuzu uses internal APIs
      "-DYUZU_USE_BUNDLED_FFMPEG=ON"

      # don't check for missing submodules
      "-DYUZU_CHECK_SUBMODULES=OFF"

      # enable some optional features
      "-DYUZU_USE_QT_WEB_ENGINE=ON"
      "-DYUZU_USE_QT_MULTIMEDIA=ON"
      "-DUSE_DISCORD_PRESENCE=ON"

      # We dont want to bother upstream with potentially outdated compat reports
      "-DYUZU_ENABLE_COMPATIBILITY_REPORTING=OFF"
      "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
    ];

    # Does some handrolled SIMD
    env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

    # Fixes vulkan detection.
    # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
    qtWrapperArgs = [
      "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
    ];

    preConfigure = ''
      # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
      cmakeFlagsArray+=(
        "-DTITLE_BAR_FORMAT_IDLE=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) {}"
        "-DTITLE_BAR_FORMAT_RUNNING=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) | {}"
      )

      # provide pre-downloaded tz data
      mkdir -p build/externals/nx_tzdb
      ln -s ${nx-tzdb} build/externals/nx_tzdb/nx_tzdb
    '';

    # This must be done after cmake finishes as it overwrites the file
    postConfigure = ''
      ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
    '';

    postInstall = ''
      install -Dm444 $src/dist/72-yuzu-input.rules $out/lib/udev/rules.d/72-yuzu-input.rules
    '';

    meta = with lib; {
      homepage = "https://yuzu-emu.org";
      changelog = "https://yuzu-emu.org/entry";
      description = "An experimental Nintendo Switch emulator written in C++";
      longDescription = ''
        An experimental Nintendo Switch emulator written in C++.
        Using the mainline branch is recommended for general usage.
        Using the early-access branch is recommended if you would like to try out experimental features, with a cost of stability.
      '';
      mainProgram = "yuzu";
      platforms = [ "aarch64-linux" "x86_64-linux" ];
      license = with licenses; [
        gpl3Plus
        # Icons
        asl20 mit cc0
      ];
      maintainers = with maintainers; [
        
      ];
    };
})
