{
  description = "Volcandle dev env";

  nixConfig.extra-substituters = [
    "https://tweag-jupyter.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];

  inputs = {
    cq-flake.url = "github:vinszent/cq-flake";
    utils.url = "github:numtide/flake-utils";
    # jupyenv.url = "github:tweag/jupyenv";
  };

  outputs = { self, cq-flake, utils }: (utils.lib.eachSystem ["x86_64-linux" ] (system: let
    pkgs = cq-flake.inputs.nixpkgs.legacyPackages.${system};
    python = cq-flake.packages.${system}.python;
    # inherit (jupyenv.lib.${system}) mkJupyterlabNew;
    
  in rec {
    packages = rec {
      # pythreejs = pkgs.callPackage ./pythreejs.nix {
      #   inherit (python.pkgs)
      #     buildPythonPackage
      #     setuptools
      #     jupyterlab;
      # };
      inherit (cq-flake.packages.${system}) cadquery;

      jupyterlab = python.pkgs.callPackage ./packages/jupyterlab.nix {};
      cad-viewer-widget = python.pkgs.callPackage ./packages/cad-viewer-widget.nix {
        inherit jupyterlab;
      };

      jupyter-cadquery = python.pkgs.callPackage ./packages/jupyter-cadquery.nix {
        inherit jupyterlab cad-viewer-widget;
      };

      pythonEnv = python.withPackages(ps: [
        cq-flake.packages.${system}.cadquery
        jupyter-cadquery
        jupyterlab
      ] ++ (with ps; [
        numpy
        pandas
        pillow
        rasterio

        numpy # these two are
        scipy # probably redundant to pandas
        matplotlib

        papermill
        black
      ]));

      # jupyterlab = mkJupyterlabNew ({...}: {
      #   nixpkgs = cq-flake.inputs.nixpkgs;
      #   imports = [(import ./kernels.nix { inherit pythonEnv; })];
      # });
    };

    apps.default.program = "${packages.pythonEnv}/bin/jupyter-lab";
    apps.default.type = "app";

    defaultPackage = packages.pythonEnv; # If you want to juist build the environment
    #devShell = packages.pythonEnv.env; # We need .env in order to use `nix develop`
    devShell = pkgs.mkShell {
      buildInputs = [
        packages.pythonEnv
        # pkgs.openscad
      ];
      shellHook = ''

        export JUPYTERLAB_DIR="$(pwd)/.jupyter"
        # jupyter labextension install jupyter-leaflet --app-dir=$JUPYTERLAB_DIR
        echo "Welcome to the Volcandle development environment!"
        # Add more shell commands here if needed
      '';
    };
  }));
}
