{ ... }:
final: prev:

{
  nushell = prev.nushell.overrideAttrs (old: {
    patches = old.patches ++ [
      # Patch nushell on macos to use XDG_CONFIG_HOME
      ./0001-feat-Use-XDG_CONFIG_HOME-if-defined-on-macos.patch
    ];
  });
}
