{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    sessionVariables = {
      EDITOR = "vim";
    };
    shellAliases = {
      cat = "bat --style=plain";
      ls = "${pkgs.coreutils}/bin/ls --color";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" ];
      theme = "af-magic";
    };
  };

}
