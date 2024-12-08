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
      font = {
        mono = {
          main = "FiraCode Nerd Font Mono";
          secondary = "JetBrainsMono Nerd Font";
        };
        propo = {
          main = "FiraCode Nerd Font Mono";
        };

        # TODO: I don't think this is even used
        packages = with pkgs; [
          (nerdfonts.override {
            fonts = [
              "FiraCode"
              "JetBrainsMono"
            ];
          })
        ];
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
      };

      vis.defaultColorScheme = "ocean";
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

      eww = {
        eww-file = "../../resources/eww/ocean-breeze/eww.yuck";
        css-file = "../../resources/eww/ocean-breeze/eww.scss";
      };

      swww = {
        script = "${pkgs.swww}/bin/swww img $HOME/.background-images/ocean-breeze/1.png";
      };

      btop.theme = "tokyo-night";

      zsh.theme = "agnoster-custom";
    };
  };
}
