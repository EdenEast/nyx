{ ... }:

_final: prev:

let
  sha256 = "sha256-t6n4uID7KTu/BqsmndJOft0ifxZNfv9lfqlzFX0ApKw=";
  version = "0.2.0";
in
{
  # https://github.com/NixOS/nixpkgs/issues/86349
  vhs = (prev.callPackage "${prev.path}/pkgs/applications/misc/vhs" {
    buildGoModule = args: prev.buildGoModule (args // {
      version = version;
      src = prev.fetchFromGitHub {
        owner = "charmbracelet";
        repo = "vhs";
        rev = "v${version}";
        sha256 = "sha256-t6n4uID7KTu/BqsmndJOft0ifxZNfv9lfqlzFX0ApKw=";
      };

      vendorHash = "sha256-9nkRr5Jh1nbI+XXbPj9KB0ZbLybv5JUVovpB311fO38=";
    });
  });

  # (self: super: {
  #   bazel-gazelle = (super.callPackage "${super.path}/pkgs/development/tools/bazel-gazelle" {
  #     buildGoModule = args: super.buildGoModule (args // {
  #       modSha256 = "13yx70p0x7hpdp2zn7zrl0i88fk6dhcryp0lmn0zwdn92ldm3n5y";
  #       patches = (args.patches or []) ++ super.lib.lists.singleton (super.fetchpatch {
  #         url = "https://github.com/bazelbuild/bazel-gazelle/pull/749.patch";
  #         sha256 = "03sxbgwvb6hxwpmk9mckwjzgxank9difc0bgvzl6x3rir76ivwmj";
  #       });
  #     });
  #   });
  # })

  # vhs = prev.vhs.overrideAttrs (
  #   old: rec {
  #     version = "0.2.0";
  #     src = prev.fetchFromGitHub {
  #       owner = "charmbracelet";
  #       repo = "vhs";
  #       rev = "v${version}";
  #       sha256 = sha256;
  #     };
  #
  #     modSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #     vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #     vendorSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #   }
  # );
}
