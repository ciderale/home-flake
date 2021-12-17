{ ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      pwd_hash=$(echo -n $PWD | shasum | cut -d ' ' -f 1)
      direnv_layout_dir=$XDG_CACHE_HOME/direnv/layouts/$pwd_hash
    '';
  };
}
