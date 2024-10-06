# Debugging failing flake builds

While developing
[rojekti](https://github.com/kuglimon/molokki/tree/main/rojekti) I had an issue
where tests would pass on the dev shell but fail during `nix build`.

If you want to test this issue using `rojekti` then checkout commit
`9a1ac22b6e319774f4011d07f11bdb408a2eb308`.

First issue is after the build ends all the artifacts are fucking gone, poof,
nuked to oblivion, fuck you very much.

But fall in to despair do not! There are two tools for this:
[breakpointHook](https://nixos.org/manual/nixpkgs/stable/#breakpointhook) and
[cntr](https://github.com/Mic92/cntr).

`breakpointHook` you add to your `nativeBuildInputs`:

```nix
    nativeBuildInputs = with pkgs; [
        breakpointHook
    ];
```

And `cntr` you'll install on your system, flake or temporary shell.

## Debugging

With the hook configured, failing builds produce error like this:

```
build failed in installPhase with exit code 1
To attach install cntr and run the following command as root:
 cntr attach -t command cntr-/nix/store/6vwxqrwq5h1fd3nw4mc61wgk7rppn2qw-jupyterlab-extended
```

When you run the command use `sudo` as your user likely doesn't have access.
Remember that the sudo user might not see this binary. Adjust path to match
`/nix/store` location in that case.

I ran the following command to debug:

```
sudo cntr attach -t command /nix/store/118i0ra8lrmm1d83ag1mwyh9q9fwz5d4-rojekti-0.1.0
```

Now we're inside some part of the builder, I don't yet fully understand how this
works. But if you check for tools that should be available in your inputs you'll
notice that we see the filesystem but not the build environment.

To enter the build environment we use `cntr exec`. You can run arbitary commands
through it. I find it easier to just start a shell:

```bash
# We have to adjust binary paths as we're no longer inside our normal
# environment.
/etc/profiles/per-user/kuglimon/bin/cntr exec bash
```

YAY! Now you have a shell session inside your failing build and you can debug to
your hearts content.

Eventually I found the issue to be a shell script I use during testing which has
the shebang `#/usr/bin/env bash`. Build environment doesn't even have `/usr`
directory.
