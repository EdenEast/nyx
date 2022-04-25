{ ... }:

{
  nyx = {
    modules = {
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
      desktop.enable = true;
      development.enable = true;
    };
  };
}
