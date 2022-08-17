{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    sessionVariables = {
      EDITOR = "vim";
    };
    shellAliases = {
      cat = "bat --style=plain";
    };

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "sudo" "docker" "kubectl" "fzf"];
      theme = "af-magic";
    };
  };
  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}
