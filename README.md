# Home-Manager Configuration

## Minimal "Bootstrap" Installation

The following initialises a git repository from a flake template.
The nix run will evaluate the configuration and activate it immediately.
This is only thin, but opinionated convenience wrapper over home-manager.

```
cd ~/path/to/my-home-flake
nix flake init -t github:ciderale/home-flake
# edit 'yourUsername' to match the users
nix run .#yourUsername
git init
git add -a
git commit -m "initial home-manager config"
```

## Design Decision

This flake is an experiment to keep parts of the home-manager
configuration in a private repository while sharing other parts.

* configuration is split into 1+n repositories
	* one public repository with shareable modules
	* n private repository with data one may not want to share
		* contains the actual home-manager configurations
		* e.g. one repo for work and one repo for home
* the private repositories follows the pub
* Various aliases 'hm*=' to simplify working with this setting
	* hmCd: jump to the non-sharable repository
	* hmBuild: build the default configuration
	* hmSwitch: build and activate the default configuration
	* hmPull: update local flake to most recent sharable flake version
	* hmPullBuild/Switch: like hmPull, but also build/activate
* nixpkgs typically follows the public repos version
	* inputs.nixpkgs.follows = "home-flake/nixpkgs";
	* simplifies keeping all other repositories in-sync
* hmLocalBuild/hmLocalSwitch aliases
	* build/activate using the locally checked-out/modified public repo
	* TODO: adjust nixpkgs.follows to use the locally locked version
		* currently, it still uses the non-overridden nixpkgs (from upstream)
		* e.g. nix build . --override-input home-flake ./home-flake  --override-input nixpkgs "nixpkgs/e14f9fb57315f0d4abde222364f19f88c77d2b79"

## Directory Structure

* template: example usage of this flake
* modules: adding custom option to the configuration
	* these modules should not enable any configuration
	* they provide certain convenience configurations
	* they are sharable
* config: modules that effectively apply configurations
	* configs are like not sharable for other users
	* configs may contain user specific settings
* overlay: custom modifications of derivations
* apps: manually packaged (typically MacOS gui) apps
