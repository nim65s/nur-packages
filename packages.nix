# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs ? import <nixpkgs> { },
}:
let
  sway-lone-titlebar-unwrapped =
    (pkgs.sway-unwrapped.overrideAttrs (
      _: _: {
        src = pkgs.fetchFromGitHub {
          owner = "svalaskevicius";
          repo = "sway";
          rev = "hiding-lone-titlebar-scenegraph";
          hash = "sha256-cXBEXWUj3n9txzpzDgl6lsNot1ag1sEE07WAwfCLWHc=";
        };
      }
    )).override
      {
        wlroots = pkgs.wlroots.overrideAttrs {
          version = "0.18.0-dev";
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "wlroots";
            repo = "wlroots";
            rev = "873e8e455892fbd6e85a8accd7e689e8e1a9c776";
            hash = "sha256-5zX0ILonBFwAmx7NZYX9TgixDLt3wBVfgx6M24zcxMY=";
          };
          patches = [ ];
        };
      };
  omniorb = pkgs.python3Packages.callPackage ./pkgs/omniorb { };
  omniorbpy = pkgs.python3Packages.callPackage ./pkgs/omniorbpy { };
  osgqt = pkgs.callPackage ./pkgs/osgqt { };
  qgv = pkgs.libsForQt5.callPackage ./pkgs/qgv { };
  collada-dom = pkgs.callPackage ./pkgs/collada-dom { };
  osg-dae = pkgs.openscenegraph.override {
    colladaSupport = true;
    opencollada = collada-dom;
  };
  osgqt-dae = osgqt.override { openscenegraph = osg-dae; };
  gepetto-viewer = pkgs.callPackage ./pkgs/gepetto-viewer { };
  ndcurves = pkgs.callPackage ./pkgs/ndcurves { };
  py-ndcurves = pkgs.python3Packages.toPythonModule (
    pkgs.callPackage ./pkgs/ndcurves { pythonSupport = true; }
  );
  #multicontact-api = pkgs.callPackage ./pkgs/multicontact-api { };
  #py-multicontact-api = pkgs.python3Packages.toPythonModule (
  #pkgs.callPackage ./pkgs/multicontact-api {
  #pythonSupport = true;
  #}
  #);

  hpp-centroidal-dynamics = pkgs.callPackage ./pkgs/hpp-centroidal-dynamics { };
  py-hpp-centroidal-dynamics = pkgs.python3Packages.toPythonModule (
    pkgs.callPackage ./pkgs/hpp-centroidal-dynamics { pythonSupport = true; }
  );
  hpp-bezier-com-traj = pkgs.callPackage ./pkgs/hpp-bezier-com-traj { };
  py-hpp-bezier-com-traj = pkgs.python3Packages.toPythonModule (
    pkgs.callPackage ./pkgs/hpp-bezier-com-traj { pythonSupport = true; }
  );
  hpp-environments = pkgs.callPackage ./pkgs/hpp-environments { };
  hpp-universal-robot = pkgs.callPackage ./pkgs/hpp-universal-robot { };
  hpp-util = pkgs.callPackage ./pkgs/hpp-util { };
  hpp-statistics = pkgs.callPackage ./pkgs/hpp-statistics { };
  hpp-template-corba = pkgs.callPackage ./pkgs/hpp-template-corba { };
  hpp-pinocchio = pkgs.callPackage ./pkgs/hpp-pinocchio { };
  hpp-constraints = pkgs.callPackage ./pkgs/hpp-constraints { };
  hpp-baxter = pkgs.callPackage ./pkgs/hpp-baxter { };
  hpp-core = pkgs.callPackage ./pkgs/hpp-core { };
  hpp-manipulation = pkgs.callPackage ./pkgs/hpp-manipulation { };
in
{
  inherit
    collada-dom
    gepetto-viewer
    omniorb
    omniorbpy
    ndcurves
    osg-dae
    osgqt-dae
    hpp-centroidal-dynamics
    hpp-bezier-com-traj
    hpp-util
    hpp-environments
    hpp-statistics
    hpp-template-corba
    hpp-pinocchio
    hpp-constraints
    hpp-baxter
    hpp-core
    hpp-manipulation
    hpp-universal-robot
    #multicontact-api
    #py-multicontact-api
    py-ndcurves
    py-hpp-centroidal-dynamics
    py-hpp-bezier-com-traj
    qgv
    ;

  sauce-code-pro = pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; };
  sway-lone-titlebar = pkgs.sway.override { sway-unwrapped = sway-lone-titlebar-unwrapped; };

  gepetto-viewer-full = gepetto-viewer.withPlugins (ps: with ps; [ corba ]);
}
