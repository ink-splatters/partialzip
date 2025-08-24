{lib, ...}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    options.rust-toolchain = lib.mkOption {
      type = lib.types.attrs;
      default = inputs'.fenix.packages.minimal.toolchain;
    };
  };
}
