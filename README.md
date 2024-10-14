<div align="center">
  <img alt="My desktop" src="docs/assets/desktop.png" />

  # dotfiles
  My dotfiles for Mac and Linux (NixOS btw)
</div>

## Supported hardware

* Intel or Nvidia GPU
* Intel or AMD CPU
* mac x86-64

## Current state

Linux/NixOS is stable and is my daily driver.

Darwin side is hit and miss. I've pretty much stopped using macs after
transitioning to Linux and the current laptops will be the last Apple products I
own. The config does work, but as I tend to update all channels at the same time
they might be broken. If you start using nix on macs, then understand that what
you get is vastly subpar experience of the real thing.

I've tried to split everything into commits with decent messages. It's probably
best if you shift through the commits to learn more.

Don't blindly copy this repository and try to install. I will force push from
time to time and break stuff often.

## Usage

Update NixOS system:

```bash
sudo nixos-rebuild switch --flake .
```

Update macOS system:

```bash
darwin-rebuild switch --flake .
```

## What did you use before Nix?

Over 10 years ago, I used
[laptop](https://github.com/UncertainSchrodinger/laptop). During or after which,
I experimented with [rcm](https://github.com/thoughtbot/rcm). I dropped it after
I got a new machine and had forgotten how it worked.

Eventually I migrated to plain ass bash script for symlinking dotfiles. Check
commit `4f63efd8bc8dbec8913ed7e9fcbe6e89c81f6d10` for the last working version
of that.

### License

Wallpapers are not made by me. I have already forgotten where I got them.
