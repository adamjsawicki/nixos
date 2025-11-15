{ pkgs, ... }: {
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  imports = [
    ./desktop.nix
    ./fzf.nix
    ./git.nix
    ./packages.nix
    ./session.nix
    ./vscode.nix
    ./zsh.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.starship.enable = true;
}
