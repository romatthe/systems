{ lib
, fetchFromGitHub
, python3
, tk
}:

python3.pkgs.buildPythonApplication rec {
  pname = "steam-metadata-editor";
  version = "2024-06-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tralph3";
    repo = "Steam-Metadata-Editor";
    rev = "5c6ec345417c48160ea9798d97643c6f0e82ba7d";
    sha256 = "sha256-+80NYqzTjWA7JZxHx0N1R96/B/XKtvnILhJ06JMwcX4=";
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
      version='2024.06.30',
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