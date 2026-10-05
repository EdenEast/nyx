_: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    updater = pkgs.writeShellApplication {
      name = "agent-tools-update";
      runtimeInputs = with pkgs; [
        coreutils
        curl
        jq
        nodejs_24
        procps
      ];
      text = ''
        export NPM_CONFIG_PREFIX="''${NPM_CONFIG_PREFIX:-$HOME/.local}"
        export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

        current_step="starting"
        on_error() {
          local status="$?"
          echo
          echo "Update failed during: $current_step (exit $status)." >&2
          exit "$status"
        }
        trap on_error ERR
        step() {
          current_step="$1"
          printf '\n==> %s\n' "$current_step"
        }

        echo "Agent tools update"
        echo "Install prefix: $NPM_CONFIG_PREFIX"

        step "[1/5] Updating Claude Code"
        npm install --global @anthropic-ai/claude-code@latest

        step "[2/5] Updating Codex"
        npm install --global @openai/codex@latest
        if [[ ! -x "$NPM_CONFIG_PREFIX/bin/codex" ]]; then
          echo "Codex installed without an executable at $NPM_CONFIG_PREFIX/bin/codex." >&2
          exit 1
        fi
        "$NPM_CONFIG_PREFIX/bin/codex" --version

        step "[3/5] Updating Pi"
        npm install --global @earendil-works/pi-coding-agent@latest

        step "[4/5] Updating T3 Code CLI"
        if [[ -x "$HOME/.local/bin/t3" ]]; then
          "$HOME/.local/bin/t3" update
        else
          echo "T3 Code CLI is not installed. Downloading the official installer..."
          curl --fail --silent --show-error --location https://t3.codes/install.sh | sh
        fi

        if [[ "$(uname -s)" != Linux ]]; then
          echo "T3 Code Desktop AppImage is only installed on Linux; skipping."
          echo "All supported agent tools are up to date."
          exit 0
        fi

        case "$(uname -m)" in
          x86_64 | amd64) appimage_suffix="-x86_64.AppImage" ;;
          aarch64 | arm64) appimage_suffix="-arm64.AppImage" ;;
          *)
            echo "T3 Code Desktop has no supported AppImage for $(uname -m); skipping." >&2
            echo "All supported agent tools are up to date."
            exit 0
            ;;
        esac

        step "[5/5] Updating T3 Code Desktop"
        echo "Querying the latest stable GitHub release..."
        release_json="$(curl --fail --silent --show-error --location \
          https://api.github.com/repos/pingdotgg/t3code/releases/latest)"
        release_tag="$(jq --exit-status --raw-output '.tag_name' <<<"$release_json")"
        asset_url="$(jq --exit-status --raw-output --arg suffix "$appimage_suffix" \
          '.assets[] | select(.name | endswith($suffix)) | .browser_download_url' \
          <<<"$release_json")"
        asset_digest="$(jq --exit-status --raw-output --arg suffix "$appimage_suffix" \
          '.assets[] | select(.name | endswith($suffix)) | .digest' \
          <<<"$release_json")"
        asset_name="''${asset_url##*/}"

        install_dir="$HOME/.local/opt/t3-code"
        desktop_path="$install_dir/T3-Code.AppImage"
        version_path="$install_dir/version"
        installed_version=""
        if [[ -f "$version_path" ]]; then
          installed_version="$(<"$version_path")"
        fi

        echo "Latest release: $release_tag"
        if [[ -n "$installed_version" ]]; then
          echo "Installed release: $installed_version"
        else
          echo "Installed release: none"
        fi

        if [[ "$installed_version" == "$release_tag" && -x "$desktop_path" ]]; then
          echo "T3 Code Desktop is already up to date."
          echo "All agent tools are up to date."
          exit 0
        fi

        staging="$(mktemp --directory)"
        trap 'rm -rf "$staging"' EXIT
        echo "Downloading $asset_name..."
        curl --fail --show-error --location --progress-bar \
          "$asset_url" --output "$staging/$asset_name"

        echo "Verifying the published SHA-256 digest..."
        expected_hash="''${asset_digest#sha256:}"
        if [[ "$asset_digest" != sha256:* || -z "$expected_hash" ]]; then
          echo "T3 Code Desktop release has no SHA-256 digest." >&2
          exit 1
        fi
        actual_hash="$(sha256sum "$staging/$asset_name" | cut -d' ' -f1)"
        if [[ "$actual_hash" != "$expected_hash" ]]; then
          echo "T3 Code Desktop checksum verification failed." >&2
          exit 1
        fi

        if [[ -x "$desktop_path" ]] && pgrep --full --exact "$desktop_path" >/dev/null; then
          echo "T3 Code Desktop is running. Restart it after this update."
        fi

        echo "Digest verified."
        echo "Installing to $desktop_path..."
        mkdir --parents "$install_dir"
        install --mode=0755 "$staging/$asset_name" "$install_dir/.T3-Code.AppImage.new"
        mv --force "$install_dir/.T3-Code.AppImage.new" "$desktop_path"
        printf '%s\n' "$release_tag" >"$version_path"
        echo "Installed T3 Code Desktop $release_tag."
        echo "All agent tools are up to date."
      '';
    };

    launcher = pkgs.writeShellApplication {
      name = "t3-code-desktop";
      text = ''
        export PATH="$HOME/.local/bin:$PATH"
        app="$HOME/.local/opt/t3-code/T3-Code.AppImage"
        if [[ ! -x "$app" ]]; then
          echo "T3 Code Desktop is not installed. Run agent-tools-update first." >&2
          exit 1
        fi
        exec "$app" "$@"
      '';
    };

    desktopItem = pkgs.makeDesktopItem {
      name = "t3-code";
      desktopName = "T3 Code";
      comment = "Control coding agents on this computer";
      exec = "t3-code-desktop %U";
      icon = "application-x-executable";
      categories = ["Development"];
      terminal = false;
    };
  in {
    packages.agent-tools-update = pkgs.symlinkJoin {
      name = "agent-tools-update";
      paths = [
        updater
        launcher
        desktopItem
      ];
      meta = {
        description = "Install and update agent CLIs and T3 Code Desktop";
        license = lib.licenses.mit;
        mainProgram = "agent-tools-update";
        platforms = lib.platforms.unix;
      };
    };
  };
}
