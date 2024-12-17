{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  options.wezterm-config = {
    enable = lib.mkEnableOption "enable wezterm config";
    default = lib.mkEnableOption "If true will set config.term to wezterm";
    enableBashIntegration = lib.mkEnableOption "enable wezterm bash integration, passed to programs.wezterm.shellIntegration.BashIntegration";
    enableZshIntegration = lib.mkEnableOption "enable wezterm zsh integration, passed to programs.wezterm.shellIntegration.ZshIntegration";
  };

  config = lib.mkIf config.wezterm-config.enable {
    programs.wezterm = {
      enable = true;
      enableBashIntegration = config.kitty-config.enableBashIntegration;
      enableZshIntegration = config.kitty-config.enableZshIntegration;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      colorSchemes = {
        current_theme = {
          ansi = [
            config.theme.color.black
            config.theme.color.red
            config.theme.color.green
            config.theme.color.yellow
            config.theme.color.blue
            config.theme.color.magenta
            config.theme.color.cyan
            config.theme.color.white
          ];
          brights = [
            config.theme.color.bright.black
            config.theme.color.bright.red
            config.theme.color.bright.green
            config.theme.color.bright.yellow
            config.theme.color.bright.blue
            config.theme.color.bright.magenta
            config.theme.color.bright.cyan
            config.theme.color.bright.white
          ];
          background = config.theme.color.background;
          foreground = config.theme.color.foreground;
          cursor_bg = "#BEAF8A";
          cursor_border = "#BEAF8A";
          cursor_fg = "#1B1B1B";
          selection_bg = "#444444";
          selection_fg = "#E9E9E9";
        };
      };

      extraConfig = builtins.readFile ../../../resources/wezterm/wezterm.lua;
    };
  };
}
