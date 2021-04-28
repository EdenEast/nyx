{ ... }:

{
  username = "eden";
  system = "x86_64-linux";
  config = {
    nyx = {
      aspects = {
        shell = {
          git = {
            userName = "James Simpson";
            userEmail = "edenofest@gmail.com";
          };

          gnupg = {
            enable = true;
            enableService = false;
          };
        };
      };
      profiles = {
        development.enable = true;
        extended.enable = true;
      };
    };
  };
}
