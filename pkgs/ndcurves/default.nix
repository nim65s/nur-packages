{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  eigen,
  pinocchio,
  pythonSupport ? false,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ndcurves";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-I0vYzL8FFlAAP158eAEO+13HOGGUWntX8JY1VSXI8Sc=";
  };

  outputs = [
    "dev"
    "out"
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs =
    lib.optionals (!pythonSupport) [ pinocchio ]
    ++ lib.optionals pythonSupport [ python3Packages.pinocchio ];

  cmakeFlags = lib.optionals pythonSupport [ "-DBUILD_PYTHON_INTERFACE=ON" ];

  doCheck = true;

  pythonImportsCheck = lib.optionals (!pythonSupport) [ "ndcurves" ];

  meta = with lib; {
    description = "Library for creating smooth cubic splines";
    homepage = "https://github.com/loco-3d/ndcurves";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nim65s ];
  };
})
