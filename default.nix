# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  gruppled-black-cursors = pkgs.callPackage ./pkgs/gruppled-cursors {
    theme = "gruppled_black";
  };
  gruppled-black-lite-cursors = pkgs.callPackage ./pkgs/gruppled-lite-cursors {
    theme = "gruppled_black_lite";
  };
  gruppled-white-cursors = pkgs.callPackage ./pkgs/gruppled-cursors {
    theme = "gruppled_white";
  };
  gruppled-white-lite-cursors = pkgs.callPackage ./pkgs/gruppled-lite-cursors {
    theme = "gruppled_white_lite";
  };
  osgqt = pkgs.libsForQt5.callPackage ./pkgs/osgqt { };
  omniorb = pkgs.omniorb.overrideAttrs (finalAttrs: previousAttrs: {
    postInstall = "rm $out/${pkgs.python3.sitePackages}/omniidl_be/__init__.py";
  });
  omniorbpy = pkgs.python3Packages.toPythonModule (pkgs.callPackage ./pkgs/omniorbpy {
    inherit (pkgs) python3Packages;
  });
  qpoases = pkgs.callPackage ./pkgs/qpoases { };
}
