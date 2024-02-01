# https://cmacr.ae/post/2020-05-09-managing-firefox-on-macos-with-nix/
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.app.firefox;

  # Settings found in about:config
  defaultSettings = {
    "app.update.auto" = false;
    "browser.startup.homepage" = "https://github.com";
    "browser.ctrlTab.sortByRecentlyUsed" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
    "reader.color_scheme" = "sepia";
  };
in
{
  options.nyx.modules.app.firefox = {
    enable = mkEnableOption "firefox configuration";
  };

  config = mkIf cfg.enable {
    programs.firefox =
      let
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          darkreader
          privacy-badger
          tree-style-tab
          ublock-origin
          vimium
        ];
      in
      {
        enable = true;
        profiles = {
          home = {
            # inherit extensions;
            id = 0;
            settings = defaultSettings // {
              "browser.urlbar.placeholderName" = "DuckDuckGo";
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            };
          };

          work = {
            # inherit extensions;
            id = 1;
            settings = defaultSettings // {
              "browser.startup.homepage" = "about:blank";
            };
          };
        };
      };
  };
  # config = mkIf cfg.enable {
  #   programs.firefox = {
  #     enable = true;
  #     extensions = with pkgs.nur.repos.rycee.firefox-addons; [
  #       https-everywhere
  #       darkreader
  #     ];
  #     # profiles = let
  #     #   defaultSettings = {
  #     #     "app.update.auto" = false;
  #     #     "browser.startup.homepage" = "https://github.com";
  #     #   };
  #     # in
  #     #   {
  #     #     home = {
  #     #       id = 0;
  #     #       settings = defaultSettings // {
  #     #         "browser.urlbar.placeholderName" = "DuckDuckGo";
  #     #         "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  #     #       };
  #     #       # userChrome = builtins.readFile ../conf.d/userChrome.css;
  #     #     };

  #     #     work = {
  #     #       id = 1;
  #     #       settings = defaultSettings // {
  #     #         "browser.startup.homepage" = "about:blank";
  #     #       };
  #     #     };
  #     #   };
  #   };
}
