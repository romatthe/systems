buildGoModule rec {
  pname = "wlogoutbar";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ftphikari";
    repo = "wlogoutbar";
    rev = "${version}";
    sha256 = "tlEviZysOcqaGmulxJ8lk+OUB2o3Y9OKNUkSWhx1ti0=";
  };

  vendorSha256 = "1879j77k96684wi554rkjxydrj8g3hpp0kvxz03sd8dmwr3lh83j";

  runVend = true;

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}