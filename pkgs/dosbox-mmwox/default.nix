{ lib
, stdenv
, dosbox-staging
, imagemagick
, innoextract
, nuked-sc55
, requireFile
, writeShellScript
, installer ? requireFile {
    name = "setup_might_and_magic_4-5_-_world_of_xeen_1.0.exe";
    message = ''
      This nix expression requires that the GOG World of Xeen installer 
      "setup_might_and_magic_4-5_-_world_of_xeen_1.0_(28066).exe" is already 
      part of the nix store. To get this file, download it from GOG's website
      and add it to the nix store with "nix-store --add-fixed sha256 <FILE>".
    '';
    sha256 = "e7153462c19b4a6750b01c8574e3dd159cdba4e60307ff46611e41fe1def4f2b";
  }
}:
let
  launcher = writeShellScript "dosbox-launch-mmwox" ''
    ${nuked-sc55} -i -p0:128 -gs & pid_nuked=$!
    sleep 2
    ${dosbox-staging} --working-dir @out@/share/mmwox & pid_dosbox=$!
    wait $pid_dosbox
    kill $pid_nuked
  '';
in stdenv.mkDerivation {
  pname = "dosbox-mmwox";
  version = "1.0.0";

  src = installer;

  dontUnpack = true;

  nativeBuildInputs = [
    innoextract
  ];

  buildPhase = ''
    echo $src
    ls -lah $src

    innoextract $src

    mv GAME1.GOG XEEN1.BIN
    mv GAME1.INS XEEN1.CUE
    mv GAME2.GOG XEEN2.BIN
    mv GAME2.INS XEEN2.CUE

    substituteInPlace XEEN1.CUE \
      --replace "game1.gog" "XEEN1.BIN"
    substituteInPlace XEEN1.CUE \
      --replace "music\" "../drives/c/MUSIC/"

    substituteInPlace XEEN2.CUE \
      --replace "game2.gog" "XEEN2.BIN"
    substituteInPlace XEEN2.CUE \
      --replace "music\" "../drives/c/MUSIC/"

    ls -lah .
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/mmwox/drives/c/
    mkdir -p $out/share/mmwox/drives/c/MUSIC
    mkdir -p $out/share/mmwox/drives/c/WORLD
    mkdir -p $out/share/mmwox/cd/

    install -Dm755 ${launcher} $out/bin/${launcher.name}
    substituteInPlace $out/bin/${launcher.name} --subst-var out

    install -Dm644 BOSS.MM4    $out/share/mmwox/drives/c/
    install -Dm644 INSTALL.EXE $out/share/mmwox/drives/c/
    install -Dm644 INTRO.CC    $out/share/mmwox/drives/c/
    install -Dm644 XEEN.CFG    $out/share/mmwox/drives/c/
    install -Dm644 XEEN.DAT    $out/share/mmwox/drives/c/
    install -Dm644 XEEN.EXE    $out/share/mmwox/drives/c/

    install -Dm644 __support/save/DARK.CUR    $out/share/mmwox/drives/c/
    install -Dm644 __support/save/DARK.CC     $out/share/mmwox/drives/c/
    install -Dm644 __support/save/XEEN.CC     $out/share/mmwox/drives/c/
    install -Dm644 __support/save/XEEN.CUR    $out/share/mmwox/drives/c/
    
    install -Dm644 MUSIC/* $out/share/mmwox/drives/c/MUSIC/
    install -Dm644 WORLD/* $out/share/mmwox/drives/c/WORLD/
  '';
}