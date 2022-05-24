#!/usr/bin/env nix-shell
#! nix-shell -p nix jq curl rsync cargo
#! nix-shell -i bash

set -eu

cd "$(dirname "$0")"

user="katharostech"
repo="cast2gif"

source ../lib.sh

tag=$(get_latest_version_from_github $user $repo)
version="$(printf '%s' "$tag" | cut -c 2-)"

rev=$(get_head_from_github $user $repo)
prefetch="$(prefetch_from_github $user $repo $rev)"
sha="$(printf '%s' "$prefetch" | head -n1)"
store="$(printf '%s' "$prefetch" | tail -n1)"

cat >metadata.nix <<EOF
{
  pname = "$repo";
  version = "$version-git";
  fetch = {
    owner = "$user";
    repo = "$repo";
    rev = "$rev";
    sha256 = "$sha";
  };
}
EOF

echo "Fetching Cargo.lock"
cp -f "$store/Cargo.lock" ./Cargo.lock

