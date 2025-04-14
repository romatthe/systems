{ lib
, stdenv
, fetchFromGitHub
, gettext
, meson
, ninja
, pkg-config
, vala
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, glib
, gobject-introspection
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
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    glib
    gobject-introspection
    gtk4
    gusb
    libadwaita
    libportal-gtk4
  ];
}