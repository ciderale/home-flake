{
  config,
  pkgs,
  lib,
  ...
}: let
  vimPlugins = pkgs.vimPlugins;
  cmpPlugins = ["cmp-buffer" "cmp-path" "cmp-nvim-lsp"];
in
  with lib; {
    options.ale.neovim.completion = mkOption {
      type = types.bool; # We could list all sources
      default = false;
      description = ''enable some default completion sources'';
    };

    config.programs.neovim.plugins = mkIf config.ale.neovim.completion ([
        {
          plugin = vimPlugins.nvim-cmp;
          config = ''
            lua << EOF

            local cmp = require('cmp')

            cmp.setup {
              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'path' },
              }),
            }
            EOF
          '';
        }
      ]
      ++ (pkgs.lib.attrVals cmpPlugins vimPlugins));
  }
