# Useful study material I've found for Nix

First tip is to read other peoples nix configs and nix code. It's far easier
than any of the documentation available in my opinion.

[Matthew Croughan - What Nix Can Do (Docker Can't) - SCaLE
20x](https://www.youtube.com/watch?v=6Le0IbPRzOE). This is where my Nix journey
started. I watched this video and migrated my main desktop the next day.

[NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/introduction/).
Great for learning about Nix language and Flakes. Contains other topics as well.

[nix.dev](https://nix.dev/). This is the replacement for the dead Wiki. It's
hard to read and suffers from the same as the manual - it's geared towards
people who already know nix down to the implementation.

Mostly this is due to dropping new terms on every page and then linking to the
reference manual, rather than explaining them in simple terms.

Imagine someone starting programming and you tell them to read the C++ reference
and supporting research papers. Like, fuck man, I just want to print 'hello
world'. Not apply for a phd.

[Nix reference manual](https://nixos.org/manual/nix/stable/introduction).
Especially useful is the 'Languages and frameworks'. I don't know why I used to
think this was bad, it's good.

[Mitchell Hashimotos nix config](https://github.com/mitchellh/nixos-config).
Simple setup (in a good way) for nix-darwin and building VM images. Contains an
interesting idea for a mac environment where most of your graphical applications
live in the osx and your development setup inside a NixOS VM.

[John Wiegleys nix config](https://github.com/jwiegley/nix-config). This is a
gold mine for learning - from overlays to packaging. For nix-darwin use check
the avesome overlay for directly installing DMGs. Search for
`installApplication` for it. Again the structure of the config is simple.

[Henrik Lissners nix config](https://github.com/hlissner/dotfiles). Readme
contains great reference material for studying. Nix files have some good
examples. But I do feel like everything is split into too many modules and
files, it's too hard to navigate as you're constantly jumping from directory to
directory.
