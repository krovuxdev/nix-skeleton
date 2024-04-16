{
  description = "A Python Proyect Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
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
        pypi = pkgs.python3.withPackages (pypi:
          with pypi; [
            #add your python libraries here
          ]);
      in
        f {
          inherit pkgs;
          nativeBuildInputs = with pkgs; [
            python3
            #add you packages
          ];
          buildInputs = [
            # add Your packages and libraries
          ];
          packages = [
            pypi
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
