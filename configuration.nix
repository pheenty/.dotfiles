{ config, pkgs, ... }:


let
  graphics = true;
  sound = true; # well it doesn't really hurt anyway
in
{
  imports = [
    "/etc/nixos/hardware-configuration.nix"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "pheenty-laptop"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Novosibirsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pheenty = {
    isNormalUser = true;
    description = "Ted Lukin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      pinentry-tty
      fastfetch
      stow
      eza
      gnupg
      ffmpeg
      fd
      fzf
      dotnet-sdk_9
      steamcmd
      python3
      rustup
      go
      podman
      btop
    ] ++ (if graphics then [
      ghostty
      niri
      #nwg-look
      themechanger
      #kdePackages.qt6ct
      fuzzel
      swaynotificationcenter
      copyq
      thunar
      flameshot
      firefox
      vlc
      steam
      vesktop
      libreoffice
      mpvpaper
      zed-editor
    ] else []) ++ (if sound then [
      wiremix
    ] else []);
  };

  fonts.packages = with pkgs; [ # also should be user-side but whatever
    nerd-fonts.caskaydia-mono
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.throne = if graphics then {
    enable = true;
    tunMode.enable = true;
  } else {};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # should have system-wide config
     git
     # ly
  ] ++ (if sound then [
     wireplumber
  ] else []) ++ (if graphics then [
     lact
  ] else []);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  security.rtkit.enable = sound;
  services.pipewire = if sound then {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  } else {};

  systemd.services.lact = if graphics then {
    description = "LACT daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  } else {};

  hardware.graphics = {
    enable = graphics;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
