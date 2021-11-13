{ ... }:

{
  home.stateVersion = "20.09";

  nyx = {
    modules = {
      shell = {
        gnupg = {
          enable = true;
          enableService = false;
          publicKey = ../../config/.gnupg/public.key;
        };
      };
    };
    profiles = {
      common.enable = true;
      extended.enable = true;
      development.enable = true;
    };
  };
}
