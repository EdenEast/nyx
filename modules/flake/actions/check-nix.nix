_: {
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
    jobs = {
      check-flake = {
        runs-on = "ubuntu-latest";
        steps = [
          {
            uses = "actions/checkout@v5";
            "with" = {fetch-depth = 1;};
          }
          {uses = "DeterminateSystems/nix-installer-action@main";}
          {
            name = "Check flake evaluation";
            run = "nix -Lv flake check --all-systems";
          }
        ];
      };
    };
  };
}
