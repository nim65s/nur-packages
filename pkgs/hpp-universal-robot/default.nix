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
  pname = "hpp-universal-robot";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-universal-robot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fmyOCDobWjFdPsSEK7yhjrDdLeucZ0S3j4V2B5a7GyI=";
  };

  outputs = [
    "dev"
    "out"
  ];

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

  pythonImportsCheck = lib.optionals (!pythonSupport) [ "hpp.corbaserver.ur5" ];

  meta = {
    description = "Data specific to robots ur5 and ur10 for hpp-corbaserver";
    homepage = "https://github.com/humanoid-path-planner/hpp-universal-robot";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
