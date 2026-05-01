{
  description = "Adam's NixOS + Home Manager (flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
    # FreeRDP 2.x for Remmina compatibility with RD Gateway
    nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    # Always up-to-date Claude Code (hourly upstream updates)
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    # Requires garnix cache (no module provided, so we configure it manually below)
    nix-openclaw.url = "github:openclaw/nix-openclaw";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-2405,
      home-manager,
      sops-nix,
      claude-code-nix,
      nix-openclaw,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [ "openclaw-2026.4.2" ];
      };
      # Older nixpkgs with FreeRDP 2.x for Remmina RD Gateway compatibility
      pkgs-2405 = import nixpkgs-2405 {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          ./modules/power.nix
          ./modules/sops.nix
          ./modules/flake-auto-update.nix
          sops-nix.nixosModules.sops

          home-manager.nixosModules.home-manager

          {
            # Share pkgs and install user packages via HM
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit pkgs-unstable pkgs-2405 sops-nix; };

            # HM user mapping
            home-manager.users = {
              adam = import ./modules/users/adam.nix;
              root = import ./modules/users/root.nix;
            };

            # Back up pre-existing dotfiles on first activation
            home-manager.backupFileExtension = ".bak";

            # Convenience: HM CLI on PATH system-wide
            environment.systemPackages = [ pkgs.home-manager ];

            # Set global 'allowUnfree'
            nixpkgs.config.allowUnfree = true;

            # Overlays
            nixpkgs.overlays = [
              claude-code-nix.overlays.default
              nix-openclaw.overlays.default
            ];

            # Make openclaw module available (enabled per-user in their config)
            home-manager.sharedModules = [ nix-openclaw.homeManagerModules.openclaw ];

            # Binary cache for nix-openclaw (garnix.io)
            nix.settings.extra-substituters = [ "https://cache.garnix.io" ];
            nix.settings.extra-trusted-public-keys = [
              "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            ];
          }
        ];
      };
    };
}
