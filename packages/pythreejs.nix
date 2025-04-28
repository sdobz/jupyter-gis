{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, jupyterlab
}:

buildPythonPackage rec {
  pname = "pythreejs";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "jupyter-widgets";
    repo = "pythreejs";
    rev = version;
    hash = "sha256-IBcLI64VUCYgqJcM3nGqnYwtCAKJ5CNpshjOdwqGtPU=";
  };

  pyproject = true;

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    jupyterlab
  ];

  nativeCheckInputs = [ ];

  pythonImportsCheck = [
    "pythreejs"
  ];

  meta = with lib; {
    description = "A Jupyter - Three.js bridge";
    homepage = "https://github.com/jupyter-widgets/pythreejs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
