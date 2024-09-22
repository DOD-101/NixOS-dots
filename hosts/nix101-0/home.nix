{ pkgs, inputs, ... }:
{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "david";
  home.homeDirectory = "/home/david";

  zsh-config.enable = true;
  foot-config.enable = true;
  fastfetch-config.enable = true;
  wofi-config.enable = true;
  spotify-player-config.enable = true;
  vis-config.enable = true;
  mpv-config.enable = true;

  eww-config.enable = true;
  eww-config.enableZshIntegration = true;

  yazi-config.enable = true;
  yazi-config.enableZshIntegration = true;

  hypr-config = {
    enable = true;
    hyprland.enable = true;
    hypridle.enable = true;
    hyprlock.enable = true;
    hyprpaper.enable = true;
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

      # Dots
      eww
      slurp
      grim
      cliphist
      hyprlock
      hypridle

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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.activation.createSyncDir = {
    before = [ "writeBoundary" ]; # Optional, but recommended
    after = [ "writeGlobalProfile" ]; # Optional, but recommended
    data = "mkdir -p ~/Sync/.stfolder";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/david/etc/profile.d/hm-session-vars.sh
  #

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
