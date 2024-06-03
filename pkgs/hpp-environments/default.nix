{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  jrl-cmakemodules,
  example-robot-data,
  pythonSupport ? false,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-environments";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-environments";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gvYIICVS4DHzVeSrZZs3tszaIV7EBCOWLs9UJ7H9ZY4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs =
    [ jrl-cmakemodules ]
    ++ lib.optionals (!pythonSupport) [ example-robot-data ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.eigenpy
      python3Packages.boost
      python3Packages.pinocchio
      python3Packages.example-robot-data
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;

  pythonImportsCheck = lib.optionals (!pythonSupport) [ "hpp.environments" ];

  meta = {
    description = "Environments and robot descriptions for HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-environments";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
