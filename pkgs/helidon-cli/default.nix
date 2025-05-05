{ lib
, buildGraalvmNativeImage
, fetchFromGitHub
, makeWrapper
, maven
, jre
, unzip
}:

let
  name = "helidon-cli";
  version = "4.0.16";

  jar = maven.buildMavenPackage rec {
    inherit version;

    pname = "${name}-jar";

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

    nativeBuildInputs = [
      jre
    ];

    postBuild = ''
      jar xf target/helidon-cli.jar META-INF/native-image/io.helidon.build-tools.cli/helidon-cli-impl/native-image.properties

      substituteInPlace META-INF/native-image/io.helidon.build-tools.cli/helidon-cli-impl/native-image.properties \
        --replace-fail "\''${buildNumber}" "${version}"

      jar uf target/helidon-cli.jar META-INF/native-image/io.helidon.build-tools.cli/helidon-cli-impl/native-image.properties

      rm -Rf META-INF/
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/libs

      install -Dm644 target/${name}.jar $out/${name}.jar
      install -Dm644 target/libs/* $out/libs/

      runHook postInstall
    '';
  };
in
  buildGraalvmNativeImage {
    inherit version;

    pname = name;
    src = jar;
    jar = "${jar}/${name}.jar";

    executable = "helidon";

    # Copied from pom.xml
    extraNativeImageBuildArgs = [
      "--no-fallback"
      "-H:EnableURLProtocols=https"
      "-H:EnableURLProtocols=http"
    ];
  }