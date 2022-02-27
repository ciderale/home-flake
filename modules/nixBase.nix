{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nix;
  dir = config.nix.hmConfigDir;

  aliases = rec {
    nix = "nix --experimental-features '${cfg.experimentalFeatures}'";
    hmCd = "cd ${dir}";
    hmPull = "(hmCd && nix flake lock --update-input home-flake)";
    hmBuild = "(hmCd && nix build .)";
    hmSwitch = "(hmCd && ./result/activate && source ~/.zshrc)";
    hmPullSwitch = "hmPull && hmBuild && hmSwitch";
    hmLocalBuild = "(hmCd && nix build . --override-input home-flake ./home-flake)";
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
    experimentalFeatures = mkOption {
      type = types.nullOr types.str;
      default = "nix-command flakes";
      description = "Enabling experimental features";
    };
  };
  config.programs.home-manager.enable = cfg.hmConfigDir != null;
  config.programs.zsh.shellAliases = optionalAttrs (cfg.hmConfigDir != null) aliases;
}
