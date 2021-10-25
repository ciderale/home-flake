inputs:

final: prev: {
  mkVimPlugin = name: prev.vimUtils.buildVimPlugin {
    inherit name; src = inputs."${name}";
  };
  vimPlugins = prev.vimPlugins // prev.lib.genAttrs [
    "vim-zettel" "vim-ranger" "vim-any-jump"
  ] final.mkVimPlugin;
}
