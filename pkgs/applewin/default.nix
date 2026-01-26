{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, lerc
, libdeflate
, libevdev
, libglvnd
, libjpeg
, libpcap
, libslirp
, libtiff
, libwebp
, libX11
, SDL2
, SDL2_image
, tinyxxd
, xz
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "AppleWin";
  version = "unstable-2026-01-18";
  
  src = fetchFromGitHub {
    owner = "audetto";
    repo = pname;
    rev = "60df032b933db97e253c6f5948eea9ee895e25a0";
    hash = "sha256-lMu+OGEB/k7zjCBBqz6I8KVyhxgYM6EQTj+8pfd18Ow=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DBUILD_APPLEN=OFF"
    "-DBUILD_QAPPLE=OFF"
    "-DBUILD_LIBRETRO=OFF"
    "-DBUILD_SA2=ON" 
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    tinyxxd
  ];

  buildInputs = [
    lerc
    libdeflate
    libevdev
    libglvnd
    libjpeg
    libpcap
    libslirp
    libtiff
    libwebp
    libX11
    SDL2
    SDL2_image
    xz
    zlib
    zstd
  ];

  postPatch = ''
    # Resolve issues finding libslirp
    sed -i 's/pkg_search_module(SLIRP slirp)/find_package(libslirp CONFIG QUIET)/' \
      source/CMakeLists.txt

    sed -i 's/SLIRP_FOUND/libslirp_FOUND/g' \
      source/CMakeLists.txt

    # Change argument group name from `sa2` to `sdl`
    sed -i 's|{"sa2",|{"sdl",|g' \
      source/frontends/common2/argparser.cpp

    # Change binary name from `sa2` to `applewin`
    sed -i 's|^add_executable(sa2)$|add_executable(sa2)\n\nset_target_properties(sa2 PROPERTIES\n    OUTPUT_NAME "applewin"\n)|' source/frontends/sdl/CMakeLists.txt
  '';
}