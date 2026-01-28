{ lib
, fetchFromGitea
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

    dontAddPrefix = true;

    postPatch = ''
      patchShebangs . 
    '';

    configurePhase = ''
      ./configure --no_flac --prefix $out
    '';
  };
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
}