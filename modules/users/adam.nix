{ pkgs, ... }: {

  imports = [ ../home-manager/base.nix ../home-manager/desktop.nix ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
