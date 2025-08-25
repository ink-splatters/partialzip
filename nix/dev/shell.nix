{
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) pre-commit craneLib;
  in {
    devShells.default = craneLib.devShell {
      inherit (config) checks;

      packages = with pkgs;
        [
          bacon
          cargo-expand
          cargo-watch
          fd
          ripgrep
        ]
        ++ pre-commit.settings.enabledPackages;

      shellHook = ''
        ${pre-commit.installationScript}
        echo "🦀 Welcome to partialzip development shell!"
        echo "Available commands:"
        echo "  cargo build    - Build the project"
        echo "  cargo test     - Run tests"
        echo "  cargo clippy   - Run clippy lints"
        echo "  cargo fmt      - Format code"
        echo "  nix flake check - Run all checks"
      '';

      RUST_SRC_PATH = "${config.rust-toolchain}/lib/rustlib/src/rust/library";
    };
  };
}
