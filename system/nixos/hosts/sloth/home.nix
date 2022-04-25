{ ... }:

{
  nyx = {
    modules = {
      # Set the default theme for this host
      theme.colors = with builtins;
        fromJSON (readFile ../../../../home/modules/theme/nightfox.json);

      shell = {
        gnupg = {
          enable = true;
          publicKeys = [{
            key = ../../../../config/.gnupg/public.key;
          }];
        };
      };
    };
    profiles = {
      common.enable = true;
      extended.enable = true;
      desktop = {
        enable = true;
        laptop = true;
      };
      development.enable = true;
    };
  };
}
