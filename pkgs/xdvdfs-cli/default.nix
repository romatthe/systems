{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "xdvdfs-cli";
  version = "0.6.0-dev";

  src = fetchFromGitHub {
    owner = "antangelo";
    repo = "xdvdfs";
    rev = "6f9f581668ddbfe5d4df2810fdb33c8678ce9ac7";
    hash = "sha256-+lpqo/n2pD2yQ+jeyWwUJ9lOT1s2Sj9EpnGLRd33WTQ=";
  };

  # sourceRoot = "${src.name}/xdvdfs-cli";

  cargoPatches = [ ./cargo-lock.patch ];
  cargoHash = "sha256-687cUtSwvrkbqjgD7qfQsLcvUg64/gIZSdyZ9F1sbRM=";
  buildAndTestSubdir = "xdvdfs-cli";

  meta = with lib; {
    # description = "A fast line-oriented regex search tool, similar to ag and ack";
    # homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.mit;
  };
}