# Overlay current master version until new release is cut
# see: https://github.com/mozilla/sccache/issues/887

self: super:

let metadata = import ./metadata.nix;
in {
  sccache = super.sccache.overrideAttrs (old: rec {
    version = metadata.version;
    src = super.fetchFromGitHub {
      owner = "mozilla";
      repo = "sccache";
      rev = metadata.rev;
      sha256 = metadata.sha256;
    };

    cargoSha256 = metadata.cargoSha256;
  });
}

