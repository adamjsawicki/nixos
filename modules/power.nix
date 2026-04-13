{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ==========================================================================
  # NVIDIA Optimus - offload mode (GPU off by default, on-demand)
  # ==========================================================================

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;

    # Power management - keeps GPU off when not in use
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Open source kernel module (works better on Turing+)
    open = true;

    # PRIME offload - dGPU stays off, use `nvidia-offload` to run GPU apps
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics.enable = true;

  # ==========================================================================
  # TLP - Power management for laptops
  # ==========================================================================

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "quiet";
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      USB_AUTOSUSPEND = 1;
    };
  };

  # Disable power-profiles-daemon (conflicts with TLP)
  services.power-profiles-daemon.enable = false;

  # ==========================================================================
  # Additional optimizations
  # ==========================================================================

  services.thermald.enable = true;

  environment.systemPackages = with pkgs; [
    powertop
    nvtopPackages.nvidia
  ];
}
