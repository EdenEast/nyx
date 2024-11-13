crates_api="https://crates.io/api/v1/crates"
gh_api="https://api.github.com/repos"
curl_opts=(
  -H "Accept: application/json"
  -H "User-Agent: update script (https://github.com/edeneast/nyx)"
  -sS
)

function get_latest_version_from_crates_io() {
  echo "Getting latest version from crates.io API" >&2
  local create result

  crate="$1"

  result=$(curl "${curl_opts[@]}" "$crates_api/$crate" | jq -r .crate.max_stable_version)
  echo "Version = $result" >&2 && echo "$result"
}

function get_latest_version_from_github() {
  echo "Getting latest version from github API" >&2
  local user repo result

  user="$1"
  repo="$2"

  result=$(curl "${curl_opts[@]}" "$gh_api/$user/$repo/releases/latest" | jq -r .tag_name)
  echo "Version = $result" >&2 && echo "$result"
}

function get_head_from_github() {
  echo "Getting HEAD from github API" >&2
  local user repo branch result

  user="$1"
  repo="$2"

  set +u
  branch="$3"
  if [[ -z $3 ]]; then
    branch=$(curl "${curl_opts[@]}" "$gh_api/$user/$repo" | jq -r .default_branch)
  fi
  set -u

  result=$(curl "${curl_opts[@]}" "$gh_api/$user/$repo/branches/$branch" | jq -r .commit.sha)
  echo "rev = $result" >&2 && echo "$result"
}

function prefetch_from_crates_io() {
  echo "Prefetching src from crates.io API" >&2
  local crate version

  crate="$1"
  version="$2"

  nix-prefetch-url --print-path --type sha256 --unpack "$crates_api/$crate/$version/download"
}

function prefetch_from_github() {
  echo "Prefetcing src from github API" >&2
  local user repo tag

  user="$1"
  repo="$2"
  tag="$3"

  nix-prefetch-url --print-path --type sha256 --unpack "$gh_api/$user/$repo/tarball/$tag"
}

function fetch_cargo_lock_from_store() {
  echo "Fetching Cargo.lock"
  local store
  store=$1

  cp -f "$store/Cargo.lock" ./Cargo.lock
}

function update_latest_version_from_crates_io() {
  local crate name version prefetch sha store

  crate="$1"
  name="${2:-$crate}"

  version="$(get_latest_version_from_crates_io "$crate")"
  prefetch="$(prefetch_from_crates_io "$crate" "$version")"
  sha="$(printf '%s' "$prefetch" | head -n1)"
  store="$(printf '%s' "$prefetch" | tail -n1)"

  echo "sha: $sha"
  echo "store: $store"

  cat >metadata.nix <<EOF
{
  pname = "$name";
  version = "$version";
  fetch = {
    pname = "$crate";
    version = "$version";
    sha256 = "$sha";
  };
}
EOF

  fetch_cargo_lock_from_store "$store"
}

function update_latest_version_from_github() {
  local user repo name version prefetch sha store

  user="$1"
  repo="$2"
  name="${3:-$repo}"

  version="$(get_latest_version_from_github "$user" "$repo")"
  prefetch="$(prefetch_from_github "$user" "$repo" "$version")"
  sha="$(printf '%s' "$prefetch" | head -n1)"
  store="$(printf '%s' "$prefetch" | tail -n1)"

  echo "sha: $sha"
  echo "store: $store"

  cat >metadata.nix <<EOF
{
  pname = "$name";
  version = "$version";
  fetch = {
    owner = "$user";
    repo = "$repo";
    rev = "$version";
    sha256 = "$sha";
  };
}
EOF

  if [ "$RUST_APPLICATION" ]; then
    fetch_cargo_lock_from_store "$store"
  fi
}

function update_head_from_github() {
  local user repo name rev prefetch sha store

  user="$1"
  repo="$2"
  postfix="${3:-git}"
  name="${4:-$repo}"

  rev="$(get_head_from_github "$user" "$repo")"
  prefetch="$(prefetch_from_github "$user" "$repo" "$rev")"
  sha="$(printf '%s' "$prefetch" | head -n1)"
  store="$(printf '%s' "$prefetch" | tail -n1)"

  echo "sha: $sha"
  echo "store: $store"

  cat >metadata.nix <<EOF
{
  pname = "$name";
  version = "$version-$postfix";
  fetch = {
    owner = "$user";
    repo = "$repo";
    rev = "$rev";
    sha256 = "$sha";
  };
}
EOF

  if [ "$RUST_APPLICATION" ]; then
    fetch_cargo_lock_from_store "$store"
  fi
}
