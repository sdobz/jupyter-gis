{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools

, webcolors
, numpy
, cachetools
, imagesize
}:
buildPythonPackage rec {
    pname = "ocp-tessellate";
    version = "3.0.11";

    src = fetchFromGitHub {
        owner = "bernhard-42";
        repo = "ocp-tessellate";
        rev = "v${version}";
        hash = "sha256-4AEYRUnmzuG8eaMnGl3HUF8uOifY2kN20X5prRWND/E=";
    };

    pyproject = true;
    
    build-system = [
        setuptools
    ];

    dependencies = [
        webcolors
        numpy
        cachetools
        imagesize
    ];

    meta = with lib; {
        description = "Tessellate OCP (https://github.com/cadquery/OCP) objects to use with threejs";
        homepage = "https://github.com/bernhard-42/ocp-tessellate";
        license = licenses.asl20;
        maintainers = with maintainers; [ ];
    };
}
