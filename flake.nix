{
  description = "Volcandle dev env";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: (utils.lib.eachSystem ["x86_64-linux" ] (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in rec {
    packages = {
      pythonEnv = pkgs.python3.withPackages(ps: with ps; [
        numpy
        pandas
        pillow
        rasterio

        numpy # these two are
        scipy # probably redundant to pandas
        jupyterlab
        matplotlib

        papermill
        black
      ]);
    };

    defaultPackage = packages.pythonEnv; # If you want to juist build the environment
    #devShell = packages.pythonEnv.env; # We need .env in order to use `nix develop`
    devShell = pkgs.mkShell {
      buildInputs = [
        packages.pythonEnv
        pkgs.openscad
      ];
      shellHook = ''
        # export JUPYTERLAB_DIR="$(pwd)/jupyterlab"
        # jupyter labextension install jupyter-leaflet --app-dir=$JUPYTERLAB_DIR
        echo "Welcome to the Volcandle development environment!"
        # Add more shell commands here if needed
      '';
    };
  }));
}
