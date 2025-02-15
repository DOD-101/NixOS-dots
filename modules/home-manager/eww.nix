{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Function to recursively convert a set into SCSS variables
  toScssVars =
    set: prefix:
    builtins.concatStringsSep "\n" (
      builtins.concatMap (
        name:
        let
          value = set.${name};
          varName = if prefix == "" then name else "${prefix}-${name}";
        in
        if builtins.isAttrs value then
          [ (toScssVars value varName) ] # Recursively process nested sets
        else
          [ "\$${varName}: ${toString value};" ] # Convert key-value to SCSS variable
      ) (builtins.attrNames set)
    );
  colors = toScssVars config.theme.color "";
in
{
  options.eww-config = {
    enable = lib.mkEnableOption "enable eww config ";
    toggles = with lib; {
      touchscreen = mkOption {
        type = types.bool;
        default = false;
      };
      show_battery = mkOption {
        type = types.bool;
        default = false;
      };
      show_caps_lock = mkOption {
        type = types.bool;
        default = false;
      };
      show_num_lock = mkOption {
        type = types.bool;
        default = false;
      };
      show_disk = mkOption {
        type = types.bool;
        default = false;
      };
      show_ddisk = mkOption {
        type = types.bool;
        default = false;
      };
      wifi_device = mkOption {
        type = types.str;
        default = "";
      };
      ethernet_device = mkOption {
        type = types.str;
        default = "";
      };
      cpu_temp = lib.mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = lib.mkIf config.eww-config.enable {
    home.packages = with pkgs; [
      eww
      wtype
      jq
    ];

    home.file = {
      ".config/eww" = {
        recursive = true;
        source = ../../resources/eww;
      };

      # This will not work in pure eval mode if the var is a path,
      # hence the conversion.
      ".config/eww/eww.yuck".source = ../. + config.theme.eww.eww-file;
      ".config/eww/eww.scss".source = ../. + config.theme.eww.css-file;

      ".config/eww/colors.scss".text = colors;

      ".config/eww/toggles.yuck".text =
        ''
          ; These toggles are auto-generated using home-manager

        ''
        + lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: value:
            "(defvar ${name} ${
              if builtins.typeOf value == "bool" then if value then "true" else "false" else ''"${value}"''
            })"
          ) config.eww-config.toggles
        );
    };
  };
}
