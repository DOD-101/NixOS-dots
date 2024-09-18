{ lib, config, ... }:
{
  options = {
    foot-config.enable = lib.mkEnableOption "enable foot config";
  };

  config = lib.mkIf config.foot-config.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "FiraCode Nerd Font Mono:size=14";
        };
        scrollback = {
          lines = 10000;
        };
        mouse = {
          hide-when-typing = "yes";
        };
        colors = {
          alpha = 1;
          background = "272c44";
          foreground = "df5a4e";
          # flash=ffffff
          # flash-alpha=0.5

          ## Normal/regular colors (color palette 0-7)
          regular0 = "000000"; # black
          regular1 = "ff1616"; # red
          regular2 = "7cd605"; # green
          regular3 = "feb301"; # yellow
          regular4 = "3073d9"; # blue
          regular5 = "d135de"; # magenta
          regular6 = "13dd7e"; # cyan
          regular7 = "fef2d0"; # white

          ## Bright color; (color palette 8-15)
          bright0 = "4d4d4d"; # bright black
          bright1 = "ff4c4c"; # bright red
          bright2 = "b4ee68"; # bright green
          bright3 = "fecf58"; # bright yellow
          bright4 = "77a1df"; # bright blue
          bright5 = "de6fe7"; # bright magenta
          bright6 = "64f2af"; # bright cyan
          bright7 = "fef7e1"; # bright white

        };
      };
    };
  };
}
