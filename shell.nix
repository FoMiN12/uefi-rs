# Sets up a basic shell environment with all relevant tooling to run
# "cargo xtask run|test|clippy". It uses rustup rather than a pinned rust
# toolchain.

let
  sources = import ./nix/sources.nix;
  pkgs = import ./nix/nixpkgs.nix;
  rustToolchain = pkgs.callPackage ./nix/rust-toolchain.nix {};
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # nix related stuff (such as dependency management)
    niv
    # TODO use "nixfmt" once it is stable - likely in nixpkgs @ NixOS 24.11
    nixfmt-rfc-style

    # Integration test dependencies
    swtpm
    qemu

    # Rust toolchain
    rustToolchain

    # Other
    mdbook
    yamlfmt
    which # used by "cargo xtask fmt"
  ];

  # Set ENV vars.
  # OVMF_CODE="${pkgs.OVMF.firmware}";
  # OVMF_VARS="${pkgs.OVMF.variables}";
  # OVMF_SHELL="${pkgs.edk2-uefi-shell}";

  # To invoke "nix-shell" in the CI-runner, we need a global Nix channel.
  # For better reproducibility inside the Nix shell, we override this channel
  # with the pinned nixpkgs version.
  NIX_PATH = "nixpkgs=${sources.nixpkgs}";
}
