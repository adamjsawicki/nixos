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

      # find and replace: far 'old' 'new' file1 file2 ...
      far() { sed -i "s|$1|$2|g" "''${@:3}"; }

      # quick nix commit
      gnix() { git -C /etc/nixos add -A && git -C /etc/nixos commit -m "$1"; }

      # Auto-start zellij for interactive shells (but not in VSCode or already in zellij)
      # Only exit if zellij ran cleanly — otherwise leave a usable shell to debug from.
      if [[ $- == *i* && -z "$ZELLIJ" && "$TERM_PROGRAM" != "vscode" ]]; then
        if zellij attach -c main; then
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
      nbs = "sudo nixos-rebuild switch --flake /etc/nixos";
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
