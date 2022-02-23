{ config, lib, ... }:
with lib;
{
  options.programs.direnv = {
    cacheInHome = mkOption {
      type = types.bool;
      default = true;
      description = "Caching in ~/.cache/direnv/layouts";
    };
  };
  config.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    stdlib = mkIf config.programs.direnv.cacheInHome ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
      echo "''${direnv_layout_dirs[$PWD]:=$(
        echo -n "$XDG_CACHE_HOME"/direnv/layouts/
        echo -n "$PWD" | shasum | cut -d ' ' -f 1
        )}"
      }
    '';
  };
}
