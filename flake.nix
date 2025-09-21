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
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations.nix101-0 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/nix101-0/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.nix101-1 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/nix101-1/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.nix101-2 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/nix101-2/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
