### Plain dotfiles vs nix options

I'm torn on just configuring applications by hand rather than nix options. Using
nix is another abstraction layer. If there's ever an issue in the tool I would
still have to learn the underlying configuration. Swapping to another distro
would probably not be the end of the world - I'd just copy the config from the
store. Debugging might be harder if the nix configuration doesn't install under
`$HOME`.

Keeping plain dotfiles means another set of files. Do I keep those files close
to the nix configuration or in a separate dotfiles directory?

Originally I was adamant on using plain dotfiles. But not anymore. Well, neovim
I will keep in `init.lua`. That's a hill I'm still willing to die on.
