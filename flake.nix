# flake.nix — Amir's NixOS + Home-Manager configuration

{
  description = "Amir's NixOS configuration with Home-Manager";

  inputs = {
    # Stable channel (recommended for reliability)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # If you want latest packages (more bleeding-edge):
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";  # Use the same nixpkgs version
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    # Main NixOS configuration
    nixosConfigurations = {
      # Primary config (use with: nixos-rebuild switch --flake .#nixos)
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };  # Pass inputs to modules if needed
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Import user config for amir
            home-manager.users.amir = import ./home.nix;

            # Optional: pass extra arguments to home-manager
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      # Optional: default alias so you can just do nixos-rebuild switch --flake .
      default = self.nixosConfigurations.nixos;
    };
  };
}
