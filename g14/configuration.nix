# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
#  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.settings.experimental-features = [
	"nix-command"
	"flakes"
  ];


  networking.hostName = "g14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Santiago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."martsegura" = {
    isNormalUser = true;
    description = "Martín Segura";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ### KDE PLASMA

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
 	enable = true;
	wayland.enable = true;
  };

  ### GRAPHICS

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
	"amdgpu"
	"nvidia"
  ];
  hardware.nvidia = {
	modesetting.enable = true;
	open = true;
	nvidiaSettings = true;
	prime = {
		offload = {
			enable = true;
			enableOffloadCmd = true;
		};
		nvidiaBusId = "PCI:100:0:0";
		amdgpuBusId = "PCI:400:0:0";
	};
  };


  ### AUDIO

  security.rtkit.enable = true;

  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
  };


  ### BLUETOOTH
  hardware.bluetooth = {
	enable = true;
	powerOnBoot = true;
  };

 ### APPIMAGE

  programs.appimage = {
	enable = true;
	binfmt = true;

	package = pkgs.appimage-run.override {
		extraPkgs = pkgs: with pkgs; [
			libva
		];
	};

  };

  ### DISTROBOX / PODMAN

  virtualisation.podman = {
	enable = true;
	dockerCompat = true;
  };

   #### APPS
  environment.systemPackages = with pkgs; [
	git
	curl
	wget
	nano
	zip
	unzip
	pciutils
	usbutils
	mesa-demos
	vulkan-tools
	distrobox
	discord
	gearlever
	mangohud
	onlyoffice-desktopeditors
	localsend
	vlc
	prismlauncher
	godot
	blender
	libresprite
	gimp
	inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default
	obs-studio
	nodejs
	jdk21
	jdt-language-server
	github-cli
	zed-editor


  ];


  ### BINARIOS NECESARIOS PARA ZED
  programs.nix-ld = {
	enable = true;

	libraries = with pkgs; [
	stdenv.cc.cc
	openssl
	];
  };

   ### JUEGUITOS
  programs.steam = {
	enable = true;
  };
  programs.gamemode.enable = true;

  ### FIRMWARE
  hardware.enableRedistributableFirmware = true;

  ### SECURITY
  networking.firewall = {
	enable = true;
	allowedTCPPorts = [ 53317 ];
	allowedUDPPorts = [ 53317 ];
  };
  # Printing
  services.printing.enable = true;

  # Discover printers over Wi-Fi / mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  ### MATENCION NIX
  nix.settings.auto-optimise-store = true;

  nix.gc = {
	automatic = true;
	dates = "weekly";
		options = "--delete-older-than 14d";
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
