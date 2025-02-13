# This module is just used to create the folder markers for the nixos/syncthing.nix module.
{
  lib,
  osConfig,
  ...
}:
{
  home.file = lib.mkIf osConfig.syncthing-config.enable (
    builtins.mapAttrs (name: value: {
      target = builtins.toPath value.path + "/.stfolder";
      text = "";
    }) osConfig.syncthing-config.settings.folders
  );
}
