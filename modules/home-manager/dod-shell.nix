{
  lib,
  config,
  ...
}:
let
  cfg = config.dod-shell-config;
in
{
  options.dod-shell-config = {
    enable = lib.mkEnableOption "enable dod-shell config";
    removed-components = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = "Passed to dod-shell.removed-components";
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Setting passed to dod-shell.setting";
    };
  };

  config = lib.mkIf cfg.enable {
    dod-shell = {
      enable = true;
      removed-components = cfg.removed-components;
      scss.text = config.theme.dod-shell;
      config.config = lib.attrsets.recursiveUpdate cfg.settings {

        launcher = {
          max_results = 30;
          # NOTE: Upstream changes needed to get rid of this unnecessarily long list
          launch_mode.apps = [
            {
              cmd = "foot";
              name = "Foot";
            }
            {
              cmd = "kitty -e spotify_player";
              name = "Spotify Player";
            }
            {
              cmd = "kitty";
              name = "Kitty";
            }
            {
              cmd = "steam";
              name = "Steam";
            }
            {
              cmd = "vesktop";
              name = "Vesktop";
            }
            {
              cmd = "heroic";
              name = "Heroic Launcher";
            }
            {
              cmd = "signal-desktop";
              name = "Signal";
            }
            {
              cmd = "prismlauncher";
              name = "Prism";
            }
            {
              cmd = "drawio";
              name = "Draw.io";
            }
            {
              cmd = "zen";
              name = "Zen Browser";
            }
            {
              cmd = "thunderbird";
              name = "Thunderbird";
            }
            {
              cmd = "xournalpp";
              name = "Xournal++";
            }
            {
              cmd = "teams-for-linux";
              name = "Teams for Linux";
            }
            {
              cmd = "keepassxc";
              name = "Keepass XC";
            }
            {
              cmd = "libreoffice";
              name = "Libre Office";
            }
            {
              cmd = "inkscape";
              name = "Inkscape";
            }
          ];
        };
      };
    };
  };
}
