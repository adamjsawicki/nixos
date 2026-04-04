{ pkgs, ... }: {

  programs.git = {
    enable = true;
    settings = {
      user.name = "Adam Sawicki";
      user.email = "sawicki.adam.j@gmail.com";
      safe.directory = "/etc/nixos";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
