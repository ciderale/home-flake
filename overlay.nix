inputs:

final: prev: {
  # don't use the nix.overlay to benefit from cached build
  #nix = inputs.nix.packages.${prev.system}.nix;

  mkVimPlugin = name: prev.vimUtils.buildVimPlugin {
    inherit name; src = inputs."${name}";
  };
  vimPlugins = prev.vimPlugins // prev.lib.genAttrs [
    "vim-zettel" "vim-ranger" "vim-any-jump"
  ] final.mkVimPlugin;

  apps.amethyst = prev.callPackage ./apps/amethyst.nix {};
  apps.dropbox = prev.callPackage ./apps/dropbox.nix {};
}
