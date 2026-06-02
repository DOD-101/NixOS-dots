# Base module providing shared theme options for all theme implementations.
# Defines common theme options (colors, fonts, cursors).
#
# The options defined here should not be used here to set other values as well.
# The application of the actual theme related values should happen in the
# respective program modules.
#
# ## Adding a new option
#
# 1. Add the option in here to allow it to be set by the themes
#
# 2. Provide a default if possible
#
# 3. Go into the programs module and apply the option there
#
# > DO NOT add a `program-config.theme` option.
{
  lib,
  config,
  inputs,
  ...
}:
# TODO: It would be good to ensure the themes actually all set these values properly with tests

# TODO: Add sensible defaults possibly based off of base16, that can either be
# entirely or partially overwritten
let
  # Removes leading `#` prefix from hex color strings in a nested attrset.
  # Preserves non-string values and recursively processes nested attrsets.
  removeHash =
    str:
    if builtins.typeOf str == "set" then
      builtins.mapAttrs (name: value: removeHash value) str
    else if builtins.substring 0 1 str == "#" then
      builtins.substring 1 (builtins.stringLength str) str
    else
      str;

  # Converts hex color strings to space-separated RGB format (e.g., "255, 255, 255")
  # in a nested attrset using nix-colors library.
  convertToRgb =
    str:
    if builtins.typeOf str == "set" then
      builtins.mapAttrs (name: value: convertToRgb value) str
    else
      builtins.replaceStrings [ " " ] [ ", " ] (
        toString (inputs.nix-colors.lib.conversions.hexToRGB str)
      );

  # Recursively converts a nested attrset to SCSS variable declarations.
  # Nested attrs become prefixed variables (e.g., `$extras-overlay1`),
  toScssVars =
    set: prefix:
    builtins.concatStringsSep "\n" (
      builtins.concatMap (
        name:
        let
          value = set.${name};
          varName = if prefix == "" then name else "${prefix}-${name}";
          itemToScss =
            item:
            if builtins.isAttrs item then
              "(${builtins.concatStringsSep ", " (builtins.mapAttrs (k: v: "${k}: ${itemToScss v}") item)})"
            else if builtins.isList item then
              "(${builtins.concatStringsSep ", " (map (v: itemToScss v))})"
            else if builtins.typeOf item == "string" then
              ''"${item}"''
            else
              toString item;
        in
        if builtins.isAttrs value then
          [ (toScssVars value varName) ] # Recursively process nested sets
        else if builtins.isList value then
          if builtins.length value == 0 then
            [ ]
          else
            [ "\$${varName}: ${builtins.concatStringsSep ", " (map itemToScss value)};" ]
        else
          [ "\$${varName}: ${toString value};" ] # Convert key-value to SCSS variable
      ) (builtins.attrNames set)
    );

  # Creates a Nix option that accepts either a file path via `source`
  # or inline text via `text`.
  mkFileOption =
    mkOptionInputs:
    lib.mkOption mkOptionInputs
    // {
      type = lib.types.oneOf [
        (lib.types.submodule {
          options.source = lib.mkOption { type = lib.types.path; };
        })
        (lib.types.submodule {
          options.text = lib.mkOption { type = lib.types.str; };
        })
      ];
    };

  # Creates a SCSS option that combines generated color variables
  # from `config.theme.color` with raw SCSS content.
  #
  # See also: `mkFileOption`
  mkScssOption =
    mkOptionInputs:
    (mkFileOption (
      mkOptionInputs
      // {
        apply =
          pre:
          let
            raw = if pre ? source then builtins.readFile pre.source else pre.text;
            colors = toScssVars config.theme.color "";
            fonts = toScssVars config.theme.fonts "";
          in
          lib.concatLines [
            colors
            fonts
            raw
          ];
      }
    ));
