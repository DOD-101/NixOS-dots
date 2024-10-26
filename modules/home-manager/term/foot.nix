{ lib, config, ... }:
{
  options.foot-config = {
    enable = lib.mkEnableOption "enable foot config";
    default = lib.mkEnableOption "If true will set config.term to foot";
  };

  config = lib.mkIf config.foot-config.enable {

    term = lib.mkIf config.foot-config.default "foot";

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "${config.theme.font.mono.main}:size=14";
        };

        scrollback = {
          lines = 10000;
        };

        mouse = {
          hide-when-typing = "yes";
        };

        colors = {
          alpha = 1;
          background = config.theme.hashlessColor.background;
          foreground = config.theme.hashlessColor.foreground;
          # flash=ffffff
          # flash-alpha=0.5

          ## Normal/regular colors (color palette 0-7)
          regular0 = config.theme.hashlessColor.black; # black
          regular1 = config.theme.hashlessColor.red; # red
          regular2 = config.theme.hashlessColor.green; # green
          regular3 = config.theme.hashlessColor.yellow; # yellow
          regular4 = config.theme.hashlessColor.blue; # blue
          regular5 = config.theme.hashlessColor.magenta; # magenta
          regular6 = config.theme.hashlessColor.cyan; # cyan
          regular7 = config.theme.hashlessColor.white; # white

          ## Bright color; (color palette 8-15)
          bright0 = config.theme.hashlessColor.bright.black; # bright black
          bright1 = config.theme.hashlessColor.bright.red; # bright red
          bright2 = config.theme.hashlessColor.bright.green; # bright green
          bright3 = config.theme.hashlessColor.bright.yellow; # bright yellow
          bright4 = config.theme.hashlessColor.bright.blue; # bright blue
          bright5 = config.theme.hashlessColor.bright.magenta; # bright magenta
          bright6 = config.theme.hashlessColor.bright.cyan; # bright cyan
          bright7 = config.theme.hashlessColor.bright.white; # bright white

        };
      };
    };
  };
}
