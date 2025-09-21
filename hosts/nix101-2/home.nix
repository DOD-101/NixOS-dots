{
  ...
}:
{
  imports = [
    ../../modules/home-manager
    ../../themes
  ];

  home.username = "server";
  home.homeDirectory = "/home/server";

  theme.ocean-breeze.enable = true;

  fastfetch-config.enable = true;
  btop-config.enable = true;

  yazi-config.enable = true;

  # dconf = {
  #   enable = true;
  #   settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  # };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # home.packages = with pkgs; [ ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
