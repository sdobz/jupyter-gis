{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, jupyterlab
, hatchling
, hatch-jupyter-builder
, hatch-nodejs-version
}:
buildPythonPackage rec {
    pname = "jupyter_leaflet";
    version = "0.19.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-sJtbpIsUiMth2jem9Vg0cmnrU/9tZNwac+AF/8RCAGM=";
    };

    pyproject = true;
    env.HATCH_BUILD_NO_HOOKS = true;

    build-system = [
      hatchling
      hatch-jupyter-builder
      hatch-nodejs-version
      jupyterlab
    ];

    propagatedBuildInputs = [ 

    ];

    doCheck = false;

    meta = with lib; {
        description = "A Jupyter - Leaflet.js bridge ";
        homepage = "https://github.com/jupyter-widgets/ipyleaflet";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}
