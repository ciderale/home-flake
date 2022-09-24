{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.ale.neovim.python-ls = mkOption {
    type = types.bool;
    default = false;
    description = ''BASH language server with shellcheck'';
  };

  config.programs.neovim = mkIf config.ale.neovim.python-ls {
    extraPackages = [
      pkgs.python39Packages.jedi-language-server
    ];
    plugins = [
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        config = ''
          lua << EOF

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          require'lspconfig'.jedi_language_server.setup{}
          EOF
        '';
      }
    ];
  };
}
