{
  imports = [
    ./rust-toolchain.nix
    ./crane-lib.nix
    ./args.nix
    ./artifacts.nix
  ];

  perSystem = {config, ...}: let
    inherit (config) craneLib commonArgs commonArgsNative cargoArtifacts cargoArtifactsNative;
  in {
    packages = {
      partialzip = craneLib.buildPackage (commonArgs
        // {
          inherit cargoArtifacts;
        });

      partialzip-native = craneLib.buildPackage (commonArgsNative
        // {
          inherit cargoArtifactsNative;
        });
    };
  };
}
