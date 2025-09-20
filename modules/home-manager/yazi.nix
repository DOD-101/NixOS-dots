{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.yazi-config = {
    enable = lib.mkEnableOption "enable yazi config";
  };

  config = lib.mkIf config.yazi-config.enable {
    home.packages = with pkgs; [
      zoxide
      ripgrep
      fzf
      jq
      poppler
      imagemagick
      swayimg
      p7zip
    ];

    programs.yazi = {
      enable = true;

      initLua = ../../resources/yazi/init.lua;
      plugins = {
        smart-enter = pkgs.yaziPlugins.smart-enter;
        no-status = pkgs.yaziPlugins.no-status;
        git = pkgs.yaziPlugins.git;
      };

      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = "b";
              run = "cd ~";
            }
            {
              on = "<C-q>";
              run = "quit --no-cwd-file";
            }
            {
              on = "i";
              run = "shell --confirm --orphan \"swayimg \\\"$@\\\"\"";
            }
            {
              on = "l";
              run = "plugin smart-enter";
              desc = "Enter the child directory, or open the file";
            }
            {
              on = "R";
              run = "shell --confirm --block \"gtrash restore\"";
            }
            {
              on = "<C-n>";
              run = "shell --confirm --block \"$EDITOR\"";
            }
          ];
        };
      };

      settings = {
        mgr = {
          ratio = [
            1
            4
            3
          ];
          sort_by = "natural";
          sort_sensitive = false;
          sort_dirs_first = true;
          sort_translit = true;
          show_hidden = true;
        };

        opener = {
          xournalpp = [
            {
              run = ''xournalpp "$@"'';
              desc = "Open xournalpp files";
            }
          ];
          drawio = [
            {
              run = ''drawio "$@"'';
              desc = "Open draw.io files";
            }
          ];
        };

        open = {
          prepend_rules = [
            {
              name = "*.xopp";
              use = "xournalpp";
            }
            {
              name = "*.drawio";
              use = "drawio";
            }
          ];
        };

        plugin = {
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
        };
      };

      theme = {
        mgr = {
          hovered = {
            fg = "magenta";
          };
        };

        filetype = {
          rules = [
            {
              mime = "image/*";
              fg = config.theme.yazi.filetype.image;
            }
            {
              mime = "video/*";
              fg = config.theme.yazi.filetype.video;
            }
            {
              mime = "audio/*";
              fg = config.theme.yazi.filetype.audio;
            }
            {
              name = "*.{xopp,drawio}";
              fg = config.theme.yazi.filetype.doc;
            }
            {
              mime = "application/{pdf,doc,rtf,vnd.*}";
              fg = config.theme.yazi.filetype.doc;
            }
            {
              mime = "application/{,g}zip";
              fg = config.theme.yazi.filetype.archive;
            }
            {
              mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
              fg = config.theme.yazi.filetype.archive;
            }
            {
              name = "*";
              is = "orphan";
              fg = config.theme.yazi.filetype.orphan;
            }
            {
              name = "*";
              is = "exec";
              fg = config.theme.yazi.filetype.exec;
            }
            {
              name = "*/";
              fg = config.theme.yazi.filetype.dir;
            }
          ];
        };

        icon = {
          prepend_exts = [
            {
              name = "yuck";
              text = "󱍕";
              fg_dark = config.theme.color.foreground;
              fg_light = config.theme.color.foreground;
            }
            {
              name = "drawio";
              text = "󰇞";
              fg_dark = config.theme.color.foreground;
              fg_light = config.theme.color.foreground;
            }
            {
              name = "xopp";
              text = "󰂺";
              fg_dark = config.theme.color.foreground;
              fg_light = config.theme.color.foreground;
            }
          ];
        };
      };

    };
  };
}
