{
  description = "A PHP Proyect Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    phps.url = "github:fossar/nix-phps";
  };

  outputs = {
    self,
    nixpkgs,
    phps,
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
        pkgs = import nixpkgs {inherit system;};
        php = phps.packages.${system}.php74;
        composer = php.packages.composer;
      in
        f {
          inherit pkgs;
          nativeBuildInputs = with pkgs; [
            php
            #add you packages
          ];
          buildInputs = with pkgs; [
            # add Your packages and libraries
            pkg-config
            libmcrypt
          ];
          packages = with pkgs; [
            # add Your packages
            composer
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
