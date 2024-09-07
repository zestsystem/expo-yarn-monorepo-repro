{
  description = "Expo Yarn Workspace Monorepo";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      formatter = pkgs.alejandra;

      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Node
            nodejs_20
            yarn-berry
            nodePackages.eas-cli
          ];
        };
      };
    });
}
