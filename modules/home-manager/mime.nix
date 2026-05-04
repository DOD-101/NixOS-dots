{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  hypr-pkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options = {
    mime-config.enable = lib.mkEnableOption "enable mime config";
  };

  config = lib.mkIf config.mime-config.enable {
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
            "org.inkscape.Inkscape.desktop"
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
  };

}
