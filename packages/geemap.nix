{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools_scm

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

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-+1FiKQu1GBFvwrJLtna2h4UnB69LsDpTEeWYh/4Rh+Q=";
    }; 

    pyproject = true;

    postPatch = ''
        substituteInPlace pyproject.toml --replace 'ipyleaflet>=0.19.2' 'ipyleaflet>=0.0.0'
        '';
    
    build-system = [
        setuptools
        setuptools_scm
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
