{
  description = "Home Manager Configuration";

  inputs = {
    home-flake.url = "github:ciderale/home-flake";
    #in case you need to use a different nixpkgs
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #home-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    home-flake,
    ...
  }:
    home-flake.homeConfigurationWithActivations {
      username = "<ale>";
      configuration = {
        imports = [
          # include modules: local or from other flakes
          # home-flake.homeManagerModule.some-name
          # ./myconfig.nix # additional modules
        ];
        # additional inline configuration
        nixpkgs.config.allowUnfree = true;
        programs.git = {
          userName = "";
          userEmail = "";
        };
      };
    };
}
