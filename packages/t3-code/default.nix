_: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages = {
      t3-code = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "t3-code";
        version = "0.0.45";

        desktopItem = pkgs.makeDesktopItem {
          name = "t3-code";
          desktopName = "T3 Code";
          exec = "t3-code %U";
          icon = "t3-code";
          categories = ["Development"];
          startupWMClass = "t3code";
          mimeTypes = ["x-scheme-handler/t3code"];
        };

        src = pkgs.fetchFromGitHub {
          owner = "pingdotgg";
          repo = "t3code";
          tag = "v${finalAttrs.version}";
          hash = "sha256-8drTHjFqa2vJ96jhpRZXmNbtbXtKk1q40jOEp9dohNc=";
        };

        pnpmWorkspaces = [
          "@t3tools/desktop..."
          "@t3tools/web..."
          "@t3tools/scripts..."
          "t3..."
        ];

        pnpmDeps = pkgs.fetchPnpmDeps {
          inherit (finalAttrs) pname version src pnpmWorkspaces;
          pnpm = pkgs.pnpm_11;
          fetcherVersion = 4;
          hash = "sha256-2dGEHOQrnidTei54NlZTJh5u5/i810hb2LddK4XfUNQ=";
        };

        cargoRoot = "native/resource-monitor";

        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = "${finalAttrs.src}/native/resource-monitor/Cargo.lock";
        };

        nativeBuildInputs = [
          pkgs.cargo
          pkgs.makeWrapper
          pkgs.nodejs_24
          pkgs.pnpm_11
          pkgs.pnpmConfigHook
          pkgs.rustc
          pkgs.rustPlatform.cargoSetupHook
        ];

        env = {
          ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
          PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
          SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
          npm_config_build_from_source = "true";
        };

        buildPhase = ''
          runHook preBuild

          pnpm run build:desktop
          cargo build --locked --release --manifest-path native/resource-monitor/Cargo.toml

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/lib/t3-code $out/bin
          cp -R . $out/lib/t3-code
          install -Dm755 native/resource-monitor/target/release/t3-resource-monitor \
            $out/lib/t3-code/native/resource-monitor/target/release/t3-resource-monitor
          install -Dm644 assets/prod/black-universal-1024.png \
            $out/share/icons/hicolor/1024x1024/apps/t3-code.png
          mkdir -p $out/share/applications
          cp ${finalAttrs.desktopItem}/share/applications/* $out/share/applications/

          makeWrapper ${lib.getExe pkgs.electron_43} $out/bin/t3-code \
            --add-flags $out/lib/t3-code/apps/desktop

          runHook postInstall
        '';

        meta = {
          description = "Agentic coding environment from T3 Tools";
          homepage = "https://github.com/pingdotgg/t3code";
          license = lib.licenses.asl20;
          mainProgram = "t3-code";
          platforms = ["x86_64-linux"];
        };
      });
    };
  };
}
