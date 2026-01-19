{
  lib,
  config,
  pkgs,
  inputs,
  palettes,
  ...
}:
let
  match = builtins.match "catppuccin-(.+)-(.+)" config.theme.theme;
in
{
  config = lib.mkIf ((builtins.typeOf match == "list") && (builtins.length match == 2)) {
    # Things styled non-declaratively:
    #   - vimium (https://github.com/catppuccin/vimium)
    theme =
      let
        zen = inputs.catppuccin-zen;
        btop_ = inputs.catppuccin-btop;
        discord_ = inputs.catppuccin-discord;
        fish_ = inputs.catppuccin-fish;
        vimium = inputs.catppuccin-vimium;

        flavour = builtins.elemAt match 0;
        accent = builtins.elemAt match 1;

        palette = palettes.catppuccin.${flavour};

        capitalize =
          str:
          lib.strings.toUpper (builtins.substring 0 1 str)
          + builtins.substring 1 (builtins.stringLength str) str;

        hyprlock-imgs =
          pkgs.runCommand "hyprlock-catppuccin-${flavour}-${accent}-imgs"
            {
              buildInputs = with pkgs; [ inkscape ];
            }
            ''
              mkdir -p $out

              # change the accent color of the line
              sed 's/#eba0ac/${config.theme.color.extras.accent}/g' ${../resources/hypr/catppuccin-line.svg} > $out/line.svg

              # change width and background color then save files
              inkscape $out/line.svg -w 1000 -b \${config.theme.color.background} -o $out/line.png;
              inkscape ${../resources/hypr/profile.svg} -w 600 -b \${config.theme.color.background} -o $out/profile.png;
            '';

        ignoreCssPrefrence =
          path:
          lib.strings.concatLines [
            (builtins.readFile path)
            (builtins.replaceStrings
              [ "@media (prefers-color-scheme: dark) {" ]
              [ "@media (prefers-color-scheme: light) {" ]
              (builtins.readFile path)
            )
          ];

        fishThemeToVars =
          contents:
          builtins.filter (line: !(lib.hasPrefix "#" line || line == "")) (
            map (line: lib.strings.trim line) (lib.splitString "\n" contents)
          );
      in
      rec {
        name = "catppuccin-${flavour}-${accent}";
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
          package = pkgs.catppuccin-cursors."${flavour}${capitalize accent}";
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

          extras = lib.genAttrs (builtins.attrNames palette.colors) (name: palette.colors.${name}.hex) // {
            accent = palette.colors.${accent}.hex;
          };
        };

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
              fg = color.magenta;
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
              gaps_in = 10;
              gaps_out = "10,15,15,15";
              border_size = 2;
              "col.active_border" = "rgb(${config.theme.hashlessColor.extras.accent})";
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
                size = 2;
                passes = 2;
                noise = 0;
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
              outer_color = "rgb(${config.theme.hashlessColor.extras.accent})";
              inner_color = "rgb(${config.theme.hashlessColor.background})";
              font_color = "rgb(${config.theme.hashlessColor.foreground})";
              fade_on_empty = false;
              fade_timeout = 1000;
              placeholder_text = ''<span foreground="#${color.foreground}"> ... </span>'';
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
              text =
                let
                  contents = builtins.readFile ../resources/hypr/scripts/lock_time.sh;

                  replaced-contents =
                    builtins.replaceStrings [ "@HYPRLOCK_BATTERY@" ] [ config.hypr-config.hyprlock.battery ]
                      contents;

                  file = builtins.toFile "lock_time.sh" replaced-contents;
                in
                "cmd[update:1000] sh ${file}";
              color = "rgba(${config.theme.hashlessColor.white}ff)";
              font_size = 20;
              font_family = "FiraCode Nerd Font Mono";
              position = "0, 50";
              halign = "center";
              valign = "bottom";
            }
          ];
        };

        swww = {
          script = "${pkgs.swww}/bin/swww img $HOME/.background-images/catppuccin-${flavour}/1.png";
        };

        btop.theme.source = btop_ + "/themes/catppuccin_${flavour}.theme";

        fish.theme = fishThemeToVars (
          builtins.readFile (fish_ + "/themes/Catppuccin ${capitalize flavour}.theme")
        );

        nvim.theme = "catppuccin-${flavour}";

        discord.theme.source = discord_ + "/themes/${flavour}.theme.css";

        zen-browser = {
          userChrome = ignoreCssPrefrence (
            zen + "/themes/${capitalize flavour}/${capitalize accent}/userChrome.css"
          );
          userContent = ignoreCssPrefrence (
            zen + "/themes/${capitalize flavour}/${capitalize accent}/userContent.css"
          );
          zen-logo.source =
            zen + "/themes/${capitalize flavour}/${capitalize accent}/zen-logo-${flavour}.svg";
          darkreader-theme = {
            "darkSchemeBackgroundColor" = color.extras.base;
            "darkSchemeTextColor" = color.extras.text;
            "selectionColor" = color.extras.surface2;
          };
          vimium-css = builtins.readFile (vimium + "/themes/catppuccin-vimium-${flavour}.css");
        };

        cava.color = {
          gradient = 1;
          gradient_color_1 = color.extras.blue;
          gradient_color_2 = color.extras.sky;
          gradient_color_3 = color.extras.accent;
          gradient_color_4 = color.extras.pink;
          gradient_color_5 = color.extras.peach;
          gradient_color_6 = color.extras.yellow;
          gradient_color_7 = color.extras.red;
        };

        fastfetch.config.text =
          builtins.replaceStrings
            [
              "@logo@"
            ]
            [
              (toString ../resources/fastfetch/kitty.txt)
            ]
            (builtins.readFile ../resources/fastfetch/catppuccin.jsonc);

        igneous-md = ''
          @import url("github-markdown-dark.css");

          :root {
            --color-0: ${color.extras.text};
            --color-1: ${color.extras.base};
            --color-2: ${color.extras.mauve};
            --color-8: ${color.extras.mantle};
          }
        '';

        dod-shell = ../resources/dod-shell/catppuccin.scss;
      };

    programs.starship = {
      enable = true;
      settings =
        let
          inherit (config.theme) color;

          /**
            Add a starship prompt bubble around the passed element.

            # Type
            ```
            bubble :: attrs -> string -> string

            ```
          */
          bubble =
            {
              fg,
              bg ? color.background,
            }:
            icon: "(fg:${bg} bg:${bg})[](fg:${fg} bg:${bg})${icon}(fg:${bg} bg:${fg})[](fg:${fg} bg:none) ";

        in
        {
          format = "$all";
          right_format = "$nix_shell$git_metrics$git_branch$cmd_duration";
          line_break = {
            disabled = true;
          };

          character = with color; {
            success_symbol = "[󰄾](${green} bold)";
            error_symbol = "[󰄾](${red} bold)";
          };

          directory = with color; {
            format = bubble { fg = extras.accent; } "[ $path]";
            # style = "fg:${extras.crust} bg:${background}";
            truncation_length = 3;
            truncate_to_repo = true;
          };

          nix_shell = with color; {
            format = bubble { fg = extras.teal; } "[]";
          };

          git_status = {
            disabled = true;
          };

          git_metrics = {
            format = "([+$added]($added_style)/)([-$deleted]($deleted_style) )";
            disabled = false;
          };

          package = with color; {
            disabled = false;
            format = bubble {
              fg = extras.peach;
            } "[ $version]";
          };

          sudo = {
            disabled = false;
          };

          rust = {
            format = bubble { fg = color.extras.red; } "[󱘗 $version]";
          };
          lua = {
            format = bubble { fg = color.extras.blue; } "[󰢱 $version]";
          };
          python = {
            format = bubble { fg = color.extras.green; } "[󰌠 $version]";
          };
          nodejs = {
            format = bubble { fg = color.extras.green; } "[󰎙 $version]";
          };
          bun = {
            format = bubble { fg = color.extras.yellow; } "[ $version]";
          };
        };
    };
  };
}
