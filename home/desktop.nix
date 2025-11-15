{ pkgs, ... }: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "x-scheme-handler/mailto" = [ "brave-browser.desktop" ];
    };
  };

  dconf.settings."org/gnome/shell".favorite-apps = [
    "org.gnome.Console.desktop"
    "brave-browser.desktop"
    "code.desktop"
    "spotify.desktop"
  ];
}
