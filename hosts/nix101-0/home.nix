{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
    ../../themes
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "david";
  home.homeDirectory = "/home/david";

  theme.theme = "catppuccin-macchiato-mauve";

  btop-config.enable = true;
  fastfetch-config.enable = true;
  foot-config.enable = true;
  igneous-config.enable = true;

  kitty-config.default = true;
  kitty-config.enable = true;

  mime-config.enable = true;
  mpv-config.enable = true;
  office-config.enable = true;
  spotify-player-config.enable = true;
  swayimg-config.enable = true;
  swww-config.enable = true;
  cava-config.enable = true;

  yazi-config.enable = true;

  zathura-config.enable = true;

  zen-config.enable = true;

  dod-shell-config = {
    enable = true;
    removed-components = [
      inputs.dod-shell.packages.${pkgs.stdenv.hostPlatform.system}.osk-release
    ];
    settings = {
      bar = {
        disk = "/dev/nvme0n1p1";
        show_capslock = false;
        show_numlock = true;
      };
    };
  };

  hypr-config = {
    enable = true;
    hypridle = {
      enable = true;
      lock_time = 3600; # 1h
    };
    hyprlock.enable = true;
    hyprland = {
      enable = true;
      extraConfig = ''
        # Monitors
        monitor=DP-4,3440x1440,0x0,1
        monitor=DP-6,3440x1440,3440x0,1

        # Execs
        exec-once = [workspace 1 silent] ${config.term}
        exec-once = [workspace 4 silent] zen

        # Workspaces
        workspace = 1, monitor:DP-4, default:true, persistent:true
        workspace = 2, monitor:DP-4, persistent:true
        workspace = 3, monitor:DP-4, persistent:true

        workspace = 4, monitor:DP-6, default:true, persistent:true
        workspace = 5, monitor:DP-6, persistent:true
        workspace = 6, monitor:DP-6, persistent:true

        # Bindings 
        bind = , XF86Tools, exec, $terminal
        bind = , XF86Launch6, exec, zen
        bind = , XF86Launch7, exec, thunderbird 
        bind = , XF86Launch8, exec, gimp
        bind = , XF86Launch9, exec, keepassxc
        bind = , XF86Launch5, exec, vesktop

        experimental {
          xx_color_management_v4 = true
        }
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

  home.packages = with pkgs; [
    keepassxc
    signal-desktop

    # discord
    vesktop

    # email
    thunderbird

    # minecraft
    prismlauncher
    jdk17

    ckan
    heroic

    # art
    gimp
    inkscape
    # blender
    drawio
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
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
