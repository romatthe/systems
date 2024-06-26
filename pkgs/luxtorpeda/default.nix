{ lib
, fetchzip
, stdenv
}:

stdenv.mkDerivation rec {
  name = "luxtorpeda";
  version = "70.0.0";

  src = fetchzip {
    url = "https://github.com/luxtorpeda-dev/luxtorpeda/releases/download/v${version}/luxtorpeda-v${version}.tar.xz";
    hash = "sha256-BU6Th4WsgbntajN3TYGNs/qTyEwvTuKKCWHuNThNAdw=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/share/Steam/compatibilitytools.d/luxtorpeda *

    runHook postInstall
  '';


  meta = with lib; {
    description = "Steam Play compatibility tool to run games using native Linux engines";
    homepage = "https://github.com/luxtorpeda-dev/luxtorpeda";
    changelog = "https://github.com/luxtorpeda-dev/luxtorpeda/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ romatthe ];
  };
}
