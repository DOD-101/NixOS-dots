{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  options.hypr-config = {
    enable = lib.mkEnableOption "enable hypr config";
    hyprland = {
      enable = lib.mkEnableOption "enable hyprland config";
      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = '''';
        description = "additional config for hyprland, passed to wayland.windowManager.hyprland.extraConfig";
      };
      plugins = {
        hyprgrass.enable = lib.mkEnableOption "enable hyprgrass plugin for touch gestures";
      };
    };
    hypridle.enable = lib.mkEnableOption "enable hypridle config";
    hyprlock.enable = lib.mkEnableOption "enable hyprlock config";
  };

  config = lib.mkIf config.hypr-config.enable {

    home.packages = with pkgs; [
      slurp
      grim
      cliphist
      brightnessctl
      config-store
    ];

    # hyprland
    wayland.windowManager.hyprland = lib.mkIf config.hypr-config.hyprland.enable {
      enable = true;
      systemd.enable = true;
      plugins =
        [ ]
        ++ lib.optionals config.hypr-config.hyprland.plugins.hyprgrass.enable [
          pkgs.hyprlandPlugins.hyprgrass
        ];

      # Additional style related config is done through the selected theme
      settings = {
        source = [
          "${../../resources/hypr/hyprgeneral.conf}"
          "${../../resources/hypr/hyprbinds.conf}"
        ];

        workspace = [
          "special:minimized"
        ];

        env = [
          "EGL_PLATFORM,wayland"
          "MOZ_ENABLE_WAYLAND,1"
        ];

        "$terminal" = config.term;
        # TODO: This asumes that wofi is installed and is the preferred "launch menu"
        "$menu" = "wofi --show drun -O alphabetical -a -i -I";
        "$mainMod" = "Super";
        "$touchpadEnabled" = "true";

        windowrulev2 = [
          "opacity 0.95 override 0.7 override,class:(${config.term})"
        ];

        exec-once =
          [
            "wl-paste --watch cliphist store"
          ]
          ++ lib.optionals osConfig.sound-config.enable [
            "pipewire"
            "pipewire-pulse"
          ]
          ++ lib.optionals osConfig.razer-config.enable [ "openrazer-daemon" ]
          ++ lib.optionals config.hypr-config.hypridle.enable [ "systemctl --user start hypridle.service" ]
          ++ lib.optionals config.swww-config.enable [ "systemctl --user restart swww.service" ];

        bind =
          [ ]
          ++ lib.optionals config.hypr-config.hyprlock.enable [ "$mainMod, Delete, exec, hyprlock" ];

        plugin = {
          touch_gestures = lib.mkIf config.hypr-config.hyprland.plugins.hyprgrass.enable {
            hyprgrass-bind = [
              # swipe left from right edge
              ", edge:r:l, workspace, +1"
              # swipe right from left edge
              ", edge:l:r, workspace, -1"
              # swipe up from bottom edge
              ", edge:d:u, killactive"
              # swipe down from left edge
              ", edge:l:d, exec, pactl set-sink-volume @DEFAULT_SINK@ -4%"
              # tap with 3 fingers
              ", tap:3, exec, ${config.term}"
              # tap with 4 fingers
              ", tap:4, exec, xournalpp"
            ];

            # longpress can trigger mouse binds:
            hyprgrass-bindm = [
              ", longpress:3, resizewindow"
              ", longpress:2, movewindow"
            ];
          };
        };
      };

      extraConfig = config.hypr-config.hyprland.extraConfig + "\n" + osConfig.razer-config.hyprlandConfig;
    };

    home.file.".config/hypr/scripts" = lib.mkIf config.hypr-config.hyprland.enable {
      source = ../../resources/hypr/scripts;
      recursive = true;
    };

    # hypridle
    services.hypridle = lib.mkIf config.hypr-config.hypridle.enable {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 600; # 10min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 330; # 5.5min
            on-timeout = lib.strings.concatStringsSep ";" (
              [
                "hyprctl dispatch dpms off"
              ]
              ++ lib.optionals osConfig.razer-config.enable [
                "polychromatic-cli -d keyboard -o brightness -p 0"
                "polychromatic-cli -d mouse -o brightness -p 0"
              ]
            );
            on-resume = lib.strings.concatStringsSep ";" (
              [
                "hyprctl dispatch dpms on"
              ]
              ++ lib.optionals osConfig.razer-config.enable [
                "polychromatic-cli -d keyboard -o brightness -p 100"
                "polychromatic-cli -d mouse -o brightness -p 100"
              ]
            );
          }
          {
            timeout = 21600; # 6h
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };

    # hyprlock
    programs.hyprlock = lib.mkIf config.hypr-config.hyprlock.enable {
      enable = true;
      settings = config.theme.hyprlock.settings;
    };
  };
}
