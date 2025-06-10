{
  description = "Volcandle dev env";

  inputs = {
    cq-flake.url = "github:vinszent/cq-flake";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, cq-flake, utils }: (utils.lib.eachSystem ["x86_64-linux" ] (system: let
    pkgs = cq-flake.inputs.nixpkgs.legacyPackages.${system};
    python = cq-flake.packages.${system}.python;

    unfreePkgs = import cq-flake.inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    
  in rec {
    packages = rec {
      inherit (cq-flake.packages.${system}) cadquery;

      orjson = python.pkgs.orjson.overridePythonAttrs (old: rec {
        version = "3.10.16";
        src = pkgs.fetchFromGitHub {
          owner = "ijl";
          repo = "orjson";
          rev = version;
          sha256 = "sha256-hgyW3bff70yByxPFqw8pwPMPMAh9FxL1U+LQoJI6INo=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          name = "${old.pname}-${version}";
          hash = "sha256-mOHOIKmcXjPwZ8uPth+yvreHG4IpiS6SFhWY+IZS69E=";
        };
      });

      jupyterlab = python.pkgs.callPackage ./packages/jupyterlab.nix {};
      cad-viewer-widget = python.pkgs.callPackage ./packages/cad-viewer-widget.nix {
        inherit jupyterlab;
      };
      ocp-tessellate = python.pkgs.callPackage ./packages/ocp-tessellate.nix {};
      ocp-vscode = python.pkgs.callPackage ./packages/ocp-vscode.nix {
        inherit ocp-tessellate orjson;
      };

      jupyter-cadquery = python.pkgs.callPackage ./packages/jupyter-cadquery.nix {
        inherit jupyterlab cad-viewer-widget ocp-vscode orjson;
      };

      earthengine-api = python.pkgs.callPackage ./packages/earthengine-api.nix {};
      eerepr = python.pkgs.callPackage ./packages/eerepr.nix {
        inherit earthengine-api;
      };
      ipyevents = python.pkgs.callPackage ./packages/ipyevents.nix {};
      ipyfilechooser = python.pkgs.callPackage ./packages/ipyfilechooser.nix {};
      jupyter-leaflet = python.pkgs.callPackage ./packages/jupyter-leaflet.nix {
        inherit jupyterlab;
      };
      ipyleaflet = python.pkgs.callPackage ./packages/ipyleaflet.nix {
        inherit jupyter-leaflet;
      };
      ipytree = python.pkgs.callPackage ./packages/ipytree.nix {};
      geemap = python.pkgs.callPackage ./packages/geemap.nix {
        inherit earthengine-api eerepr ipyevents ipyfilechooser ipyleaflet ipytree;
      };

      deepcomparer = python.pkgs.callPackage ./packages/deepcomparer.nix {};
      k3d-jupyter = python.pkgs.callPackage ./packages/k3d-jupyter.nix {
        inherit jupyterlab deepcomparer;
      };

      touchterrain = python.pkgs.callPackage ./packages/touchterrain.nix {
        inherit earthengine-api k3d-jupyter;
      };

      pymesh = python.pkgs.callPackage ./packages/pymesh.nix { # holy heck what a time killer. Does not work!
        mkl = unfreePkgs.mkl;
      };

      fast-simplification = python.pkgs.callPackage ./packages/fast-simplification.nix {};

      pyhershey = python.pkgs.callPackage ./packages/pyhershey.nix {};

      pythonEnv = python.withPackages(ps: [
        cq-flake.packages.${system}.cadquery
        cq-flake.packages.${system}.build123d
        jupyter-cadquery
        jupyterlab
        earthengine-api
        jupyter-leaflet
        geemap
        k3d-jupyter
        touchterrain
        pymesh
        fast-simplification
        pyhershey
      ] ++ (with ps; [
        numpy
        pandas
        pillow

        trimesh
        networkx
        lxml

        shapely
        scikit-image

        rasterio

        scipy
        matplotlib

        # font processing
        fonttools
        cu2qu

        papermill
        black

        geojson
      ]));
    };

    apps.default.program = "${packages.pythonEnv}/bin/jupyter-lab";
    apps.default.type = "app";

    defaultPackage = packages.pythonEnv; # If you want to juist build the environment
    #devShell = packages.pythonEnv.env; # We need .env in order to use `nix develop`
    devShell = pkgs.mkShell {
      buildInputs = [
        packages.pythonEnv
        pkgs.cntr
      ];
      shellHook = ''
        echo "Welcome to the Volcandle development environment!"
      '';
    };
  }));
}
