# Consuming private nix packages

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

