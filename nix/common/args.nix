{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) craneLib src;
    inherit (pkgs.llvmPackages_latest) clang bintools stdenv;

    mkFlags = flags: lib.concatStringsSep " " (map (x: "-C ${x}") flags);

    flags = [
      "linker=${clang}/bin/cc"
      "link-args=-fuse-ld=lld"
      "embed-bitcode=yes"
      "lto=thin"
    ];

    mkCommonArgs = args @ {flags, ...}:
      {
        stdenv = p: p.stdenv;
        src = lib.cleanSourceWith {
          inherit src;
          filter = path: type:
          # Include testdata directory for tests
            (lib.hasInfix "/testdata" path)
            ||
            # Let crane's default filter handle Rust files
            craneLib.filterCargoSources path type;
        };
        strictDeps = true;
        enableParallelBuilding = true;
        RUSTFLAGS = "-Zdylib-lto " + (mkFlags flags);

        buildInputs = with pkgs; [
          bzip2
          curl
          zlib
          zstd
        ];

        nativeBuildInputs = with pkgs; [
          bintools
          curl
          pkg-config
        ];

        env = {
          ZSTD_SYS_USE_PKG_CONFIG = true;
        };

        __darwinAllowNetworking = true;
      }
      // (builtins.removeAttrs args ["flags"]);
  in {
    options = {
      commonArgs = lib.mkOption {
        type = lib.types.attrs;
        default = mkCommonArgs {inherit flags;};
      };

      commonArgsNative = lib.mkOption {
        type = lib.types.attrs;

        default = mkCommonArgs {
          flags = flags ++ ["target-cpu=native"];
          NIX_ENFORCE_NO_NATIVE = 0;
        };
      };
    };
  };
}
