{
  # todo: parameterize hostPlatform when installing flake, somehow...
  # use nix language?
  imports = [
    ./hw/aarch64-linux/qemu.nix
  ];
}