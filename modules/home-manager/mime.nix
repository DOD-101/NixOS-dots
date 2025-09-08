{ config, lib, ... }:
let
  reversAssoc = app: mimes: lib.genAttrs mimes (_: app);
in
{
  options = {
    mime-config.enable = lib.mkEnableOption "enable mime config";
  };

  config = lib.mkIf config.mime-config.enable {
    xdg = {
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

        }
        // lib.optionalAttrs config.zen-config.enable (
          reversAssoc "zen.desktop" [
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/chrome"
            "text/html"
            "application/x-extension-htm"
            "application/x-extension-html"
            "application/x-extension-shtml"
            "application/xhtml+xml"
            "application/x-extension-xhtml"
            "application/x-extension-xht"
          ]
        );
      };
    };
  };

}
