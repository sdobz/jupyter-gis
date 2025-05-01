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
        owner = "sdobz";
        repo = "TouchTerrain_for_CAGEO";
        rev = "a83933ff026f77dfe9809e09ced71ed9aea287e1";
        hash = "sha256-Qr6/5QQaYU924hbxd3Eeg7voE2M9x6bYsIt1lm6Evzw=";
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
