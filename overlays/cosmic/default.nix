_: final: _prev: {
  # TODO: Remove https://github.com/NixOS/nixpkgs/commit/b16df2a922448e316bda92748b1cdb4b1a48fb13 once is in unstable
  inherit (final.master) cosmic-applets cosmic-settings-daemon;
}
