{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  qmake,
  qtwebengine,
  qtxmlpatterns,
  qttools,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "python-qt";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "MeVisLab";
    repo = "pythonqt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Yz7w5Gs0W3ilrZXjkC+wXLCCXWTKkhCpWXbg+PshXKI=";
  };

  patches = [
    (fetchpatch {
      name = "fix-format-security.patch";
      url = "https://github.com/MeVisLab/pythonqt/pull/197/commits/c35d1efd00b83e0ebd826d7ed8454f3684ddffff.patch";
      hash = "sha256-WJBLPdMemuKlZWoqYVU9TXldoDpaBm84RxkepIaocUQ=";
    })
  ];

  nativeBuildInputs = [
    qmake
    qtwebengine
    qtxmlpatterns
    qttools
    unzip
  ];

  buildInputs = [ python3 ];

  qmakeFlags = [
    "PYTHON_DIR=${python3}"
    "PYTHON_VERSION=3.${python3.sourceVersion.minor}"
  ];

  dontWrapQtApps = true;

  unpackCmd = "unzip $src";

  installPhase = ''
    mkdir -p $out/include/PythonQt
    cp -r ./lib $out
    cp -r ./src/* $out/include/PythonQt
    cp -r ./build $out/include/PythonQt
    cp -r ./extensions $out/include/PythonQt
  '';

  meta = with lib; {
    description = "PythonQt is a dynamic Python binding for the Qt framework. It offers an easy way to embed the Python scripting language into your C++ Qt applications";
    homepage = "https://pythonqt.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ hlolli ];
  };
})
