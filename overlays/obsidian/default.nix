_: _final: prev: {
  obsidian = prev.obsidian.overrideAttrs (old: let
    version = "1.14.4";
    baseUrl = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}";
    srcs = {
      x86_64-linux = prev.fetchurl {
        url = "${baseUrl}/obsidian-${version}.tar.gz";
        hash = "sha256-5wt81jeH5/eYqE/sRT9cRGuRh3vT9hLo+5jpt2zIESA=";
      };
      aarch64-linux = prev.fetchurl {
        url = "${baseUrl}/obsidian-${version}-arm64.tar.gz";
        hash = "sha256-/CEoBFFXE+2F/l71vEsAmHK8wBhHxL5PzBSXHe7ipC0=";
      };
      aarch64-darwin = prev.fetchurl {
        url = "${baseUrl}/Obsidian-${version}.dmg";
        hash = "sha256-3PgY3SDuXZ3T54Lu4MDExHzCJTg7BRwvya99V3L1n3A=";
      };
    };
  in {
    inherit version;
    src = srcs.${prev.stdenv.hostPlatform.system};
    passthru = (old.passthru or {}) // {inherit srcs;};
  });
}
