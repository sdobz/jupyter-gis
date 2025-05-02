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

, numpy
, scipy

, patchelf

, breakpointHook
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
      cp -r ../python/pymesh/third_party/* $out
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
      pymeshThirdParty
    ];

    preConfigure = ''
    ln -s "${pymeshThirdParty}" python/pymesh/third_party
    '';

    installPhase = ''
    mkdir $out
    cp -r ../python/pymesh/lib $out
    mv $out/lib/PyMeshNone $out/lib/PyMesh.so
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

    postPatch = ''
    substituteInPlace setup.py --replace-fail 'cmake_build,' 'build,'
    '';

    preBuild = ''
    ln -s "${pymeshThirdParty}" python/pymesh/third_party
    ln -s "${pymeshLib}/lib" python/pymesh/lib
    '';

    dependencies = [
      numpy
      scipy
    ];

    nativeBuildInputs = [
      patchelf
    ];

    postInstall = ''
    find "$out/lib/${python.libPrefix}/site-packages/pymesh/lib" -name '*.so' -type f | while read -r so; do
      echo "Patching $so"
      patchelf --add-rpath \$ORIGIN/../third_party/lib $so
    done
    '';
    
    pythonImportsCheck = "pymesh";

    meta = with lib; {
        description = "Geometry Processing Library for Python ";
        homepage = "https://github.com/PyMesh/PyMesh";
        license = licenses.mpl10; # version unknown, selected ~2020
        maintainers = with maintainers; [ ];
    };
}
