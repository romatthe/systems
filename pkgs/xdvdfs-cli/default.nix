{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "xdvdfs-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "antangelo";
    repo = "xdvdfs";
    rev = "v${version}";
    hash = "sha256-Q88vdzAWbJz0+Glsc4YU/x76zeoWc8jqEkwV89Mt4ks=";
  };

  # sourceRoot = "${src.name}/xdvdfs-cli";

  cargoPatches = [ ./cargo-lock.patch ];
  cargoHash = "sha256-ANVF+a22TJtXRKse1COWjm3g9RRi2/egU0iBJGoBvcc=";
  buildAndTestSubdir = "xdvdfs-cli";

  meta = with lib; {
    # description = "A fast line-oriented regex search tool, similar to ag and ack";
    # homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.mit;
  };
}