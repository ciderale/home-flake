{
  description = "Home Manager Configuration";

  inputs = {
    home-flake.url = "github:ciderale/home-flake";
    nixpkgs.follows = "home-flake/nixpkgs";
    flake-utils.follows = "home-flake/flake-utils";
    #in case you need to use a different nixpkgs
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #home-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-utils,
    home-flake,
    ...
  }:
    home-flake.lib.homeConfigurations {
      default = "yourUsername";
      yourUsername = {
        imports = [
          # include modules: local or from other flakes
          home-flake.homeManagerModules.base
          # ./myconfig.nix # additional modules
        ];
        # additional inline configuration
        programs.git = {
          userName = "";
          userEmail = "";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
    });
}
