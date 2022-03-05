{
  description = "Rust application and setup env";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, fenix, naersk, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        # ----------------------------------------------------------------------
        # TODO: Pick a toolchain to support
        toolchain = fenix.packages."${system}".stable;
        # toolchain = fenix.packages."${system}".latest;
        # toolchain = fenix.packages."${system}".fromToolchainFile { dir = ./.; };
        # ----------------------------------------------------------------------

        naersk-lib = naersk.lib."${system}".override {
          cargo = toolchain.cargo;
          rustc = toolchain.rustc;
        };

        manifest = builtins.fromTOML (builtins.readFile ./Cargo.toml);
        version = manifest.package.version;

        rust-app = naersk-lib.buildPackage {
          inherit version;
          pname = "rust-app";
          root = ./.;

          buildInputs = with pkgs; [ ];
          nativeBuildInputs = with pkgs; [ ];
        };

        devShell = pkgs.mkShell {
          name = "rust-app";
          packages = with pkgs; with toolchain; [
            # Core rust
            rustc
            cargo
            rust-src

            # Development tools
            rust-analyzer
            rustfmt-preview
            clippy-preview

            # Cargo extensions
            cargo-bloat
            cargo-edit
            cargo-limit
            cargo-watch
            cargo-whatfeatures

            # ------------------------------------------------------------------
            # These might be required.
            # pkg-config
            # openssl
            # ------------------------------------------------------------------
          ] ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
            libiconv
          ]);

          CARGO_BUILD_RUSTFLAGS = if pkgs.stdenv.isDarwin then "-C rpath" else null;
          RUST_SRC_PATH = "${toolchain.rust-src}/lib/rustlib/src/rust/library";
        };
      in
      rec {
        inherit devShell;

        # `nix build`
        packages.rust-app = rust-app;
        defaultPackage = self.packages.${system}.rust-app;

        # `nix run`
        apps.rust-app = inputs.flake-utils.lib.mkApp { drv = packages.rust-app; };
        defaultApp = apps.rust-app;
      });
}

