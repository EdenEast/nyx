{ self, lib, inputs, ... }:

{
  # Creates standalone home-manager configurations. Takes the name of thi host config created by the mkHostConfiguration
  mkHomeConfig = name: { configName ? name, system }:
    lib.nameValuePair name (inputs.home-manager.lib.homeManagerConfiguration {
      inherit system;
      configuration = { ... }: {
        imports = [ inputs.self.internal.hostConfigurations."${configName}" ];
      };


      pkgs = lib.my.mkPkgs system;
      homeDirectory = "/home/eden";
      username = "eden";
      extraSpecialArgs = { inherit name inputs; };
    });
}
