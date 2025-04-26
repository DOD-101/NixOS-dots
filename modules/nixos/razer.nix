{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    razer-config = {
      enable = lib.mkEnableOption "enable razer config";
      hyprlandConfig = lib.mkOption {
        type = lib.types.str;
        default = ''
          exec-once = config-store set scroll_mode --value 0 --alternate 1
          exec-once = config-store set scroll_speed --value 3200 --alternate 7500
          exec-once = polychromatic-cli -d mouse -z main -o scroll_mode -p $(config-store get scroll_mode)
          exec-once = polychromatic-cli -d mouse --dpi $(config-store get scroll_speed)

          bind = SHIFT CTRL ALT, F2, exec, polychromatic-cli -d mouse -z main -o scroll_mode -p $(config-store toggle scroll_mode)
          bind = SHIFT CTRL ALT, F3, exec, polychromatic-cli -d mouse --dpi $(config-store toggle scroll_speed)
        '';
        description = "additional config for hyprland, passed to wayland.windowManager.hyprland.extraConfig";
      };
    };
  };

  config = lib.mkIf config.razer-config.enable {
    hardware.openrazer.enable = true;

    environment.systemPackages = with pkgs; [
      openrazer-daemon
      polychromatic
      config-store
    ];
  };
}
