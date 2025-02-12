{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.fstrim.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "quiet"
    "udev.log_priority=3"
  ];

  boot.tmp.cleanOnBoot = true;

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  networking.hostName = "nix101-0"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors = {
    hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.udisks2.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Enable config modules
  razer-config.enable = true;
  sound-config.enable = true;
  font-config.enable = true;
  bluetooth-config.enable = true;
  nvidia-config.enable = true;
  mime-config.enable = true;
  borg-config.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # Syncthing config
  syncthing-config.enable = true;
  syncthing-config.settings = {
    devices = {
      "nix101-1" = {
        id = "YWZ23VE-MJZEY2A-3WLNHNX-IP4EJO7-ZYTDVUD-JQBPP3Q-ZKMIQ6R-RP7FFQJ";
      };
      "android101-0" = {
        id = "XTGPRWO-5OPQ5JX-YC4524J-QKQ2HWH-DU5O5SR-FPKGGVU-4XDNPWT-YGZPHAC";
      };
    };

    # INFO: Don't forget to create the .stfolder
    folders = {
      "Main" = {
        path = "~/Sync";
        devices = [
          "nix101-1"
          "android101-0"
        ];
      };
      "School" = {
        path = "~/Data/School-Schule";
        devices = [
          "nix101-1"
        ];
      };
    };
  };

  users.users.david = {
    isNormalUser = true;
    home = "/home/david";
    hashedPassword = "$y$j9T$0QvrKa4enFuufCu14r0NC/$Xvij.zytnbXdHt64yoJZxA4JF99LtFuhNsJMzxM1md1";
    extraGroups = [
      "wheel"
      "networkmanager"
      "openrazer"
      "plugdev"
      "input"
    ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "david" = import ./home.nix;
    };
    backupFileExtension = "bck";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    stow
    gccgo14
    gnumake42
    go
    btop
    wirelesstools
    wl-clipboard
  ];

  # # Enable the OpenSSH daemon.
  # services.openssh = {
  #   enable = true;
  #   ports = [ 22 ];
  #   settings = {
  #     PasswordAuthentication = true;
  #     AllowUsers = [ "david" ];
  #   };
  # };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 8000;
      to = 8999;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 8000;
      to = 8999;
    }
  ];
  # Or disable the firewall altogether.

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
