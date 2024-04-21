{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home = {
    homeDirectory = "/home/x";
    packages = with pkgs; [
      nano
    ];
    username = "x";
  };
}