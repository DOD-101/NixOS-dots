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
          results_height = 500;
        };
      };
    };
  };
}
