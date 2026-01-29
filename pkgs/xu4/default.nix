{ lib
, fetchFromGitea
, fetchurl
, stdenv
, bash
, boron
, libglvnd
, libpng
, libpulseaudio
, libvorbis
, libX11
, libxcursor
, zlib
}:

let
  faun = stdenv.mkDerivation rec {
    pname = "faun";
    version = "0.2.3";

    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "wickedsmoke";
      repo = "faun";
      tag = "v${version}";
      hash = "sha256-fUYKrs4nSIh/l3UQ+PA7F0RJ5hPBd99sjhex7LZ/Lik=";
    };

    nativeBuildInputs = [ 
      bash
    ];

    buildInputs = [
      libpulseaudio
      libvorbis
    ];

    # This is a custom configure script that doesn't follow the autotools argument parsing conventions
    dontAddPrefix = true;

    postPatch = ''
      patchShebangs . 
    '';

    configurePhase = ''
      ./configure --no_flac --prefix $out
    '';
  };
  # u4Upgrade = fetchurl {
  #   url = "https://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip";
  #   hash = "sha256-QArDcxHzvnTBsteDZWGy6tKxRvUWJYaGWw9IgSJcylg=";
  # };
in
  stdenv.mkDerivation rec {
    pname = "xu4";
    version = "1.4.3";
    
    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "xU4";
      repo = "xu4";
      tag = "v${version}";
      hash = "sha256-0nTnUX2Exka7ytZnFWsjuMIodU4HQ2l/h+z2v550sTU=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      
    ];

    buildInputs = [
      boron
      faun
      libglvnd
      libpng
      libvorbis
      libX11
      libxcursor
      zlib
    ];

    hardeningDisable = [ "format" ];

    dontAddPrefix = true;

    # preInstall = ''
    #   cp ${u4Upgrade} ./u4upgrad.zip
    #   ls -lah .
    # '';

    # The `install` make target fetches the U4 VGA patch, so we manually install instead
    installPhase = ''
      mkdir -p $out/bin $out/share/xu4
      install -m 755 -s src/xu4 $out/bin/xu4
      install -m 644 -t $out/share/xu4 render.pak Ultima-IV.mod U4-Upgrade.mod
      install -D -m 644 icons/shield.png $out/share/icons/hicolor/48x48/apps/xu4.png
      install -D -m 644 dist/xu4.desktop $out/share/applications/xu4.desktop
    '';
}