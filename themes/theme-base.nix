{
  lib,
  config,
  inputs,
  ...
}:
let
  colorLib = import ./color-lib.nix { inputs = inputs; };
in
{
  options.theme = rec {
    name = lib.mkOption { type = lib.types.str; };
    font = {
      mono = {
        main = lib.mkOption { type = lib.types.str; };
        secondary = lib.mkOption {
          type = lib.types.str;
          default = config.theme.font.mono.main;
        };
      };
      propo = {
        main = lib.mkOption { type = lib.types.str; };
        secondary = lib.mkOption {
          type = lib.types.str;
          default = config.theme.font.prop.main;
        };
      };
      packages = lib.mkOption { type = lib.types.listOf; };
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

    cava.color = lib.mkOption { type = lib.types.attrs; };

    yazi = {
      filetype = {
        image = lib.mkOption { type = lib.types.str; };
        video = lib.mkOption { type = lib.types.str; };
        audio = lib.mkOption { type = lib.types.str; };
        archive = lib.mkOption { type = lib.types.str; };
        doc = lib.mkOption { type = lib.types.str; };
        orphan = lib.mkOption { type = lib.types.str; };
        exec = lib.mkOption { type = lib.types.str; };
        dir = lib.mkOption { type = lib.types.str; };
      };
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

    swww.script = lib.mkOption { type = lib.types.str; };

    btop.theme = lib.mkOption { type = lib.types.attrs; };

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

    discord.theme = lib.mkOption { type = lib.types.attrs; };

    zen-browser = {
      userChrome = lib.mkOption { type = lib.types.str; };
      userContent = lib.mkOption { type = lib.types.str; };
      zen-logo = lib.mkOption { type = lib.types.attrs; };
      darkreader-theme = lib.mkOption { type = lib.types.attrs; };
      vimium-css = lib.mkOption { type = lib.types.str; };
    };

    fastfetch.config = lib.mkOption {
      type = lib.types.attrs;
    };

    igneous-md = lib.mkOption { type = lib.types.str; };

    dod-shell = lib.mkOption { type = lib.types.path; };
  };

  config = {
    theme = {
      hashlessColor = builtins.mapAttrs (name: value: colorLib.removeHash value) config.theme.color;

      rgbColor = builtins.mapAttrs (name: value: colorLib.convertToRgb value) config.theme.hashlessColor;
    };

    wayland.windowManager.hyprland.settings = config.theme.hyprland.themeSettings;

    swww-config.script = config.theme.swww.script;

    home.sessionVariables = {
      JANC_NVIM_COLORSCHEME = config.theme.nvim.theme;
    };

    zen-config = with config.theme.zen-browser; {
      userChrome = userChrome;
      userContent = userChrome;
      darkreader-theme = darkreader-theme;
      vimium-css = vimium-css;
    };

    home.file = {
      ".config/vesktop/themes/theme.css" = config.theme.discord.theme;

      # NOTE: hard-coded profile from `../modules/home-manager/zen.nix`
      ".zen/default/chrome/zen-logo.svg" =
        lib.mkIf config.zen-config.enable config.theme.zen-browser.zen-logo;

      ".config/fastfetch/config.jsonc" = config.theme.fastfetch.config;

      ".config/btop/themes/${config.theme.name}.theme" = config.theme.btop.theme;
    };
  };
}
