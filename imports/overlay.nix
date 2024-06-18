{ inputs, ... }:

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
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.self.overlays.default
          (import ../overlays/pinocchio.nix)
        ];
        config = { };
      };

      overlayAttrs = config.packages;
    };
}
