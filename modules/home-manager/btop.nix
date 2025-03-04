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
  };

  config = lib.mkIf config.btop-config.enable {
    programs.btop = {
      enable = true;
      package = pkgs.btop.override { cudaSupport = osConfig.nvidia-config.enable; };
      settings = {
        color_theme = config.theme.name;
        vim_keys = true;
      };
    };
  };
}
