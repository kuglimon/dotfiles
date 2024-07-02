# Virtual Machines and NixOS

I'd like to test a workflow where I could build NixOS VM snapshots for say Qemu
or VirtualBox. This would allow me to release these snapshots to some service,
like Github and use them as needed.

I can create ISO's but those are usually just the installer images for given OS.
This would have everything installed and the first rebuild for NixOS run. You'd
just start the snapshot and begin coding.
