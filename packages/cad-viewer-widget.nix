# ref: https://github.com/fgaz/nixpkgs/blob/0fb8c1fb471cad678aeffb14fd835719593673d3/pkgs/development/python-modules/ipydatagrid/default.nix
# ref: https://github.com/NixOS/nixpkgs/blob/7fccd1c7f11b23cd0f8c0ed5ae90dc37197dbadf/pkgs/development/python-modules/dash/default.nix
{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, hatchling
, hatch-jupyter-builder
, hatch-nodejs-version

, jupyterlab
, ipywidgets
, numpy
, pyparsing

, yarn
, yarnConfigHook
, breakpointHook
, fetchYarnDeps
, nodejs
}:
buildPythonPackage rec {
    pname = "cad-viewer-widget";
    version = "3.0.2";

    src = fetchFromGitHub {
        owner = "bernhard-42";
        repo = "cad-viewer-widget";
        rev = "v${version}";
        hash = "sha256-dTBfn+qQSvHz4NgYHddjNGtIXGXL6Kt2Ad5cAJBc+nE=";
    };

    yarnOfflineCache = fetchYarnDeps {
        yarnLock = "${src}/js/yarn.lock";
        hash = "sha256-dPMP0fXYyygh0sHeKg4HZN/e8GMXB9PzFoe+YlKlwjc=";
    };

    pyproject = true;
    
    build-system = [
        setuptools
        hatchling
        hatch-jupyter-builder
        hatch-nodejs-version
    ];

    preConfigure = ''
        pushd js
    '';

    preBuild = ''
        # Generate the jupyterlab extension files
        yarn --offline run build:prod

        popd
    '';

    nativeBuildInputs = [
        # breakpointHook
        yarnConfigHook
        yarn
        nodejs
        jupyterlab
    ];

    dependencies = [
        ipywidgets
        numpy
        pyparsing
    ];

    meta = with lib; {
        description = "An ipywidget based interface to the Javascript three-cad-viewer";
        homepage = "https://github.com/bernhard-42/cad-viewer-widget";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
    };
}