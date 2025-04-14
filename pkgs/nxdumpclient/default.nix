{ lib
, stdenv
, fetchFromGitHub
, gettext
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook4
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, glib
, gtk4
, gusb
, libadwaita
, libportal-gtk4
}:

stdenv.mkDerivation rec {
  pname = "nxdumpclient";
  version = "1.1.3";
  src = fetchFromGitHub {
    owner = "v1993";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9s/FdnG3L8oh0ZGd5JErp9qsC6cqmwG91Q9PyBfpASQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream-glib
    blueprint-compiler
    glib
    gtk4
    gusb
    libadwaita
    libportal-gtk4
  ];
}