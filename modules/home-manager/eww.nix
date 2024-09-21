{ config, lib, ... }:
{
  options.eww-config = {
    enable = lib.mkEnableOption "enable eww-config config";
    enableBashIntegration = lib.mkEnableOption "enable eww-config bash integration, passed to programs.eww-config.enableBashIntegration";
    enableFishIntegration = lib.mkEnableOption "enable eww-config fish integration, passed to programs.eww-config.enableFishIntegration";
    enableZshIntegration = lib.mkEnableOption "enable eww-config zsh integration, passed to programs.eww-config.enableZshIntegration";
  };

  config = lib.mkIf config.eww-config.enable {
    programs.eww = {
      enable = true;
      enableBashIntegration = config.eww-config.enableBashIntegration;
      enableFishIntegration = config.eww-config.enableFishIntegration;
      enableZshIntegration = config.eww-config.enableZshIntegration;
      configDir = ../../resources/eww;
    };
  };
}
