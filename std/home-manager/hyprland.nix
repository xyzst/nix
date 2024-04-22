{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
  ];
  # fixes problems with themes: https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#fixing-problems-with-themes
  
  wayland = {
    windowManager = {
      hyprland = { # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.hyprland.enable
        enable = true;
        extraConfig = '' # https://wiki.hyprland.org/Configuring/Variables/
        '';
        plugins = [
          # list of official plugins: https://github.com/hyprwm/hyprland-plugins
        ];
        settings = {
          
        };
        systemd = {
          variables = [
            "--all" # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
          ];
        };
        xwayland = {
          enable = true;
        };
      };
    };
  };
}