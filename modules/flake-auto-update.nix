# Watch claude-code-nix GitHub repo for new commits
{
  config,
  pkgs,
  lib,
  ...
}:

let
  stateDir = "/var/lib/check-claude-code";
  repo = "sadjow/claude-code-nix";

  checkScript = pkgs.writeShellScript "check-claude-code-update" ''
    set -e
    mkdir -p ${stateDir}

    # Get latest commit SHA from GitHub
    latest=$(${pkgs.curl}/bin/curl -sf \
      "https://api.github.com/repos/${repo}/commits/main" | \
      ${pkgs.jq}/bin/jq -r '.sha')

    if [ -z "$latest" ]; then
      echo "Failed to fetch latest commit"
      exit 0
    fi

    # Compare with last seen
    lastFile="${stateDir}/last-sha"
    if [ -f "$lastFile" ]; then
      last=$(cat "$lastFile")
    else
      last=""
    fi

    if [ "$latest" != "$last" ] && [ -n "$last" ]; then
      echo "New commit: $latest"

      # Notify logged-in users
      for uid in $(${pkgs.coreutils}/bin/ls /run/user/ 2>/dev/null); do
        sudo -u "#$uid" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
          ${pkgs.libnotify}/bin/notify-send \
            "Claude Code Update Available" \
            "Run: nix flake update claude-code-nix && sudo nixos-rebuild switch" \
            --icon=software-update-available \
          2>/dev/null || true
      done
    elif [ -z "$last" ]; then
      echo "First run, recording current SHA: $latest"
    else
      echo "No new commits"
    fi

    # Save current SHA
    echo "$latest" > "$lastFile"
  '';
in
{
  systemd.services.check-claude-code-update = {
    description = "Check GitHub for claude-code-nix updates";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString checkScript;
    };
    path = [
      pkgs.curl
      pkgs.jq
      pkgs.sudo
      pkgs.coreutils
    ];
  };

  systemd.timers.check-claude-code-update = {
    description = "Hourly claude-code-nix update check";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };
}
