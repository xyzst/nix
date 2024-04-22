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
    ../hyprland.nix
  ];
  
  home = {
    homeDirectory = "/home/d";
    packages = with pkgs; [
      vim
    ];
    username = "d";
  };
}