{ lib
, fetchFromGitHub
, python3
, tk
}:

python3.pkgs.buildPythonApplication rec {
  pname = "steam-metadata-editor";
  version = "2023-09-14";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "tralph3";
    repo = "Steam-Metadata-Editor";
    rev = "563ca343b400cdc497134f5e3410ac4bedb5c08c";
    sha256 = "sha256-Kr/5GNnGggaBd3d+JxgSg32ChwJ86ABKFPiM436Rzbc=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];

  propagatedBuildInputs = [ 
    python3.pkgs.tkinter
    tk 
  ];

  preBuild = ''
    cat > setup.py << EOF
    from setuptools import setup

    setup(
      name='${pname}',
      version='2023.09.14',
      entry_points={
        'console_scripts': [
            'steam-metadata-editor=main:main',
        ],
      },
    )
    EOF
  '';

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/gui/img
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps

    cp $src/src/gui/img/* $out/${python3.sitePackages}/gui/img/
    cp $src/steam-metadata-editor.png $out/share/icons/hicolor/256x256/apps
    cp $src/steam-metadata-editor.desktop $out/share/applications

    substituteInPlace $out/share/applications/steam-metadata-editor.desktop \
      --replace /usr/bin/steammetadataeditor ${placeholder "out"}/bin/steam-metadata-editor

    substituteInPlace $out/share/applications/steam-metadata-editor.desktop \
      --replace /usr/share/pixmaps/steam-metadata-editor/steam-metadata-editor.png steam-metadata-editor
  '';

  meta = with lib; {
    # ...
  };
}