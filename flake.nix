{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
  };

  outputs = inputs: let
    lib = import "${inputs.nixpkgs}/lib";
    forAllSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
    packages = forAllSystems (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        package = {
          fetchFromGitHub,
          buildGoModule,
          lib,
        }:
          buildGoModule {
            pname = "cuetsy";
            version = "0.1.11";

            src = fetchFromGitHub {
              owner = "grafana";
              repo = "cuetsy";
              rev = "v0.1.11";
              hash = "sha256-dirzVR4j5K1+EHbeRi4rHwRxkyveySoM7qJzvOlGp+0=";
            };

            vendorHash = "sha256-CDa7ZfbVQOIt24VZTy4j0Dn24nolmYa0h9zgrJ3QTeY=";

            meta = {
              description = "Experimental CUE->TypeScript exporter";
              homepage = "https://github.com/grafana/cuetsy";
              license = lib.licenses.asl20;
              maintainers = with lib.maintainers; [bryanhonof];
              mainProgram = "cuetsy";
            };
          };
      in {
        default = inputs.self.packages.${system}.cuetsy;
        cuetsy = pkgs.callPackage package {};
      }
    );
  };
}
