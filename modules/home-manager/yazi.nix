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
      shellWrapperName = "yy";

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
              run = "xournalpp %s";
              desc = "Open xournalpp files";
              orphan = true;
            }
          ];
          drawio = [
            {
              run = "drawio %s";
              desc = "Open draw.io files";
              orphan = true;
            }
          ];
        };

        open = {
          prepend_rules = [
            {
              url = "*.xopp";
              use = "xournalpp";
            }
            {
              url = "*.drawio";
              use = "drawio";
            }
          ];
        };

        plugin = {
          prepend_fetchers = [
            {
              id = "git";
              url = "*";
              run = "git";
            }
            {
              id = "git";
              url = "*/";
              run = "git";
            }
          ];
        };
      };

      theme = lib.recursiveUpdate config.theme.yazi.theme {
        icon = {
          prepend_exts = [
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
