{ pkgs, ... }: {
  home.packages = with pkgs; [
    #niv cachix # currently broken
    manix
    ncdu nix-tree
    ripgrep fzf
    curl wget jq less
    pandoc
    kpcli
  ];
  programs.bat.enable = true;

  # Mac OS: Standard "Cycle Thru Windows" Command Doesn't Work
  # https://githubhot.com/repo/kovidgoyal/kitty/issues/4693
  # Open System Preferences, Keyboard, Shortcuts, Keyboard. Disable and enable Move focus to next window.
  programs.kitty.enable = true;
  programs.zsh.shellAliases.ssh = "kitty +kitten ssh";

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
}
