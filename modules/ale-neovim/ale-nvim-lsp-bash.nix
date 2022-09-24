{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.ale.neovim.bashls = mkOption {
    type = types.bool;
    default = false;
    description = ''BASH language server with shellcheck'';
  };

  config.programs.neovim = mkIf config.ale.neovim.bashls {
    extraPackages = [
      pkgs.nodePackages.bash-language-server
      pkgs.shellcheck
    ];
    plugins = [
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        config = ''lua require'lspconfig'.bashls.setup{}'';
      }
    ];
  };
}
