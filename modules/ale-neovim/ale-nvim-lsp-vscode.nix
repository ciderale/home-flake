{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.ale.neovim.vscode-ls = mkOption {
    type = types.bool;
    default = false;
    description = ''BASH language server with shellcheck'';
  };

  config.programs.neovim = mkIf config.ale.neovim.vscode-ls {
    extraPackages = [
      pkgs.nodePackages.vscode-langservers-extracted
      # pkgs.nodePackages.typescript-language-server
    ];
    plugins = [
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        config = ''
          lua << EOF

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          require'lspconfig'.cssls.setup{}
          require'lspconfig'.html.setup{
            capabilities = capabilities,
            init_options = {
              configurationSection = { "html", "css", "javascript" },
              embeddedLanguages = {
                css = true,
                javascript = true
              },
              provideFormatter = true
            }
          }
          require'lspconfig'.jsonls.setup{
            capabilities = capabilities,
            init_options = {
              provideFormatter = true
            }
          }

          -- the following seem not to work, do they require a full package.json setup?
          -- require'lspconfig'.eslint.setup{}
          -- require'lspconfig'.tsserver.setup{}
          EOF
        '';
      }
    ];
  };
}
