{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools

, requests
, ipykernel
, orjson
, websockets
, pyaml
, flask
, flask-sock
, click

, ocp-tessellate

, yarn
, yarnConfigHook
, yarnBuildHook
, fetchYarnDeps
, nodejs
}:
buildPythonPackage rec {
    pname = "vscode-ocp-cad-viewer";
    version = "2.7.1";

    src = fetchFromGitHub {
        owner = "bernhard-42";
        repo = "vscode-ocp-cad-viewer";
        rev = "v${version}";
        hash = "sha256-1ZF3DUFZj3nhYGYSoA0OOtX1odNqcikFRhDLFemWysI=";
    };

    yarnOfflineCache = fetchYarnDeps {
        yarnLock = "${src}/yarn.lock";
        hash = "sha256-c1essqk3uNqMIUPzhqGRu/IPhdaNUfiedveq5uJXQtw=";
    };

    pyproject = true;
    
    build-system = [
        setuptools
    ];

    nativeBuildInputs = [
        # breakpointHook
        yarnConfigHook
        yarnBuildHook
        yarn
        nodejs
    ];

    dependencies = [
        ocp-tessellate

        requests
        ipykernel
        orjson
        websockets
        pyaml
        flask
        flask-sock
        click
    ];

    meta = with lib; {
        description = "A viewer for OCP based Code-CAD (CadQuery, build123d) integrated into VS Code";
        homepage = "https://github.com/bernhard-42/vscode-ocp-cad-viewer";
        license = licenses.asl20;
        maintainers = with maintainers; [ ];
    };
}
