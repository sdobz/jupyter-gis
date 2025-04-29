{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, hatchling

, earthengine-api
}:
buildPythonPackage rec {
    pname = "eerepr";
    version = "0.1.1";

    src = fetchFromGitHub {
        owner = "aazuspan";
        repo = "eerepr";
        rev = "v${version}";
        hash = "sha256-VVZDM5Ooarl8tdNqePsXJAKdsAAwYyP62DIbYgPv3aE=";
    };

    pyproject = true;
    
    build-system = [
        setuptools
        hatchling
    ];

    dependencies = [
        earthengine-api
    ];

    meta = with lib; {
        description = "Interactive Code Editor-style reprs for Earth Engine objects in a Jupyter notebook ";
        homepage = "https://github.com/aazuspan/eerepr";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}
