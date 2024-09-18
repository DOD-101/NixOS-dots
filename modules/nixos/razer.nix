{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    razer-config.enable = lib.mkEnableOption "enable razer config";
  };

  config = lib.mkIf config.razer-config.enable {
    hardware.openrazer.enable = true;

    environment.systemPackages = with pkgs; [
      openrazer-daemon
      polychromatic
    ];
  };
}
