{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      bindkey -M emacs '^R' fzf-history-widget
      bindkey '^[[1;5C' forward-word   # Ctrl →
      bindkey '^[[1;5D' backward-word  # Ctrl ←

      # Load secrets from sops-nix (if they exist)
      [[ -r /run/secrets/openai_api_key ]] && export OPENAI_API_KEY=$(cat /run/secrets/openai_api_key)
      [[ -r /run/secrets/brave_api_key ]] && export BRAVE_API_KEY=$(cat /run/secrets/brave_api_key)
      [[ -r /run/secrets/anthropic_api_key ]] && export ANTHROPIC_API_KEY=$(cat /run/secrets/anthropic_api_key)
      [[ -r /run/secrets/notion_api_key ]] && export NOTION_API_KEY=$(cat /run/secrets/notion_api_key)

      # find and replace: far 'old' 'new' file1 file2 ...
      far() { sed -i "s|$1|$2|g" "''${@:3}"; }

      # quick nix commit
      gnix() { git -C /etc/nixos add -A && git -C /etc/nixos commit -m "$1"; }

      # only run for interactive shells
      if [[ $- == *i* ]]; then
      # don't start a zellij inside a zellij
        if [ -z "$ZELLIJ" ]; then
          # attach to "main" or create it
          zellij attach -c main
          # stop this shell so we don't have a zsh running underneath
          exit
        fi
      fi
    '';
    shellAliases = {
      clip = "xclip -selection clipboard";

      ga = "git add";
      gb = "git branch";
      gc = "git commit -m"; # (ok, just be aware some folks use gc for 'git clean')
      gd = "git diff";
      gdc = "git diff --cached";
      goo = "git checkout";
      gp = "git push";
      gs = "git status";
      gu = "git reset HEAD~";
      gcan = "git commit --amend --no-edit";
      gau = "git add -u .";
      ghack = "git add -u . && git commit --amend --no-edit && git push -f";
      glf = "git log --format=oneline";

      cnix = "sudo code /etc/nixos --no-sandbox --user-data-dir ~/.sudo-vscode";
      nbs = "sudo nixos-rebuild switch --flake /etc/nixos#adam-laptop";
      secrets = "sudo EDITOR=hx SOPS_AGE_KEY=$(sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key) sops /etc/nixos/secrets/secrets.yaml";

      night = "gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true";
      day = "gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false";
    };
  };

  programs.fzf = {
    enable = true; # installs fzf
    enableZshIntegration = true; # wires shell bindings
    defaultOptions = [
      "--height=40%"
      "--reverse"
      "--border"
    ];
  };
}
