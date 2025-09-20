{ lib, config, ... }:
{
  options.kitty-config = {
    enable = lib.mkEnableOption "enable kitty config";
    default = lib.mkEnableOption "If true will set config.term to kitty";
  };

  config = lib.mkIf config.kitty-config.enable {

    term = lib.mkIf config.kitty-config.default "kitty";

    # NOTE: Have to overwrite the scale, since the scaling is different in kitty
    theme.spotify-player.cover_img_scale = lib.mkForce 1;

    programs.kitty = {
      enable = true;

      font = {
        name = config.theme.font.mono.main;
        size = 14;
      };

      keybindings = {
        "ctrl+shift+n" = "launch --cwd=current --type=os-window";
      };

      settings = {
        enable_audio_bell = false;

        scrollback_lines = 10000;

        background = config.theme.color.background;
        foreground = config.theme.color.foreground;

        cursor = config.theme.color.foreground;
        cursor_text_color = "background";

        ## Normal/regular colors (color palette 0-7)
        color0 = config.theme.color.black; # black
        color1 = config.theme.color.red; # red
        color2 = config.theme.color.green; # green
        color3 = config.theme.color.yellow; # yellow
        color4 = config.theme.color.blue; # blue
        color5 = config.theme.color.magenta; # magenta
        color6 = config.theme.color.cyan; # cyan
        color7 = config.theme.color.white; # white

        ## Bright color; (color palette 8-15)
        color8 = config.theme.color.bright.black; # bright black
        color9 = config.theme.color.bright.red; # bright red
        color10 = config.theme.color.bright.green; # bright green
        color11 = config.theme.color.bright.yellow; # bright yellow
        color12 = config.theme.color.bright.blue; # bright blue
        color13 = config.theme.color.bright.magenta; # bright magenta
        color14 = config.theme.color.bright.cyan; # bright cyan
        color15 = config.theme.color.bright.white; # bright white
      };
    };

  };
}
