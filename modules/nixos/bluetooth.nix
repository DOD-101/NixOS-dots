{
  common,
  ...
}@args:
common.mkSimpleConfigModule "bluetooth" {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
} args
