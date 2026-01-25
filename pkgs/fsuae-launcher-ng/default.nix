{ lib
, fetchFromGitHub
, fetchPypi
, fsuae
, gettext
# , python3Packages
, python3
, qt6
, stdenv
, nix-update-script
}:
let
  lhafile = python3.pkgs.buildPythonPackage rec {
    pname = "lhafile";
    version = "0.3.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-pmoJHmGvVpOEhE7XS/dhecV15dKLyIv5v1R2ozl9B30=";
    };

    pyproject = true;

    build-system = with python3.pkgs; [
      setuptools
    ];

    doCheck = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fs-uae-launcher-ng";
  version = "3.2.20";

  src = fetchFromGitHub {
    owner = "FrodeSolheim";
    repo = "fs-uae-launcher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JuCwcVKuc0EzsKQiPXobH9tiIWEFD3tjcXneRXzjsH0=";
  };

  buildInputs = [
    qt6.qtbase
  ];

  nativeBuildInputs = [
    gettext
    python3.pkgs.python
    qt6.wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    lhafile
    macholib
    pillow
    pyopengl
    pyqt6
    requests
    sentry-sdk
    typing-extensions
  ] ++ [
    lhafile
  ];

  strictDeps = true;

  makeFlags = [ "prefix=$(out)" ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "distutils.core" "setuptools"
  '';

  preFixup = ''
    wrapQtApp "$out/bin/fs-uae-launcher" \
      --set PYTHONPATH "$PYTHONPATH"

    # fs-uae-launcher search side by side for executables and shared files
    # see $src/fsgs/plugins/pluginexecutablefinder.py#find_executable
    ln -s ${fsuae}/bin/fs-uae $out/bin
    ln -s ${fsuae}/bin/fs-uae-device-helper $out/bin
    ln -s ${fsuae}/share/fs-uae $out/share/fs-uae
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "fs-uae-launcher";
    maintainers = with lib.maintainers; [
      sander
      c4patino
    ];
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isx86 patterns.isLinux;
  };
})