{
  inputs,
  config,
  lib,
  pkgs,
  common,
  ...
}@args:
common.mkSimpleConfigModule "igneous-md" {
  home.packages = [
    inputs.igneous-md.packages."${pkgs.stdenv.hostPlatform.system}".igneous-md-release
  ];

  xdg.configFile = builtins.listToAttrs (
    lib.imap0 (i: v: {
      name = "igneous-md/css/_${toString i}${config.theme.name}.css";
      value = {
        text = v;
      };
    }) config.theme.igneous-md
  );

  shell.completions = [ "igneous-md completions @shell@" ];
} args
