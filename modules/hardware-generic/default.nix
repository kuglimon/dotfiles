# Enable various generic hardware tweaks
{
  lib,
  ...
}:
{
  hardware.enableRedistributableFirmware = lib.mkDefault true;

}
