{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  options.btop-config = {
    enable = lib.mkEnableOption "enable btop config";
    battery = lib.mkOption {
      type = lib.types.str;
      default = "Auto";
      description = "Which battery to use. Passed to btop `selected-battery`.";
    };
  };

  config = lib.mkIf config.btop-config.enable {
    programs.btop = {
      enable = true;
      package = pkgs.btop.override { cudaSupport = osConfig.nvidia-config.enable; };
      settings = {
        color_theme = config.theme.name;
        vim_keys = true;
        selected_battery = config.btop-config.battery;
      };
    };
  };
}
