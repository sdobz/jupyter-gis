{ lib
, buildPythonPackage
, fetchPypi

, cython
, numpy
, setuptools
}:
buildPythonPackage rec {
    pname = "fast_simplification";
    version = "0.1.10";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-muRbvixouy9M2HEdTmG8jX/eRrTqk9bZzWoyogaFs/g=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml --replace 'numpy>=2,<3' 'numpy>=1,<3'
      substituteInPlace setup.py --replace 'numpy>=2.0' 'numpy>=1.0'
      '';

    build-system = [
      setuptools
    ];

    pyproject = true;

    dependencies = [ 
      cython
      numpy
    ];

    pythonImportsCheck = "fast_simplification";

    meta = with lib; {
        description = "Fast Quadratic Mesh Simplification";
        homepage = "https://github.com/pyvista/fast-simplification";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}
