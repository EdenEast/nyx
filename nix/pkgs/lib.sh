function get_latest_version_from_crates_io() {
  local create curl_opts

  crate="$1"
  curl_opts=(
    -H "Accept: application/json"
    -H "User-Agent: $crate update script (https://github.com/edeneast/nyx)"
  )

  curl "${curl_opts[@]}" "https://crates.io/api/v1/crates/$crate" | jq -r .crate.max_stable_version
}

function get_latest_version_from_github() {
  local user repo curl_opts

  user="$1"
  repo="$2"

  curl_opts=(
    -H "Accept: application/json"
    -H "User-Agent: $crate update script (https://github.com/edeneast/nyx)"
  )

  curl "${curl_opts[@]}" "https://api.github.com/repos/$user/$repo/releases/latest" | jq -r .tag_name
}

function prefetch_from_crates_io() {
  local crate version

  crate="$1"
  version="$2"

  nix-prefetch-url --print-path --type sha256 --unpack "https://crates.io/api/v1/crates/$crate/$version/download"
}

function prefetch_from_github() {
  local user repo tag

  user="$1"
  repo="$2"
  tag="$3"

  nix-prefetch-url --print-path --type sha256 --unpack "https://api.github.com/repos/$user/$repo/tarball/$tag"
}

