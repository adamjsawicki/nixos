{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        golang.go
        jnoortheen.nix-ide
        mkhl.direnv
        ms-python.python
      ];

      userSettings = {
        # General
        "editor.formatOnSave" = true;
        "files.trimTrailingWhitespace" = true;
        "update.mode" = "none";

        # Terminal
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.sendKeybindingsToShell" = true;

        # Nix LSP
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        "nix.serverSettings" = {
          "nil" = { "formatting" = { command = [ "nixfmt" ]; }; };
        };
      };
    };
  };
}
