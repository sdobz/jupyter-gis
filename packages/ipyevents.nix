{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, hatchling
, hatch-jupyter-builder

, ipywidgets
, jupyterlab

, yarn
, yarnConfigHook
, breakpointHook
, fetchYarnDeps
, nodejs
}:
buildPythonPackage rec {
    pname = "ipyevents";
    version = "2.0.2";

    src = fetchFromGitHub {
        owner = "sdobz";
        repo = "ipyevents";
        rev = "722163d37b18f3d36c390846d3d2370496432d78";
        hash = "sha256-/kEdmy1YO1zA8MOSLMTL2NyJiDH405t8PA7SkCuK5Wk=";
    };

    yarnOfflineCache = fetchYarnDeps {
        yarnLock = "${src}/yarn.lock";
        hash = "sha256-Qo32y3VyCCvNZTvFYk/C7SbC0MFFmyu9wQdsAnew2oc=";
    };

    postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'jupyterlab==3.*' 'jupyterlab==4.*'
    '';

    pyproject = true;
    
    build-system = [
        setuptools
        hatchling
        hatch-jupyter-builder
    ];
    
    nativeBuildInputs = [
        # breakpointHook
        yarnConfigHook
        yarn
        nodejs
        jupyterlab
    ];

    dependencies = [
      ipywidgets
      jupyterlab
    ];

    meta = with lib; {
        description = "A custom widget for returning mouse and keyboard events to Python. ";
        homepage = "https://github.com/mwcraig/ipyevents";
        license = licenses.bsd3;
        maintainers = with maintainers; [ ];
    };
}
