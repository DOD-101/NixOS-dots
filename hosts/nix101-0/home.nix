{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
    ../../themes
    inputs.nix-colors.homeManagerModules.default
  ];

  home.username = "david";
  home.homeDirectory = "/home/david";

  theme.ocean-breeze.enable = true;

  zsh-config.enable = true;
  foot-config.enable = true;
  fastfetch-config.enable = true;
  wofi-config.enable = true;
  spotify-player-config.enable = true;
  vis-config.enable = true;
  mpv-config.enable = true;
  swww-config.enable = true;

  eww-config.enable = true;

  yazi-config.enable = true;
  yazi-config.enableZshIntegration = true;

  hypr-config = {
    enable = true;
    hypridle.enable = true;
    hyprlock.enable = true;
    hyprland = {
      enable = true;
      extraConfig = ''
        # Monitors
        monitor=HDMI-A-2,1920x1200,0x0,1

        # Execs
        exec-once = eww open SingleBarWin0
        exec-once = [workspace 1 silent] foot
        exec-once = [workspace 2 silent] zen

        # Workspaces
        workspace = 1, monitor:HDMI-A-2, default:true, persistent:true
        workspace = 2, monitor:HDMI-A-2, persistent:true
        workspace = 3, monitor:HDMI-A-2, persistent:true
      '';
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # Dev config
  dev-config = {
    enable = true;
    git.enable = true;
    nvim.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      foot
      firefox
      swayimg
      webkitgtk_4_1
      keepassxc

      # Office
      libreoffice

      # discord
      vesktop

      # email
      thunderbird

      # minecraft
      prismlauncher
      jdk17

      # art
      gimp
      inkscape
      blender
      drawio
      xournalpp

      # pdf 
      zathura

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ [
      inputs.zen-browser.packages.x86_64-linux.zen-browser
    ];

  home.activation.createSyncDir = {
    before = [ "writeBoundary" ]; # Optional, but recommended
    after = [ "writeGlobalProfile" ]; # Optional, but recommended
    data = "mkdir -p ~/Sync/.stfolder";
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
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
