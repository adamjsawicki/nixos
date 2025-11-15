{ pkgs, ... }: {
  programs.fzf = {
    enable = true; # installs fzf
    enableZshIntegration = true; # wires shell bindings
    defaultOptions = [ "--height=40%" "--reverse" "--border" ];
  };
}
