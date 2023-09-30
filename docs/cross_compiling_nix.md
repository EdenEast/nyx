In `lagacyPackages` there is a package called `pkgsCross`. In the nixpkgs repo you can cross compile a package with the
following command.

```
nix build .#pkgsCross.aarch64-multiplatform.<package>
```

Here is a raw output of the values under `pkgsCross`

```
nix-repl> legacyPackages.x86_64-linux.pkgsCross.
legacyPackages.x86_64-linux.pkgsCross.aarch64-android             legacyPackages.x86_64-linux.pkgsCross.i686-embedded               legacyPackages.x86_64-linux.pkgsCross.msp430                      legacyPackages.x86_64-linux.pkgsCross.riscv64-embedded
legacyPackages.x86_64-linux.pkgsCross.aarch64-android-prebuilt    legacyPackages.x86_64-linux.pkgsCross.iphone32                    legacyPackages.x86_64-linux.pkgsCross.musl-power                  legacyPackages.x86_64-linux.pkgsCross.rx-embedded
legacyPackages.x86_64-linux.pkgsCross.aarch64-darwin              legacyPackages.x86_64-linux.pkgsCross.iphone32-simulator          legacyPackages.x86_64-linux.pkgsCross.musl32                      legacyPackages.x86_64-linux.pkgsCross.s390
legacyPackages.x86_64-linux.pkgsCross.aarch64-embedded            legacyPackages.x86_64-linux.pkgsCross.iphone64                    legacyPackages.x86_64-linux.pkgsCross.musl64                      legacyPackages.x86_64-linux.pkgsCross.s390x
legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform       legacyPackages.x86_64-linux.pkgsCross.iphone64-simulator          legacyPackages.x86_64-linux.pkgsCross.muslpi                      legacyPackages.x86_64-linux.pkgsCross.sheevaplug
legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform-musl  legacyPackages.x86_64-linux.pkgsCross.loongarch64-linux           legacyPackages.x86_64-linux.pkgsCross.or1k                        legacyPackages.x86_64-linux.pkgsCross.ucrt64
legacyPackages.x86_64-linux.pkgsCross.aarch64be-embedded          legacyPackages.x86_64-linux.pkgsCross.m68k                        legacyPackages.x86_64-linux.pkgsCross.pogoplug4                   legacyPackages.x86_64-linux.pkgsCross.vc4
legacyPackages.x86_64-linux.pkgsCross.arm-embedded                legacyPackages.x86_64-linux.pkgsCross.mingw32                     legacyPackages.x86_64-linux.pkgsCross.powernv                     legacyPackages.x86_64-linux.pkgsCross.wasi32
legacyPackages.x86_64-linux.pkgsCross.armhf-embedded              legacyPackages.x86_64-linux.pkgsCross.mingwW64                    legacyPackages.x86_64-linux.pkgsCross.ppc-embedded                legacyPackages.x86_64-linux.pkgsCross.x86_64-darwin
legacyPackages.x86_64-linux.pkgsCross.armv7a-android-prebuilt     legacyPackages.x86_64-linux.pkgsCross.mips-embedded               legacyPackages.x86_64-linux.pkgsCross.ppc64                       legacyPackages.x86_64-linux.pkgsCross.x86_64-embedded
legacyPackages.x86_64-linux.pkgsCross.armv7l-hf-multiplatform     legacyPackages.x86_64-linux.pkgsCross.mips-linux-gnu              legacyPackages.x86_64-linux.pkgsCross.ppc64-musl                  legacyPackages.x86_64-linux.pkgsCross.x86_64-freebsd
legacyPackages.x86_64-linux.pkgsCross.avr                         legacyPackages.x86_64-linux.pkgsCross.mips64-embedded             legacyPackages.x86_64-linux.pkgsCross.ppcle-embedded              legacyPackages.x86_64-linux.pkgsCross.x86_64-netbsd
legacyPackages.x86_64-linux.pkgsCross.ben-nanonote                legacyPackages.x86_64-linux.pkgsCross.mips64-linux-gnuabi64       legacyPackages.x86_64-linux.pkgsCross.raspberryPi                 legacyPackages.x86_64-linux.pkgsCross.x86_64-netbsd-llvm
legacyPackages.x86_64-linux.pkgsCross.bluefield2                  legacyPackages.x86_64-linux.pkgsCross.mips64-linux-gnuabin32      legacyPackages.x86_64-linux.pkgsCross.remarkable1                 legacyPackages.x86_64-linux.pkgsCross.x86_64-unknown-redox
legacyPackages.x86_64-linux.pkgsCross.fuloongminipc               legacyPackages.x86_64-linux.pkgsCross.mips64el-linux-gnuabi64     legacyPackages.x86_64-linux.pkgsCross.remarkable2
legacyPackages.x86_64-linux.pkgsCross.ghcjs                       legacyPackages.x86_64-linux.pkgsCross.mips64el-linux-gnuabin32    legacyPackages.x86_64-linux.pkgsCross.riscv32
legacyPackages.x86_64-linux.pkgsCross.gnu32                       legacyPackages.x86_64-linux.pkgsCross.mipsel-linux-gnu            legacyPackages.x86_64-linux.pkgsCross.riscv32-embedded
legacyPackages.x86_64-linux.pkgsCross.gnu64                       legacyPackages.x86_64-linux.pkgsCross.mmix                        legacyPackages.x86_64-linux.pkgsCross.riscv64
```

- [discourse discussion](https://discourse.nixos.org/t/how-do-i-cross-compile-a-flake/12062/12)
