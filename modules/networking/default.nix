# Networking setup
{
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
  };
}
