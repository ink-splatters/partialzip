{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
    ./checks.nix
    ./pre-commit.nix
    ./shell.nix
  ];

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    formatter = pkgs.writeShellScriptBin "fmt-all" ''
      echo "🔧 Formatting Nix files..."
      ${pkgs.alejandra}/bin/alejandra . "$@"

      echo "🦀 Formatting Rust files..."
      ${config.rust-toolchain}/bin/cargo fmt --all

      echo "📦 Formatting TOML files..."
      ${pkgs.taplo}/bin/taplo fmt

      echo "✅ All files formatted!"
    '';
  };
}
