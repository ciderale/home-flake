{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nix;
  dir = config.nix.hmConfigDir;
  baseFlake = config.nix.hmBaseFlake;

  hmBaseOverrides = pkgs.writeShellScript "overrideInputs.sh" ''
    cd ${dir} && cd ${baseFlake} && nix flake metadata | grep -v follows | sed -n -e "s?.*─\([^:]*\): \([^ ]*\).*?--override-input home-flake/\1 \2?p" | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'
  '';

  aliases =
    optionalAttrs (dir != null) {
      # flake based home manager utilities
      hmCd = "cd ${dir}";
      hmBuild = "(hmCd && nix build .)";
      hmSwitch = "(hmCd && ./result/activate) && source ~/.zshrc";
    }
    // optionalAttrs (baseFlake != null) {
      # assuming a home-flake setup
      hmPull = "(hmCd && nix flake lock --update-input ${baseFlake})";
      hmPullBuild = "hmPull && hmBuild";
      hmPullSwitch = "hmPullBuild && hmSwitch";
      hmLocalBuild = "(hmCd && nix build . --override-input ${baseFlake} ./${baseFlake} $(${hmBaseOverrides}))";
      hmLocalSwitch = "hmLocalBuild && hmSwitch";
    };
  homePrefixDefault =
    if (builtins.match ".*-darwin" pkgs.system != null)
    then "/Users"
    else "/home";
in {
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
    hmHomePrefix = mkOption {
      type = types.nullOr types.str;
      default = homePrefixDefault;
      description = "set homeDirectory to /home/{username} (linux) or /Users/{username} (darwin)";
    };
  };
  config.home.homeDirectory = mkIf (cfg.hmHomePrefix != null) "${config.nix.hmHomePrefix}/${config.home.username}";
  config.programs.home-manager.enable = cfg.hmConfigDir != null;
  config.home.packages = [pkgs.nix];
  config.nix = {
    package = pkgs.nix;
    settings = optionalAttrs (cfg.experimentalFeatures != null) {
      experimental-features = cfg.experimentalFeatures;
    };
  };
  config.programs.zsh.shellAliases = aliases; # optionalAttrs (cfg.hmConfigDir != null) aliases;
  config.home.stateVersion = "22.11"; # override with 'home.stateVersion = lib.mkForce "22.05";'
}
