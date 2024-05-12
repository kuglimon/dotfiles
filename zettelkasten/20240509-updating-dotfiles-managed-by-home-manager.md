### Updating dotfiles managed by home manager

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

