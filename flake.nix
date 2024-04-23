{
  description = "My personal NUR repository. Mostly nixpkgs stagging area.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        ./imports/overlay.nix
        ./imports/formatter.nix
        #./imports/pkgs-by-name.nix
        #./imports/pkgs-all.nix
        ./imports/pkgs.nix
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          # don't put that in imports, or nix-direnv won't autoupdate
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              gepetto-viewer
              (python3.withPackages (
                ps: with ps; [
                  example-robot-data
                  gepetto-viewer
                  gepetto-viewer-corba
                ]
              ))
            ];
          };
        };
    };
}
