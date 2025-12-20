{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [ "https://cuda-maintainers.cachix.org" ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    igneous-md = {
      url = "github:DOD-101/igneous-md/refs/tags/0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    topiary-yuck = {
      url = "github:DOD-101/topiary-yuck";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dod-shell = {
      url = "github:DOD-101/dod-shell/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotify-player = {
      url = "github:DOD-101/spotify-player/add-flake";
    };

    # catppuccin inputs

    catppuccin-zen = {
      url = "github:catppuccin/zen-browser";
      flake = false;
    };

    catppuccin-btop = {
      url = "github:catppuccin/btop";
      flake = false;
    };

    catppuccin-discord = {
      url = "github:catppuccin/discord";
      flake = false;
    };

    catppuccin-fish = {
      url = "github:catppuccin/fish";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      palettes = {
        catppuccin = import ./resources/palettes/catppuccin.nix;
      };
      mkSystem =
        {
          host,
          mainUser ? "david",
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs palettes;
          };

          modules = [
            ./hosts/${host}/configuration.nix
            ./modules/nixos
            home-manager.nixosModules.default
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs palettes;
                };
                users.${mainUser} = import ./hosts/${host}/home.nix;
                backupFileExtension = "bck";
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nix101-0 = mkSystem { host = "nix101-0"; };
        nix101-1 = mkSystem { host = "nix101-1"; };
        nix101-2 = mkSystem {
          host = "nix101-2";
          mainUser = "server";
        };
      };
    };

}
