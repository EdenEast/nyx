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
            signing = {
              key = "5A038CEFD458DB47A6135B3F8316DECECB1A3F10";
            };
          };

          gnupg = {
            enable = true;
            enableService = false;
            publicKey = ../../home/files/.gnupg/public.key;
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
