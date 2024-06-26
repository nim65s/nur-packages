{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "mim-solvers";
  version = "0.0.4.c0";

  src = fetchFromGitHub {
    owner = "cmake-wheel";
    repo = "mim_solvers";
    rev = "v${version}";
    hash = "sha256-3lGQbEIxGfccedd7MCZfoUOM7pbjH0zMgBAXZ1jOZ78=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Implementation of numerical solvers used in the Machines in Motion Laboratory";
    homepage = "https://github.com/cmake-wheel/mim_solvers";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s ];
    mainProgram = "mim-solvers";
    platforms = platforms.all;
  };
}
