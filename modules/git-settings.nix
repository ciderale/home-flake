{
  config,
  lib,
  ...
}: {
  options.programs.git.recommendedDefaults =
    lib.mkEnableOption "recommendedDefaults"
    // {
      description = ''
        Configure various recommended defaults.

        Source: https://blog.gitbutler.com/how-git-core-devs-configure-git/
        (Does not set all the options defined in the blog)
      '';
    };

  config.programs.git.extraConfig = lib.mkIf config.programs.git.recommendedDefaults {
    ### https://blog.gitbutler.com/how-git-core-devs-configure-git/

    ## Clearly Makes Git Better
    init.defaultBranch = "main";
    column.ui = "auto";
    branch.sort = "-committerdate";
    tag.sort = "version:refname";
    diff.algorithm = "histogram";
    diff.colorMoved = "plain";
    diff.mnemonicPrefix = true;
    diff.renames = true;
    push.default = "simple"; # (default since 2.0)
    # push.autoSetupRemote = true; I kind of like that
    # push.followTags = true; # keep it explicit
    fetch.prune = true;
    fetch.pruneTags = true;
    fetch.all = true;

    ## Why the Hell Not?
    help.autocorrect = "prompt";
    #commit.verbose = true;
    #rerere.enabled = true;
    #rerere.autoupdate = true;
    rebase.autoSquash = true;
    rebase.autoStash = true;
    # rebase.updateRefs = true; interesting, but maybe opt-in on cmdline
  };
}
