{...}: _final: prev: {
  nushell = prev.nushell.overrideAttrs (old: {
    patches =
      old.patches
      ++ (prev.lib.optionals prev.stdenv.isDarwin [
        # Patch nushell on macos to use XDG_CONFIG_HOME
        ./0001-feat-Use-XDG_CONFIG_HOME-if-defined-on-macos.patch
      ]);
  });
}
