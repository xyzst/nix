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

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  fileSystems = {
    # [2024-04-20] fix "⚠️ Mount point '/boot' which backs the random seed file is world accessible, which is a security hole! ⚠️" warning
    # https://github.com/NixOS/nixpkgs/issues/279362#issuecomment-1913506090
    # https://github.com/NixOS/nixpkgs/issues/279362#issuecomment-1883970541
    # https://discourse.nixos.org/t/security-warning-when-installing-nixos-23-11/37636/3
    "/boot" = {
      options = [
        "uid=0"
        "gid=0"
        "fmask=0077"
        "dmask=0077"
      ];
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
    
  };

  environment = {
    etc = lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;
    
    systemPackages = with pkgs; [
    ];
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
              # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
            ];
          };
        };
        # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
        extraGroups = ["wheel"];
        group = "dev";
      };
    };
  };

  services = {
    openssh = {
      banner = ''🤠 Howdy, partner!
      << If you're reading this, you've been in a coma for almost 20 years now. We're trying a new technique. We don't know where this message will end up in your dream, but we hope it works. Please wake up, we miss you. >>
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