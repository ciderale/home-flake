{pkgs, ...}: let
  inherit (pkgs) vimPlugins;
in {
  programs.neovim.plugins = [
    vimPlugins.nvim-web-devicons
    {
      plugin = vimPlugins.nvim-tree-lua;
      config = ''
        lua << EOF
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        -- optionally enable 24-bit colour
        vim.opt.termguicolors = true

        require("nvim-tree").setup()
        EOF
      '';
    }
  ];
}
