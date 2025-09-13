{
  lib,
  config,
  ...
}:
let
  cfg = config.dod-shell-config;

  toScssVars =
    set: prefix:
    builtins.concatStringsSep "\n" (
      builtins.concatMap (
        name:
        let
          value = set.${name};
          varName = if prefix == "" then name else "${prefix}-${name}";
        in
        if builtins.isAttrs value then
          [ (toScssVars value varName) ] # Recursively process nested sets
        else
          [ "\$${varName}: ${toString value};" ] # Convert key-value to SCSS variable
      ) (builtins.attrNames set)
    );
  colors = toScssVars config.theme.color "";
in
{
  options.dod-shell-config = {
    enable = lib.mkEnableOption "enable dod-shell config";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Setting passed to dod-shell.setting";
    };
  };

  config = lib.mkIf cfg.enable {
    dod-shell = {
      enable = true;
      scss = colors + "\n" + builtins.readFile config.theme.dod-shell;
      # TODO: Rework this
      settings =
        if
          lib.attrsets.hasAttrByPath [
            "launcher"
            "launch_mode"
            "apps"
          ] cfg.settings
        then
          cfg.settings
        else
          lib.attrsets.recursiveUpdate cfg.settings {
            launcher = {
              max_results = 30;

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
              ];
            };
          };
    };
  };
}
