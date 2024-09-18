{ lib, config, ... }:
{
  imports = [
    ./git.nix
    ./nvim.nix
  ];

  options.dev-config = {
    enable = lib.mkEnableOption "global dev-config toggle";
    git.enable = lib.mkEnableOption "enable git config";
    nvim.enable = lib.mkEnableOption "enable nvim config";
  };

  config = lib.mkIf config.dev-config.enable {

    git-config.enable = config.dev-config.git.enable;
    nvim-config.enable = config.dev-config.nvim.enable;
  };
}
