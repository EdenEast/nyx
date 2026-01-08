{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.myUsers.eden.enable {
    users.users.eden = {
      description = "James Simpson";
      extraGroups = config.myUsers.defaultGroups;
      hashedPassword = config.myUsers.eden.password;
      isNormalUser = true;

      uid = 1000;
    };

    nix.settings.trusted-users = ["eden"];
  };
}
