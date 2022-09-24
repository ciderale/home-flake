{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.ale.neovim.nix-formatter = mkOption {
    type = types.bool; # Note: could be available formatters
    default = false;
    description = ''which formatter to use for nix (currently fix alejandra)'';
  };

  config.programs.neovim = mkIf config.ale.neovim.nix-formatter {
    plugins = [pkgs.vimPlugins.neoformat];
    extraPackages = [pkgs.alejandra];
    extraConfig = ''
      let g:neoformat_enabled_nix = ['alejandra']
      augroup fmt
        autocmd!
        autocmd BufWritePre * undojoin | Neoformat
      augroup END
    '';
  };
}
