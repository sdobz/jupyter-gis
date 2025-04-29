{ lib
, buildPythonPackage
, fetchPypi

, ipywidgets
, jupyter-packaging
}:
buildPythonPackage rec {
    pname = "ipyfilechooser";
    version = "0.6.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Qd+eQ5WpJPjht44oBNvlBm3D/cIz+wf+z83CoMmn2NM=";
    };
    propagatedBuildInputs = [ 
      ipywidgets jupyter-packaging
    ];
    pythonImportsCheck = "ipyfilechooser";
    doCheck = false;

    meta = with lib; {
        description = "Python file chooser widget for use in Jupyter/IPython in conjunction with ipywidgets";
        homepage = "https://github.com/crahan/ipyfilechooser";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}
