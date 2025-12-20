{lib, ...}: {
  options = {
    mySnippets.nix.settings = lib.mkOption {
      type = lib.types.attrs;
      description = "Default nix settings shared across machines.";

      default = {
        auto-optimise-store = true;
        builders-use-substitutes = true;

        experimental-features = [
          "fetch-closure"
          "flakes"
          "nix-command"
          "pipe-operators"
        ];

        substituters = [
          "https://cache.nixos.org/"
          "https://edeneast.cachix.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "edeneast.cachix.org-1:a4tKrKZgZXXXYhDytg/Z3YcjJ04oz5ormt0Ow6OpExc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        trusted-users = ["eden" "@admin" "@wheel" "nixbuild"];
      };
    };
  };
}
