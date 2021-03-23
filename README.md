# Dotfiles

My dotfiles for Mac and Linux.

This documentation serves as a reminder for me when I decide to come back to
these in another decade.

# Requirements

The scripts have only been tested using ZSH. They might work on other shells but I not
been tested it.

# Architecture

After trying bunch of different options for provisioning
dotfiles I returned back to just plain old shell scripting.

Trying to remember how `rcrc` worked and having it installed
was not worth it. You rarely have to install these from scratch
and when you do, you won't remember what the hell you did 4
years ago. Same goes for crap like Ansible, you'll just fight
outdated libraries and try to get system Python to work. All
this to make a couple of symlinks. You'll rarely come back and
update libraries for a project like this.

Some rules for configuration:

1. Be explicit! If that means copying the same `pwd` command a thousand times
   then so be it.

2. Simple problems should have simple solutions! We're symlinking 20 files not
   trying to fly to fucking Mars...

4. Remember that when you need to install these it's usually not because
   it's a sunny afternoon and you have all the time in the world. You'll
   install these when there are deadlines coming and your laptop decided
   to kill itself.

   So make these scripts with this in mind. When all you have is time, then
   you could make these in assembly and still have fun.

   But sadly that is fiction.

### Configuration

Configuration should follow the following guide lines.

#### Platforms

Helper functions exist for asserting current platform: `if_linux` and `if_osx`

Use these to differentiate functionality. There's no need to install i3 configuration
on macOS.

#### Local configuration - `.config.local`

For any configuration where possible at the end they should load a file with
suffix `.local`. I might have custom configuration, which should not end up in
`git`. Like client specific env variables in `.zshenv.local`.
