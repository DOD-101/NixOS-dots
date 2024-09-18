{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    sound-config.enable = lib.mkEnableOption "enable sound config";
  };

  config = lib.mkIf config.sound-config.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      playerctl
      pulsemixer
    ];
  };
}
