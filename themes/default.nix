# Main theme module importing all available theme implementations.
# Select theme via `theme.theme`.
{ lib, palettes, ... }:
let
  createThemeVariations = base: variations: map (v: "${base}-${v}") variations;

  catppuccin-palette = palettes.catppuccin;

  catppuccin-flavors = builtins.filter (name: name != "version") (
    builtins.attrNames catppuccin-palette
  );

  catppuccin-colors = builtins.attrNames (
    (builtins.getAttr (builtins.elemAt catppuccin-flavors 0) catppuccin-palette).colors
  );

  catppuccin-variations = lib.lists.flatten (
    map (flavor: createThemeVariations flavor catppuccin-colors) (
      createThemeVariations "catppuccin" catppuccin-flavors
    )
  );
in
{
  imports = [
    ./theme-base.nix
    ./catppuccin.nix
    # ./nordic.nix
    # ./ocean-breeze.nix # WARN: unmaintained, doesn't currently work
  ];

  options.theme = {
    theme = lib.mkOption {
      type = lib.types.enum (
        [
          "ocean-breeze"
          "nordic"
        ]
        ++ catppuccin-variations
      );
      description = "which theme to use";
    };
  };
}
