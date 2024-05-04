{ lib
, buildDotnetModule
, dotnetCorePackages
, copyDesktopItems
, makeDesktopItem
, fetchFromGitHub
, glfw
, imagemagick
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
  dotnet-runtime = dotnetCorePackages.runtime_7_0;
  dotnetInstallFlags = [ "--framework" "net7.0" ];

  patches = [ ./no-readline.patch ];

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  runtimeDeps = [
    glfw
  ];

  desktopItems = [ 
    (makeDesktopItem {
      name = "ambermoon-net";
      desktopName = "Ambermoon.net";
      exec = "ambermoon-net";
      icon = "ambermoon-net";
      comment = "Ambermoon.net";
      genericName = "Open source re-implementation of the classic Amiga game Ambermoon.";
      categories = [ "Game" "RolePlaying" ];
    })
  ];

  postInstall = ''
    for size in 16 24 32 48 64 128 256 ; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" Ambermoon.net/Resources/AppIcon.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/ambermoon-net.png
    done;
  '';

  postFixup = ''
    mv $out/bin/Ambermoon.net $out/bin/ambermoon-net
    mv $out/bin/AmbermoonPatcher $out/bin/ambermoon-patcher
  '';

  meta = with lib; {
    description = "Open source re-implementation of the classic Amiga game Ambermoon.";
    homepage = "https://github.com/pyrdacor/ambermoon.net";
    license = [ licenses.gpl3Only ];
    maintainers = with maintainers; [ romatthe ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}