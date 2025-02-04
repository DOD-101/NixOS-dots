{ config, lib, ... }:
{

  options = {
    zathura-config.enable = lib.mkEnableOption "enable zathura config";
  };

  config = lib.mkIf config.zathura-config.enable {
    programs.zathura = {
      enable = true;
      options = {
        notification-error-bg = config.theme.color.red;
        notification-error-fg = config.theme.color.foreground;
        notification-warning-bg = config.theme.color.yellow;
        notification-warning-fg = config.theme.color.blue;
        notification-bg = config.theme.color.background;
        notification-fg = config.theme.color.foreground;
        completion-bg = config.theme.color.background;
        completion-fg = config.theme.color.white;
        completion-group-bg = config.theme.color.background;
        completion-group-fg = config.theme.color.white;
        completion-highlight-bg = config.theme.color.blue;
        completion-highlight-fg = config.theme.color.foreground;
        index-bg = config.theme.color.background;
        index-fg = config.theme.color.foreground;
        index-active-bg = config.theme.color.blue;
        index-active-fg = config.theme.color.foreground;
        inputbar-bg = config.theme.color.background;
        inputbar-fg = config.theme.color.foreground;
        statusbar-bg = config.theme.color.background;
        statusbar-fg = config.theme.color.foreground;
        highlight-color = "rgba(${config.theme.rgbColor.yellow}, 0.5)";
        highlight-active-color = config.theme.color.green;
        default-bg = config.theme.color.background;
        default-fg = config.theme.color.foreground;
        render-loading = "true";
        render-loading-fg = config.theme.color.background;
        render-loading-bg = config.theme.color.foreground;

        # for inverted colors
        recolor-lightcolor = config.theme.color.background;
        recolor-darkcolor = config.theme.color.foreground;

        selection-clipboard = "clipboard";
      };
    };
  };
}
