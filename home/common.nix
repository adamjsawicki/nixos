{ pkgs, ... }: {
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  imports = [ ./fzf.nix ./git.nix ./vscode.nix ];

  programs.starship.enable = true;

}
