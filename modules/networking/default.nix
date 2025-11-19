# Networking setup
{
  lib,
  ...
}:
{
  networking.hostName = "desktop"; # Define your hostname.
  networking.nameservers = [
    "1.1.1.1" # cloudflare
  ];

  networking.dhcpcd = {
    enable = true;

    # TODO(tatu): I should really configure a static IP or do something about
    # this. DHCP takes like 10 seconds on NixOS. This should make it so that it
    # doesn't wait for IP.
    wait = "background";

    extraConfig = ''
      noarp
    '';
    # Enables DHCP on each ethernet and wireless interface. In case of scripted
    # networking (the default) this is the recommended approach. When using
    # systemd-networkd it's still possible to use this option, but it's
    # recommended to use it in conjunction with explicit per-interface
    # declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;
  };
}
