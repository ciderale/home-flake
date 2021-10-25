{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = input@{ self, nixpkgs, home-manager }: {
    homeManagerConfigurations = {
      base = home-manager.lib.homeManagerConfiguration {
        configuration = {};
        system = "x86_64-darwin";
        homeDirectory = "/Users/ale";
        username = "ale";
      };
    };
    homeManagerConfiguration = self.homeManagerConfigurations.base;
    defaultPackage.x86_64-darwin = self.homeManagerConfiguration.activationPackage;
  };
}
