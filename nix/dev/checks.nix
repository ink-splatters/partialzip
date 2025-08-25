{
  perSystem = {config, ...}: let
    inherit (config) craneLib commonArgs src cargoArtifacts;
  in {
    checks = {
      inherit (config.packages) partialzip;

      partialzip-clippy = craneLib.cargoClippy (
        commonArgs
        // {
          inherit cargoArtifacts;
          cargoClippyExtraArgs = "--all-targets -- --deny warnings";
        }
      );

      partialzip-doc = craneLib.cargoDoc (
        commonArgs
        // {
          inherit cargoArtifacts;
        }
      );

      partialzip-fmt = craneLib.cargoFmt {
        inherit src;
      };

      partialzip-nextest = craneLib.cargoNextest (
        commonArgs
        // {
          inherit cargoArtifacts;
          partitions = 1;
          partitionType = "count";
        }
      );
    };
  };
}
