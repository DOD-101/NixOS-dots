{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.yazi-config = {
    enable = lib.mkEnableOption "enable yazi config";
    enableBashIntegration = lib.mkEnableOption "enable yazi bash integration, passed to programs.yazi.enableBashIntegration";
    enableFishIntegration = lib.mkEnableOption "enable yazi fish integration, passed to programs.yazi.enableFishIntegration";
    enableNushellIntegration = lib.mkEnableOption "enable yazi nushell integration, passed to programs.yazi.enableNushellIntegration";
    enableZshIntegration = lib.mkEnableOption "enable yazi zsh integration, passed to programs.yazi.enableZshIntegration";
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
      enableBashIntegration = config.yazi-config.enableBashIntegration;
      enableFishIntegration = config.yazi-config.enableFishIntegration;
      enableNushellIntegration = config.yazi-config.enableNushellIntegration;
      enableZshIntegration = config.yazi-config.enableZshIntegration;

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
              mime = "application/{,g}zip";
              fg = config.theme.yazi.filetype.archive;
            }
            {
              mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
              fg = config.theme.yazi.filetype.archive;
            }
            {
              mime = "application/{pdf,doc,rtf,vnd.*}";
              fg = config.theme.yazi.filetype.doc;
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
          ];
        };
      };

    };
  };
}
