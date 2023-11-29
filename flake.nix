{
  description = ''
    Extest is a drop in replacement for the X11 XTEST extension. It creates a virtual device with the uinput kernel module.
    It's been primarily developed for allowing the desktop functionality on the Steam Controller to work while Steam is open on Wayland.
  '';

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.extest = {
    url = "github:Supreeeme/extest";
    flake = false;
  };

  outputs = { self, flake-utils, nixpkgs, extest }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        crossSystem = nixpkgs.lib.systems.examples.gnu32;
      };
    in with pkgs; rec {
      packages.${system}.default = rustPlatform.buildRustPackage {
        pname = "extest";
        src = extest;
        version = toString self.lastModifiedDate;
        cargoLock.lockFile = "${extest}/Cargo.lock";

        meta = {
          homepage = "https://github.com/Supreeeme/extest";
          license = lib.licenses.mit;
          platforms = lib.platforms.linux;
        };
      };
      overlays.default = _: _: {
        extest = packages.${system}.default;
      };
    };
}
