{
  description = "My home-manager setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    mac-app-util.url = "github:hraban/mac-app-util";

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

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    ...
  }: {
    overlay = import ./overlay.nix inputs;
    homeManagerModules = {
      base = {
        nixpkgs.overlays = [self.overlay];
        imports = [
          ./modules/nixBase.nix
          ./modules/direnv.nix
          ./modules/git-settings.nix
          #./modules/applinks.nix
          #./modules/hm-macos-applications.nix
          inputs.mac-app-util.homeManagerModules.default
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

    # see ./template/flake.nix for usage examples
    # lib.homeConfigurations is a function:
    # - input: attrSet["username" => "home-manager-module"]
    #          (special attribute name default="defaultUser")
    # - generates homeConfiguration.username for every module & architecture
    # - generates packages.$system.username to expose "home-manager activation script"
    # - generates packages.$system.default for the defaultUser name
    lib.homeConfigurations = homes:
      flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {
          inherit system;
          # option nixpkgs.config.allowUnfree currently not working
          # https://github.com/nix-community/home-manager/issues/2954
          config = {allowUnfree = true;};
        };
        configurations = builtins.removeAttrs homes ["default"];
        mkHomeConfig = name: configuration:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [{home.username = name;} configuration];
          };
        mkActivationPackage = _: homeConfiguration: homeConfiguration.activationPackage;
      in rec {
        homeConfigurations = builtins.mapAttrs mkHomeConfig configurations;
        packages =
          (builtins.mapAttrs mkActivationPackage homeConfigurations)
          // pkgs.lib.optionalAttrs (homes ? default) {default = packages.${homes.default};};
      });

    defaultTemplate = {
      description = "Template to use nix-home";
      path = ./template;
    };
  };
}
