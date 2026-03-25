{lib, ...}: {
  # check-nix.yml
  ".github/workflows/check-nix.yml" = {
    name = "check-nix";
    concurrency = {
      cancel-in-progress = true;
      group = "\${{ github.workflow }}-\${{ github.ref }}";
    };
    on = {
      push = {
        branches = ["main"];
        paths-ignore = [
          "**/*.md"
          ".github/**"
          "config/**"
          "docs/**"
        ];
      };
      pull_request = {};
      workflow_dispatch = {};
    };
    jobs =
      lib.mapAttrs' (name: system: {
        name = "check-flake-${name}";
        value = {
          runs-on = system;
          steps = [
            {
              uses = "actions/checkout@v6";
              "with" = {fetch-depth = 1;};
            }
            {uses = "DeterminateSystems/nix-installer-action@main";}
            {
              name = "Check flake evaluation";
              run = "nix -Lv flake check";
            }
          ];
        };
      }) {
        "linux" = "ubuntu-latest";
        # "darwin" = "macos-latest";
      };
  };
}
