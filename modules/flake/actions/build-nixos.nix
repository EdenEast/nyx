{
  lib,
  self,
  ...
}: {
  ".github/workflows/build-nixos.yml" = {
    name = "build-nixos";
    concurrency = {
      group = "\${{ github.workflow }}-\${{ github.ref }}";
      cancel-in-progress = true;
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
      lib.mapAttrs'
      (hostname: _: {
        name = "build-${hostname}";
        value = {
          runs-on = "ubuntu-latest";
          steps = [
            {
              name = "Free Disk Space (Ubuntu)";
              uses = "jlumbroso/free-disk-space@main";
            }
            {
              name = "Checkout";
              uses = "actions/checkout@v5";
              "with" = {fetch-depth = 1;};
            }
            {
              name = "Install Nix";
              uses = "DeterminateSystems/nix-installer-action@main";
            }
            {
              name = "Cachix";
              uses = "cachix/cachix-action@master";
              "with" = {
                name = "edeneast";
                authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
              };
            }
            {
              name = "Build ${hostname}";
              run = "nix build --accept-flake-config --print-out-paths --show-trace .#nixosConfigurations.${hostname}.config.system.build.toplevel";
            }
          ];
        };
      })
      self.nixosConfigurations;
  };
}
