# flake.nix
{
  description = "NixOS and Home Manager Configurations";

  inputs = {
    # --- Core Inputs ---
    # Pin nixpkgs to a specific branch or release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # Or nixos-unstable, etc.

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11"; # Match nixpkgs branch
      inputs.nixpkgs.follows = "nixpkgs"; # Crucial: Ensures HM uses the same nixpkgs
    };

    # --- Optional Inputs ---
    hardware.url = "github:NixOS/nixos-hardware"; # For specific hardware modules
    # nur.url = "github:nix-community/NUR"; # Nix User Repository

    # Secret management tool (choose one)
    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... } @ inputs:
    let
      # Helper function to build a NixOS system configuration
      # mkNixosSystem = { system ? "x86_64-linux", hostName, username, extraModules ? [], }:
      mkNixosSystem = { hostName, username, extraModules ? [], }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hostName username; }; # Pass inputs & custom args down to modules
          modules = [
            # Core Home Manager module
            home-manager.nixosModules.home-manager
            # Core secrets module (choose one)
            # agenix.nixosModules.default
            sops-nix.nixosModules.sops

            # Machine-specific config
            ./nixos/hosts/${hostName}/configuration.nix

            # Shared NixOS configurations
            ./nixos/common/base.nix

            # Home Manager configuration for the primary user of this system
            {
              home-manager.useGlobalPkgs = true; # Share nixpkgs instance
              home-manager.useUserPackages = true; # Allow user packages
              home-manager.extraSpecialArgs = { inherit inputs hostName username; }; # Pass args to HM modules
              home-manager.users.${username} = import ./home/users/${username}/home.nix;
            }
          ] ++ extraModules; # Add any host-specific extra modules
        };

    in {
      # === NixOS System Configurations ===
      nixosConfigurations = {
        # "desktop-alpha" = mkNixosSystem { hostName = "desktop-alpha"; username = "alice"; };
        # "laptop-beta" = mkNixosSystem { hostName = "laptop-beta"; username = "alice"; };
        # "server-gamma" = mkNixosSystem { hostName = "server-gamma"; username = "bob"; system = "aarch64-linux"; };
        # Add more hosts here...
	"jellyfin" = mkNixosSystem { hostName = "jellyfin"; username = "apollo"; };
      };

      # === Standalone Home Manager Configurations (Optional) ===
      # Useful for non-NixOS systems or managing multiple users distinctly
      # homeConfigurations = {
      #    "alice@desktop-alpha" = home-manager.lib.homeManagerConfiguration {
      #       pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #       extraSpecialArgs = { inherit inputs; username = "alice"; hostName = "desktop-alpha"; };
      #       modules = [ ./home/users/alice/home.nix ];
      #    };
      #    # Add more standalone HM configs...
      # };

      # === Custom Packages (Optional) ===
      # packages.x86_64-linux.my-custom-script = pkgs.callPackage ./pkgs/my-script.nix {};

      # === Custom Modules (Optional) ===
      # nixosModules.my-custom-module = import ./nixos/modules/my-module.nix;
    };
}
