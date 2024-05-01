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

## GPG backup

Backup keys to keepass:

```bash
gpg --output public.pgp --armor --export <email>
gpg --output backupkeys.pgp --armor --export-secret-keys --export-options export-backup <email>

keepassxc-cli attachment-import -f <kdbx> Services/gpg public.pgp public.pgp
keepassxc-cli attachment-import -f <kdbx> Services/gpg backupkeys.pgp backupkeys.pgp
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

### Plain configuration vs nix options

I'm torn on just configuring applications by hand rather than nix options. The
options hide underlying tools, I'd never learn how to configure these tools. And
if I ever have issues then I need to understand the configuration. If I ever
want to stop using NixOS I have to rewrite all my configuration files.

I'm more leaning on the fact that it's not a good idea to use nix options too
much. If I were just starting linux use I for sure would not use options, way
too much magic.

### Update visibility is bad

When using pacman I could always see what packages would update and do I want to
update them. Like if the gpu drivers would update, I'd usually postpone it
until work was done.

With nix I don't have a single clue what it's going to update. Sure there are
generations and I can always rollback. But still, I'd like to see what is being
updated.

### Consuming private packages

I have a monorepo where I have some random tools I've developed. One of them is
made in rust and I'd like to reference it. I haven't built any CI for it, as I'm
not an alcoholic, thus I'd need a way to build it. With nix this was trivial, I
just devined a rust build on the repository, basic build being like 5 lines of
code. Then import that repository here:

```nix
# Define as input
inputs = {
    rojekti = {
        url = "github:UncertainSchrodinger/molokki?dir=rojekti";
        inputs.nixpkgs.follows = "nixpkgs";
    };
};

# Then consume as a package in some other config
packages = [
    inputs.rojekti.packages.${system}.default
];
```

Read that through a couple of times. It already has support for projects in
subdirectories. No cope-ass-scripts to get around tooling limitations because
they expect everything to be in the root directory. Notice how THE FUCKING
SYSTEM ARCHITECTURE IS A CONFIGURED PART. No matter how strong underbite and
limited vision you have, you'll still fix issues using osx and arm, even if you
keep saying you have not had issues with arm macs when others spend weeks worth
of work to fix your issues.

And it doesn't stop here. Let's take a look at the `flake.lock`:

```json
"locked": {
"dir": "rojekti",
"lastModified": 1714904193,
"narHash": "sha256-x/kBHAMGQNCyW7cbmdU7uwkYXx+8EwCZoI1Sb9FJSek=",
"owner": "UncertainSchrodinger",
"repo": "molokki",
"rev": "57e7975431bfe90edf09653f580ba9c6e6f07cf9",
"type": "github"
}
```

It locked the revision AND the file content hashes on the lockfile. No more
random ass tags changing, tracking master and then crying when stuff works for
other but not for you, no one could have predicted that. Issues like this are
rarely solved, they're just thought of as 'you gotta do what you gotta do'.

At this point I'm pretty much sold on nix. For like 20 minutes of work I have a
reproducable build all the way down to tooling and a way to consume such
dependencies. I could just run `nix-build` on CI and it would build the project
just fine. No more setting up random ass yaml configuration to install
rust/cargo with randomest-ass-yaml-tasks and then spending countles of hours
when that shit eventually breaks.

Nix is starting to look too good to be true.

### Darwin bootstrap:

```bash
sudo scutil --set HostName lorien
sudo scutil --set LocalHostName lorien
sudo scutil --set ComputerName lorien
dscacheutil -flushcache
```

### Nix and Darwin/macos

First of, I have nothing but love for the people maintaining nix support for
darwin. This is not meant to critique their work, just vent my frustration.

NixOS was kind of painful to get working and started. Nix on macos is on another
level of pain:

* Many `program` options will not work (like firefox)
* `program` option might install differently.
    * Keepassxc would not install CLI tools on PATH
* Spotlight doesn't find apps by default.
* Many system defaults in nix-darwin don't work
    * Best is to dump the defaults `defaults read > def`
    * Modify system settings through the GUI and dump settings `defaults read >
      def2`
    * `diff def def2`
    * Apply to nix based on diff

Setting system values from CLI has always been fucking awful in macos. If you
happen to use the wrong tool, then the UI in System Setting might show the value
in incorrect state. It might be enabled even if the UI says it's disabled. And
using nix does that, your trackpad settings might show something disabled but
it'll still work.

As always with macs, I feel like I have the automation at like 80%. Honestly,
this will be the last mac laptop I personally buy. On linux I can get perfect
automation and no random ass problems with tools like docker.
