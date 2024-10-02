{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.eww-config = {
    enable = lib.mkEnableOption "enable eww config ";
  };

  config = lib.mkIf config.eww-config.enable {
    home.packages = with pkgs; [
      eww
    ];

    home.file = {
      ".config/eww" = {
        recursive = true;
        source = ../../resources/eww;
      };

      # This will not work in pure eval mode if the var is a path,
      # hence the conversion.
      ".config/eww/eww.yuck".source = ../. + config.theme.eww.eww-file;
      ".config/eww/eww.scss".source = ../. + config.theme.eww.css-file;
    };
  };
}
