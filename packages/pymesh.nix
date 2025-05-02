# doesn't quite work yet
{ lib
, buildPythonPackage
, python
, fetchFromGitHub

, stdenv
, cmake
, gcc
, mkl

# required c deps
, gmp
, mpfr
, boost
# in third-party
# , eigen
# , tbb
# , nlohmann_json
# , pybind11
# , libigl

, setuptools
, distutils

# , breakpointHook
# , keepBuildTree
}: let
  src = fetchFromGitHub {
      owner = "sdobz";
      repo = "PyMesh";
      rev = "52dced1114a8434db38aeabbb01145bb0f892a20";
      hash = "sha256-uF3gV73cQmPCwLeqt0HjkJUbvrnFQEBH46qlnd9AOuA=";
      fetchSubmodules = true;
  };
  pymeshThirdParty = stdenv.mkDerivation {
    pname = "pymesh-third-party";
    version = "0.3";

    inherit src;

    # only relevant with cmake configure
    # dependencies = [
    #   gmp
    #   mpfr
    #   boost
    # ];

    buildInputs = [
      # breakpointHook
      cmake
      gcc

      gmp
      mpfr
      boost
    ];

    dontUseCmakeConfigure = true;

    buildPhase = ''
      CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${boost.dev}/include:${gmp.dev}/include:${mpfr.dev}/include"
      CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${boost}/lib:${gmp}/lib:${mpfr}/lib"
      cd third_party
      python build.py all
    '';

    installPhase = ''
      mkdir $out
      cp -r ../python/pymesh/third_party $out
    '';
  };

  pymeshLib = stdenv.mkDerivation {
    pname = "pymesh-lib";
    version = "0.3";
    
    build-system = "cmake";
    inherit src;

    postPatch = ''
      substituteInPlace cmake/FindAllDependencies.cmake --replace-fail 'lib/cmake/nlohmann_json' 'lib64/cmake/nlohmann_json'
      substituteInPlace Settings.cmake --replace-fail 'execute_process(COMMAND ''${PYTHON_EXECUTABLE} ''${PROJECT_SOURCE_DIR}/cmake/SetInstallRpath.py)' ' '
      substituteInPlace Settings.cmake --replace-fail 'include(SetInstallRpath)' ' '
    '';

    buildInputs = [
      # breakpointHook
      cmake
      gcc

      gmp
      mpfr
      boost
      mkl
    ];

    preConfigure = ''
    ln -s "${pymeshThirdParty}/third_party" python/pymesh/third_party
    '';

    installPhase = ''
    mkdir $out
    cp -r python/pymesh/lib $out
    '';
  };
in 
buildPythonPackage rec {
    pname = "pymesh";
    version = "0.3";

    inherit src;

    buildInputs = [
      setuptools
      distutils
    ];

    preConfigure = ''
    ln -s "${pymeshThirdParty}/third_party" python/pymesh/third_party
    ln -s "${pymeshLib}/lib" python/pymesh/lib
    '';

    # https://github.com/PyMesh/PyMesh?tab=readme-ov-file#build

    buildPhase = ''
    python setup.py bdist_wheel --skip-build
    '';
    
    pythonImportsCheck = "pymesh";

    meta = with lib; {
        description = "Geometry Processing Library for Python ";
        homepage = "https://github.com/PyMesh/PyMesh";
        license = licenses.mpl10; # version unknown, selected ~2020
        maintainers = with maintainers; [ ];
    };
}
