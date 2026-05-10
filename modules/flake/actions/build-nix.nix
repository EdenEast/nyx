{
  lib,
  self,
  ...
}: {
  ".github/workflows/build-nix.yml" = {
    name = "build-nix";
    concurrency = {
      group = "\${{ github.workflow }}-\${{ github.ref }}";
      cancel-in-progress = true;
    };
    on = {
      push = {
        branches = ["main"];
        paths = [
          "flake.lock"
          "flake.nix"
          "packages/"
        ];
      };
      pull_request = {};
      workflow_dispatch = {};
    };
    jobs = let
      packages = lib.pipe (self.packages.x86_64-linux or {}) [
        # skip actions-nix render-workflow package
        (lib.filterAttrs (name: _: name != "render-workflows"))
        lib.attrNames
      ];

      packageJobs = lib.listToAttrs (map
        (name: {
          name = "build-package-${name}";
          value = {
            runs-on = "ubuntu-latest";
            steps = [
              {
                uses = "actions/checkout@v6";
                "with" = {fetch-depth = 1;};
              }
              {uses = "DeterminateSystems/nix-installer-action@main";}
              {
                uses = "cachix/cachix-action@master";
                "with" = {
                  name = "edeneast";
                  authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
                };
              }
              {
                name = "Build package ${name}";
                run = "nix build --accept-flake-config --print-out-paths --show-trace .#packages.x86_64-linux.${name}";
              }
            ];
          };
        })
        packages);

      shellJob = {
        "build-shell" = {
          runs-on = "ubuntu-latest";
          steps = [
            {
              uses = "actions/checkout@v6";
              "with" = {fetch-depth = 1;};
            }
            {uses = "DeterminateSystems/nix-installer-action@main";}
            {
              uses = "cachix/cachix-action@master";
              "with" = {
                name = "edeneast";
                authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
              };
            }
            {
              name = "Build development shell environment";
              run = "nix develop --accept-flake-config --show-trace --profile ./dev-shell-profile --command true";
            }
            {
              name = "Cache development shell environment";
              run = "cachix push edeneast ./dev-shell-profile";
            }
          ];
        };
      };
    in
      packageJobs // shellJob;
  };
}
