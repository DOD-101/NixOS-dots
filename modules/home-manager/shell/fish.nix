{
  config,
  lib,
  ...
}:
let
  /**
    ```
      [ string ] -> string
    ```
  */
  setFishVars =
    let
      inherit (lib.strings) concatLines;
      inherit (lib.lists) findFirstIndex drop;
    in
    vars:
    concatLines (
      map (var: "set -U ${var}") ((drop ((findFirstIndex (v: v == "[dark]") "-1" vars) + 1)) vars)
    );
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
        "cg" = "cd $(git rev-parse --show-toplevel 2> /dev/null)";
      };
      binds = {
        "ctrl-y".command = "fish_clipboard_copy";
      };
      functions = {
        mkcd = "mkdir -p $argv[1] && cd $argv[1]";
      };
      interactiveShellInit = ''
        fish_vi_key_bindings

        set -U fish_greeting 

        # fish theme
        ${setFishVars config.theme.fish.theme}

        if test "$(tty)" = "/dev/tty1"
            if command -v Hyprland &> /dev/null
                start-hyprland
            else if command -v fastfetch &> /dev/null
                fastfetch
            else
                echo "Current time: $(date)"
            end
        end
      '';
    };
  };
}
