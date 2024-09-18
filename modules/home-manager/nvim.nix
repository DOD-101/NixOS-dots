{
  pkgs,
  config,
  lib,
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

      # Nix
      nixfmt-rfc-style

      # Lua
      lua
      stylua
      luajitPackages.luacheck

      # js
      nodejs_22
      biome

      # sh
      shfmt

      # css
      stylelint

      # html
      # nothing

      # rust
      rustfmt
      cargo
      rustc
      pkg-config
      openssl

      # python
      python3
      black
      pylint
    ];

    home.activation.installNpmNvimPackages = {
      before = [ "writeBoundary" ]; # Optional, but recommended
      after = [ "writeGlobalProfile" ]; # Optional, but recommended
      data = ''
        ${pkgs.nodejs_22}/bin/npm install \
        prettier \
        @vtsls/language-server
      '';
    };

    # These might also be needed: 
    # stylelint-config-standard-scss \
    # stylelint-config-standard
    home.sessionVariables = {
      EDITOR = "nvim";
      NVIM_APPNAME = "nvim/janc";
    };
  };
}
