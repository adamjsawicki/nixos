{
  description = "Adam's NixOS + Home Manager (flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager

          {
            # Share pkgs and install user packages via HM
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # HM user mapping
            home-manager.users = {
              adam = import ./home/adam.nix;
              root = import ./home/root.nix;
            };

            # Back up pre-existing dotfiles on first activation
            home-manager.backupFileExtension = ".bak";

            # Convenience: HM CLI on PATH system-wide
            environment.systemPackages = [ pkgs.home-manager ];

            # Also allow unfree at system level (redundant but harmless)
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
}
