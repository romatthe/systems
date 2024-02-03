{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, openssl
, zlib
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

  selfContainedBuild = true;

  projectFile = "Test/Test.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];

  runtimeDeps = [
    openssl
    zlib
  ];

  postPatch = ''
    # Give the output binary a decent name
    sed -i "/<\/TreatWarningsAsErrors>/a <AssemblyName>binobjscanner</AssemblyName>" Test/Test.csproj

    # Change the binary name in the help output
    substituteInPlace Test/Options.cs \
        --replace 'Console.WriteLine("test.exe' 'Console.WriteLine("binobjscanner'

    # Delete the lines that cause the CLI to pause on completion
    sed -i '26d;27d;61d;62d' Test/Program.cs
  '';

  meta = {
    description = "C# protection, packer, and archive scanning library";
    homepage = "https://github.com/SabreTools/BinaryObjectScanner";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}