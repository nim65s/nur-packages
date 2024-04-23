{ inputs, lib, ... }:
{

  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      packages = import ../packages.nix { inherit pkgs; };
    };
}
