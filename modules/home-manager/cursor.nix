{ pkgs, ... }:
{
  # TODO: Decide how cursor are best to be configured
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.macchiatoDark;
    name = "catppuccin-macchiato-dark-cursors";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };
}
