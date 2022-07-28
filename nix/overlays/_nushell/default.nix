{ inputs, ... }:
final: prev:

let
  outPath = inputs.nushell-src.outPath;
  cargoToml = outPath + "/Cargo.toml";
  lockfile = outPath + "/Cargo.lock";
  manifest = builtins.fromTOML (builtins.readFile cargoToml);
  short = inputs.nushell-src.shortRev;
in
{
  nushell = prev.nushell.override {
    rustPlatform.buildRustPackage = args:
      final.rustPackages.rustPlatform.buildRustPackage
      (builtins.removeAttrs args [ "cargoSha256" ] // {
        version = "${manifest.package.version}-${short}";
        src = outPath;
        cargoLock.lockFile = lockfile;
      });
  };
}

# There is currently an issue on mac compiling on osx
# error[E0432]: unresolved import `crate::osx_libproc_bindings::proc_pid_rusage`
#   --> /private/tmp/nix-build-nushell-0.66.2-e2a21af.drv-0/cargo-vendor-dir/libproc-0.12.0/src/libproc/pid_rusage.rs:12:5
#    |
# 12 | use crate::osx_libproc_bindings::proc_pid_rusage;
#    |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^---------------
#    |     |                            |
#    |     |                            help: a similar name exists in the module: `PROC_PID_RUSAGE`
#    |     no `proc_pid_rusage` in `osx_libproc_bindings`

# Could not use overrideAttrs here because I `cannot coerce a set to a string`
# Some references on how I was able to work around this issue
#
# - Explanation of the issue and why overrideAttrs is failing
#   - https://stackoverflow.com/a/39619891
# - Example of removing cargoSha256 and replace with lockfile
#   - https://github.com/danielphan2003/flk/blob/4ec3c59ed5d3ab1f9d7341dc9d6197c9f84adc37/overlays/spotify.nix
