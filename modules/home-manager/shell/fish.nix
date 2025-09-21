{
  config,
  lib,
  pkgs,
  ...
}:
let
  /**
    ```
      [ string ] -> string
    ```
  */
  setFishVars = vars: lib.strings.concatLines (map (var: "set -U ${var}") vars);
in
{
  config = lib.mkIf (config.shell.shell == "fish") {
    home.shell.enableFishIntegration = true;
    programs.fish = {
      enable = true;
      shellAliases = {
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
      };
      binds = {
        "ctrl-y".command = "fish_clipboard_copy";
      };
      functions = {
        mkcd = ''mkdir -p $argv[1] && cd $argv[1]'';
      };
      interactiveShellInit = ''
        fish_vi_key_bindings

        set -U fish_greeting 

        # fish theme
        ${setFishVars config.theme.fish.theme}

        if test "$(tty)" = "/dev/tty1"
            if command -v Hyprland &> /dev/null
                Hyprland
            else if command -v fastfetch &> /dev/null
                fastfetch
            else
                echo "Current time: $(date)"
            end
        end
      '';
      plugins = [
        {
          name = "pisces";
          src = pkgs.fishPlugins.pisces;
        }
      ];
    };
  };
}
