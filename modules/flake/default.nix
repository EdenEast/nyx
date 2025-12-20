{lib, ...}: {
  imports = with lib;
    map (fn: ./${fn})
    (builtins.attrNames (
      filterAttrs (
        n: _v: (!(hasPrefix "_" n) && !(hasPrefix "default" n))
      ) (builtins.readDir ./.)
    ));
}
