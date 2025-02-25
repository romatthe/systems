{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "steam-cleaner";
  version = "0.1.0-dev";

  src = fetchFromGitHub {
    owner = "romatthe";
    repo = "sme-rs";
    rev = "61582e6aa8969a933631243ec4b0009c4080f13f";
    hash = "sha256-VvfOij2KptNYpdKuhYPlL4Io2yBveoVqHn1a+5ltX2o=";
  };

  # cargoPatches = [ ./cargo-lock.patch ];
  cargoHash = "sha256-234Ezc+pKT0OLwdWqz//BnW/GTWeKcTSUBCO2dT0/4I=";
  # cargoLock.lockFile = ./Cargo.lock;

  meta = with lib; {
    # description = "A fast line-oriented regex search tool, similar to ag and ack";
    # homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.mit;
  };
}