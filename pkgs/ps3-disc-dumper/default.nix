{ lib
, buildDotnetModule
, dotnet-sdk_8
, fetchFromGitHub
, zlib
, openssl
}:

buildDotnetModule rec {
  pname = "ps3-disc-dumper";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "13xforever";
    repo = "ps3-disc-dumper";
    rev = "v${version}";
    hash = "sha256-BU7SKrYjOTjky30tWde415oAcK+IDax8t6EzUq3X0lo=";
  };

  selfContainedBuild = true;

  projectFile = "UI.Console/UI.Console.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnet-sdk_8;

  runtimeDeps = [
    zlib
    openssl
  ];

  meta = with lib; {
    homepage = "https://github.com/13xforever/ps3-disc-dumper";
    description = "A handy utility to make decrypted PS3 disc dumps";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
