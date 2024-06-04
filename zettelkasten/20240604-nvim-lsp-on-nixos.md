# NeoVim LSP on NixOS

It's common to install LSP's using something like Mason in NeoVim. But Mason
expects normal environment, it'll install servers with dynamically linked
libraries, which won't work on Nix systems.

A better solution is preffered. I wonder if I can just ditch Mason completely
and configure through Nix?
