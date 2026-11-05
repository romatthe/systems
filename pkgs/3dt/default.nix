{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "3dt";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = "3dt";
    tag = finalAttrs.version;
    hash = "sha256-vieqyyFheQrhLZ8YAa6ircDSjLa9k3mAUHnBpZk5ARw=";
  };

  strictDeps = true;

  # Every dependency is vendored, so stdenv is all that is needed

  # The default goal is an unoptimized debug build and `NDEBUG=1` links
  # statically, so the optimization flags are set by hand instead. `BINDIR`
  # otherwise points into a 3do-devkit checkout under `$HOME`
  makeFlags = [
    "OPT=-O2"
    "BINDIR=${placeholder "out"}/bin"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  # The test binary links against the object files from the build above, so it
  # has to be compiled with the same flags
  checkTarget = "check-identify";

  # `docs/` carries a README of its own, so it keeps its own directory
  postInstall = ''
    install -Dm444 -t $out/share/doc/3dt README.md
    install -Dm444 -t $out/share/doc/3dt/docs docs/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "All in one 3DO disc tool";
    longDescription = ''
      Unpacks and packs 3DO disc images, identifies discs, inspects OperaFS
      content and ROMTags, signs and verifies RSA signatures, and encrypts and
      decrypts boot payloads.
    '';
    homepage = "https://github.com/trapexit/3dt";
    license = lib.licenses.isc;
    mainProgram = "3dt";
    platforms = lib.platforms.unix;
  };
})
