{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "steam-cleaner";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "romatthe";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G7BrVYtTi8kIH4rNhcj8EYbQh0tvq8KgbCWfGfVuON4=";
  };

  cargoHash = "sha256-cfdmIuEcWg4Xqvp8O+Y2LBRV2Anu7B2J4VwFEaG6N6M=";

  meta = with lib; {
    license = licenses.mit;
  };
}