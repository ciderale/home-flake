{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    delta.enable = true;
    delta.options = { dark = true; };
    ignores = [
      ".old" ".tmp" "*~" ".DS_Store"
    ];
    aliases = {
      what = "log --author=alain --pretty=format:'%h - %an, %>(14)%ar : %s'";
      releasenotes = "log --date=short --pretty=format:'%h | %<(15,trunc)%an | %ad | %<(100,trunc)%s'";
    };
  };
}
