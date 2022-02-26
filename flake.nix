{
  description = "My home-manager setup";

  inputs = {
    nix.url = "github:NixOS/nix/2.5.1"; # temporarily use directly from nix
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vim-zettel.url = "github:michal-h21/vim-zettel";
    vim-zettel.flake = false;
    vim-ranger.url = "github:francoiscabrol/ranger.vim";
    vim-ranger.flake = false;
    vim-any-jump.url = "github:pechorin/any-jump.vim";
    vim-any-jump.flake = false;
    ale-slides.url = "github:ciderale/ale-slides";
    ale-slides.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    overlay = import ./overlay.nix inputs;
    homeManagerModule = {
      nixpkgs.overlays = [self.overlay];
      imports = [
        ./modules/nixBase.nix
        ./modules/neovim
        ./modules/common.nix
        ./modules/git.nix
        ./modules/zsh.nix
        ./modules/direnv.nix
        ./modules/applinks.nix
        ./modules/keepass.nix
        inputs.ale-slides.homeManagerModule
      ];
    };
    activationPackageFor = def: let
      configuration = home-manager.lib.homeManagerConfiguration def;
    in configuration.activationPackage;

    defaultTemplate = {
      description = "Template to use nix-home";
      path = ./template;
    };

    homeManagerConfigurations = {
      base = home-manager.lib.homeManagerConfiguration {
        configuration = {
          imports = [self.homeManagerModule];
        };
        system = "x86_64-darwin";
        homeDirectory = "/Users/ale";
        username = "ale";
      };
    };
    homeManagerConfiguration = self.homeManagerConfigurations.base;
    defaultPackage.x86_64-darwin = self.homeManagerConfiguration.activationPackage;
  };
}
