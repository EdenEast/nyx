{
  self,
  inputs,
  config,
  ...
}: let
  inherit (inputs.nixpkgs) lib;

  specialArgsFor = rec {
    common = {
      flake = {inherit self inputs config;};
    };
    nixos = common;
    darwin = common;
  };
in {
  flake.lib =
    rec {
      inherit specialArgsFor;

      # Combine mapAttrs' and filterAttrs
      #
      # f can return null if the attribute should be filtered out.
      mapAttrsMaybe = f: attrs:
        lib.pipe attrs [
          (lib.mapAttrsToList f)
          (builtins.filter (x: x != null))
          builtins.listToAttrs
        ];

      forAllNixFiles = dir: f:
        if builtins.pathExists dir
        then
          lib.pipe dir [
            builtins.readDir
            (mapAttrsMaybe (
              fn: type:
                if lib.hasPrefix "_" fn || fn == "default.nix"
                then null
                else if type == "regular"
                then let
                  name = lib.removeSuffix ".nix" fn;
                in
                  if name != fn
                  then lib.nameValuePair name (f name "${dir}/${fn}")
                  else null
                else if type == "directory" && builtins.pathExists "${dir}/${fn}/default.nix"
                then lib.nameValuePair fn (f fn "${dir}/${fn}")
                else null
            ))
          ]
        else {};

      forAllNixFilesRecursive = dir: f:
        if builtins.pathExists dir
        then
          lib.pipe dir [
            builtins.readDir
            (mapAttrsMaybe (
              fn: type:
                if lib.hasPrefix "_" fn || fn == "default.nix"
                then null
                else if type == "regular"
                then let
                  name = lib.removeSuffix ".nix" fn;
                in
                  if name != fn
                  then lib.nameValuePair name (f name "${dir}/${fn}")
                  else null
                else if type == "directory"
                then forAllNixFilesRecursive "${dir}/${fn}" f
                else null
            ))
          ]
        else {};

      importAllNixFiles = dir: builtins.attrValues (forAllNixFiles dir (_name: fn: fn));
    }
    // lib;
}
