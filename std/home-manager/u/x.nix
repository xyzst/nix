{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../home.nix
  ];
  
  home = {
    homeDirectory = "/home/x";
    packages = with pkgs; [
      nano
    ];
    username = "x";
  };
}