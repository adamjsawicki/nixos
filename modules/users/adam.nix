{ pkgs, ... }:
{
  imports = [
    ../home-manager/base.nix
    ../home-manager/desktop.nix
    ../home-manager/openclaw.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
