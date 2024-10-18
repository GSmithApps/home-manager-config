{
  description = "Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        homeManagerPkgs = home-manager.lib.homeManagerConfiguration;
      in {
        homeConfigurations.grants = homeManagerPkgs {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            {
              home = {
                username = "grants";
                homeDirectory = "/home/grants";
                stateVersion = "24.05";
                packages = with pkgs; [
                  lazygit
                ];
              };
              nixpkgs.config.allowUnfree = true;
              programs = {
                home-manager.enable = true;
              };
            }
          ];
        };
      }
    );
}
