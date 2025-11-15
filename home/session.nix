{ pkgs, ... }: {
  home.sessionVariables = {
    SUDO_EDITOR = "code --wait";
    VISUAL = "code --wait";
    EDITOR = "code --wait";
  };
}
