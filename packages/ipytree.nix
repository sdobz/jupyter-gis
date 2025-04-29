{ lib
, buildPythonPackage
, fetchPypi

, ipywidgets
, jupyter-packaging
}:
buildPythonPackage rec {
    pname = "ipytree";
    version = "0.2.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-1T1zm7qqRUFXM80G4NxCCirz0XNDhhfbRypRe8emHlY=";
    };
    propagatedBuildInputs = [ 
      ipywidgets
      jupyter-packaging
    ];

    pythonImportsCheck = "ipytree";
    doCheck = false;

    meta = with lib; {
        description = "A Tree Widget using Jupyter-widgets protocol and jsTree";
        homepage = "https://github.com/martinRenou/ipytree";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}
