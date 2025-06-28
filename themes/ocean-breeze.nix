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
    theme = rec {
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
        package = pkgs.catppuccin-cursors.macchiatoDark;
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
          image = color.yellow;
          video = color.white;
          audio = color.white;
          archive = color.red;
          doc = color.cyan;
          orphan = color.red;
          exec = color.green;
          dir = color.blue;
        };
      };

      spotify-player = {
        cover_img_scale = 2;
        component_style = {
          border = {
            fg = color.foreground;
          };
          selection = {
            fg = color.yellow;
          };
          playback_metadata = {
            fg = color.blue;
          };
          playback_track = {
            fg = color.white;
          };
          playback_album = {
            fg = color.white;
          };
          playback_artists = {
            fg = color.white;
          };
          playback_progress_bar = {
            fg = color.green;
          };
          playback_progress_bar_unfilled = {
            fg = color.red;
          };
        };
      };

      hyprland = {
        themeSettings = {

          general = {
            gaps_in = 6;
            gaps_out = 10;
            border_size = 2;
            "col.active_border" = "rgba(4154bbff)";
            "col.inactive_border" = "rgba(2e0a1500)";
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
            path =
              pkgs.runCommand "hyprlock-ocean-breeze-imgs" { buildInputs = [ pkgs.inkscape ]; } ''
                mkdir -p $out;

                inkscape ${../resources/hypr/profile.svg} -w 600 -b \${color.background} -o $out/profile.png;
              ''
              + "/profile.png";
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

      btop.theme.text = ''
        theme[main_bg]="${color.background}"
        theme[main_fg]="${color.foreground}"
        theme[title]="${color.bright.white}"
        theme[hi_fg]="${color.blue}"
        theme[selected_bg]="${color.bright.black}"
        theme[selected_fg]="${color.bright.white}"
        theme[inactive_fg]="${color.bright.black}"
        theme[proc_misc]="${color.cyan}"
        theme[cpu_box]="${color.blue}"
        theme[mem_box]="${color.blue}"
        theme[net_box]="${color.blue}"
        theme[proc_box]="${color.blue}"
        theme[div_line]="${color.blue}"
        theme[temp_start]="${color.green}"
        theme[temp_mid]="${color.yellow}"
        theme[temp_end]="${color.red}"
        theme[cpu_start]="${color.green}"
        theme[cpu_mid]="${color.yellow}"
        theme[cpu_end]="${color.red}"
        theme[free_start]="${color.green}"
        theme[free_mid]="${color.yellow}"
        theme[free_end]="${color.red}"
        theme[cached_start]="${color.green}"
        theme[cached_mid]="${color.yellow}"
        theme[cached_end]="${color.red}"
        theme[available_start]="${color.green}"
        theme[available_mid]="${color.yellow}"
        theme[available_end]="${color.red}"
        theme[used_start]="${color.green}"
        theme[used_mid]="${color.yellow}"
        theme[used_end]="${color.red}"
        theme[download_start]="${color.green}"
        theme[download_mid]="${color.yellow}"
        theme[download_end]="${color.red}"
        theme[upload_start]="${color.green}"
        theme[upload_mid]="${color.yellow}"
        theme[upload_end]="${color.red}"
      '';

      zsh.theme = "agnoster-custom";

      cava.color = {
        gradient = 1;
        gradient_color_1 = color.red;
        gradient_color_2 = color.magenta;
        gradient_color_3 = color.yellow;
        gradient_color_4 = color.cyan;
      };

      fastfetch.config.source = ../resources/fastfetch/ocean-breeze.jsonc;

      nvim.theme = "tokyonight";

      discord.theme.source =
        pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "dca4adba7dc5f09302a00b0e76078d54d82d2658";
          hash = "sha256-WLu2OzNtLInbPGHKmZVlqx5Xu2kh+R5DL4yVUrA8+lA=";
        }
        + "/extras/discord/tokyonight_night.css";

      zen-browser = {
        userChrome.text = "";
        userContent.text = "";
        zen-logo.text = "";
      };

      # INFO: Just use the GitHub theme for now
      igneous-md = ''
        @import url("github-markdown-dark.css");
      '';
    };
  };
}
