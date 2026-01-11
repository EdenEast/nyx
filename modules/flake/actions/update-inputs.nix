_: {
  ".github/workflows/update-inputs.yml" = {
    name = "update-inputs";
    on = {
      schedule = [
        {cron = "0 6 1 * *";} # At 06:00 on first day of the month
      ];
      workflow_dispatch = {};
    };
    jobs = {
      update-flake-lock = {
        runs-on = "ubuntu-latest";
        steps = [
          {
            uses = "actions/checkout@v5";
            "with" = {
              ref = "\${{ github.head_ref }}";
              fetch-depth = 1;
            };
          }
          {
            name = "Setup Git";
            run = ''
              git config --local user.name "github-actions[bot]"
              git config --local user.email "github-actions[bot]@users.noreply.github.com"
            '';
          }
          {uses = "DeterminateSystems/nix-installer-action@main";}
          {
            uses = "DeterminateSystems/update-flake-lock@main";
            "with" = {
              token = "\${{ secrets.PAT }}";
              branch = "automated/update_flake_lock_action";
              pr-title = "flake: update inputs";
              pr-assignees = "edeneast";
              pr-labels = ''
                dependencies
                automated
              '';
            };
          }
        ];
      };
    };
  };
}
