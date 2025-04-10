{ appimageTools
, fetchurl
, fetchzip
, lib
}:

let
  pname = "pcsx2-pgs";
  version = "2.2.0-custom";

  src = fetchurl {
    url = "https://files.catbox.moe/8a948l.AppImage";
    hash = "sha256-8L2udhd/SxibXNWszJK4gJ8OCAgARfeVOgG0VIOyqOk=";
  };

  extracted = appimageTools.extract {
    inherit src pname version;
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${extracted}/net.pcsx2.PCSX2.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Name=PCSX2' 'Name=PCSX2 PGS'

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=pcsx2-qt' 'Exec=pcsx2-pgs'
  '';
}