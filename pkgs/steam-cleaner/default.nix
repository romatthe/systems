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

  cargoHash = "sha256-pzur9lFcwp2ZcahOy+F5RcUCJgeClUofWyUGHi3raAg=";

  meta = with lib; {
    license = licenses.mit;
  };
}