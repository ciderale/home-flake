{
  description = "Home Manager Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-flake.url = "github:ciderale/home-flake";
    home-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-flake, ... }:
    home-flake.homeConfigurationWithActivations {
      username = "<ale>";
      configuration = {
        nixpkgs.config.allowUnfree = true;
        imports = [
          home-flake.homeManagerModule
          # ./myconfig.nix # additional modules
        ];
        programs.git = {
          userName = "";
          userEmail = "";
        };
        # additional configuration
      };
    };
}
