# doesn't quite work yet
{ lib
, buildPythonPackage
, fetchFromGitHub

, cmake
, gcc
, mkl
, gmp
, mpfr
, boost

, setuptools
, distutils

, breakpointHook
}:
buildPythonPackage rec {
    pname = "pymesh";
    version = "0.3";

    src = fetchFromGitHub {
        owner = "sdobz";
        repo = "PyMesh";
        rev = "f620325619023ad133f8eb00bcee91a84c7df261";
        hash = "sha256-hKuY6PWZcO6gQEMkvFVXNrjXz1ZoEkryVrrAuUb0eAM=";
        fetchSubmodules = true;
    };

    build-system = [
      setuptools
      cmake
      gcc
    ];

    postPatch = ''
      substituteInPlace third_party/tbb/include/tbb/task.h --replace 'task* next_offloaded;' 'tbb::task* next_offloaded;'
      substituteInPlace third_party/pybind11/include/pybind11/pybind11.h --replace 'std::uint16_t' 'uint16_t'
      substituteInPlace third_party/pybind11/include/pybind11/attr.h --replace 'std::uint16_t' 'uint16_t'
    '';

    propagatedBuildInputs = [
      mkl
      gmp
      mpfr
      boost
      distutils
    ];

    # https://github.com/PyMesh/PyMesh?tab=readme-ov-file#build
    buildPhase = ''
    pushd third_party
    python build.py cork

    popd
    mkdir build
    pushd build
    cmake ..

    make
    popd
    python setup.py bdist_wheel
    '';
    
    pythonImportsCheck = "pymesh";

    meta = with lib; {
        description = "Geometry Processing Library for Python ";
        homepage = "https://github.com/PyMesh/PyMesh";
        license = licenses.mpl10; # version unknown, selected ~2020
        maintainers = with maintainers; [ ];
    };
}
