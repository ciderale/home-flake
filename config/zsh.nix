{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

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
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
  };
}
