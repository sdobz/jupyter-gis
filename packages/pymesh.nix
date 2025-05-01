# doesn't quite work yet
{ lib
, buildPythonPackage
, fetchFromGitHub

, stdenv
, cmake
, gcc
#, mkl

# required c deps
, gmp
, mpfr
, boost
# in third-party
, eigen
, tbb
, nlohmann_json
, pybind11
, libigl

, setuptools
, distutils

, breakpointHook
, keepBuildTree
}: let
  src = fetchFromGitHub {
      owner = "rocketvector";
      repo = "PyMesh";
      rev = "16363009cd0b534f04854c92a478be8fafe55252";
      hash = "sha256-Ihi/l011CFzR8dIhiXe9NTp8GSRH8pcJM5sYhNzmNqQ=";
  };

  # tbb = stdenv.mkDerivation {
  #   pname = "tbb";
  #   version = "dev";

  #   src = fetchFromGitHub {
  #     owner = "PyMesh";
  #     repo = "tbb";
  #     rev = "ed6f6f15cece26ae4ab0816eab220c5e0691093f";
  #     hash = "sha256-Ihi/l011CFzR8dIhiXe9NTp8GSRH8pcJM5sYhNzmNqS=";
  #   };
  # };
in 
buildPythonPackage rec {
    pname = "pymesh";
    version = "0.3";

    inherit src;

    postPatch = ''
        substituteInPlace Settings.cmake --replace 'add_subdirectory(''${PROJECT_SOURCE_DIR}/third_party/pybind11)' 'find_package(pybind11 REQUIRED)'
    #   substituteInPlace setup.py --replace 'commands = [' 'print(os.getcwd()); commands = ['
    #   substituteInPlace third_party/tbb/include/tbb/task.h --replace 'task* next_offloaded;' 'tbb::task* next_offloaded;'
    #   substituteInPlace third_party/pybind11/include/pybind11/pybind11.h --replace 'std::uint16_t' 'uint16_t'
    #   substituteInPlace third_party/pybind11/include/pybind11/attr.h --replace 'std::uint16_t' 'uint16_t'
    '';

    build-system = [
      cmake
    ];

    buildInputs = [
      setuptools
      distutils
    ];

    nativeBuildInputs = [
      # breakpointHook
      cmake

      # thirdparty, need to use cmake flags??
      # eigen
      # tbb
      # nlohmann_json
      # libigl
      # thidparty, auto found?
      pybind11

      # implicit
      # mkl # not required

      gmp
      mpfr
      boost
    ];

    cmakeFlags = [
      "-DEIGEN_ROOT_DIR=${eigen}/include/eigen3/"
      "-DTBB_INCLUDE_DIR=${tbb.dev}/include/tbb"
      "-DTBB_LIBRARY=${tbb}/lib/tbb.so"
      "-DTBB_LIBRARY_MALLOC=${tbb}/lib/tbbmalloc.so"
      "-DBoost_INCLUDE_DIR=${boost.dev}/include"
      "-Dnlohmann_json_DIR=${nlohmann_json}/share/cmake/nlohmann_json"
      "-DLIBIGL_INCLUDE_DIRS=${libigl}"
    ];

    # https://github.com/PyMesh/PyMesh?tab=readme-ov-file#build

    buildPhase = ''
    mkdir build
    cd build
    cmake ..
    cd ..
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
