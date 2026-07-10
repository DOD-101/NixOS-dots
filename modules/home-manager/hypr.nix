# Config related to everything hypr-
#
# ## How it all works
# Since version 0.55 of Hyprland it uses a lua config. Since I don't like
# writing lua inside nix I have opted to largely write the config as standalone
# lua files, which are then linked into place.
#
# These standalone modules are then required into the main `hyprland.lua` via
# `wayland.windowManager.hyprland.extraConfig`. In a similar manner the lua
# config for the themes any other parts of the NixOS / hm config are included.
#
# To bridge the gap between the nix and lua side the `vars.lua` file is
# generated with any variables from nix that are needed in the lua config.
#
# Each host has a separate file in `../../resources/hypr/hosts` which is also
# included via `extraConfig`.
{
  config,
  osConfig,
  pkgs,
  lib,
  inputs,
  common,
  ...
}:
let
  hypr-pkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.hypr-config;
  hyprSubOption = common.mkSubOption cfg.enable;
in
{
  options.hypr-config = {
    enable = lib.mkEnableOption "enable hypr config";
    hyprland = {
      enable = hyprSubOption "enable hyprland config";
      plugins = {
        hyprgrass.enable = lib.mkEnableOption "enable hyprgrass plugin for touch gestures";
      };
    };
    hypridle = {
      enable = hyprSubOption "enable hypridle config";
      screen_off_time = lib.mkOption {
        type = lib.types.number;
        default = 330; # 5.5min
        description = "time before hypridle will turn the screen off (in s)";
      };
      lock_time = lib.mkOption {
        type = lib.types.number;
        default = 600; # 10min
        description = "time before hypridle will lock the screen (in s)";
      };
    };
    hyprlock = {
      enable = hyprSubOption "enable hyprlock config";
      battery = lib.mkOption {
        type = lib.types.str;
        default =
          if !config.dod-shell-config.enable then
            ""
          else
            lib.attrsets.attrByPath [ "bar" "battery" ] "" config.dod-shell-config.settings;
        description = "battery of which to show information of on lock screen";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slurp
      grim
      cliphist
      brightnessctl
      config-store
      inputs.hyprland-preview-share-picker.packages.${pkgs.stdenv.hostPlatform.system}.default
      (pkgs.writeShellScriptBin "dpms-toggle" (
        builtins.readFile ../../resources/hypr/scripts/dpms-toggle.sh
      ))
      (pkgs.writeShellScriptBin "osk-toggle" (
        builtins.readFile ../../resources/hypr/scripts/osk-toggle.sh
      ))
    ];

    # hyprland
    wayland.windowManager.hyprland = lib.mkIf cfg.hyprland.enable {
      enable = true;
      package = hypr-pkgs.hyprland;
      portalPackage = hypr-pkgs.xdg-desktop-portal-hyprland;
      systemd.enable = true;
      plugins =
        [ ]
        ++ lib.optionals cfg.hyprland.plugins.hyprgrass.enable [
          inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      configType = "lua";
      extraConfig =
        let
          luaRequires = modules: builtins.foldl' (acc: x: acc + "require(\"${x}\")\n") "" modules;
        in
        lib.concatLines [
          (luaRequires (
            [
              "core"
              "window_rules"
              "binds"
              "hosts.${osConfig.networking.hostName}"
              "hyprgrass"
            ]
            ++ lib.optionals osConfig.razer-config.enable [ "razer" ]
          ))
          config.theme.hyprland.themeSettings
        ];
    };

    xdg.configFile = lib.mkIf cfg.hyprland.enable {
      "hypr/scripts" = {
        source = ../../resources/hypr/scripts;
        recursive = true;
      };
      "hypr" = {
        source = ../../resources/hypr/lua;
        recursive = true;
      };
      "hypr/vars.lua" = {
        text =
          let
            toLua = lib.generators.toLua { multiline = false; };
            val = toLua {
              terminal = config.term;
              menu = if config.dod-shell-config.enable then "dod-shell-launcher" else null;
              mainMod = "SUPER +";
              browser = config.zen-config.cmd;
              dod_shell_config.enable = config.dod-shell-config.enable;
              hypr_config.hyprlock.enable = cfg.hyprlock.enable;
            };
          in
          "return ${val}";
      };
      # hyprland-preview-share-picker
      "hypr/xdph.conf" = {
        text = inputs.home-manager.lib.hm.generators.toHyprconf {
          attrs = {
            screencopy = {
              allow_token_by_default = true;
              custom_picker_binary = "hyprland-preview-share-picker";
            };
          };
        };
      };
      "hyprland-preview-share-picker/config.yaml".text = (
        lib.generators.toYAML { } {
          stylesheets = [ "./config.scss" ];
          default_page = "outputs";
        }
      );
      "hyprland-preview-share-picker/config.scss".text = config.theme.hyprland-preview-share-picker;
    };

    # hypridle
    services.hypridle = lib.mkIf cfg.hypridle.enable {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = cfg.hypridle.screen_off_time;
            on-timeout = "dpms-toggle off";
            on-resume = "dpms-toggle on";
          }
          {
            timeout = cfg.hypridle.lock_time;
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 21600; # 6h
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };

    # hyprlock
    programs.hyprlock = lib.mkIf cfg.hyprlock.enable {
      enable = true;
      settings = lib.recursiveUpdate {
        general.ignore_empty_input = true;
      } config.theme.hyprlock.settings;
    };
  };
}
