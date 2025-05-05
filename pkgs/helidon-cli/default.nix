{
  lib,
  fetchFromGitHub,
  maven,
  buildGraalvmNativeImage,
}:

let
  pname = "helidon-cli";
  version = "4.0.16";

  jar = maven.buildMavenPackage rec {
    pname = "helidon-cli-jar";
    inherit version;

    src = fetchFromGitHub {
      owner = "helidon-io";
      repo = "helidon-build-tools";
      tag = version;
      hash = "sha256-P2wWUfYLi6WwO8eP1pErDs6l+vGBfxxuIdAqdi8BdJU=";
    };

    sourceRoot = "${src.name}/cli/impl";

    mvnHash = "sha256-zdsvrSUwStm974brTABeQpcDhHd45NYiSU4l7E2q1Dc=";

    mvnParameters = lib.concatStringsSep " " [
      "-Dmaven.buildNumber.skip=true"
      "-DskipTests"
    ];

    installPhase = ''
      install -Dm644 target/helidon-cli.jar $out
    '';
  };
in
  buildGraalvmNativeImage {
    inherit pname version;

    src = jar;

    executable = "helidon-cli";

    # Copied from pom.xml
    extraNativeImageBuildArgs = [
      "--no-fallback"
      "-H:EnableURLProtocols=https"
      "-H:EnableURLProtocols=http"
    ];
  }
