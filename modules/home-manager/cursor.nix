{ config, ... }:
{
  home.pointerCursor = {
    enable = true;
    package = config.theme.cursor.package;
    name = config.theme.cursor.name;
    size = 18;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_SIZE = config.home.pointerCursor.size;
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = config.theme.dconf.color-scheme;
  };
  gtk = {
    enable = true;
    gtk4.theme = null;
  };
  qt.enable = true;
}
