{
  description = "Volcandle dev env";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: (utils.lib.eachSystem ["x86_64-linux" ] (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    # my_jupyter_leaflet = pkgs.callPackage ./jupyter_leaflet {};
    my_ipyleaflet = pkgs.python3Packages.buildPythonPackage rec {
      pname = "ipyleaflet";
      version = "0.19.1";
      # format = "pyproject";
      src = pkgs.python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-NFTbwNNgFQUW6io6tBCVA865tzR/oXRqbK/YiQdaD/g=";
      };
      doCheck = false;

      nativeBuildInputs = with pkgs.python3Packages; [
        setuptools
        wheel
      ];

      build-system = with pkgs.python3Packages; [
        hatchling
      ];

      propagatedBuildInputs = with pkgs.python3Packages; [
        # comm
        # ipython
        # jupyterlab-widgets
        # traitlets
        # widgetsnbextension
        traittypes
        xyzservices
        branca
        ipywidgets
        # my_jupyter_leaflet
      ];

      nativeCheckInputs = with pkgs.python3Packages; [
        # ipykernel
        # jsonschema
        # pytest7CheckHook
        # pytz
      ];

    };

    
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

        my_ipyleaflet
        # my_jupyter_leaflet
        ipywidgets

        papermill
      ]);
    };

    defaultPackage = packages.pythonEnv; # If you want to juist build the environment
    #devShell = packages.pythonEnv.env; # We need .env in order to use `nix develop`
    devShell = pkgs.mkShell {
      buildInputs = [
        packages.pythonEnv
        pkgs.nodejs
        pkgs.yarn-berry
        pkgs.cntr
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
