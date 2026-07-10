{
  pkgs,
  common,
  ...
}@args:
common.mkSimpleConfigModule "sound" {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    playerctl
    pulsemixer
  ];
} args
