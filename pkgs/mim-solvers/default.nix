{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  crocoddyl,
  jrl-cmakemodules,
  proxsuite,
  py-proxsuite,
  pythonSupport ? false,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "mim-solvers";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "cmake-wheel";
    repo = "mim_solvers";
    rev = "v0.0.4.c0";
    hash = "sha256-3lGQbEIxGfccedd7MCZfoUOM7pbjH0zMgBAXZ1jOZ78=";
  };

  prePatch = lib.optional (!pythonSupport) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_project_dependency(eigenpy 2.7.10 REQUIRED)" ""
  '';

  cmakeFlags = [
    "-DBUILD_WITH_PROXSUITE=ON"
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs =
    [ jrl-cmakemodules ]
    ++ lib.optionals (!pythonSupport) [
      crocoddyl
      proxsuite
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.crocoddyl
      py-proxsuite
    ];
  checkInputs = lib.optionals pythonSupport [
    python3Packages.example-robot-data
    python3Packages.numpy
    python3Packages.osqp
    python3Packages.scipy
  ];

  doCheck = true;
  pythonImportsCheck = [ "mim_solvers" ];

  meta = {
    description = "Implementation of numerical solvers used in the Machines in Motion Laboratory";
    homepage = "https://github.com/cmake-wheel/mim_solvers";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
