{ pkgs, ... }: {
  home.packages = with pkgs; [
    #niv cachix # currently broken
    manix
    ncdu nix-tree
    ripgrep fzf
    curl wget jq less
    pandoc
  ];
  programs.bat.enable = true;
}
