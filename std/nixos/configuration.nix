# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    inputs.home-manager.nixosModules.home-manager

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      d = import ../home-manager/u/d.nix;
      x = import ../home-manager/u/x.nix;
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html
    extraOptions = ''
      experimental-features = nix-command flakes
      auto-optimise-store = true
    '';

    gc = {
      automatic = true;
    };
    
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = [
      "/etc/nix/path"
    ];

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    
    settings = {
      substituters = [
        "https://ryz-dev.cachix.org"
      ];
      trusted-public-keys = [
        "ryz-dev.cachix.org-1:fu8HH5PhQuDVA/TIOLiNjo62TjoOCp8XnmOBmHo8S08="
      ];
    };
  };

  environment = {
    etc = lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;
  };


  # FIXME: Add the rest of your current configuration

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

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
    };
  };

  users = {
    groups = {
      dev = {
        gid = 420;
      };
    };
    users = {
      d = {
        # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
        # Be sure to change it (using passwd) after rebooting!
        initialPassword = "shortaapl";
        isNormalUser = true;
        openssh = {
          authorizedKeys = {
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYjTKw+0nIX2x0vx3Z6xtd7O8Lb6ZkB26z7STsqYJ8g"
            ];
          };
        };
        extraGroups = [
          "wheel" # enable `sudo`
        ];
        group = "dev";
      };
      x = {
        initialPassword = "shortmsft";
        isNormalUser = true;
        openssh = {
          authorizedKeys = {
            keys = [
              # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
            ];
          };
        };
        extraGroups = [
        ];
        group = "dev";
      };
    };
  };

  services = {
    ntp = {
      enable = true; # by default, nixos uses `systemd-timesyncd`
    };
    openssh = {
      banner = ''🤠 Howdy, partner!

                                         _|
 _|  _|_|  _|    _|  _|_|_|_|        _|_|_|    _|_|    _|      _|
 _|_|      _|    _|      _|        _|    _|  _|_|_|_|  _|      _|
 _|        _|    _|    _|          _|    _|  _|          _|  _|
 _|          _|_|_|  _|_|_|_|  _|    _|_|_|    _|_|_|      _|
                 _|
             _|_|
---
If you're reading this, you've been in a coma for almost 20 years now.
We're trying a new technique. We don't know where this message will
end up in your dream, but we hope it works. Please wake up, we miss you.
      '';
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
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

  system = {
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
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
    # Additional information, see https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11"; # Did you read the comment?
  };
  
  time = {
    timeZone = "Etc/UTC";
  };
}