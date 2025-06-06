{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    zsh-config.enable = lib.mkEnableOption "enable zsh config";
  };

  config = lib.mkIf config.zsh-config.enable {
    home.packages = with pkgs; [
      zoxide
      gtrash
      direnv
      nix-direnv
    ];

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        style = "full";
        inline_height = 0;
        enter_accept = true;
      };
    };

    home.file.".dircolors".source = ../../../resources/.dircolors;

    home.file.".oh-my-zsh/custom" = {
      recursive = true;
      source = ../../../resources/.oh-my-zsh/custom;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        rt = "gtrash put";
        l = "ls -vAlh --group-directories-first";

        ls = "ls --color=auto";
        grep = "grep --color=auto";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "rust"
          "vi-mode"
          "direnv"
        ];
        theme = config.theme.zsh.theme;
      };

      localVariables = {
        ZSH_CUSTOM = "$HOME/.oh-my-zsh/custom";
        ENABLE_CORRECTION = "true";
        CASE_SENSITIVE = "true";
      };

      sessionVariables = {
        VIRTUAL_ENV_DISABLE_PROMPT = "true";
        SDL_VIDEODRIVER = "wayland";
        # XDG_DATA_DIRS=/home/david/.local/share/applications/:$XDG_DATA_DIRS
        GTRASH_HOME_TRASH_DIR = "$HOME/.local/share/Trash";
        GTRASH_ONLY_HOME_TRASH = "true";
      };

      initContent = lib.strings.concatLines (
        [
          ''
            eval "$(atuin init zsh)"
            eval "$(dircolors ~/.dircolors)"
            eval "$(zoxide init zsh)"
            eval "$(igneous-md completions zsh)"

            setopt globdots
            setopt extended_glob

            if [[ "$(tty)" == "/dev/tty1" ]]; then
              if command -v fastfetch &> /dev/null; then
                ${if config.hypr-config.hyprland.enable then ''Hyprland'' else ''fastfetch''}
              else
                echo "Current time: $(date)"
              fi
            fi

            # mkcd

            mkcd () {
                mkdir -p "$1" && cd "$1"
            }

            countdown() {
                start="$(( $(date '+%s') + $1))"
                while [ $start -ge $(date +%s) ]; do
                    time="$(( $start - $(date +%s) ))"
                    printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
                    sleep 0.1
                done
            }

            stopwatch() {
                start=$(date +%s)
                while true; do
                    time="$(( $(date +%s) - $start))"
                    printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
                    sleep 0.1
                done
            }
          ''
        ]
        ++ lib.optionals config.eww-config.enable [ ''eval "$(eww shell-completions --shell zsh)"'' ]
        ++ lib.optionals config.spotify-player-config.enable [ ''eval "$(spotify_player generate zsh)"'' ]
        ++ lib.optionals config.hypr-config.enable [
          ''eval "$(config-store completions zsh)"''
        ]
        ++ lib.optionals config.dev-config.enable [
          ''eval "$(${pkgs.uv}/bin/uv generate-shell-completion zsh)"''
        ]
      );
    };
  };
}
