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
        lib.map (file: "${self.secretsDir}/publicKeys/${file}")
        (lib.filter (file: lib.hasPrefix "eden_" file)
          (builtins.attrNames (builtins.readDir "${self.secretsDir}/publicKeys")));

      uid = 1000;
    };
  };
}
