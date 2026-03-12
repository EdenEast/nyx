{
  config,
  lib,
  self,
  ...
}: {
  config = lib.mkIf config.my.users.eden.enable {
    users.users.eden = {
      description = "James Simpson";
      extraGroups = config.my.users.defaultGroups;
      hashedPassword = config.my.users.eden.password;
      isNormalUser = true;

      openssh.authorizedKeys.keyFiles =
        lib.map (file: "${self.secretsDir}/public-keys/${file}")
        (lib.filter (file: lib.hasPrefix "eden_" file)
          (builtins.attrNames (builtins.readDir "${self.secretsDir}/public-keys")));

      uid = 1000;
    };
  };
}
