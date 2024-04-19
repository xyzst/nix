{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
      };
    };
  };
  
  environment = {
    systemPackages = with pkgs; [
    ];
  };
  
  hardware = {
    pulseaudio = {
      enable = false;
    };
  };
  
  home-manager.users.d = {
    home = {
      stateVersion = "23.11"; # required: [keep the same as current nixos version?]
    };
    wayland = {
      windowManager = {
        hyprland = {
          enable = true;
          enableNvidiaPatches = false;
          package = pkgs.hyprland;
          plugins = [
            ""
          ];
        };
      };
    };
  };
  
  networking = {
    firewall = {
      # allowedTCPPorts = [
      # ];
      # allowedUDPPorts = [
      # ];
      enable = true;
    };
    hostName = "ryz";
    networkmanager = {
      enable = false;
    };
    # proxy = {
    #  default = "http://u:p@proxy:port/";
    #  noProxy = "127.0.0.1,localhost,internal.domain";
    # };
    wireless = {
      enable = false;
    };
  };
  
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      frequency = "weekly";
    };
    package = pkgs.nixUnstable;
    # settings = {
    #  substituters = [
    #    ""
    #  ];
    #  trusted-public-keys = [
    #    ""
    #  ];
    # };
  };
  
  services = {
    openssh = {
      enable = true;
    };
    printing = {
      enable = false;
    };
    xserver = {
      enable = false;
      libinput = {
        enable = false;
      };
    };
  };
  
  sound = {
    enable = false;
  };
  
  system = {
    # Copy NixOS configuration file and link it from the resulting system (/run/current-system/configuration.nix)
    # This is useful in case you accidentally delete configuration.nix
    copySystemConfiguration = true;
    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    stateVersion = "23.11"; # Did you read the comment?
  };
  
  time = {
    timeZone = "Etc/UTC"
  };
  
  users = {
    groups = {
      dev = {
        gid = 420;
      };
    };
    users = {
      darren = {
        createHome = true;
        extraGroups = [
          "wheel" # sudoer
        ];
        group = "dev";
        home = "/home/darren";
        homeMode = "700";
        initialPassword = "darren";
      };
    };
  };
}