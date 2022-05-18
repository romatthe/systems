{ fetchurl, lib, p7zip, stdenv }:

stdenv.mkDerivation {
  name = "otf-apple";
  version = "1.0";

  buildInputs = [ p7zip ];
  src = [
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"; 
      sha256 = "e084f247273c91513eb4d3927a78aee5f9bfc68daf79bb33b330afcbe7ffb7dc";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg"; 
      sha256 = "9570884ee0d09b03478fdbeae96ba6c21f2c76b169f790065ee8d53ff43dacd6";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"; 
      sha256 = "6571966c11f74aa64a46ef3774fc8376f822e58d1b785bf5c2c89920e75b0d94";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg"; 
      sha256 = "7e4efceb7ba124075b0463a37dc75b5c58b39c3a543d7e3d644079edb85d0946";
    })
  ];

  sourceRoot = "./";

  preUnpack = "mkdir fonts";

  unpackCmd = ''
    7z x $curSrc >/dev/null
    dir="$(find . -not \( -path ./fonts -prune \) -type d | sed -n 2p)"
    cd $dir 2>/dev/null
    7z x *.pkg >/dev/null
    7z x Payload~ >/dev/null
    mv Library/Fonts/*.otf ../fonts/
    cd ../
    rm -R $dir
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/{SF\ Pro,SF\ Mono,SF\ Compact,New\ York}
    cp -a fonts/SF-Pro*.otf $out/share/fonts/opentype/SF\ Pro
    cp -a fonts/SF-Mono*.otf $out/share/fonts/opentype/SF\ Mono
    cp -a fonts/SF-Compact*.otf $out/share/fonts/opentype/SF\ Compact
    cp -a fonts/NewYork*.otf $out/share/fonts/opentype/New\ York
  '';
}