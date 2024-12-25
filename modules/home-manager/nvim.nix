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
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    home.packages = with pkgs; [
      git
      ripgrep
      fzf
      gh
      live-server

      # Lua
      lua
      lua-language-server
      stylua
      luajitPackages.luacheck

      # html
      emmet-language-server
      nodePackages.prettier
      biome
      htmlhint

      # css
      nodePackages.vscode-langservers-extracted
      stylelint

      # js
      nodejs_22
      vtsls

      # json

      # python
      python3
      pyright
      black
      pylint

      # sh
      shfmt
      bash-language-server

      # rust
      rustfmt
      cargo
      # WARN: Change this as soon as a fix for the autocomplete is found
      inputs.cursor_nixpkgs.legacyPackages."${system}".rust-analyzer
      clippy
      rustc
      pkg-config
      openssl

      # Nix
      nixfmt-rfc-style
      nixd

      # hypr
      hyprls

      #markdown
      marksman
    ];

    # These might also be needed:
    # stylelint-config-standard-scss \
    # stylelint-config-standard
    home.sessionVariables = {
      NVIM_APPNAME = "nvim/janc";
    };

    home.shellAliases = {
      n = "nvim";

      pyserver = "python -m http.server";
      pyvenv = "python -m venv .venv";
    };
  };
}
