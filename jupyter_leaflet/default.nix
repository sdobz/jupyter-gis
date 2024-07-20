{pkgs}: let
  node = pkgs.callPackage ./node {};
in pkgs.python3Packages.buildPythonPackage rec {
      pname = "jupyter_leaflet";
      version = "0.19.1";
      format = "pyproject";
      src = pkgs.python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-9MGreosskdAaCUDRurZUPFfpHcpkJXiWMngO731YsmY=";
      };
      doCheck = false;

      # node packaging
      # https://github.com/NixOS/nixpkgs/blob/ca161d869d55f70b3a26220f55fb4581b5d9d49d/pkgs/development/python-modules/panel/default.nix
      # project uses new ayrn
      # add yarn-berry dep
      # yarn plugin import https://raw.githubusercontent.com/stephank/yarn-plugin-nixify/main/dist/yarn-plugin-nixify.js
      # yarn

      preBuild = ''
          ln -s ${node.nodeDependencies}/lib/node_modules
      '';
          # export PATH="${node.nodeDependencies}/bin:$PATH"

      # dependencies = with pkgs.python3Packages; [
      # ];

      build-system = with pkgs.python3Packages; [
        hatchling
      ];

      nativeBuildInputs = with pkgs.python3Packages; [
        # setuptools
        # wheel
        # jupyter-packaging
        pkgs.nodejs
        jupyterlab
        hatch-nodejs-version
        hatch-jupyter-builder
        pkgs.breakpointHook
      ];

      propagatedBuildInputs = with pkgs.python3Packages; [
        # comm
        # ipython
        # jupyterlab-widgets
        # traitlets
        # widgetsnbextension
        # xyzservices
        # branca
        # ipywidgets
      ];

      nativeCheckInputs = with pkgs.python3Packages; [
        # ipykernel
        # jsonschema
        # pytest7CheckHook
        # pytz
      ];
    }