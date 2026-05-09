{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Use /data for nix build scratch space — / is small, big builds (kernels,
  # browsers, etc.) can blow past tmpfs. /data has hundreds of GB free.
  systemd.services.nix-daemon.environment.TMPDIR = "/data/nix-build";
  systemd.tmpfiles.rules = [
    "d /data/nix-build 0755 root root -"
  ];

  # Bootloader: ESP at /boot/efi, keep kernels on ext4 under /boot
  boot.loader = {
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
    grub.useOSProber = true;
    grub.configurationLimit = 8;
    grub.copyKernels = false; # guardrail: never copy kernels to ESP
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ 53317 ]; # LocalSend
    allowedUDPPorts = [ 53317 ];
  };

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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # SSH (enables host key generation for sops-nix)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
    # If you don't want SSH listening, uncomment:
    # openFirewall = false;
  };

  # Tailscale VPN (for remote access)
  services.tailscale.enable = true;

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
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh; # login shell; HM configures zsh internals
  };
  programs.zsh.enable = true;

  # 1Password - must use NixOS modules (not home-manager packages) for CLI
  # integration to work. The module sets up polkit policies and the IPC socket
  # that allows `op` CLI to authenticate through the GUI app.
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "adam" ];
  };

  # Allow running unpatched dynamic binaries (needed for VSCode extensions like Claude Code)
  programs.nix-ld.enable = true;

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Shared /home partition (across distros)
  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
  };

  # Shared /data partition (docker, ollama, large files).
  # neededForBoot because /nix bind-mounts from /data/nix — initrd must
  # mount /data before stage-2 can find the store.
  fileSystems."/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
    neededForBoot = true;
  };

  # /nix lives on /data — root partition is only 96G and the store
  # was filling it. Bind-mount keeps /data shared with docker/ollama/etc.
  fileSystems."/nix" = {
    device = "/data/nix";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/data" ];
    neededForBoot = true;
  };

  # Passwordless nixos-rebuild (optional)
  security.sudo.extraRules = [
    {
      users = [ "adam" ];
      commands = [
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  system.stateVersion = "25.05";
}