in
{
  options.theme = rec {
    name = lib.mkOption { type = lib.types.str; };
    fonts = {
      monospace = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "DejaVu Sans Mono" ];
        description = "monospace fonts (names) to use";
      };
      sansSerif = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "DejaVu Sans" ];
        description = "sansSerif fonts (names) to use";
      };
      serif = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "DejaVu Serif" ];
        description = "serif fonts (names) to use";
      };
    };

    cursor = {
      package = lib.mkOption { type = lib.types.package; };
      name = lib.mkOption { type = lib.types.str; };
    };

    color = {
      background = lib.mkOption { type = lib.types.str; };
      foreground = lib.mkOption { type = lib.types.str; };

      # These are the standard terminal colors, off of which most of the config is based.
      black = lib.mkOption { type = lib.types.str; };
      red = lib.mkOption { type = lib.types.str; };
      green = lib.mkOption { type = lib.types.str; };
      yellow = lib.mkOption { type = lib.types.str; };
      blue = lib.mkOption { type = lib.types.str; };
      magenta = lib.mkOption { type = lib.types.str; };
      cyan = lib.mkOption { type = lib.types.str; };
      white = lib.mkOption { type = lib.types.str; };

      bright = {
        black = lib.mkOption { type = lib.types.str; };
        red = lib.mkOption { type = lib.types.str; };
        green = lib.mkOption { type = lib.types.str; };
        yellow = lib.mkOption { type = lib.types.str; };
        blue = lib.mkOption { type = lib.types.str; };
        magenta = lib.mkOption { type = lib.types.str; };
        cyan = lib.mkOption { type = lib.types.str; };
        white = lib.mkOption { type = lib.types.str; };
      };

      extras = lib.mkOption { };
    };

    hashlessColor = color;

    rgbColor = color;

    cava.color = lib.mkOption {
      type = lib.types.attrs;
      default = with color; {
        gradient = 1;
        gradient_color_1 = white;
        gradient_color_2 = cyan;
        gradient_color_3 = blue;
        gradient_color_4 = green;
        gradient_color_5 = magenta;
        gradient_color_6 = yellow;
        gradient_color_7 = red;
      };
    };

    yazi.theme = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "yazi theme passed to programs.yazi.theme";
    };

    spotify-player = {
      # This value needs to be kept in relation to the terminal font size
      cover_img_scale = lib.mkOption { type = lib.types.int; };
      component_style = {
        border = {
          fg = lib.mkOption { type = lib.types.str; };
        };
        selection = {
          fg = lib.mkOption { type = lib.types.str; };
        };
        playback_metadata = {
          fg = lib.mkOption { type = lib.types.str; };
        };
        playback_track = {
          fg = lib.mkOption { type = lib.types.str; };
        };
        playback_album = {
          fg = lib.mkOption { type = lib.types.str; };
        };
        playback_artists = {
          fg = lib.mkOption { type = lib.types.str; };
        };
        playback_progress_bar = {
          fg = lib.mkOption { type = lib.types.str; };
        };
        playback_progress_bar_unfilled = {
          fg = lib.mkOption { type = lib.types.str; };
        };
      };
    };

    hyprland.themeSettings = lib.mkOption {
      description = "Additional style related config passed to wayland.windowManager.hyprland.settings";
    };

    hyprlock.settings = lib.mkOption { };

    hyprland-preview-share-picker = mkScssOption { };

    awww.script = lib.mkOption { type = lib.types.str; };

    btop.theme = lib.mkOption { type = lib.types.str; };

    zsh.theme = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "oh my zsh prompt theme";
    };

    fish = {
      theme = lib.mkOption {
        type = with lib.types; listOf str;
        default = { };
        description = ''
          fish theme variables

          used to set the fish theme via universal variables in config.fish'';
      };
    };

    nvim.theme = lib.mkOption { type = lib.types.str; };

    discord.theme = lib.mkOption {
      type =
        with lib.types;
        oneOf [
          str
          path
        ];
    };

    zen-browser = {
      userChrome = lib.mkOption { type = lib.types.str; };
      userContent = lib.mkOption { type = lib.types.str; };
      zen-logo = lib.mkOption { type = lib.types.attrs; };
      darkreader-theme = lib.mkOption { type = lib.types.attrs; };
      vimium-css = lib.mkOption { type = lib.types.str; };
    };

    fastfetch.settings = lib.mkOption {
      type = lib.types.attrs;
    };

    igneous-md = lib.mkOption { type = with lib.types; listOf str; };

    dod-shell = mkScssOption { };
  };

  config = {
    theme = {
      hashlessColor = builtins.mapAttrs (name: value: removeHash value) config.theme.color;

      rgbColor = builtins.mapAttrs (name: value: convertToRgb value) config.theme.hashlessColor;
    };
  };
}
