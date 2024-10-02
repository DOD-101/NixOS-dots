{ config, ... }:
{
  home.pointerCursor = {
    package = config.theme.cursor.package;
    name = config.theme.cursor.name;
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };
}
