#!/usr/bin/env nix-shell
#! nix-shell -p nix jq curl
#! nix-shell -i bash

set -eu

cd "$(dirname "$0")"

user="fresh2dev"
repo="zellij-autolock"

source ../lib.sh

RUST_APPLICATION=1
update_latest_version_from_github "$user" "$repo"
