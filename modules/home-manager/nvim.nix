{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    nvim-config.enable = lib.mkEnableOption "enable nvim config. Should not be used outside of dev.";
  };

  config = lib.mkIf config.nvim-config.enable {
    home.packages = with pkgs; [
      neovim
      git
      ripgrep
      fzf
      gh
      live-server

      # Nix
      nixfmt-rfc-style
      nixd

      # Lua
      lua
      stylua
      luajitPackages.luacheck

      # js
      nodejs_22
      biome
      vtsls
      nodePackages.prettier

      # sh
      shfmt

      # css
      stylelint

      # html
      # nothing

      # rust
      rustfmt
      cargo
      # WARN: Change this as soon as a fix for the autocomplete is found
      inputs.cursor_nixpkgs.legacyPackages."${system}".rust-analyzer
      clippy
      rustc
      pkg-config
      openssl

      # python
      python3
      black
      pylint
    ];

    # These might also be needed:
    # stylelint-config-standard-scss \
    # stylelint-config-standard
    home.sessionVariables = {
      EDITOR = "nvim";
      NVIM_APPNAME = "nvim/janc";
    };

    home.shellAliases = {
      n = "nvim";

      pyserver = "python -m http.server";
      pyvenv = "python -m venv .venv";
    };
  };
}
