{ config, lib, ... }:
{
  options = {
    mime-config.enable = lib.mkEnableOption "enable mime config";
  };

  config = lib.mkIf config.mime-config.enable {
    xdg.mime.defaultApplications = {
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
    };
  };

}
