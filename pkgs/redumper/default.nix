{ stdenv
, lib
, fetchzip
}:

stdenv.mkDerivation rec {
  name = "redumper";
  version = "313";

  src = fetchzip {
    url = "https://github.com/superg/redumper/releases/download/build_${version}/redumper-2024.01.10_build313-Linux.zip";
    hash = "sha256-JtH4RJBqUCK+8Zn75y87F8WVl5hqh6oP0JjrDAx9ZyA=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/redumper

    runHook postInstall
  '';
}