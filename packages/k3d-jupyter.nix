{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, hatch-nodejs-version
, hatch-jupyter-builder
, jupyterlab

, ipywidgets
, msgpack
, deepcomparer
, numpy
, traitlets
, traittypes
}:
buildPythonPackage rec {
    pname = "k3d";
    version = "2.16.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-1MYxTJD64TYoaZCdKMBKhugFs10yDseNRCVQkMVoxgk=";
    };

    postPatch = ''
        substituteInPlace pyproject.toml --replace 'jupyterlab~=3.0' 'jupyterlab~=4.0'
        '';

    build-system = [
      hatchling
      hatch-nodejs-version
      hatch-jupyter-builder
    ];

    nativeBuildInputs = [
      jupyterlab
    ];

    propagatedBuildInputs = [ 
      ipywidgets
      msgpack
      deepcomparer
      numpy
      traitlets
      traittypes
    ];

    pyproject = true;

    pythonImportsCheck = "k3d";
    doCheck = false;

    meta = with lib; {
        description = "K3D lets you create 3D plots backed by WebGL with high-level API";
        homepage = "https://github.com/K3D-tools/K3D-jupyter";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}
