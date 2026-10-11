#!@shell@
# Download the community Wurm Online map dumps that WurmExplorer renders.
#
# The maps are not shipped with the application. They live in a public Google
# Drive folder, are refreshed every few months, and are named after the scheme
# the application scans for: `<Server>-<classic|topo|terrain>-<YYYYMMDD>.png`.
#
# Everything lands in the per-user data directory, one of the locations
# `treasure::core::getMapSearchDirectories()` looks at, so the read-only copy in
# the store stays untouched. Override the destination with `MAP_DEST_DIR`.
#
# Arguments are passed straight to upstream's fetcher, so `--filter Chaos`
# limits the download to a single server and `--all` grabs every historical
# release instead of only the most recent one per server.
set -eu

: "${MAP_DEST_DIR:=${XDG_DATA_HOME:-$HOME/.local/share}/WurmMods/WurmExplorer/maps}"
export MAP_DEST_DIR

mkdir -p "$MAP_DEST_DIR"

exec @python@/bin/python3 @script@ "$@"
