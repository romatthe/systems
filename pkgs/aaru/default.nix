{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, fetchgit
}:

buildDotnetModule rec {
  pname = "aaru";
  version = "6.0.0-alpha9";

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = "v${version}";
    hash = "sha256-2lEeZI+UyEUf5JOpfaZGaNwdrjhWr4PgAtCw9lpYcfk=";
    leaveDotGit = true;
    postFetch = ''
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

  meta = {
    homepage = "https://aaru.app";
    description = "Fully featured media dump management solution";
    license = [ lib.licenses.gpl3Only ];
    mainProgram = "aaru";
  };
}