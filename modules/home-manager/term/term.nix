{ lib, ... }:
{
  options = {
    term = lib.mkOption {
      type = lib.types.str;
      description = "The terminal emulator to use.";
    };
  };

}
