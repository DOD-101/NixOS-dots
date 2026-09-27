{
  common,
  ...
}:
let
  modules = common.enabledModules [
    "btop"
    "fastfetch"
    "yazi"
  ];
in
modules
// {

  home.username = "server";
  home.homeDirectory = "/home/server";

  theme.theme = "catppuccin-macchiato-red";

  dev-config = {
    enable = true;
    opencode.enable = false;
  };

  syncthing-config = {
    enable = true;
    folders = {
      main = {
        enable = true;
        devices = [
          "nix101-0"
          "nix101-1"
          "android101-2"
        ];
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.
}
