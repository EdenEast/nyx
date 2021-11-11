{ inputs, ... }:

with inputs.nixpkgs.lib;
rec {
  # Derivation agnostic settings for all types of top level derivations (nixos, home-manager && darwin).
  mkUserHome = { config, system ? "x86_64-linux", ... }: {
    imports = [
      (import ../home/modules)
      (import ../home/profiles)
      (import config)
    ];

    # For compatibility with nix-shell, nix-build, etc.
    home.file.".nixpkgs".source = inputs.nixpkgs;
    home.sessionVariables."NIX_PATH" =
      "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";

    # TODO: Note sure where this should go
    home.sessionPath = [ "$HOME/.local/nyx/bin" "$XDG_BIN_HOME" ];
  };

  # Top level derivation for just home-manager
  mkHome = name: { config, username, system ? "x86_64-linux" }:
    let
      pkgs = inputs.self.pkgsBySystem."${system}";
      homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    in
      nameValuePair name (
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs system username homeDirectory;
          configuration = { ... }: {
            imports = let home = mkUserHome { inherit config system; }; in [ home ];
            specialArgs = { inherit name inputs self; };
          };
        }
      );
}
