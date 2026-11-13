{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "aws-emulator";
  version = "1.0.348";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-emulator";
    rev = "v${version}";
    hash = "sha256-SDC2OJtb1f4hmzJeSpzRzN3/D63hm23nVt50YUdwiVI=";
  };

  cargoHash = "sha256-A7hLjoECexjiSfKELR+Cz6OzEUAbCpcE9s9UFCp5erY=";

  # Only build the server binary, not every service crate's tests
  cargoBuildFlags = [ "-p" "aws-emulator-router" ];

  # aws-lc-sys builds its bundled C code with CMake
  nativeBuildInputs = [ cmake makeWrapper ];
  dontUseCmakeConfigure = true;

  # One test crate per AWS service; running them all would take forever
  doCheck = false;

  # Telemetry is on by default upstream, keep it off unless explicitly enabled
  postInstall = ''
    wrapProgram $out/bin/aws-emulator \
      --set-default EMULATOR_TELEMETRY off
  '';

  meta = with lib; {
    description = "Local emulator of the AWS APIs";
    homepage = "https://github.com/aws/aws-emulator";
    license = with licenses; [ cc0 asl20 ];
    mainProgram = "aws-emulator";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
