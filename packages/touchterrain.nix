{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools

, pillow
, google-api-python-client
, earthengine-api
, oauth2client
, numpy
, scipy
, kml2geojson
, geojson
, defusedxml
, six
, gdal
, imageio
, k3d-jupyter
, httplib2
, matplotlib
}:
buildPythonPackage rec {
    pname = "touchterrain";
    version = "3.5-dev";

    src = fetchFromGitHub {
        owner = "ChHarding";
        repo = "TouchTerrain_for_CAGEO";
        rev = "bbbc32c6f8ed1b54b644ed224c3cfc2e63be397a";
        hash = "sha256-R9N97Fn7Z+BAJ9vG9ps5u2/sEFIJX6NuKFtM7Dcj5eI=";
    };
    
    build-system = [
        setuptools
    ];

    dependencies = [
      pillow
      google-api-python-client
      earthengine-api
      oauth2client
      numpy
      scipy
      kml2geojson
      geojson
      defusedxml
      six
      gdal
      imageio
      k3d-jupyter
      httplib2
      matplotlib
    ];

    meta = with lib; {
        description = "Touch Terrain: A python app to create 3D printable terrain models (STL/OBJ) from only elevation data (via Google Earth Engine) or from a local geotiff.";
        homepage = "https://github.com/ChHarding/TouchTerrain_for_CAGEO";
        license = licenses.gpl3;
        maintainers = with maintainers; [ ];
    };
}
