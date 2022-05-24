crates_api="https://crates.io/api/v1/crates"
gh_api="https://api.github.com/repos"
curl_opts=(
  -H "Accept: application/json"
  -H "User-Agent: $repo update script (https://github.com/edeneast/nyx)"
  -sS
)

function unquote() {
  echo $1 | awk '{print substr($0, 2, length($0)-2)}' -
}

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

function get_latest_Version_from_github_tags() {
  echo "Getting latest version from github tags API" >&2
  local user repo json version rev

  user="$1"
  repo="$2"

  # json=$(curl "${curl_opts[@]}" "$gh_api/$user/$repo/tags")
  json=$(cat api)
  tag=$(printf '%s' "$json" | jq '[.[].name] | max')
  rev=$(printf '%s' "$json" | jq ".[] | select(.name == $tag) | .commit.sha")

  tag=$(unquote $tag)
  rev=$(unquote $rev)

  echo "Tag: $tag" >&2
  echo "Rev: $rev" >&2

  echo "$tag"
  echo "$rev"
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
