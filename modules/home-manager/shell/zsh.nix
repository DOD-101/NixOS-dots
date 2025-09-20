{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.shell.shell == "zsh") {
    home.shell.enableZshIntegration = true;

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

      initContent = lib.strings.concatLines (
        [
          ''
            eval "$(dircolors ~/.dircolors)"

            setopt globdots
            setopt extended_glob

            if [[ "$(tty)" == "/dev/tty1" ]]; then
              if command -v fastfetch &> /dev/null; then
                ${if config.hypr-config.hyprland.enable then ''Hyprland'' else ''fastfetch''}
              else
                echo "Current time: $(date)"
              fi
            fi

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
        ++ map (c: ''eval "$(${c})"'') config.shell.completions
      );
    };
  };
}
