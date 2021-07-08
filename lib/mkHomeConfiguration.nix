{ self, lib, inputs, ... }:

{
  # Creates standalone home-manager configurations. Takes the name of thi host config created by the mkHostConfiguration
  mkHomeConfig = name: { configName ? name, system }:
    lib.nameValuePair name (
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit system;
        configuration = { ... }: {
          imports = [ inputs.self.internal.hostConfigurations."${configName}" ];

          xdg.configFile."nix/conf.nix".text =
            let
              nixConf = import ../nix/cache.nix;
            in
              ''
                substituters = ${builtins.concatStringsSep " " nixConf.binaryCache }
                trusted-public-keys = ${builtins.concatStringsSep " " nixConf.binaryCachePublicKeys}
                experimental-features = nix-command flakes
              '';
        };

        pkgs = lib.my.mkPkgs system;
        homeDirectory = "/home/eden";
        username = "eden";
        extraSpecialArgs = { inherit name inputs; };
      }
    );
}
