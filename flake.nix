{
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09-small;
    mach-nix = {
      url = github:DavHau/mach-nix/master;
      inputs = {
        nixpkgs.follows     = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    tinybeachthor = {
      url = github:tinybeachthor/nur-packages/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, flake-utils, nixpkgs, mach-nix, tinybeachthor }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs {
          inherit system;
          overlays = [
            tinybeachthor.overlay
            (final: pred: {
              lib = pred.lib // mach-nix.lib.${system};
            })
          ];
        });
      in { devShell = import ./shell.nix { inherit pkgs; }; });
}
