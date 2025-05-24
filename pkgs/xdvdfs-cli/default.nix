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
  cargoHash = "sha256-Mv1tmmen4iHh4ryCU7MijMmNe0BXzbG0Icbmee51/fc=";
  buildAndTestSubdir = "xdvdfs-cli";

  meta = with lib; {
    license = licenses.mit;
  };
}