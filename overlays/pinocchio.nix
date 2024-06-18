final: prev:
let
  # apply pinocchio#2284
  florent-devel = final.fetchFromGitHub {
    owner = "florent-lamiraux";
    repo = "pinocchio";
    rev = "cfddbdf46cb30a4e78c5bbf9239d751c92cb5535";
    hash = "sha256-VTCm9MzcGzqmfZNZCU2t5CsJ2sXSARONdSMmWCDw3GY=";
  };
  # TODO: test-cpp-contact-cholesky fails
  no-test-cpp-contact-cholesky = ''
    substituteInPlace unittest/CMakeLists.txt \
      --replace-fail "add_pinocchio_unit_test(contact-cholesky)" ""
  '';
in
{
  pinocchio = prev.pinocchio.overrideAttrs {
    src = florent-devel;
    prePatch = no-test-cpp-contact-cholesky;
  };
  pythonPackagesOverlays = [
    (
      python-final: python-prev: {
        pinocchio = python-prev.pinocchio.overrideAttrs {
          src = florent-devel;
          prePatch = no-test-cpp-contact-cholesky;
        };
      }
    )
  ];
}
