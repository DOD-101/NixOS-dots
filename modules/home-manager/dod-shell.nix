{
  lib,
  config,
  osConfig,
  pkgs,
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

  installed =
    pkg:
    lib.lists.contains osConfig.systemPackages pkgs.${pkg}
    || lib.lists.contains config.home.packages pkgs.${pkg};

  # Takes values in the form:
  # {
  # pkg = pkgs.kitty;
  # entry = { cmd = "kitty", name = "Kitty" }
  # }
  onlyInstalled = all: builtins.filter (val: installed val.pkg) all;
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
      scss.text = colors + "\n" + builtins.readFile config.theme.dod-shell;
      # TODO: Rework this
      config.config = lib.attrsets.recursiveUpdate {
        launcher = {
          max_results = 30;

          launch_mode.apps = onlyInstalled [];
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
      } cfg.settings;
    };
  };
}
