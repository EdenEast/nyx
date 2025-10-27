{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.myUsers.eden.enable {
    users.users.eden = {
      # description = "EdenEast";
      description = "Eden";
      extraGroups = config.myUsers.defaultGroups;
      hashedPassword = config.myUsers.eden.password;
      isNormalUser = true;

      shell = pkgs.zsh;
      uid = 1000;
    };
  };
}
