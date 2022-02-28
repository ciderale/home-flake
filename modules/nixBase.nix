{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nix;
  dir = config.nix.hmConfigDir;
  baseFlake = config.nix.hmBaseFlake;

  aliases = optionalAttrs (cfg.experimentalFeatures != null) {
    nix = "nix --experimental-features '${cfg.experimentalFeatures}'";
  } // optionalAttrs (dir != null) {
    # flake based home manager utilities
    hmCd = "cd ${dir}";
    hmBuild = "(hmCd && nix build .)";
    hmSwitch = "(hmCd && ./result/activate) && source ~/.zshrc";
  } // optionalAttrs (baseFlake != null) {
    # assuming a home-flake setup
    hmPull = "(hmCd && nix flake lock --update-input ${baseFlake})";
    hmPullBuild = "hmPull && hmBuild";
    hmPullSwitch = "hmPullBuild && hmSwitch";
    hmLocalBuild = "(hmCd && nix build . --override-input ${baseFlake} ./${baseFlake})";
    hmLocalSwitch = "hmLocalBuild && hmSwitch";
  };
in
{
  options.nix = {
    hmConfigDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Location of the home manager flake";
    };
    hmBaseFlake = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Name of a base flake";
    };
    experimentalFeatures = mkOption {
      type = types.nullOr types.str;
      default = "nix-command flakes";
      description = "Enabling experimental features";
    };
  };
  config.programs.home-manager.enable = cfg.hmConfigDir != null;
  config.programs.zsh.shellAliases = aliases; # optionalAttrs (cfg.hmConfigDir != null) aliases;
}
