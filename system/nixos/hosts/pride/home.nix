{ ... }:

{
  nyx = {
    modules = {
      app = {
        alacritty.fontSize = 8;
        wezterm.fontSize = 14;
        obs.enable = true;
      };
      shell = {
        gnupg = {
          enable = true;
          publicKey = ../../../../config/.gnupg/public.key;
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
