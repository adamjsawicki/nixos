{
  pkgs,
  pkgs-unstable,
  pkgs-2405,
  ...
}:
{

  home.packages = with pkgs; [
    # GUI apps
    brave
    localsend
    obsidian
    protonvpn-gui
    pkgs-2405.remmina # FreeRDP 2.x - more stable with RD Gateway
    freerdp # xfreerdp CLI client (FreeRDP 3.x)
    spotify

    # CLI tools (no HM module)
    bat
    xclip
    eza
    fd
    ghostty
    helix
    jq
    ripgrep
    zellij

    # Coding Assistents
    claude-code
    codex
    openclaw # provided by nix-openclaw overlay

    # Languages
    go
    nodejs
    python3

    # Nix-y things
    # Allows 'jnoortheen.nix-ide' to work by providing language server + formatter
    nixfmt-rfc-style
    nil
    nh # nixos-rebuild wrapper; needs nom + nvd on PATH for rich output
    nix-output-monitor # provides `nom` — multi-build tree view
    nvd # generation diff after rebuild
    fh # FlakeHub CLI

    # Secrets management
    sops
    ssh-to-age
  ];
}
