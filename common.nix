{ lib }:
{
  enabledModules =
    modules: lib.genAttrs' modules (s: lib.nameValuePair (s + "-config") { enable = true; });

  mkSimpleConfigModule =
    name: moduleConfig:
    { config, ... }:
    {
      options."${name}-config".enable = lib.mkEnableOption "enable ${name} config";

      config = lib.mkIf config."${name}-config".enable moduleConfig;
    };

  mkSubOption =
    parentOption: desc:
    lib.mkOption {
      type = lib.types.bool;
      default = parentOption;
      description = desc;
    };
}
