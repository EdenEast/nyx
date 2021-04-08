# Shared configuration options for `nix.conf` between NixOS and non-NixOS.
{
  binaryCaches =
    [ "https://cachix.cachix.org" "https://nix-community.cachix.org" ];

  binaryCachePublicKeys = [
    "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
}
