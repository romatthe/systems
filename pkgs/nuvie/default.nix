{ stdenv
, lib
, fetchFromGitHub
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, autoconf
, automake
, SDL2
}:

let
  desktopItem = makeDesktopItem rec {
    name = "Nuvie";
    exec = "nuvie";
    desktopName = name;
    comment = "An open-source engine for Ultima VI";
    categories = [ "Game" ];
  };
in stdenv.mkDerivation rec {
  pname = "nuvie";
  version = "unstable-2019-09-04";

  src = fetchFromGitHub {
    owner = "nuvie";
    repo = "nuvie";
    rev = "350c89b";
    hash = "sha256-RnXnQNqJAbX8UlypriyiwGFk3EcQ5x6k7xi/lwI17bs=";
  };

  nativeBuildInputs = [ autoconf automake makeWrapper ];
  buildInputs = [ SDL2 ];

  NIX_CFLAGS_COMPILE = "-std=c++11";

  preConfigure = ''
    ./autogen.sh
  '';

  # WrapProgram needed here to set ~/.config/nuvie/nuvie.cfg and the location of the Ultima 6 base files

  postInstall = ''
    ls -lah $out
    echo '---------------'
    ls -lah $out/bin

    wrapProgram $out/bin/nuvie \
      --run "mkdir -p \$HOME/.config/nuvie; cd \$HOME/.config/nuvie" \
      --chdir "~/.config/nuvie"
  ''; 

  # meta = with lib; {
  #   description = "Steam Achievement Manager For Linux";
  #   homepage = "https://github.com/PaulCombal/SamRewritten";
  #   license = licenses.gpl3;
  #   platforms = platforms.linux;
  # };
}