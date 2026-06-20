{
  lib,
  config,
  common,
  ...
}:
{
  imports = [
    ./git.nix
    ./nvim.nix
  ];

  options.dev-config =
    let
      devSubOption = common.mkSubOption config.dev-config.enable;
    in
    {
      enable = lib.mkEnableOption ''
        Enable development-related config
      '';
      git.enable = devSubOption "enable git config";
      nvim.enable = devSubOption "enable nvim config";
      opencode.enable = devSubOption "enable opencode";
    };

  config = lib.mkIf (with config.dev-config; enable && opencode.enable) {
    # in the future there might be more complex config for this
    programs.opencode.enable = true;
  };
}
