# Scratchpad

This document holds random stuff I've done on my machines but which I didn't
automate. Just for future reference in case I lose these machines.

## Home server

Flashing custom firmware for the blu-ray driver for "better read compatibility".

```bash
./makemkvcon f -d 'dev_21:0' -f /tmp/sdf.bin rawflash enc -i /home/jelly/Downloads/shiet/firmware/asus/ASUS-BW-16D1HT-3.10-WM01601-211901041014.bin
```

## Desktop

Desktop still has the old `btrfs` based backups in the old nvme drive, which is
not mounted automatically.

I used `btrfs` because I didn't want openzfs blocking updates because it lags
behind some kernels. I should move out of this btrfs backup. Maybe put the drive
on the NAS server...

Some settings I set before I forget:

```bash
# Mount with compression, update fstab?
sudo mount -o compress=zlib:10 /dev/nvme0n1p1 /backup

# Due to single drive configuration
sudo btrfs balance start -dconvert=dup /backup
btrfs filesystem df /backup
```

## NixOS notes

### Update safety

Updating and making changes feels so good. I know I can always get back to a
working state. First time ever it feels good to update system packages and
configuration. Docker, ansible, none of that shit ever solved this. It was more
of 'I have a snapshot of something that works on specific set of systems'.

### home-manager and dotfiles

Editing dotfiles is ass when using home-manager. Yeah, they are supposed to be
deterministic. But I keep tinkering with these DAILY. `nixos-rebuild` with just
a line of change in a lua config is BEYOND FUCKING SLOW. I need to figure out
how to symlink these, ain't no fucking way I'm waiting 5 seconds for 50 byte
diff to apply.

Plus this throws away decades of muscle memory. Everyone either symlinks their
dotfiles OR edits them in-place. Without even looking I'm guessing 99% of the
worlds documentation relies on this.

But still, determinism is nice, generations make a man fully erect... Maybe
there's some middle ground to be had.

I have a faint memory that it was possible to temporarily symlink these.
Following workflow would be acceptable:

* Swap to symlinks
* Edit away
* Commit and revert back to determinism
