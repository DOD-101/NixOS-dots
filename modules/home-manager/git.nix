{ lib, config, ... }:
{
  options = {
    git-config.enable = lib.mkEnableOption "enable git config. Should not be used outside of dev.";
  };

  config = lib.mkIf config.git-config.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "David Thievon";
          email = "david.thievon@proton.me";
        };
        alias = {
          cc = "commit";
          ce = "commit --amend --no-edit";
          ca = "commit --amend";
          dd = "diff";
          ds = "diff --staged";
          st = "status";
          rr = "restore";
          rs = "restore --staged";
        };
        push = {
          autoSetupRemote = true;
        };
        init.defaultBranch = "master";
        blame = {
          date = "short";
        };
      };
    };

    programs.gh = {
      enable = true;
    };

    home.shellAliases = {
      g = "git";
    };
  };
}
