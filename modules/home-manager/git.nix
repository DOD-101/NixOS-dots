{ lib, config, ... }:
{
  options = {
    git-config.enable = lib.mkEnableOption "enable git config. Should not be used outside of dev.";
  };

  config = lib.mkIf config.git-config.enable {
    programs.git = {
      enable = true;
      userName = "David Thievon";
      userEmail = "pkfan@gmail.com";
      lfs.enable = true;
      aliases = {
        cc = "commit";
        ce = "commit --amend --no-edit";
        ca = "commit --amend";
        st = "status";

      };
      extraConfig = {
        push = {
          autoSetupRemote = true;
        };
        init.defaultBranch = "master";
      };
    };

    programs.gh = {
      enable = true;
    };
  };
}
