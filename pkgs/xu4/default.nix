{ lib
, fetchFromGitea
, stdenv
, boron
, libglvnd
, libpng
, libpulseaudio
, libvorbis
, libX11
, libxcursor
, mesa
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
      sha256 = lib.fakeSha256l;
    };

    buildInputs = [
      libpulseaudio
      libvorbis
    ];

    configureFlags = [ "--no_flac" ];
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
      # libXext
      # mesa
      zlib
    ];

    hardeningDisable = [ "format" ];

    dontAddPrefix = true;
}