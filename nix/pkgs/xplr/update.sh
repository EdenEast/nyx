#!/usr/bin/env nix-shell
#! nix-shell -p nix jq curl cargo rsync
#! nix-shell -i bash

set -eu

cd "$(dirname "$0")"

crate=xplr

echo "Getting latest version from crates.io API" >&2

curlOpts=(
  -H "Accept: application/json"
  -H "User-Agent: $crate update script (https://github.com/nixos/nixpkgs/)"
)

version="$(curl "${curlOpts[@]}" "https://crates.io/api/v1/crates/$crate" |
  jq -r .crate.max_stable_version)"

echo "Prefetching latest tarball from crates.io" >&2

url="https://crates.io/api/v1/crates/$crate/$version/download"
prefetch="$(nix-prefetch-url --print-path --type sha256 --unpack "$url")"

cat >metadata.nix <<EOF
{
  pname = "$crate";
  version = "$version";
  sha256 = "$(printf '%s' "$prefetch" | head -n1)";
}
EOF

echo "Fetch Cargo.log"

tmp="$(mktemp -d)"

cleanup() {
  echo "Removing $tmp" >&2
  rm -rf "$tmp"
}

trap cleanup EXIT
rsync -a --chmod=ugo=rwX "$(printf '%s' "$prefetch" | tail -n1)/" "$tmp"
cp "$tmp/Cargo.lock" ./Cargo.lock
