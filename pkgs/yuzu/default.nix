{ appimageTools
, fetchurl
, fetchzip
, lib
}:

let
  pname = "yuzu";
  version = "1734";

  src = fetchzip {
    url = "https://github.com/romatthe/systems/releases/download/old-emu/old-emu.tar.gz";
    sha256 = "sha256-92E/AQX+LBtFS1dD0jduo7Gujd+/d3CaodKePoS16Ds=";
    stripRoot = false;
    postFetch = ''
      mv $out/*.AppImage $TMPDIR/tmp
      rm -rf $out
      mv $TMPDIR/tmp $out
    '';
  };

  extracted = appimageTools.extract {
    inherit src pname version;
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${extracted}/org.yuzu_emu.yuzu.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${extracted}/org.yuzu_emu.yuzu.svg $out/share/icons/hicolor/scalable/apps/org.yuzu_emu.yuzu.svg

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Name=yuzu' 'Name=Yuzu'
  '';
}