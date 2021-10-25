{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
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
    homeManagerModule = { pkgs, ...}: {
      nixpkgs.overlays = [self.overlay];
      home.packages = [ home-manager.defaultPackage.${pkgs.system} ];
      imports = [
        ./modules/direnv.nix
        ./modules/neovim
        ./modules/common.nix
        ./modules/git.nix
        ./modules/zsh.nix
        inputs.ale-slides.homeManagerModule
      ];
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
