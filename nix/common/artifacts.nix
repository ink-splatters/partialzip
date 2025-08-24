{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) craneLib commonArgs commonArgsNative;
  in{
    options = {
      cargoArtifacts = lib.mkOption {
        type = lib.types.package;
        default = craneLib.buildDepsOnly (commonArgs // {
            pname = "partialzip-deps";
        });
      };
      cargoArtifactsNative = lib.mkOption {
        type = lib.types.package;
        default = craneLib.buildDepsOnly (commonArgsNative // {
            pname = "partialzip-deps-native";
        });
      };
    };
  };
}