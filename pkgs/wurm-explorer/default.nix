{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, meson
, ninja
, pkg-config
, glib
, gtk3
, leptonica
, nlohmann_json
, opencv4
, python3
, qt6
, runtimeShell
, tesseract
, vips
, yaml-cpp
, nix-update-script
}:

let
  # Runtime dependencies of upstream's map fetcher, see `fetch-maps.sh`
  mapFetcherPython = python3.withPackages (ps: with ps; [ gdown requests ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wurm-explorer";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "bnorthern42";
    repo = "WurmExplorer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9qgbOKsZHsnz7f2d5PbHyfp3Sira5W6ZvxBeO9Ca+qk=";
  };

  patches = [
    # The bundled config templates get copied into the user's config directory
    # on first run, which in the store means they arrive read-only
    ./writable-user-configs.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    # Pulled in by `Ocr.cpp` through the Tesseract headers
    leptonica
    nlohmann_json
    opencv4
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    tesseract
    vips
    yaml-cpp
  ];

  doCheck = true;

  # Several of the test suites instantiate widgets
  preCheck = ''
    export QT_QPA_PLATFORM=offscreen
  '';

  # The wrapper is created by hand in `preFixup`, see below
  dontWrapQtApps = true;

  # The application resolves its bundled configs and resources relative to the
  # directory of its own binary, so both live together in `libexec`
  postInstall = ''
    install -d $out/libexec/wurm-explorer
    mv $out/bin/wurm_explorer $out/libexec/wurm-explorer/wurm_explorer

    install -Dm444 -t $out/libexec/wurm-explorer/configs \
      $src/configs/*.json \
      $src/configs/*.yaml
    install -Dm444 -t $out/libexec/wurm-explorer/resources \
      $src/resources/icon.png \
      $src/resources/wurmexplorer.svg
    install -Dm444 -t $out/libexec/wurm-explorer/resources/fonts \
      $src/resources/fonts/MaterialIcons-Regular.ttf
    install -Dm444 -t $out/libexec/wurm-explorer/assets/icons \
      $src/assets/icons/wurm_explorer.svg

    # Terrain maps are a separate, externally hosted asset set, so ship
    # upstream's fetcher as a helper that defaults to the per-user data
    # directory the application scans
    install -Dm444 $src/scripts/fetch_maps.py $out/libexec/wurm-explorer/fetch_maps.py
    substitute ${./fetch-maps.sh} $out/bin/wurm-explorer-fetch-maps \
      --subst-var-by shell ${runtimeShell} \
      --subst-var-by python ${mapFetcherPython} \
      --subst-var-by script $out/libexec/wurm-explorer/fetch_maps.py
    chmod +x $out/bin/wurm-explorer-fetch-maps

    substituteInPlace $out/share/applications/wurmexplorer.desktop \
      --replace-fail "Exec=wurm_explorer" "Exec=$out/bin/wurm_explorer"

    desktop-file-validate $out/share/applications/wurmexplorer.desktop
  '';

  # `DrawingPanel` builds a `QColorDialog` on startup, which a GNOME themed Qt
  # session hands to GTK 3's colour chooser. That chooser reads the
  # `org.gtk.Settings.ColorChooser` schema and GLib aborts the process when it
  # is missing, so the schemas have to be on `XDG_DATA_DIRS`
  preFixup = ''
    makeQtWrapper $out/libexec/wurm-explorer/wurm_explorer $out/bin/wurm_explorer \
      --set-default TESSDATA_PREFIX ${tesseract}/share/tessdata \
      --prefix XDG_DATA_DIRS : ${glib.getSchemaDataDirPath gtk3}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Map, navigation, breeding and skill tracking companion for Wurm Online";
    homepage = "https://github.com/bnorthern42/WurmExplorer";
    license = lib.licenses.mit;
    mainProgram = "wurm_explorer";
    platforms = lib.platforms.linux;
  };
})
