{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.my.users.eden.enable {
    users.users.eden = {
      description = "James Simpson";
      extraGroups = config.my.users.defaultGroups;
      hashedPassword = config.my.users.eden.password;
      isNormalUser = true;

      uid = 1000;
    };
  };
}
