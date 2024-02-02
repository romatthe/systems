{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "binaryobjectscanner";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "SabreTools";
    repo = "BinaryObjectScanner";
    rev = version;
    hash = "sha256-y/2E96Txe3VG4G0n5AbkcxEEVPdh8cwBlRSkzSJD+Qo=";
    fetchSubmodules = true;
  };

  projectFile = "BinaryObjectScanner.sln";
  nugetDeps = ./deps.nix;
  runtimeId = "linux-x64";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];
  # projectFile = "BinaryObjectScanner/BinaryObjectScanner.csproj";
  # executables = "BinaryObjectScanner";

  meta = {
    description = "C# protection, packer, and archive scanning library";
    homepage = "https://github.com/SabreTools/BinaryObjectScanner";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ whovian9369 ];
    mainProgram = "Test";
    platforms = lib.platforms.all;
  };
}