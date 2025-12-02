{ pkgs, ... }: {

  imports =
    [ ./common.nix ./desktop.nix ./packages.nix ./session.nix ./zsh.nix ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
