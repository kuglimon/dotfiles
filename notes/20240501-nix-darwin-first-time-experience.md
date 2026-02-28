### nix-darwin first time experience

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
