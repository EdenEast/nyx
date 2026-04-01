{
  config,
  lib,
  self,
  ...
}: {
  options.my.snippets.ssh.knownHosts = lib.mkOption {
    type = lib.types.attrs;
    description = "Default ssh known hosts.";

    default = {
      wrath = {
        hostNames = ["wrath" "wrath.local" "wrath.${config.my.snippets.tailnet.name}"];
        publicKeyFile = "${self.secretsDir}/publicKeys/root_wrath.pub";
      };
      thor = {
        hostNames = ["thor" "thor.local" "thor.${config.my.snippets.tailnet.name}"];
        publicKeyFile = "${self.secretsDir}/publicKeys/root_thor.pub";
      };
    };
  };
}
