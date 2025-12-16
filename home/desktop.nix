{ pkgs, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html"              = [ "brave-browser.desktop" ];
      "x-scheme-handler/http"  = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "x-scheme-handler/mailto" = [ "brave-browser.desktop" ];
    };
  };

  home.packages = [
    pkgs.albert
  ];

  systemd.user.services.albert = {
    Unit = {
      Description = "Albert launcher";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.albert}/bin/albert";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  dconf.settings = {
    # Your favorites in the GNOME dock
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Console.desktop"
        "brave-browser.desktop"
        "code.desktop"
        "spotify.desktop"
      ];
    };

    # GNOME custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    # custom0: Ctrl+Space -> albert
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name    = "Albert Launcher";
      command = "albert toggle";
      binding = "<Control>space";
    };
  };
}
