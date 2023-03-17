# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "asus"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
  #  font = "Lat2-Terminus16";
    keyMap = "tr_q-latin5";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  
  # Exclude some packages from plasma 
  services.xserver.desktopManager.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
  ];

  # Configure keymap in X11
  services.xserver.layout = "tr";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip pkgs.hplipWithPlugin pkgs.samsung-unified-linux-driver  ];

  # Enable sound.


  # sound.enable = true;
  # services.pipewire.enable = true;
  # services.pipewire.audio.enable = true;
  # hardware.pulseaudio.enable = true;

  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };


  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.memeth = {
    isNormalUser = true;
    home = "/home/memeth";
    description = "Mehmet Karaman";
    extraGroups = [ "wheel" "libvirtd" "storage" "mlocate" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  };

  # Enable virtualisation
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = 
  #### BEGIN Python package declaration ####
  let
    my-python-packages = p: with p; [
      pandas
      seaborn
      matplotlib
      numpy
    ];
  in
  #### END Python package declaration ####

   #### BEGIN R and RStudio with R packages included #### 
   with pkgs;
   let
     R-with-my-packages = rWrapper.override{ packages = with rPackages; [ tidyverse prismatic ]; };
     RStudio-with-my-packages = rstudioWrapper.override{ packages = with rPackages; [ tidyverse prismatic ]; };
   in
   #### END R and RStudio with R packages included ####

    with pkgs; [
    vim
    wget
    neofetch
    firefox
    htop
    # alacritty
    plasma-pa
    vlc
    bluedevil
    source-code-pro
    cantarell-fonts
    zoom-us
    gcc
    gnumake
    R-with-my-packages
    RStudio-with-my-packages
    julia-bin
    (pkgs.python3.withPackages my-python-packages)
    jupyter
    yakuake
    libreoffice-qt
    ark
    kmail
    akregator
    microcodeIntel
    linuxHeaders
    nnn
    signal-desktop
    asciiquarium
    qbittorrent
    cmatrix
    figlet
    lolcat
    syncthing
    sddm-kcm
    konversation
    virt-manager
    kate
    git
    protonvpn-gui
    corefonts
    mlocate
    element-desktop
    lm_sensors
    vmware-workstation
    kdiskmark
    partition-manager
    smartmontools
  ];
  
  # Enable SwayWM
  # programs.sway.enable = true;

    
  # Settings for screensharing and flatpak
  #xdg.portal = {
   # enable = true;
    #extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-kde ];
    #wlr.enable = true;
  #};

 
  # my service settings
  systemd.services.NetworkManager-wait-online.enable = false;
  services.fstrim.enable = true; 
  #services.syncthing.enable = true;
  services.flatpak.enable = true;
  services.syncthing = {
    enable = true;
    user = "memeth";
    dataDir = "/home/memeth";
  };
  # Enable VMware
  virtualisation.vmware.host.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
  
    
  # Enable bluetooth
  hardware.bluetooth.enable = true;
}

  
