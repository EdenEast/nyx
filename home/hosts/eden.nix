{ ... }:

{
  home.stateVersion = "20.09";

  nyx = {
    modules = {
      dev = {
        cc.enable = true;
        rust.enable = true;
      };
      shell = {
        gnupg = {
          enable = true;
          publicKeys = [{
            key = ../../config/.gnupg/public.key;
          }];
        };
        repo = let r = import ../common/repo.nix; in
          {
            enable = true;
            projects = r.projects;
            tags = r.tags;
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
