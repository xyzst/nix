{
  # todo: parameterize hostPlatform when installing flake, somehow...
  # use nix language?
  imports = [
    ./hw/aarch64-linux/qemu.nix
  ];


  services = {
    spice-vdagentd = { # needed to enable copy and paste between host and VM
      enable = true;
    };
    spice-webdavd = {
      enable = true;
    };
  };
}