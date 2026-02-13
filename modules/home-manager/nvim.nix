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
      uv
      python3
      basedpyright
      black
      pylint

      # sh
      shfmt
      bash-language-server

      # rust
      rustfmt
      cargo
      rust-analyzer
      clippy
      rustc
      pkg-config
      openssl

      # Nix
      nixfmt
      nixd
      nil

      # hypr
      hyprls

      # markdown
      marksman

      # yaml
      yaml-language-server
      yamllint
      actionlint

      # toml
      taplo

      # yuck
      inputs.topiary-yuck.packages.${stdenv.hostPlatform.system}.default

      # java
      jdt-language-server
      google-java-format
      maven

      # treesitter
      tree-sitter
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
