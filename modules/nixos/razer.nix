{
  pkgs,
  common,
  ...
}@args:
common.mkSimpleConfigModule "razer" {
  hardware.openrazer = {
    enable = true;
    users = [ "david" ];
  };

  environment.systemPackages = with pkgs; [
    polychromatic
    config-store
  ];
} args
