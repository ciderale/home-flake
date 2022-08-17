{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [neoformat];
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
