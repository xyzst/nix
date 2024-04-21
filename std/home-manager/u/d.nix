{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home = {
    homeDirectory = "/home/d";
    packages = with pkgs; [
      vim
    ];
    username = "d";
  };
}