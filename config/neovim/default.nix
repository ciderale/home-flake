{pkgs, ...}: {
  home.packages = [pkgs.silver-searcher];
  imports = [./formatting.nix];
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    extraPackages = [pkgs.jdk pkgs.ranger];
    extraConfig = ''
      source ${./vimrc.minimal}
      source ${./filenavigation.vim}
      source ${./linenumbers.vim}
      source ${./zettel.vim}
    '';
    plugins = with pkgs.vimPlugins; [
      # rather core/essential vim plugins
      vim-airline
      vim-gitgutter
      fugitive
      nerdcommenter # typically ,cc or ,c<space>
      editorconfig-vim
      vim-autoformat
      vim-trailing-whitespace # https://github.com/bronson/vim-trailing-whitespace
      vim-polyglot
      vim-nix

      # vim text editing / zettelkasten
      tabular
      vim-table-mode
      vim-markdown
      vim-pandoc-syntax
      vimwiki
      vim-zettel

      # more
      syntastic
      #coc-nvim

      fzf-vim # https://github.com/junegunn/fzf.vim :GFiles, etc..
      vim-ranger
      bclose-vim # https://github.com/francoiscabrol/ranger.vim
      # image preview => currently not working or slow, requires iterm2, ueberzug, imgc      at, etc
      #sneak fast move forward.. not tested
      vim-any-jump # https://github.com/pechorin/any-jump.vim  <leader>j
      telescope-nvim
    ];
  };
  programs.zsh.shellAliases = {
    vi = "vim";
    vg = "vim -c ':G'";
  };
}
