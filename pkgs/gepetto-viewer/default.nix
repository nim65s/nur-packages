{
  stdenv,
  writeScript,
  lib,
  gepetto-viewer-base,
  gepetto-viewer-corba,
}:
let
  wrapper = writeScript "gepetto-gui" ''
    export GEPETTO_GUI_PLUGIN_DIRS=${gepetto-viewer-corba}/lib
    ${lib.getExe gepetto-viewer-base}
  '';
in
stdenv.mkDerivation {
  inherit (gepetto-viewer-base) pname version meta;
  #propagatedBuildInputs = [ corba ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp ${wrapper} $out/bin/gepetto-gui
  '';
}
