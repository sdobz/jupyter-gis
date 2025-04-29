{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, jupyter-packaging
, ipywidgets
, cachetools
, hatchling
, hatch-jupyter-builder

, cad-viewer-widget
, ocp-vscode
, orjson

, cadquery
, jupyterlab
}:
buildPythonPackage rec {
  pname = "jupyter-cadquery";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "bernhard-42";
    repo = "jupyter-cadquery";
    rev = "v${version}";
    hash = "sha256-vaJezD6n2ob5VGGClXYQuiCE5no7qa60XtHRXib1GH4=";
  };

  pyproject = true;

  build-system = [
    hatchling
    hatch-jupyter-builder
    setuptools
  ];

  propagatedBuildInputs = [
    jupyterlab
    cadquery
    ocp-vscode
    orjson
    cachetools

    cad-viewer-widget
  ];

  nativeCheckInputs = [ ];

  pythonImportsCheck = [
    "jupyter_cadquery"
  ];

  meta = with lib; {
    description = "An extension to show CadQuery 3 objects in JupyterLab or Notebook";
    homepage = "https://github.com/bernhard-42/jupyter-cadquery";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
