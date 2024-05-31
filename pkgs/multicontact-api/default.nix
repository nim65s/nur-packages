{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "multicontact-api";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "multicontact-api";
    rev = "v${version}";
    hash = "sha256-qZ9PyF6PNAl4d7QBogyUPHZ2/F8sEVxKH2jX5TxVnc0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "This package install a python module used to define, store and use ContactSequence objects";
    homepage = "https://github.com/loco-3d/multicontact-api";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nim65s ];
    mainProgram = "multicontact-api";
    platforms = platforms.all;
  };
}
