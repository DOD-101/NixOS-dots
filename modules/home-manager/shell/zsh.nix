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

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        rt = "gtrash put";
        l = "ls -vAlh --group-directories-first";

        cf = ''T="$(find . -type f | fzf)" ; if [[ -f "$T" ]] ; then T="$(dirname "$T")" ; fi ; cd "$T""'';

        ls = "ls --color=auto";
        grep = "grep --color=auto";

        remove-orphans = ''"sudo pacman -Rns $(pacman -Qtdq | grep -v "debug")"'';
        tzuc = "timedatectl set-timezone \$(tzupdate -p)"; # TimeZoneUpdateComplete

        sp = "spotify_player";

        pyserver = "python -m http.server";
        pyvenv = "python -m venv .venv";

        stowh = "stow -t ~ -S .";
        stowu = "stow -t ~ -D .";

        n = "nvim";
        g = "git";

        Hyprsingle = "Hyprland -c ~/.config/hypr/hyprsingle.conf";
      };
      history.path = "/dev/null";

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "rust"
        ];
        theme = "agnoster-custom";
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
        TERM = "foot";
        SDL_VIDEODRIVER = "wayland";
        # XDG_DATA_DIRS=/home/david/.local/share/applications/:$XDG_DATA_DIRS
        GTRASH_HOME_TRASH_DIR = "$HOME/.local/share/Trash";
        GTRASH_ONLY_HOME_TRASH = "true";
      };

      initExtra = ''
        export PATH=$PATH:~/.bin/:~/node_modules/.bin/

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

        # yazi

        yy() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }

        # mkcd

        mkcd () {
            mkdir -p "$1" && cd "$1"
        }

        # Hyprlaunch

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

      '';
    };
  };
}
