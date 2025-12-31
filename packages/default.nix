{lib, ...}: {
  # If I use self.lib to import this I get infinate recursion.
  imports = with lib;
    map (fn: ./${fn})
    (builtins.attrNames (
      filterAttrs (
        n: _v: (!(hasPrefix "_" n) && !(hasPrefix "default" n))
      ) (builtins.readDir ./.)
    ));

  perSystem = {pkgs, ...}: {
    packages = {
      space-sanitize = pkgs.writeShellScriptBin "space-sanitize" ''
        # Loop through files with spaces in their names
        for file in *' '*; do
          # Replace spaces with underscores
          new_name=$(echo "$file" | tr ' ' '_')

          # Rename the file
          mv "$file" "$new_name"
          echo "Renamed: $file to $new_name"
        done
      '';
    };
  };
}
