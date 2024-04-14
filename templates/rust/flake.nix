{
  description = "A Rust Proyect Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    eachSystems = lib.genAttrs systems;
    forSystem = eachSystems (
      system: import nixpkgs {inherit system;}
    );
    overlays = [(import rust-overlay)];
    pkgs = import nixpkgs {
      inherit system overlays;
    };
    rust = pkgs.buildPackages.rust-bin.stable.latest.minimal;
    nativeBuildInputs = with pkgs; [
      rust
      #add you packages
    ];
    buildInputs = with pkgs; [];
    packages = with pkgs; [];
  in {
    devShells = {
      ${system}.default = pkgs.mkShell {
        inherit nativeBuildInputs buildInputs packages;
      };
    };
    formatter = eachSystems (systems: forSystem.${systems}.alejandra);
  };
}
