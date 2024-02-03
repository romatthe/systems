{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "aaru";
  version = "6.0.0-alpha9";

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = "v${version}";
    hash = "sha256-UOuCls9HHKSNGKCF0v6wMuZWV1XfbPHJrxv+1ZTMyY4=";
    leaveDotGit = true;
    fetchSubmodules = true;
    postFetch = ''
      # We're cloning the .git directory so we can create a dump of the short commit hash,
      # but we want to remove the directory right afterwards for nix hashing consistency.
      cd "$out"
      git rev-parse --short=8 HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  selfContainedBuild = true;

  projectFile = "Aaru/Aaru.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_7_0;

  patchPhase = ''
    substituteInPlace "Aaru/Aaru.csproj" "Aaru.Archives/Aaru.Archives.csproj" \
      "Aaru.Compression/Aaru.Compression.csproj" "Aaru.Core/Aaru.Core.csproj" \
      "Aaru.Database/Aaru.Database.csproj" "Aaru.Devices/Aaru.Devices.csproj" \
      "Aaru.Filesystems/Aaru.Filesystems.csproj" \
      "Aaru.Filters/Aaru.Filters.csproj" "Aaru.Gui/Aaru.Gui.csproj" \
      "Aaru.Images/Aaru.Images.csproj" \
      "Aaru.Partitions/Aaru.Partitions.csproj" \
      "Aaru.Settings/Aaru.Settings.csproj" \
      "Aaru.Tests.Devices/Aaru.Tests.Devices.csproj" --replace '{chash:8}' \
      "$(cat COMMIT)"
  '';

  meta = with lib; {
    homepage = "https://aaru.app";
    description = "Fully featured media dump management solution";
    license = [ licenses.gpl3Only ];
    mainProgram = "aaru";
  };
}