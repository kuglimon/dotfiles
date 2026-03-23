# TODO

* Module setup is poor
  * Separation of modules is confusing
  * Directory per module is confusing
  * Packages are scattered around
* Scratchpads don't yet work in the hyprland setup
* Try niri as an alternative dm
* Stop using ZFS in homeserver
* Implement backups on desktop

## Module improvements

Maybe just having individual files under `modules` would be better?

I'm trying to have a split between GUI based systems and server. I'm not sure if
using separate modules for this is the way. Though having conditional logic in
the modules does not feel great. Maybe have just `packages-gui`,
`packages-term`?

# Move homeserver to btrfs

I use this system so rarely. Maintaining two filesystems isn't realistic.

# Backups

send + receive in the homeserver or something similar. Only backup data nothing
in the nix configuration needs to be saved.
