{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.theme.ocean-breeze.enable = lib.mkEnableOption "Enable Ocean Breeze theme";
  config = lib.mkIf config.theme.ocean-breeze.enable {
    theme = {
      name = "ocean-breeze";
      font = {
        mono = {
          main = "FiraCode Nerd Font Mono";
          secondary = "JetBrainsMono Nerd Font";
        };
        propo = {
          main = "FiraCode Nerd Font Mono";
        };
      };

      cursor = {
        package =
          with pkgs;
          inputs.cursor_nixpkgs.legacyPackages."${system}".catppuccin-cursors.macchiatoDark;
        name = "catppuccin-macchiato-dark-cursors";
      };

      color = {
        background = "#272c44";
        foreground = "#df5a4e";

        black = "#000000";
        red = "#ff1616";
        green = "#7cd605";
        yellow = "#feb301";
        blue = "#3073d9";
        magenta = "#d135de";
        cyan = "#13dd7e";
        white = "#fef2d0";

        bright = {
          black = "#4d4d4d";
          red = "#ff4c4c";
          green = "#b4ee68";
          yellow = "#fecf58";
          blue = "#77a1df";
          magenta = "#de6fe7";
          cyan = "#64f2af";
          white = "#fef7e1";
        };

        extras = { };
      };

      wofi.style = builtins.readFile ../resources/wofi/ocean-breeze.css;

      yazi = {
        filetype = {
          image = "yellow";
          video = "white";
          audio = "white";
          archive = "red";
          doc = "cyan";
          orphan = "red";
          exec = "green";
          dir = "blue";
        };
      };

      spotify-player = {
        cover_img_scale = 2;
        component_style = {
          border = {
            fg = config.color.foreground;
          };
          selection = {
            fg = "Yellow";
          };
          playback_metadata = {
            fg = "Blue";
          };
          playback_track = {
            fg = "White";
          };
          playback_album = {
            fg = "White";
          };
          playback_artists = {
            fg = "White";
          };
          playback_progress_bar = {
            fg = "Green";
          };
          playback_progress_bar_unfilled = {
            fg = "Red";
          };
        };
      };

      hyprland = {
        themeSettings = {

          general = {
            gaps_in = 6;
            gaps_out = 10;
            border_size = 2;
            col.active_border = "rgba(4154bbff)";
            col.inactive_border = "rgba(2e0a1500)";
          };

          windowrulev2 = [
            "opacity 0.95 override 0.90, class:.*"
          ];

          decoration = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 2;

            blur = {
              enabled = true;
              size = 8;
              passes = 1;
            };

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              # INFO: non standard color
              color = "rgba(1a1a1aee)";
            };
          };

          animations = {
            enabled = "yes";

            bezier = [
              "myBezier, 0.05, 0.9, 0.1, 1.05"
            ];

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 10, default, popin 80%"
              "windowsMove, 1, 7, default # make custom bezier"
              "fadeSwitch, 1, 8, default"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };
        };
      };

      hyprlock.settings = {
        general = {
          ignore_empty_input = true;
        };

        background = [
          {
            blur_passes = 1;
            blur_size = 7;
            noise = 1.17e-2;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
            color = "rgba(${config.theme.hashlessColor.background}fe)";
          }
        ];

        image = [
          {
            path = builtins.toString ../resources/hypr/hyprlock.png;
            size = "150";
            rounding = -1;
            border_size = 0;
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            size = "300, 40";
            position = "0, -20";
            monitor = "";
            outline_thickness = 1;
            dots_size = 0.33;
            dots_spacing = 0.15;
            dots_center = true;
            dots_rounding = -1;
            outer_color = "rgb(${config.theme.hashlessColor.yellow})";
            inner_color = "rgb(${config.theme.hashlessColor.background})";
            font_color = "rgb(${config.theme.hashlessColor.foreground})";
            fade_on_empty = false;
            fade_timeout = 1000;
            placeholder_text = ''<span foreground="##fef2d0">Input Password...</span>'';
            hide_input = false;
            rounding = -1;
            check_color = "rgb(${config.theme.hashlessColor.yellow})";
            fail_color = "rgb(${config.theme.hashlessColor.red})";
            fail_text = "$FAIL <b>($ATTEMPTS)</b>";
            fail_transition = 300;
            capslock_color = "rgb(${config.theme.hashlessColor.magenta})";
            numlock_color = "rgb(${config.theme.hashlessColor.cyan})";
            bothlock_color = -1;
          }
        ];

        label = [
          {
            text = "Hello There, $USER";
            color = "rgba(${config.theme.hashlessColor.white}ff)";
            font_size = 25;
            font_family = "FiraCode Nerd Font Mono";
            rotate = 0;
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
          {
            text = "$TIME";
            color = "rgba(${config.theme.hashlessColor.white}ff)";
            font_size = 20;
            font_family = "FiraCode Nerd Font Mono";
            position = "0, 50";
            halign = "center";
            valign = "bottom";
          }
        ];
      };

      eww = {
        eww-file = "../../resources/eww/ocean-breeze/eww.yuck";
        css-file = "../../resources/eww/ocean-breeze/eww.scss";
      };

      swww = {
        script = "${pkgs.swww}/bin/swww img $HOME/.background-images/ocean-breeze/1.png";
      };

      btop.theme = "tokyo-night";

      zsh.theme = "agnoster-custom";

      vis.colorScheme = ''
        gradient=true
        #df5a4e
        #d135de
        #feb301
        #13dd7e
      '';

      fastfetch.config = builtins.readFile ../resources/fastfetch/fastfetch.jsonc;
    };

  };
}
