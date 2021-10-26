{ pkgs, ... }:
let
  nixFlake = pkgs.writeShellScriptBin "nixFlake" ''
    exec ${pkgs.nixFlakes}/bin/nix  --experimental-features 'nix-command flakes' "$@"
  '';
in
{
  programs.home-manager.enable = true;
  home.packages = [ nixFlake ];
  programs.zsh.shellAliases = {
    hmSwitchExistingResult = "./result/activate && source ~/.zshrc";
    hmPull = "nixFlake build . --update-input home-flake";
    hmPullSwitch = "hmPull && hmSwitchExistingResult";
    hmLocalBuild = "nixFlake build . --override-input home-flake ./home-flake";
    hmLocalSwitch = "hmLocalBuild && hmSwitchExistingResult";
  };
}
