{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, openssl
, zlib
}:

buildDotnetModule rec {
  pname = "mpf-check";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "SabreTools";
    repo = "MPF";
    rev = version;
    hash = "sha256-N7L3nAP+lxPDmKTHu0lxAQalBFTHVVohD5OANlO2ZNs=";
  };

  selfContainedBuild = true;

  projectFile = "MPF.Check/MPF.Check.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];

  runtimeDeps = [
    openssl
    zlib
  ];

  postPatch = ''
    sed -i "/<\/VersionPrefix>/a <AssemblyName>mpf-check</AssemblyName>" MPF.Check/MPF.Check.csproj
  '';

  meta = {
    homepage = "https://github.com/SabreTools/MPF";
    description = "A CLI program that allows users to generate Redump submission information from their personal rips.";
    longDescription = "A CLI program that allows users to generate submission information from their personal Redumper, Aaru, DiscImageCreator, Cleanrip, and UmdImageCreator rips.";
    license = [ lib.licenses.gpl3Only ];
  };
}