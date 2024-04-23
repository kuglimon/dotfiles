# NixOs grub dual boot (arch) linux

Premise is fucking simple:

* You have arch linux (or any other distro)
* You use GRUB
* You have existing working /boot
* You want to maintain the same way of booting
* You want to boot Arch Linux and NixOS without cutting your dick with a live
  usb every day

Googling leads to all sorts of fucked up advices like trying NixOS in a VM (what
the actual fuck) and having two boot partitions, which is really fucking helpful
when you're trying to get your method working and not just run from fucking
alley to alley.

## Words of encouragement

First breath, but not through your mouth, and remember you're not a fucking
idiot. You can always regenerate a boot partition, nothing of value is lost, if
you fuck up, just mount /boot and consult the divine arch wiki (grub-install +
grub-mkconfig).

Remember that you do not need to fucking reinstall the whole goddamn distro if
you mess up a boot partition. This stuff is not that complicated, you're not
going to get the nobel price for this.

## How to do this

Just for easier setup first backup the working grub.cfg: `cp /boot/grub/grub.cfg
/boot/grub/grub-bak.cfg`. While you can always regenerate this it does make it
easier to consult to the old configuration after nixos has nuked your config.

Next check for the menu entries in the old config, with luck, you might even
remember what you usually select from the grub menu. My option looks like this:

```
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-58c19a90-bbdc-4f28-9224-0521322e7739' {
	load_video
	set gfxpayload=keep
	insmod gzio
	insmod part_gpt
	insmod fat
	search --no-floppy --fs-uuid --set=root A836-5A29
	echo	'Loading Linux linux ...'
	linux	/vmlinuz-linux root=UUID=58c19a90-bbdc-4f28-9224-0521322e7739 rw rootflags=subvol=@arch  loglevel=3 quiet
	echo	'Loading initial ramdisk ...'
	initrd	/initramfs-linux.img
}
```

This is the boot configuration for your distro, copy this in `configuration.nix`
under `boot.loader.grub.extraEntries` but comment out the load_video part. I'm
guessing it just setting up video for displaying GRUB. I did a completely wild
guess that NixOS probably does something similar.

Your configuration should then look something like this:

```
boot.loader.grub.extraEntries = ''
  menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-58c19a90-bbdc-4f28-9224-0521322e7739' {
    #load_video
    set gfxpayload=keep
    insmod gzio
    insmod part_gpt
    insmod fat
    search --no-floppy --fs-uuid --set=root A836-5A29
    echo	'Loading Linux linux ...'
    linux	/vmlinuz-linux root=UUID=58c19a90-bbdc-4f28-9224-0521322e7739 rw rootflags=subvol=@arch  loglevel=3 quiet
    echo	'Loading initial ramdisk ...'
    initrd	/initramfs-linux.img
  }
'';
```
