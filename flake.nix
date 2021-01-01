{
  description = ''
    Pure and reproducible overlay for binary distributed rust toolchains.
    A better replacement for github:mozilla/nixpkgs-mozilla
  '';

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: let
    inherit (nixpkgs) lib;
    overlay = import ./default.nix;

    allSystems = [
      "aarch64-linux"
      "armv6l-linux"
      "armv7a-linux"
      "armv7l-linux"
      "x86_64-linux"
      "x86_64-darwin"
      # "aarch64-darwin"
    ];

  in {
    overlay = final: prev: overlay final prev;

  } // flake-utils.lib.eachSystem allSystems (system: let
    pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
  in rec {
    defaultApp = {
      type = "app";
      program = "${defaultPackage}/bin/rustc";
    };
    defaultPackage = packages.rust-stable;
    packages = {
      rust-stable = pkgs.latest.rustChannels.stable.rust;
    };
  });
}
