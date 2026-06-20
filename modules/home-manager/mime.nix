{
  inputs,
  pkgs,
  common,
  ...
}@args:
let
  hypr-pkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
common.mkSimpleConfigModule "mime" {
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        hypr-pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config.hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };

    dataFile = {
      "mime/packages/drawio.xml".source = ../../resources/xdg-mime/drawio.xml;
    };

    desktopEntries.inkview = {
      name = "Inkview";
      genericName = "SVG Viewer";
      comment = "View SVG files with Inkscape's lightweight viewer";
      exec = "inkview %F";
      icon = "inkscape";
      terminal = false;
      categories = [
        "Graphics"
        "Viewer"
      ];
      mimeType = [
        "image/svg+xml"
        "image/svg+xml-compressed"
      ];
      settings = {
        Keywords = "svg;vector;viewer;inkscape;";
        StartupNotify = "false";
      };
    };

    mimeApps = {
      enable = true;

      defaultApplications = {
        "application/pdf" = [
          "org.pwmt.zathura.desktop"
          "xournalpp.desktop"
        ];
        "image/png" = [
          "swayimg.desktop"
          "gimp.desktop"
        ];
        "image/jpeg" = [
          "swayimg.desktop"
          "gimp.desktop"
        ];
        "image/svg+xml" = [
          "inkview.desktop"
        ];
        "application/vnd.jgraph.mxfile" = [
          "drawio.desktop"
        ];
        "application/x-xopp" = [
          "xournalpp.desktop"
        ];
      };
    };
  };
} args
