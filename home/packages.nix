{ pkgs, ... }: {

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
}
