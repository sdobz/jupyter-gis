{ lib
, yarn
, buildPythonPackage
, fetchFromGitHub
, setuptools
, hatchling
, hatch-jupyter-builder
, hatch-nodejs-version

, jupyterlab
}:
buildPythonPackage rec {
    pname = "cad-viewer-widget";
    version = "3.0.2";

    src = fetchFromGitHub {
        owner = "bernhard-42";
        repo = "cad-viewer-widget";
        rev = "v${version}";
        hash = "sha256-dTBfn+qQSvHz4NgYHddjNGtIXGXL6Kt2Ad5cAJBc+nE=";
    };

    pyproject = true;
    
    build-system = [
        setuptools
        hatchling
        hatch-jupyter-builder
        hatch-nodejs-version

        yarn
    ];

    propagatedBuildInputs = [
        jupyterlab
    ];

    pythonImportsCheck = [
        "cad-viewer-widget"
    ];

    meta = with lib; {
        description = "An ipywidget based interface to the Javascript three-cad-viewer";
        homepage = "https://github.com/bernhard-42/cad-viewer-widget";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}