{ ... }:
let
  removeHash =
    str:
    if builtins.typeOf str == "set" then
      builtins.mapAttrs (name: value: removeHash value) str
    else if builtins.substring 0 1 str == "#" then
      builtins.substring 1 (builtins.stringLength str) str
    else
      str;
in
{
  removeHash = removeHash;
}
