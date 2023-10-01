{ lib, fetchFromGitHub, rustPlatform, godot_4, openssl, SDL2, SDL2_image }:

let
  pkg-version = "67.0.0";
  cargo-post = rustPlatform.buildRustPackage rec {
    pname = "cargo-post";
    version = "0.1.7";

    src = fetchFromGitHub {
      owner = "phil-opp";
      repo = "cargo-post";
      rev = "v0.1.7";
      sha256 = "sha256-PAqpVixBdytHvSUu03OyoA1QGBxmmoeV78x6wCiCemQ=";
    };

    cargoSha256 = "sha256-dsaDpDa/BNqnL3K4a1mg3uEyM094/UO73MzJD9YaAwE=";
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "luxtorpeda";
    version = "67.0.0";

    src = fetchFromGitHub {
      owner = "luxtorpeda-dev";
      repo = "luxtorpeda";
      rev = "v67.0.0";
      hash = "sha256-gTRIcQmvIK+/yJI2DMP/TJf90FTzrri9HS9P0Qs+jqA=";
    };

    cargoHash = lib.fakeSha256;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "godot-0.1.0"           = "sha256-k22E13GhWb2y2nv4qyJU7z1eXX+z1aiWigEgXIracaA=";
        "godot4-prebuilt-0.0.0" = "sha256-WkH4PcbFOj6pTFUw3bKaaifZlSCfR8MQasd4Ato97xg=";
        "iso9660-0.1.1"         = "sha256-aIW7LqPOj5ONxivvZTbgw9VMi8iRFQb3W5HTr8Sk/KQ=";
      };
    };

    nativeBuildInputs = [ cargo-post ];

    buildInputs = [ godot_4 openssl SDL2 SDL2_image ];

    patchPhase = ''
      patchShebangs luxtorpeda.sh
    '';

    # TODO: Change to installPhase
    # TODO: Use `install` script? Like here?
    # https://github.com/NixOS/nixpkgs/blob/7d0ba0850fe9f0a520c6c8fb2f5db8f71f323627/pkgs/applications/misc/qcad/default.nix#L50
    postInstall = ''
      mkdir -p $out/share/Steam/compatibilitytools

      # cp luxtorpeda.pck        $out/bin
      cp LICENSE               $out/share/Steam/compatibilitytools
      cp toolmanifest.vdf      $out/share/Steam/compatibilitytools

      echo "v${pkg-version}" > $out/share/Steam/compatibilitytools/version

      sed 's/%name%/${pname}/; s/%display_name%/Luxtorpeda ${pkg-version}/' compatibilitytool.template \
        > $out/share/Steam/compatibilitytools/compatibilitytool.vdf

      ln -s $out/bin/luxtorpeda.sh $out/share/Steam/compatibilitytools/luxtorpeda.sh
    '';

    meta = with lib; {
      description = "Compatbility tool to run Steam games using open-source engines instead of Wine/Proton";
      homepage = "https://github.com/luxtorpeda-dev/luxtorpeda";
      license = licenses.gpl2Only;
      maintainers = with maintainers; [ romatthe ];
      platforms = platforms.linux;
    };
}
