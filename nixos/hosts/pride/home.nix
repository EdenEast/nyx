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
        git = {
          userName = "James Simpson";
          userEmail = "edenofest@gmail.com";
          signing.key = "5A038CEFD458DB47A6135B3F8316DECECB1A3F10";
        };

        gnupg = {
          enable = true;
          enableService = false;
          publicKey = ../../../config/.gnupg/public.key;
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
