{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.gnupg;
  mkEnableTrueOption = name: mkEnableOption name // { default = true; };

  publicKeyType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        default = "public.key";
        description = "Name of gpg key";
      };

      key = mkOption {
        type = types.path;
        default = null;
        description = "Gpg key path";
      };

      importKey = mkOption {
        type = types.bool;
        default = true;
        description = "Import key into gpg";
      };
    };
  };

  writeKeys = list:
    mapAttrs'
      (name: value:
        nameValuePair (".gnupg/${name}") ({
          source = value.key;
        })
      )
      (listToAttrs (map (x: nameValuePair x.name x) list))
  ;
in
{
  options.nyx.modules.shell.gnupg = {
    enable = mkEnableOption "gnupg configuration";

    enableService = mkEnableOption "gnupg service";

    publicKeys = mkOption {
      type = types.listOf publicKeyType;
      default = [ ];
      description = "List of public keys";
    };
  };

  config = mkIf cfg.enable (
    let
      activeKeys = filter (x: x.importKey) cfg.publicKeys;
    in
    mkMerge [
      {
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
      }

      (mkIf ((length cfg.publicKeys) > 0) {
        home.file = let keyfiles = writeKeys cfg.publicKeys; in keyfiles;
      })

      (mkIf ((length activeKeys) > 0) {
        home.activation.gpgtrust =
          let
            result = concatStringsSep "\n" (map (x: "${pkgs.gnupg}/bin/gpg --import ${x.key}") activeKeys);
          in
          hm.dag.entryAfter [ "installPackages" ] (result);
      })

      (mkIf cfg.enableService {
        services.gpg-agent = {
          enable = true;
          enableExtraSocket = true;
          enableScDaemon = false;
          enableSshSupport = true;
          verbose = true;
        };
      })
    ]
  );
}
