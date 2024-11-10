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
      atuin
      zoxide
      gtrash
      yazi
      tzupdate
    ];

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
        # XCURSOR_THEME="Catppuccin-Macchiato-Dark;"
        # XCURSOR_PATH="${XCURSOR_PATH}:~/.local/share/icons";
        SDL_VIDEODRIVER = "wayland";
        # XDG_DATA_DIRS=/home/david/.local/share/applications/:$XDG_DATA_DIRS
        GTRASH_HOME_TRASH_DIR = "$HOME/.local/share/Trash";
        GTRASH_ONLY_HOME_TRASH = "true";
      };

      initExtra = lib.strings.concatStrings (
        [
          ''
            eval "$(atuin init zsh)"
            eval "$(dircolors ~/.dircolors)"
            eval "$(zoxide init zsh)"

            setopt globdots
            setopt extended_glob

            if [[ "$(tty)" == "/dev/tty1" ]]; then
              if command -v fastfetch &> /dev/null; then
                fastfetch
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
      );
    };
  };
}
