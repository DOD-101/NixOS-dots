{ config, lib, ... }:
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
          "text/*" = [
            "nvim.desktop"
          ];
          "application/*" = [
            "nvim.desktop"
          ];
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
