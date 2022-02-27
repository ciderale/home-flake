{ pkgs, ... }:
let
  nixFlake = pkgs.writeShellScriptBin "nixFlake" ''
    exec ${pkgs.nix}/bin/nix  --experimental-features 'nix-command flakes' "$@"
  '';
in
{
  programs.home-manager.enable = true;
  home.packages = [ pkgs.nix nixFlake ];
  programs.zsh.shellAliases = {
    hmPull = "nixFlake flake lock --update-input home-flake";
    hmBuild = "nixFlake build .";
    hmSwitch = "hmBuild && ./result/activate && source ~/.zshrc";
    hmPullSwitch = "hmPull && hmSwitch";
    hmLocalBuild = "nixFlake build . --override-input home-flake ./home-flake";
    hmLocalSwitch = "hmLocalBuild && hmSwitchExistingResult";
  };
}
