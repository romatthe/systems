{ stdenv
, lib
, fetchFromGitHub
, curl
, gnumake
, gnutls
, gtk3
, gtkmm3
, pkg-config
, yajl
}:

stdenv.mkDerivation rec {
  pname = "SamRewritten";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = pname;
    rev = "202008";
    hash = "sha256-q3kDuZdnWw1Nfu3hVDD8XKJzbmwlx/lafJfhziVYKhw=";
  };

  nativeBuildInputs = [ gnumake pkg-config ];

  buildInputs = [
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

  meta = with lib; {
    description = "Steam Achievement Manager For Linux";
    homepage = "https://github.com/PaulCombal/SamRewritten";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}