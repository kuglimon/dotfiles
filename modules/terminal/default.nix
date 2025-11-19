# The default terminal setup I have
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options = {
    bundles.terminal = {
      enable = lib.mkEnableOption "Enables my terminal environment";
    };
  };

  config = lib.mkIf config.bundles.terminal.enable {

    users.users.kuglimon = {
      packages = with pkgs; [
        # the 'bash' package is a minimal bash installation meant for scripts and
        # automation. We want the full package for interactive use.
        bashInteractive
        btrfs-progs

        dosfstools
        file
        qemu
        ghostscript
        rclone

        # For debugging failing nix builds
        cntr

        # TODO(tatu): Is there a better way than just referencing inputs? Maybe
        # there's a way to drop the system at least.
        inputs.rojekti.packages.${system}.rojekti
      ];
    };

    users.defaultUserShell = pkgs.zsh;

    programs.git.lfs.enable = true;

    # If GPG complains about missing pinentry then try rebooting the machine.
    # There's likely some configuration error, too lazy to debug it now.
    services.pcscd.enable = true;
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
  };
}
