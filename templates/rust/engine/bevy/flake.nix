{
  description = "A Rust Proyect Template for bevyengine";

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
        rust = pkgs.buildPackages.rust-bin.stable.latest.minimal;
        xorgs = with pkgs.xorg; [
          libX11
          libxcb
          libXi
          libXrandr
          libXcursor
          libxkbfile
        ];
      in
        f {
          inherit pkgs;
          nativeBuildInputs = with pkgs; [
            rust
            pkg-config
            #add you packages
          ];
          buildInputs = with pkgs; [
            vulkan-loader
            libxkbcommon
            alsa-lib
            wayland
            udev
            # add Your packages and libraries
          ] ++ xorgs;
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
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
      };
    });
    formatter = eachSystems ({pkgs, ...}: pkgs.alejandra);
  };
}
