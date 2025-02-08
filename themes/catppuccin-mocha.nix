{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  zen-repo = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zen-browser";
    rev = "b048e8bd54f784d004812036fb83e725a7454ab4";
    hash = "sha256-SoaJV83rOgsQpLKO6PtpTyKFGj75FssdWfTITU7psXM=";
  };

  capitalize =
    str:
    lib.strings.toUpper (builtins.substring 0 1 str)
    + builtins.substring 1 (builtins.stringLength str) str;

  flavour = "mocha";
  accent = "maroon";

  hyprlock-imgs =
    pkgs.runCommand "hyprlock-catppuccin-line-${flavour}-${accent}"
      {
        buildInputs = with pkgs; [ inkscape ];
      }
      ''
        mkdir -p $out

        # change the accent color of the line
        sed 's/#eba0ac/${
          config.theme.color.extras."${accent}"
        }/g' ${../resources/hypr/catppuccin-line.svg} > $out/line.svg

        inkscape $out/line.svg -w 1000 -b \${config.theme.color.background} -o $out/line.png;

        inkscape ${../resources/hypr/profile.svg} -w 600 -b \${config.theme.color.background} -o $out/profile.png;
      '';

in
{
  options.theme."catppuccin-${flavour}".enable =
    lib.mkEnableOption "Enable catppuccin-${flavour} theme";
  config = lib.mkIf config.theme."catppuccin-${flavour}".enable {
    # Things styled non-declaratively:
    #   - vimium (https://github.com/catppuccin/vimium)
    #   - dark-reader (https://github.com/catppuccin/dark-reader)
    theme = {
      # NOTE: We might want to add the accent to the name
      name = "catppuccin-${flavour}";
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
          inputs.cursor_nixpkgs.legacyPackages."${
            system
          }".catppuccin-cursors."${flavour}${capitalize accent}";
        name = "catppuccin-${flavour}-${accent}-cursors";
      };

      color = rec {
        background = extras.base;
        foreground = extras.text;

        black = extras.surface1;
        red = extras.red;
        green = extras.green;
        yellow = extras.yellow;
        blue = extras.blue;
        magenta = extras.pink;
        cyan = extras.teal;
        white = extras.subtext1;

        bright = {
          black = extras.surface2;
          red = extras.red;
          green = extras.green;
          yellow = extras.yellow;
          blue = extras.blue;
          magenta = extras.pink;
          cyan = extras.teal;
          white = extras.subtext0;
        };

        extras = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };

      wofi.style = ''
        * {
            font-family: JetBrainsMono NFM,  san-serif;
        }

        window {
            background-color: transparent;
            border-radius: 5px;
        }

        #input {
            box-shadow: none;
            color: ${config.theme.color.yellow};
            border-radius: 3px;
            border: none;
            background-color: ${config.theme.color.extras.mantle};
            opacity: 0.95;
            margin-bottom: 15px;
        }

        #input * {
            color: ${config.theme.color.foreground};
        }

        #scroll {
            margin-top: 0px;
            border-radius: 3px;
            background-color: ${config.theme.color.extras.mantle};
            opacity: 0.92;
        }

        #text {
            margin-left: 3px;
            color: ${config.theme.color.foreground};
            background-color: transparent;
        }

        #entry:selected {
            background-color: transparent;
            border: 2px solid ${config.theme.color.red};
            border-radius: 5px;
        }

        #text:selected {
            background-color: unset;
            color: ${config.theme.color.yellow};
        }

        #img {
            background-color: transparent;
        }
      '';

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
            fg = config.theme.color.magenta;
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
            gaps_in = 10;
            gaps_out = "10,15,15,15";
            border_size = 2;
            "col.active_border" = "rgb(${config.theme.hashlessColor.magenta})";
            "col.inactive_border" = "rgb(${config.theme.hashlessColor.black})";
          };

          windowrulev2 = [
            "opacity 0.95 override 0.90, class:.*"
          ];

          decoration = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 12;

            blur = {
              enabled = true;
              size = 3;
              passes = 2;
            };

            shadow = {
              enabled = false;
              range = 5;
              render_power = 3;
              color = "rgba(${config.theme.hashlessColor.black}ff)";
            };
          };

          animations = {
            enabled = "yes";

            bezier = [
              "windows, 0.39, 0.575, 0.565, 1"
              "windowsIn, 0.55,0.055,0.675,0.19"
              "border, 0.5, 0.5, 0.5, 0.5"
              "workspaces, 0.455, 0.03, 0.515, 0.955"
              "fade, 0.19,1,0.22,1"
              "fadeIn,0.785,0.135,0.15,0.86"
              "fadeSwitch, 0.77,0,0.175,1"
            ];

            animation = [
              "windows, 1, 7, windows"
              "windowsIn, 1, 3, windows, popin 50%"
              "windowsMove, 1, 5, windows"
              "fade, 1, 7, fade"
              "fadeIn, 0, 3, fadeIn"
              "fadeSwitch, 1, 5, fadeSwitch"
              "border, 1, 4, border"
              "borderangle, 0"
              "workspaces, 1, 5, workspaces"
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
            path = hyprlock-imgs + "/profile.png";
            size = "150";
            rounding = -1;
            border_size = 0;
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
          {
            path = hyprlock-imgs + "/line.png";
            size = "250";
            rounding = 0;
            border_size = 0;
            position = "0, 75";
            halign = "center";
            valign = "bottom";
          }
        ];

        input-field = [
          {
            size = "300, 40";
            position = "0, -20";
            monitor = "";
            outline_thickness = 3;
            dots_size = 0.33;
            dots_spacing = 0.15;
            dots_center = true;
            dots_rounding = -1;
            outer_color = "rgb(${config.theme.hashlessColor.extras.maroon})";
            inner_color = "rgb(${config.theme.hashlessColor.background})";
            font_color = "rgb(${config.theme.hashlessColor.foreground})";
            fade_on_empty = false;
            fade_timeout = 1000;
            placeholder_text = ''<span foreground="#${config.theme.color.foreground}"> ... </span>'';
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
            text = ''cmd[update:1000] sh ${../resources/hypr/scripts/lock_time.sh}'';
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
        eww-file = "../../resources/eww/catppuccin-${flavour}/eww.yuck";
        css-file = "../../resources/eww/catppuccin-${flavour}/eww.scss";
      };

      swww = {
        script = "${pkgs.swww}/bin/swww img $HOME/.background-images/catppuccin-${flavour}/evening-sky.png";
      };

      btop.theme = builtins.readFile (
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "btop";
          rev = "1.0.0";
          hash = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
        }
        + "/themes/catppuccin_${flavour}.theme"
      );

      zsh.theme = "";

      nvim.theme = "catppuccin-${flavour}";

      discord.theme =
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "discord";
          rev = "16b1e5156583ee376ded4fa602842fa540826bbc";
          hash = "sha256-ECVHRuHbe3dvwrOsi6JAllJ37xb18HaUPxXoysyPP70=";
        }
        + "/themes/${flavour}.theme.css";

      zen-browser = {
        userChrome = zen-repo + "/themes/${capitalize flavour}/${capitalize accent}/userChrome.css";
        userContent = zen-repo + "/themes/${capitalize flavour}/${capitalize accent}/userContent.css";
        zen-logo = zen-repo + "/themes/${capitalize flavour}/${capitalize accent}/zen-logo-${flavour}.svg";
      };

      vis.colorScheme = ''
        gradient=true
        ${config.theme.color.black}
        ${config.theme.color.red}
        ${config.theme.color.green}
        ${config.theme.color.yellow}
        ${config.theme.color.blue}
        ${config.theme.color.magenta}
        ${config.theme.color.cyan}
        ${config.theme.color.white}
      '';

      fastfetch.config =
        builtins.replaceStrings
          [
            "@logo@"
          ]
          [
            (builtins.toString ../resources/fastfetch/kitty.txt)
          ]
          (builtins.readFile (./. + "/../resources/fastfetch/catppuccin-${flavour}.jsonc"));
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "$directory$character";
        right_format = "$nix_shell$git_status$git_branch$cmd_duration";
        line_break = {
          disabled = true;
        };

        character = {
          success_symbol = "[󰘧](${config.theme.color.magenta} bold)";
          error_symbol = "[󰘧](${config.theme.color.red})";
        };

        directory = {
          format = "(fg:${config.theme.color.background} bg:${config.theme.color.background})[](fg:${config.theme.color.bright.magenta} bg:${config.theme.color.background})[ $path](fg:${config.theme.color.background} bg:${config.theme.color.bright.magenta})[](fg:${config.theme.color.bright.magenta} bg:none) ";
          style = "fg:${config.theme.color.extras.crust} bg:${config.theme.color.background}";
          truncation_length = 3;
          truncate_to_repo = true;
        };

        nix_shell = {
          format = "(fg:${config.theme.color.background} bg:${config.theme.color.background})[](fg:${config.theme.color.extras.teal} bg:${config.theme.color.background})[](fg:${config.theme.color.background} bg:${config.theme.color.extras.teal})[](fg:${config.theme.color.extras.teal} bg:none) ";
          style = "fg:${config.theme.color.extras.teal} bg:${config.theme.color.background}";
        };

        git_status = {
          format = "(fg:${config.theme.color.background} bg:${config.theme.color.background})[](fg:${config.theme.color.extras.flamingo} bg:${config.theme.color.background})[$all_status](fg:${config.theme.color.background} bg:${config.theme.color.extras.flamingo})[](fg:${config.theme.color.extras.flamingo} bg:none) ";
          style = "fg:${config.theme.color.extras.flamingo} bg:${config.theme.color.background}";
          conflicted = "=";
          ahead = "\${count}";
          behind = "\${count}";
          diverged = "\${ahead_count}\${behind_count}";
          up_to_date = "󰄬";
          untracked = "?\${count}";
          stashed = "󰏖";
          modified = "!\${count}";
          staged = "+\${count}";
          renamed = "»\${count}";
          deleted = "󰆴\${count}";
        };

        package = {
          disabled = true;
        };

      };
    };
  };
}
