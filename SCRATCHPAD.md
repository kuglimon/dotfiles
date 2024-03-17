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
