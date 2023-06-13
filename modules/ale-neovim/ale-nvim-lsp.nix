{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.ale.neovim.lsp = mkOption {
    type = types.bool;
    default = false;
    description = ''configure neovim lsp'';
  };

  config.programs.neovim.plugins = mkIf config.ale.neovim.lsp [
    {
      plugin = pkgs.vimPlugins.nvim-lspconfig;
      # https://github.com/oxalica/nil/blob/main/dev/neovim-lsp.nix
      config = ''
        lua << EOF
        local lsp_mappings = {
            { 'gD', vim.lsp.buf.declaration },
            { 'gd', vim.lsp.buf.definition },
            { 'gi', vim.lsp.buf.implementation },
            { 'gr', vim.lsp.buf.references },
            { '[d', vim.diagnostic.goto_prev },
            { ']d', vim.diagnostic.goto_next },
            { ' ' , vim.lsp.buf.hover },
            { ' s', vim.lsp.buf.signature_help },
            { ' r', vim.lsp.buf.rename },
            { ' a', vim.lsp.buf.code_action },
            { ' d', vim.diagnostic.open_float },
            { ' q', vim.diagnostic.setloclist },
        }

        for i, map in pairs(lsp_mappings) do
          vim.keymap.set('n', map[1], function() map[2]() end)
        end

        -- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
        local caps = require('cmp_nvim_lsp').default_capabilities()

        -- local lsp_path = vim.env.NIL_PATH or 'target/debug/nil'
        local lsp_path = '${pkgs.nil}/bin/nil'
        require('lspconfig').nil_ls.setup {
          autostart = true,
          capabilities = caps,
          cmd = { lsp_path },
          settings = {
            ['nil'] = {
              testSetting = 42,
            },
          },
        }

        -- for server configuration details see:
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.txt
        -- require'lspconfig'.kotlin_language_server.setup {}
        EOF
      '';
    }
  ];
}
