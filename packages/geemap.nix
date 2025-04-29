{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools

, anywidget
, bqplot
, colour
, earthengine-api
, eerepr
, folium
, geocoder
, ipyevents
, ipyfilechooser
, ipyleaflet
, ipytree
, matplotlib
, numpy
, pandas
, plotly
, pyperclip
, pyshp
, python-box
, scooby
}:
buildPythonPackage rec {
    pname = "geemap";
    version = "0.35.3";

    src = fetchFromGitHub {
        owner = "gee-community";
        repo = "geemap";
        rev = "v${version}";
        hash = "sha256-260/oiRqTubChLtQmGOjeXmKBB0xh4LjzJD+GLRvn9w=";
    };

    pyproject = true;
    
    build-system = [
        setuptools
    ];

    dependencies = [
        anywidget
        bqplot
        colour
        earthengine-api
        eerepr
        folium
        geocoder
        ipyevents
        ipyfilechooser
        ipyleaflet
        ipytree
        matplotlib
        numpy
        pandas
        plotly
        pyperclip
        pyshp
        python-box
        scooby
    ];

    meta = with lib; {
        description = "Python and JavaScript bindings for calling the Earth Engine API.";
        homepage = "https://github.com/google/earthengine-api";
        license = licenses.asl20;
        maintainers = with maintainers; [ ];
    };
}
