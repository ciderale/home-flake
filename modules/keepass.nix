{ pkgs, config, lib, ... }: with lib; let
  cfg = config.programs.mykpcli;
in {

  options.programs.mykpcli = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "Default keepass file to open";
  };

  config.programs.zsh.shellAliases = optionalAttrs (cfg != null) {
    mykpcli = "${pkgs.kpcli}/bin/kpcli --kdb ${cfg}";
  };
  config.home.packages = [ pkgs.keeweb ];
}
