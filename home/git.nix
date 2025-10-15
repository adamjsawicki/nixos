{ pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "Adam Sawicki";
    userEmail = "sawicki.adam.j@gmail.com";
    extraConfig = {
      safe.directory = "/etc/nixos";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;

      # 👇 Force HTTPS → SSH rewrite for GitHub (applies globally)
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
