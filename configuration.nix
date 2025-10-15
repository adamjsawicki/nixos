{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader: ESP at /boot/efi, keep kernels on ext4 under /boot
  boot.loader = {
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
    grub.useOSProber = true;
    grub.configurationLimit = 8;
    grub.copyKernels = false;        # guardrail: never copy kernels to ESP
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Desktop (GNOME)
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };

  # Printing & audio
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.adam = {
    isNormalUser = true;
    description = "adam";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;   # login shell; HM configures zsh internals
  };
  programs.zsh.enable = true;

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Ubuntu home mount + targeted bind mounts
  fileSystems."/mnt/ubuntu-home" = {
    device = "/dev/disk/by-uuid/b2113b34-69b7-48c1-8c35-4266b3f9852e";
    fsType = "ext4";
    options = [ "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
  };
  fileSystems."/home/adam/Documents" = {
    device = "/mnt/ubuntu-home/swixx/Documents";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/mnt/ubuntu-home" ];
  };
  fileSystems."/home/adam/Downloads" = {
    device = "/mnt/ubuntu-home/swixx/Downloads";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/mnt/ubuntu-home" ];
  };

  # Passwordless nixos-rebuild (optional)
  security.sudo.extraRules = [
    {
      users = [ "adam" ];
      commands = [
        { command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  system.stateVersion = "25.05";
}
