{ pkgs, ... }: {
  home.packages = with pkgs; [
    niv cachix manix
    ripgrep fzf
    curl wget jq less
    pandoc
  ];
}
