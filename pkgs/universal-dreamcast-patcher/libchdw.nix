{ lib
, stdenv
, cmake
, fetchFromGitHub
  # The Universal Dreamcast Patcher source tree, which holds the C ABI itself
  # under `native/libchdw/`
, patcherSrc
, version
}:

# `libchdw_api.cpp` is upstream's C ABI over MAME's `chd_file_compressor`, so
# it has to be compiled against that tree. Upstream does this by hand and
# commits the result; `native/libchdw/build-libchdw.sh` is the same build, run
# here instead

stdenv.mkDerivation {
  pname = "libchdw";
  inherit version;

  # MAME 0.238 reduced to a standalone CMake build of chdman, the tree that
  # `build-libchdw.sh` clones. It carries no tags, so the revision upstream
  # built against is pinned by hash
  src = fetchFromGitHub {
    owner = "charlesthobe";
    repo = "chdman";
    rev = "64e7213902c24e02f44ff9c3cf66ac8c4a8fdc05";
    hash = "sha256-yo6eqcysZanfxTF78A9H8MIms9dr7JGAAT0nJifWeWk=";
  };

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
    (lib.cmakeFeature "LIBCHDW_SOURCE_DIR" "${patcherSrc}/native/libchdw")
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
}
