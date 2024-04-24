{
  stdenv,
  fetchFromGitHub,
  lib,
  boost,
  cmake,
  doxygen,
  jrl-cmakemodules,
  osg-dae,
  osgqt-dae,
  pkg-config,
  python3Packages,
  qgv,
  qtbase,
  wrapQtAppsHook,
  python-qt,
  callPackage,
  writeScript,
  gepetto-viewer,
}:
let
  version = "5.0.0";
  meta = {
    homepage = "https://github.com/gepetto/gepetto-viewer";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.nim65s ];
    mainProgram = "gepetto-gui";
  };
  python = python3Packages.python.withPackages (ps: [ ps.boost ]);
in
stdenv.mkDerivation {
  pname = "gepetto-viewer";
  inherit meta version;

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "gepetto-viewer";
    rev = "v${version}";
    hash = "sha256-e+MYEJA98U+ZUv2Aza/S7CGbQSJht7xFtmx229HmlOs=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    boost
    python-qt
    qtbase
    osgqt-dae
    python
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    wrapQtAppsHook
    pkg-config
  ];

  propagatedBuildInputs = [
    jrl-cmakemodules
    osg-dae
    osgqt-dae
    qgv
  ];

  doCheck = true;

  # display a black screen on wayland, so force XWayland for now.
  # Might be fixed when upstream will be ready for Qt6.
  qtWrapperArgs = [ "--set QT_QPA_PLATFORM xcb" ];
}
// {

  plugins = {
    corba = callPackage ./corba.nix { };
  };
  withPlugins =
    p:
    let
      selectedPlugins = p gepetto-viewer.plugins;
      wrapper = writeScript "gepetto-gui" ''
        export GEPETTO_GUI_PLUGIN_DIRS=""
        for plugin in ${builtins.concatStringsSep " " selectedPlugins}; do
          export GEPETTO_GUI_PLUGIN_DIRS=$plugin/lib:$GEPETTO_GUI_PLUGIN_DIRS
        done
        ${lib.getExe gepetto-viewer}
      '';
    in
    stdenv.mkDerivation {
      pname = "gepetto-viewer-with-plugins";
      inherit meta version;
      propagatedBuildInputs = selectedPlugins;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        cp ${wrapper} $out/bin/gepetto-gui
      '';
    };
}
