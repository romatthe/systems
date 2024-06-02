{ pkgs
# { stdenv
# , lib
# , fetchFromGitHub
# , curl
# , gnumake
# , gnutls
# , gtk3
# , gtkmm3
# , pkg-config
# , yajl
}:

# TODO: Make this work with default stdenv (GCC 13.2)
pkgs.old.stdenv.mkDerivation rec {
  pname = "SamRewritten";
  version = "2.1";

  src = pkgs.old.fetchFromGitHub {
    owner = "PaulCombal";
    repo = pname;
    rev = "202008";
    hash = "sha256-q3kDuZdnWw1Nfu3hVDD8XKJzbmwlx/lafJfhziVYKhw=";
  };

  nativeBuildInputs = with pkgs.old; [ gnumake pkg-config ];

  buildInputs = with pkgs.old; [
    curl
    gnutls
    gtk3
    gtkmm3
    yajl
  ];

  NIX_CFLAGS_LINK = "-pthread";

  makeFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    substituteInPlace $out/share/applications/samrewritten.desktop \
      --replace /usr/bin/samrewritten $out/bin/samrewritten
  '';

  meta = with pkgs.old.lib; {
    description = "Steam Achievement Manager For Linux";
    homepage = "https://github.com/PaulCombal/SamRewritten";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}