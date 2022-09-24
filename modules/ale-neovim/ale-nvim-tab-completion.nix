# https://www.reddit.com/r/neovim/comments/qdyux8/shelllike_completion_with_nvimcmp/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.ale.neovim.tab-completion = mkOption {
    type = types.bool;
    default = false;
    description = ''tab completion like in a shell'';
  };

  config.programs.neovim.plugins = mkIf config.ale.neovim.tab-completion [
    {
      plugin = pkgs.vimPlugins.nvim-cmp;

      config = ''
        lua << EOF
        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        local cmp = require('cmp')

        cmp.setup {
          mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
          },
        }
        EOF
      '';
    }
  ];
}
