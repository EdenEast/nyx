{pkgs, ...}: {
  systemd.user = {
    services.chatgpt-ping = {
      description = "Start a ChatGPT usage window with a minimal Pi prompt";
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = "%h";
        Environment = ["PATH=${pkgs.nodejs_24}/bin:${pkgs.coreutils}/bin"];
        TimeoutStartSec = "2min";
        ExecStart = toString (pkgs.writeShellScript "chatgpt-ping" ''
          export PI_CODING_AGENT_DIR="$HOME/.pi/agent"
          # Require subscription OAuth; never fall back to paid API usage.
          if ! ${pkgs.jq}/bin/jq -e '.openai.type == "oauth"' \
            "$PI_CODING_AGENT_DIR/auth.json" >/dev/null; then
            echo 'Log in to OpenAI with your ChatGPT subscription in Pi first.' >&2
            exit 1
          fi
          exec "$HOME/.local/bin/pi" \
            --provider openai --model 5.6-terra --thinking minimal \
            --print --no-session --no-tools \
            --no-extensions --no-skills --no-mcp \
            --no-context-files --no-prompt-templates --no-themes --no-approve \
            --system-prompt 'Reply to the prompt with only OK.' \
            'ping'
        '');
      };
    };
    timers.chatgpt-ping = {
      description = "Ping ChatGPT every five hours";
      timerConfig = {
        OnStartupSec = "5min";
        OnUnitActiveSec = "5h";
        Unit = "chatgpt-ping.service";
      };
      wantedBy = ["timers.target"];
    };
  };
}
