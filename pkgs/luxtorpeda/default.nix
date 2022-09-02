{ lib, fetchFromGitHub, rustPlatform, SDL2, SDL2_image }:

let
  pkg-version = "57";
in
  rustPlatform.buildRustPackage rec {
    pname = "luxtorpeda";
    version = "v${pkg-version}";

    src = fetchFromGitHub {
      owner = "luxtorpeda-dev";
      repo = "luxtorpeda";
      rev = "v${pkg-version}";
      sha256 = "RCjT3HyCggD0aPR3a1ZRqyPv5kEBYIycC4KX+M118/Y=";
    };

    cargoHash = "sha256-4MS8ZxUTiGPOdvlCv9dGk3KCse77vpS9CnO3bN75nf4";

    buildInputs = [SDL2 SDL2_image];

    patchPhase = ''
      patchShebangs luxtorpeda.sh
    '';

    # TODO: Change to installPhase
    # TODO: Use `install` script? Like here? 
    # https://github.com/NixOS/nixpkgs/blob/7d0ba0850fe9f0a520c6c8fb2f5db8f71f323627/pkgs/applications/misc/qcad/default.nix#L50
    postInstall = ''
      cp config.json           $out/bin
      cp res/icon.png          $out/bin
      cp LICENSE               $out/bin
      cp luxtorpeda.sh         $out/bin
      cp toolmanifest.vdf      $out/bin

      echo "${pkg-version}" > $out/bin/version
      sed 's/%name%/${pname}/; s/%display_name%/Luxtorpeda/' compatibilitytool.template \
        > $out/bin/compatibilitytool.vdf
    '';

    meta = with lib; {
      description = "Compatbility tool to run Steam games using open-source engines instead of Wine/Proton";
      homepage = "https://github.com/luxtorpeda-dev/luxtorpeda";
      license = licenses.gpl2Only;
      maintainers = with maintainers; [ romatthe ];
      platforms = platforms.linux;
    };
}