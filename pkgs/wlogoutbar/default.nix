{ lib, fetchFromGitHub, buildGoModule, pkg-config, cairo, glib, gtk3, gtk-layer-shell }:

buildGoModule rec {
  pname = "wlogoutbar";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ftphikari";
    repo = "wlogoutbar";
    rev = "${version}";
    sha256 = "tlEviZysOcqaGmulxJ8lk+OUB2o3Y9OKNUkSWhx1ti0=";
  };

  # vendorSha256 = lib.fakeSha256;
  vendorSha256 = "37ryHb0HvqZFEd+JnxSP97JlRgZG3fsO3ejmjTjSvyc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo glib gtk3 gtk-layer-shell ];

  runVend = false;
}