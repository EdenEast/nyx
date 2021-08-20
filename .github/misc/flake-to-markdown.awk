# Parses a flake lock update commit and output readable markdown with proper
# compare links

function unquote (str) {
  len = length(str);
  return substr(str, 2, len - 3)
}

function parse_flakeref (flakeref, res) {
  split(flakeref, arr, ":");
  type = arr[1];
  tmp = arr[2];
  split(tmp, arr, "?");
  tmp = arr[1];
  n = split(tmp, arr, "/");
  commit = arr[n];
  repo = arr[1]
  for (i = 2; i < n; i++) {
    repo = repo "/" arr[i];
  }

  res["type"] = type;
  res["commit"] = commit;
  res["repo"] = repo;
}

function short (sha) {
  return substr(sha, 1, 8);
}

$2 !~ /^Updated$/ {
  print $0
}

$2 ~ /^Updated$/ {
  input = unquote($3);
  from = unquote($4);
  to = unquote($6);
  parse_flakeref(from, parsed_from);
  parse_flakeref(to, parsed_to);
  type = parsed_from["type"];
  repo = parsed_from["repo"];
  from_commit = parsed_from["commit"];
  to_commit = parsed_to["commit"];

  if (type == "github") {
    printf(" - Updated `%s`: [`%s` ➡️ `%s`](https://github.com/%s/compare/%s..%s)\n", input, short(from_commit), short(to_commit), repo, from_commit, to_commit);
  } else if (type == "gitlab") {
    printf(" - Updated `%s`: [`%s` ➡️ `%s`](https://gitlab.com/%s/-/compare/%s...%s)\n", input, short(from_commit), short(to_commit), repo, from_commit, to_commit);
  } else {
    printf(" - Updated `%s`: `%s` ➡️ `%s`\n", input, from, to);
  }
}
