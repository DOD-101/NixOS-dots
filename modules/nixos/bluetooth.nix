{ lib, config, ... }:
{
  options = {
    bluetooth-config.enable = lib.mkEnableOption "enable bluetooth config";
  };

  config = lib.mkIf config.bluetooth-config.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
