_: {
  # check-nix.yml
  ".github/workflows/check-upstream-todo.yml" = {
    name = "check-upstream-todos";
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
      pull_request = {
        branches = ["main"];
      };
      schedule = [
        {cron = "0 6 1 * *";} # At 06:00 on first day of the month
        # {cron = "0 0 * * 0";} # Weekly on Sunday
      ];
      workflow_dispatch = {};
    };
    jobs = {
      check-flake = {
        runs-on = "ubuntu-latest";
        steps = [
          {
            uses = "actions/checkout@v6";
            "with" = {fetch-depth = 1;};
          }
          {uses = "DeterminateSystems/nix-installer-action@main";}
          {
            name = "Check flake evaluation";
            run = "nix run .#todo-check";
          }
        ];
      };
    };
  };
}
