# Enable Nvidia hardware support
{
  lib,
  config,
  ...
}:
{
  options = {
    bundles.hardware.gpu.nvidia = {
      enable = lib.mkEnableOption "Enables Nvidia GPU support";
    };
  };

  config = lib.mkIf config.bundles.hardware.gpu.nvidia.enable {

    # Enables hardware rendering.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;

      # I don't have free energy to spend on 100w idle GPU. This can cause issues
      # with sleep/hibernate.
      powerManagement.enable = true;

      # TODO(tatu): Doesn't work, complains about off-load
      # powerManagement.finegrained = true;

      # Blackwell GPUs require open source kernel modules
      open = true;

      # Enables 'nvidia-settings' command/app.
      nvidiaSettings = true;

      # FIXME(tatu): Swapped to beta drivers as stable ones are broken on 6.12
      # stable is the 'feature' version listed on nvidia site. This is the one
      # Arch Linux installs, hence we'll use this as well.
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    bundles.unfreePackages = [
      # nvidia drivers
      "nvidia-settings"
      "nvidia-x11"
    ];
  };
}
