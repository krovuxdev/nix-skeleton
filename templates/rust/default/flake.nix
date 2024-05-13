{
  description = "A Rust Proyect Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    inherit (nixpkgs) lib;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    eachSystems = f:
      lib.genAttrs systems
      (system: let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
                                  #Default Version: 'stable'
                                  #Values Version: 'stable', 'beta' ,'nightly'
        rust = pkgs.buildPackages.rust-bin.stable.latest.minimal; # values latest: 'minimal', 'default'
      in
        f {
          inherit pkgs;
          nativeBuildInputs = with pkgs; [
            rust
            #add you packages
          ];
          buildInputs = with pkgs; [
            # add Your packages and libraries
          ];
          packages = with pkgs; [
            # add you packages
          ];
        });
  in {
    devShells = eachSystems ({
      pkgs,
      nativeBuildInputs,
      buildInputs,
      packages,
      ...
    }: {
      default = pkgs.mkShell {
        inherit nativeBuildInputs buildInputs packages;
      };
    });
    formatter = eachSystems ({pkgs, ...}: pkgs.alejandra);
  };
}
