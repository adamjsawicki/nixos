{ pkgs, ... }:
{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  imports = [
    ./packages.nix
    ./session.nix
    ./shell.nix
    ./vcs.nix
    ./ollama.nix
    ./zellij.nix
  ];

  programs.starship.enable = true;

}
