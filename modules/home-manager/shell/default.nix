{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.shell = {
    shell = lib.mkOption {
      type = lib.types.enum [ "zsh" ];
      description = "which shell to use";
    };
    completions = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching ".*@shell@.*");
      description = ''List of commands to run to get completions, with the concrete shell replaced by @shell@.'';
      default = [ ];
      apply = value: map (c: lib.strings.replaceString "@shell@" config.shell.shell c) value;
    };
  };

  imports = [
    ./zsh.nix
  ];

  config = {
    home = {
      packages = with pkgs; [
        gtrash
      ];

      shellAliases = {
        rt = "gtrash put";
        l = "ls -vAlh --group-directories-first";

        ls = "ls --color=auto";
        grep = "grep --color=auto";
      };

      sessionVariables = {
        GTRASH_ONLY_HOME_TRASH = "true";
        VIRTUAL_ENV_DISABLE_PROMPT = "true";
        SDL_VIDEODRIVER = "wayland";
        # XDG_DATA_DIRS=/home/david/.local/share/applications/:$XDG_DATA_DIRS
        GTRASH_HOME_TRASH_DIR = "$HOME/.local/share/Trash";
      };

      file.".dircolors".source = ../../../resources/.dircolors;
    };

    programs = {
      atuin = {
        enable = true;
        settings = {
          style = "full";
          inline_height = 0;
          enter_accept = true;
        };
      };

      zoxide = {
        enable = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
