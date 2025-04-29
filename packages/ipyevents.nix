# https://github.com/LKS-CHART/medical-imaging-nix/blob/e809cfc1711e871ec5d7fd32a46dac8ded6514a2/flake/overlay.nix#L22
{ lib
, buildPythonPackage
, fetchPypi

, ipywidgets
, jupyter-packaging
}:
buildPythonPackage rec {
    pname = "ipyevents";
    version = "2.0.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "I+sq+rE9kFY5fxIKiAUd076wZ7aY0Iszrf/J4HfwGcs=";
    };
    propagatedBuildInputs = [ 
      ipywidgets jupyter-packaging
    ];
    pythonImportsCheck = "ipyevents";
    doCheck = false;
    postPatch = ''
            substituteInPlace setup.py --replace "ensure_python('>=3.6')" ""
            '';

    meta = with lib; {
        description = "A custom widget for returning mouse and keyboard events to Python. ";
        homepage = "https://github.com/mwcraig/ipyevents";
        license = licenses.bsd3;
        maintainers = with maintainers; [ ];
    };
}
