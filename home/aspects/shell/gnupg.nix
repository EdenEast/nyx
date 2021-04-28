{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.shell.gnupg;
  mkEnableTrueOption = name: mkEnableOption name // { default = true; };
in {
  options.nyx.aspects.shell.gnupg = {
    enable = mkEnableOption "gnupg configuration";

    enableService = mkEnableTrueOption "gnupg service";
  };

  config = mkIf cfg.enable {
    home.file.".gnupg/public.key".source = ../../files/.gnupg/public.key;

    programs.gpg = {
      enable = true;
      settings = {
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list =
          "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
      };
    };

    services.gpg-agent = {
      enable = cfg.enableService;
      enableExtraSocket = true;
      enableScDaemon = false;
      enableSshSupport = true;
      verbose = true;
    };
  };
}
