{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, glfw
}:

buildDotnetModule rec {
  pname = "ambermoon-net";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "Pyrdacor";
    repo = "Ambermoon.net";
    rev = "v${version}";
    hash = "sha256-ZtnLo6b0XSXQYt9g43yub1lkAVMNRA/s7FtXXEdLBOI=";
  };

  selfContainedBuild = true;

  projectFile = "Ambermoon.net/Ambermoon.net.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnetInstallFlags = ["-f" "net7.0"];

  runtimeDeps = [
    glfw
  ];

  meta = with lib; {
    homepage = "https://github.com/13xforever/ps3-disc-dumper";
    description = "A handy utility to make decrypted PS3 disc dumps";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}