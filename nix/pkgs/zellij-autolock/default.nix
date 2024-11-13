{ lib, fetchFromGitHub, rust-bin, makeRustPlatform, openssl, pkg-config, perl, curl, stdenv, darwin }:

let
  metadata = import ./metadata.nix;
  rustToolchain = rust-bin.stable.latest.minimal.override { targets = [ "wasm32-wasip1" ]; };
  rustPlatform = makeRustPlatform { rustc = rustToolchain; cargo = rustToolchain; };
in
rustPlatform.buildRustPackage {
  inherit (metadata) pname version;

  src = fetchFromGitHub metadata.fetch;
  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    curl
    darwin.apple_sdk.frameworks.CoreServices
  ];

  doCheck = false;

  buildPhase = ''
    cargo build --target="wasm32-wasip1" --release
    mkdir -p $out/bin;
  '';

  installPhase = ''
    mv \
      target/wasm32-wasip1/release/zellij-autolock.wasm \
      $out/bin/zellij-autolock.wasm
  '';

  meta = with lib; {
    description = "Autolock Zellij when certain processes open";
    homepage = "https://github.com/fresh2dev/zellij-autolock";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

