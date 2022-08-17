# https://github.com/nix-community/home-manager/issues/1341#issuecomment-778820334
{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.programs.home-manager = {
    applinks = mkOption {
      type = types.bool;
      default = true;
      description = "Link/copy Mac Applications to ~/.Applications";
    };
  };

  config.home.activation =
    mkIf (
      config.programs.home-manager.applinks && pkgs.stdenv.hostPlatform.isDarwin
    ) {
      copyApplications = let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          baseDir="$HOME/Applications/Home Manager Apps"
          if [ -d "$baseDir" ]; then
            rm -rf "$baseDir"
          fi
          mkdir -p "$baseDir"
          for appFile in ${apps}/Applications/*; do
            target="$baseDir/$(basename "$appFile")"
            $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
            $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
          done
        '';
    };
}
