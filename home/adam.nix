{ pkgs, ... }: {
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # GUI apps
    brave
    obsidian
    remmina
    spotify

    # CLI tools (no HM module)
    bat
    eza
    jq
    ripgrep
    zellij

    # Coding Assistents
    codex

    # Allows 'jnoortheen.nix-ide' to work by providing language server + formatter
    nixfmt-classic
    nil
  ];

  ############################
  # Program modules (HM-managed install + config)
  ############################
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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

  programs.fzf = {
    enable = true; # installs fzf
    enableZshIntegration = true; # wires shell bindings
    defaultOptions = [ "--height=40%" "--reverse" "--border" ];
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.starship.enable = true;

  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        golang.go
        jnoortheen.nix-ide
        mkhl.direnv
        ms-python.python
      ];

      userSettings = {
        # General
        "editor.formatOnSave" = true;
        "files.trimTrailingWhitespace" = true;
        "update.mode" = "none";

        # Terminal
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.sendKeybindingsToShell" = true;

        # Nix LSP
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        "nix.serverSettings" = {
          "nil" = { "formatting" = { command = [ "nixfmt" ]; }; };
        };
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Adam Sawicki";
    userEmail = "sawicki.adam.j@gmail.com";
    extraConfig = {
      safe.directory = "/etc/nixos";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;

      # 👇 Force HTTPS → SSH rewrite for GitHub (applies globally)
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  ############################
  # XDG / Desktop tweaks
  ############################
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "x-scheme-handler/mailto" = [ "brave-browser.desktop" ];
    };
  };

  dconf.settings."org/gnome/shell".favorite-apps = [
    "org.gnome.Console.desktop"
    "brave-browser.desktop"
    "code.desktop"
    "spotify.desktop"
  ];

  home.sessionVariables = {
    SUDO_EDITOR = "code --wait";
    VISUAL = "code --wait";
    EDITOR = "code --wait";
  };
}
