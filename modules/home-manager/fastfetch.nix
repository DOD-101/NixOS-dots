{
  config,
  common,
  ...
}@args:
common.mkSimpleConfigModule "fastfetch" {
  programs.fastfetch = {
    inherit (config.theme.fastfetch) settings;
    enable = true;
  };
} args
