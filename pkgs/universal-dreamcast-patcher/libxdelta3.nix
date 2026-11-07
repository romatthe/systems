{ lib
, stdenv
, xz
  # The Universal Dreamcast Patcher source tree, which vendors the xdelta3
  # source under `native/xdelta3/`
, patcherSrc
, version
}:

# nixpkgs packages xdelta as the `xdelta3` command line tool only, so the
# shared library the application imports is compiled here. The vendored tree is
# newer than the `xdelta` package's 3.1.0 tag and is what upstream validated
# the P/Invoke signatures against

stdenv.mkDerivation {
  pname = "libxdelta3";
  inherit version;

  src = patcherSrc;

  sourceRoot = "${patcherSrc.name}/native/xdelta3";

  buildInputs = [ xz ];

  # Upstream only ships a build script for win-x64, so its macro set is reused
  # here. LZMA secondary compression has to be in, or the .xdelta streams
  # written by Universal Dreamcast Patch Builder 1.8 stop decoding; upstream
  # links it statically, this one picks up the xz from nixpkgs. `SIZEOF_*`
  # would normally come from configure, and a wrong guess trips a
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
    # The `SIZEOF_*` values above are hardcoded for a 64 bit target, and
    # nothing but x86_64 has been exercised
    platforms = [ "x86_64-linux" ];
  };
}
