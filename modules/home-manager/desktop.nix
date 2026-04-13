{ pkgs, ... }:

{
  imports = [ ./editors.nix ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "x-scheme-handler/mailto" = [ "brave-browser.desktop" ];
    };
  };

  # Add ProtonVPN desktop entry and icon for menu integration
  xdg.dataFile = {
    "applications/proton.vpn.app.gtk.desktop" = {
      source = "${pkgs.protonvpn-gui}/share/applications/proton.vpn.app.gtk.desktop";
    };
    "icons/hicolor/scalable/apps/proton-vpn-logo.svg" = {
      source = "${pkgs.protonvpn-gui}/share/pixmaps/proton-vpn-logo.svg";
    };
  };

  home.packages = [ pkgs.albert ];

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
        "1password.desktop"
        "brave-browser.desktop"
        "code.desktop"
        "com.mitchellh.ghostty.desktop"
        "proton.vpn.app.gtk.desktop"
        "org.remmina.Remmina.desktop"
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
      name = "Albert Launcher";
      command = "albert toggle";
      binding = "<Control>space";
    };
  };
}
