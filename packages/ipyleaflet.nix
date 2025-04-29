{ lib
, buildPythonPackage
, fetchPypi

, ipywidgets
, traittypes
, xyzservices
, jupyter-packaging
, branca
, jupyter-leaflet
}:
buildPythonPackage rec {
    pname = "ipyleaflet";
    version = "0.19.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-s7g/40YOdClkwqWSTqeTQ2WjdJu3UxDOOI1F/XUTctI=";
    };
    propagatedBuildInputs = [ 
      ipywidgets
      traittypes
      xyzservices
      branca
      jupyter-leaflet
      jupyter-packaging
    ];

    pythonImportsCheck = "ipyleaflet";
    doCheck = false;

    meta = with lib; {
        description = "A Jupyter - Leaflet.js bridge ";
        homepage = "https://github.com/jupyter-widgets/ipyleaflet";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}
