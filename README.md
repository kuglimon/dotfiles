<div align="center">
  <img alt="My desktop" src="docs/assets/desktop.png" />

  # dotfiles
  My NixOS (btw) configuration
</div>

## Supported hardware

* Intel or Nvidia GPU
* Intel or AMD CPU

## Current state

It's stable and used as a daily driver.

I've tried to split everything into commits with decent messages. It's probably
best if you shift through the commits to learn more.

## Usage

Update dependencies:

```bash
nix flake update
```

Update NixOS system:

```bash
sudo nixos-rebuild switch --flake .
```

## Repo history

Over a decade ago, I used
[laptop](https://github.com/UncertainSchrodinger/laptop). During or after which,
I experimented with [rcm](https://github.com/thoughtbot/rcm). I dropped it after
I got a new machine and had forgotten how it worked.

Eventually I migrated to plain ass bash script for symlinking dotfiles. Check
commit `4f63efd8bc8dbec8913ed7e9fcbe6e89c81f6d10` for the last working version
of that. These scripts were daily driven on work use in Mac and Linux systems.

## Art

Sadly, I do not remember which artists made the wallpapers I use.
