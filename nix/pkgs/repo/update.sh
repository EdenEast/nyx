#!/usr/bin/env nix-shell
#! nix-shell -p nix jq curl rsync
#! nix-shell -i bash

set -eu

cd "$(dirname "$0")"

user="EdenEast"
repo="repo"
crate="repo-cli"

source ../lib.sh

echo "Getting latest version from crates.io API" >&2

version="$(get_latest_version_from_crates_io $crate)"
prefetch="$(prefetch_from_crates_io $crate $version)"
sha="$(printf '%s' "$prefetch" | head -n1)"
store="$(printf '%s' "$prefetch" | tail -n1)"

cat >metadata.nix <<EOF
{
  pname = "$repo";
  version = "$version";
  fetch = {
    pname = "$crate";
    version = "$version";
    sha256 = "$sha";
  };
}
EOF

echo "Fetching Cargo.lock"
cp "$store/Cargo.lock" ./Cargo.lock
