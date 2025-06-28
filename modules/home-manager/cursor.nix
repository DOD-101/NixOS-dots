{ config, ... }:
{
  home.pointerCursor = {
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

  gtk.enable = true;
  qt.enable = true;
}
