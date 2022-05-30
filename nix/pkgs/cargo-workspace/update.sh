#!/usr/bin/env nix-shell
#! nix-shell -p nix jq curl rsync cargo
#! nix-shell -i bash

set -eu

cd "$(dirname "$0")"

crate="cargo-workspace"

source ../lib.sh

echo "Getting latest version from crates.io API" >&2

version="$(get_latest_version_from_crates_io $crate)"
prefetch="$(prefetch_from_crates_io $crate $version)"
sha="$(printf '%s' "$prefetch" | head -n1)"
store="$(printf '%s' "$prefetch" | tail -n1)"

cat >metadata.nix <<EOF
{
  pname = "$crate";
  version = "$version";
  fetch = {
    pname = "$crate";
    version = "$version";
    sha256 = "$sha";
  };
}
EOF

# echo "Fetching Cargo.lock"
# cp "$store/Cargo.lock" ./Cargo.lock

echo "Generating updated Cargo.lock" >&2

tmp="$(mktemp -d)"

cleanup() {
  echo "Removing $tmp" >&2
  rm -rf "$tmp"
}

trap cleanup EXIT

rsync -a --chmod=ugo=rwX "$store/" "$tmp"

pushd "$tmp"
cargo update
popd

cp "$tmp/Cargo.lock" ./Cargo.lock
