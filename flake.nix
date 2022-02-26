{
  description = "My home-manager setup";

  inputs = {
    nix.url = "github:NixOS/nix/2.5.1"; # temporarily use directly from nix
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

    homeConfigurationWithActivations = {
      username,
      configuration,
    }: flake-utils.lib.eachDefaultSystem (system: rec {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration ({
        inherit system username configuration;
        homeDirectory = let
          home = if (builtins.match ".*-darwin" system != null) then "/Users" else "/home";
        in "${home}/${username}";
      });
      defaultPackage = homeConfigurations."${username}".activationPackage;
    });


    defaultTemplate = {
      description = "Template to use nix-home";
      path = ./template;
    };

  };
}
