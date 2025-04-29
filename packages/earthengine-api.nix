{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools

, google-cloud-storage
, google-api-python-client
, google-auth
, google-auth-httplib2
, httplib2
, requests
}:
buildPythonPackage rec {
    pname = "earthengine-api";
    version = "1.5.13";

    src = fetchFromGitHub {
        owner = "google";
        repo = "earthengine-api";
        rev = "v${version}";
        hash = "sha256-260/oiRqTubChLtQnGOjeXmKBB0xh4LjzJD+GLRvn9w=";
    };
    sourceRoot = "${src.name}/python";

    pyproject = true;
    
    build-system = [
        setuptools
    ];

    dependencies = [
        google-cloud-storage
        google-api-python-client
        google-auth
        google-auth-httplib2
        httplib2
        requests
    ];

    meta = with lib; {
        description = "Python and JavaScript bindings for calling the Earth Engine API.";
        homepage = "https://github.com/google/earthengine-api";
        license = licenses.asl20;
        maintainers = with maintainers; [ ];
    };
}
