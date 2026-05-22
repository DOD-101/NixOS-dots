{
  pkgs,
  lib,
  config,
  ...
}:
{

  options.font-config = {
    enable = lib.mkEnableOption "enable font config";
    fontpreview = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "if fontpreview should also be installed";
    };
  };

  config = lib.mkIf config.font-config.enable {
    fonts = {
      fontconfig = {
        antialiasing = true;
        subpixelRendering = "rgb";
        defaultFonts = {
          inherit (config.theme.fonts) monospace sansSerif serif;
          emoji = [ "NotoColorEmoji" ];
        };
      };
    };

    home.packages =
      with pkgs;
      [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.recursive-mono
        noto-fonts-color-emoji
        corefonts
      ]
      ++ lib.optional config.font-config.fontpreview (
        writeShellScriptBin "fontpreview" ''
          export FONTPREVIEW_PREVIEW_TEXT="ABCDEFGHIJKLM\nNOPQRSTUVWXYZ\nabcdefghijklm\nnopqrstuvwxyz\n1234567890\n!@$\%(){}[]\n>=|=<!="
          export FONTPREVIEW_BG_COLOR=${config.theme.color.background}
          export FONTPREVIEW_FG_COLOR=${config.theme.color.foreground}
          export FONTPREVIEW_FONT_SIZE=57
          export FONTPREVIEW_SIZE=798x548

          ${fontpreview}/bin/fontpreview $@
        ''
      );
  };
}
