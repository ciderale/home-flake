{
  description = "My home-manager setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    vim-zettel.url = "github:michal-h21/vim-zettel";
    vim-zettel.flake = false;
    vim-ranger.url = "github:francoiscabrol/ranger.vim";
    vim-ranger.flake = false;
    vim-any-jump.url = "github:pechorin/any-jump.vim";
    vim-any-jump.flake = false;
    ale-slides.url = "github:ciderale/ale-slides";
    ale-slides.inputs.nixpkgs.follows = "nixpkgs";
    ale-slides.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, ... }: {
    overlay = import ./overlay.nix inputs;
    homeManagerModules = {
      base = {
        nixpkgs.overlays = [self.overlay];
        imports = [
          ./modules/nixBase.nix
          ./modules/direnv.nix
          ./modules/applinks.nix
          ./modules/keepass.nix
          # inputs.ale-slides.homeManagerModule
        ];
      };
      ale = {
        imports = [
          ./config/common.nix
          ./config/git.nix
          ./config/zsh.nix
          ./config/neovim
        ];
      };
    };

    homeConfigurationWithActivations = {
      username,
      configuration,
    }: flake-utils.lib.eachDefaultSystem (system: rec {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration ({
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          {
            home.username = username;
            home.stateVersion = "22.11";
          }
          configuration
        ];
      });
      defaultPackage = homeConfigurations."${username}".activationPackage;
    });


    defaultTemplate = {
      description = "Template to use nix-home";
      path = ./template;
    };

  };
}
