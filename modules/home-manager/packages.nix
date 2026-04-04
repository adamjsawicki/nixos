{ pkgs, ... }: {

  home.packages = with pkgs; [
    # GUI apps
    _1password-gui
    brave
    obsidian
    protonvpn-gui
    remmina
    spotify

    # CLI tools (no HM module)
    bat
    eza
    ghostty
    jq
    ripgrep
    zellij

    # Coding Assistents
    codex
    claude-code

    # Allows 'jnoortheen.nix-ide' to work by providing language server + formatter
    nixfmt-rfc-style
    nil

    # openclaw
  ];
}
