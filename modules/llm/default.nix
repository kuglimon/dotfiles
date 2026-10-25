# Local LLM inference on the Nvidia GPU
{
  lib,
  config,
  pkgs,
  ...
}:
let
  llama-cpp-cuda = pkgs.llama-cpp.override { cudaSupport = true; };
in
{
  options.bundles.llm.enable = lib.mkEnableOption "local LLM inference";

  config = lib.mkIf config.bundles.llm.enable {
    environment.systemPackages = [ llama-cpp-cuda ];

    bundles.unfreePackagePrefixes = [
      "cuda"
      "libcu"
      "libnv"
      "libnpp"
      "cudnn"
      "nccl"
    ];

    nix.settings = {
      substituters = [ "https://cache.nixos-cuda.org" ];
      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };
}
