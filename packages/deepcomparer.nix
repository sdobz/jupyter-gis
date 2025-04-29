{ lib
, buildPythonPackage
, fetchPypi

, setuptools
}:
buildPythonPackage rec {
    pname = "deepcomparer";
    version = "0.4.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-yZof0yizULvfz1l/YeHPt20VDDje30bscJv17ut7iN4=";
    };
    propagatedBuildInputs = [ 
      setuptools
    ];
    pyproject = true;

    pythonImportsCheck = "deepcomparer";
    doCheck = false;

    meta = with lib; {
        description = "👀 Deep compare python objects and structures like dictionaries, lists and iterables. ";
        homepage = "https://github.com/n1nj4t4nuk1/deepcomparer.py";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}
