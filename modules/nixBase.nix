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
    hmLocalBuild = "nixFlake build . --override-input home-flake ./home-flake";
    hmSwitch = "hmLocalBuild && ./result/activate && source ~/.zshrc";
  };
}
