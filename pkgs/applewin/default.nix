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
    sed -i 's/pkg_search_module(SLIRP slirp)/find_package(libslirp CONFIG QUIET)/' \
      source/CMakeLists.txt

    sed -i 's/SLIRP_FOUND/libslirp_FOUND/g' \
      source/CMakeLists.txt
  '';
}