{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.my.home.programs.zen.enable = lib.mkEnableOption "zen web browser";

  config = lib.mkIf config.my.home.programs.zen.enable {
    programs.zen-browser.enable = true;

    # Notes:
    # require to change the following in `about:config`
    # - `zen.window-sync.enabled` to `false`
    #
    #   Introduced in version v1.18b (https://zen-browser.app/release-notes/#1.18b)
    #   Zen now sync the ENTIRE window across multiple windows. This change breaks
    #   the REASON to have multiple windows as tabs are now also synced across windows
    #   making creating a new window entirly pointless.
    #
    #   At the time of investigation it looks like the maintainer stating that this is the
    #   expected defaults and has not put a setting to disable it The only solution that
    #   stops the undesired behaviour is outlined here.
    #   https://github.com/zen-browser/desktop/pull/10034#issuecomment-3809427483
    #
    #   This however breaks other things like theming, esential and pinned tabs.
    #   The version before this change should be the expected behavour and this toggle does
    #   not get back to that state.
    #
    #   The issue is that a browser should not be pinned at a later verison if we do not
    #   like the change as that is a security consern.
    #
    #
    # - `zen.window-sync.prefer-unsynced-windows` to `true`
    #
    #   There is also this config value but unsure which is the correct resolution.
    #   https://github.com/zen-browser/desktop/issues/12008#issuecomment-3795584534
  };
}
