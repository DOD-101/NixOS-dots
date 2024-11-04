{ config, lib, ... }:
{
  options.btop-config = {
    enable = lib.mkEnableOption "enable btop config";
  };

  config = lib.mkIf config.btop-config.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = config.theme.btop.theme;
        vim_keys = true;
      };
    };
  };
}
