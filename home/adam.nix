{ pkgs, ... }: {
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  ############################
  # Packages (no HM module)  #
  ############################
  home.packages = with pkgs; [
    # GUI apps
    brave
    spotify

    # CLI tools (no HM module)
    bat
    eza
    jq
    ripgrep

    # Coding Assistents
    codex
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
    '';
    shellAliases = {
      ga   = "git add";
      gb   = "git branch";
      gc   = "git commit -m";     # (ok, just be aware some folks use gc for 'git clean')
      gd   = "git diff";
      gdc  = "git diff --cached";
      goo  = "git checkout";
      gp   = "git push";
      gs   = "git status";
      gu   = "git reset HEAD~";
      gcan = "git commit --amend --no-edit";
      gau  = "git add -u .";
      ghack = "git add -u . && git commit --amend --no-edit && git push -f";
      glf  = "git log --format=oneline";
    };
  };

  programs.fzf = {
    enable = true;                 # installs fzf
    enableZshIntegration = true;   # wires shell bindings
    defaultOptions = [ "--height=40%" "--reverse" "--border" ];
  };

  programs.starship.enable = true;

  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        ms-python.python
        jnoortheen.nix-ide
      ];
      userSettings = {
        "editor.formatOnSave" = true;
        "files.trimTrailingWhitespace" = true;
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.sendKeybindingsToShell" = true;
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
