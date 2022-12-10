{ inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        config = { };

        overlay = pkgsNew: pkgsOld: {
          advent-of-code-2022 =
            pkgsNew.haskell.lib.justStaticExecutables
              pkgsNew.haskellPackages.advent-of-code-2022;

          haskellPackages = pkgsOld.haskellPackages.override (old: {
            overrides = pkgsNew.haskell.lib.packageSourceOverrides {
              advent-of-code-2022 = ./.;
            };
          });
        };

        pkgs =
          import nixpkgs { inherit config system; overlays = [ overlay ]; };

      in
        rec {
          packages.default = pkgs.haskellPackages.advent-of-code-2022;

          apps.default = {
            type = "app";

            program = "${pkgs.advent-of-code-2022}/bin/advent-of-code-2022";
          };

          devShells.default = pkgs.haskellPackages.advent-of-code-2022.env;
        }
    );
}