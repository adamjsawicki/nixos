{ pkgs, ... }: {

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
        export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
        bindkey -M emacs '^R' fzf-history-widget
        bindkey '^[[1;5C' forward-word   # Ctrl →
        bindkey '^[[1;5D' backward-word  # Ctrl ←

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
      ga = "git add";
      gb = "git branch";
      gc =
        "git commit -m"; # (ok, just be aware some folks use gc for 'git clean')
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
      nbs = "sudo nixos-rebuild switch";
      gnix = ''git -C /etc/nixos add -A && git -C /etc/nixos commit -m "$@"'';

      night =
        "gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true";
      day =
        "gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false";
    };
  };
}
