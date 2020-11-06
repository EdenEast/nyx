{ config, lib, ... }:

{
  home.stateVersion = "20.09";
  nyx = {
    configs = {};
    profiles = {
      development.enable = true;
    };
  };
}
