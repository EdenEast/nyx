# Repository guidance

## Generating action workflows

If one of the following conditions are met ensure that you trigger nix-actions to regenerated the github action workflows.

- Add/edit a workflow definition in `modules/flake/actions/*.nix`
- Add a new package to `self.packages`
- Add a new host to `self.nixosConfigurations`, `self.homeConfigurations` or `self.darwinConfigurations`

If any of the above conditions have been met ensure that you regenerate the github action workflows with:

`nix run .#render-workflows --accept-flake-config`
