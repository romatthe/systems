{ stdenv
, lib
, fetchFromGitHub
, copyDesktopItems
, makeDesktopItem
# , autoreconfHook
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

  nativeBuildInputs = [ 
    autoconf 
    automake 
  ];

  buildInputs = [
    SDL2
  ];

  # NIX_CFLAGS_LINK = "-pthread";
  NIX_CFLAGS_COMPILE = "-std=c++11";

  preConfigure = ''
    ./autogen.sh
  '';

  preInstall = ''
    ls -lah
    cat Makefile
  '';

  # WrapProgram needed here to set ~/.config/nuvie/nuvie.cfg and the location of the Ultima 6 base files

  postInstall = ''
    ls -lah $out
    echo '---------------'
    ls -lah $out/bin

    wrapProgram $out/bin/nuvie \
      --prefix PATH : ${lib.makeBinPath [ openjdk ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --run 'mkdir -p ''${XDG_DATA_HOME:-~/.local/share}/starsector' \
      --chdir "$out/share/starsector"
  '';

  # meta = with lib; {
  #   description = "Steam Achievement Manager For Linux";
  #   homepage = "https://github.com/PaulCombal/SamRewritten";
  #   license = licenses.gpl3;
  #   platforms = platforms.linux;
  # };
}