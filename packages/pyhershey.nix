{ lib
, buildPythonPackage
, fetchPypi

, toml
}:
buildPythonPackage rec {
    pname = "pyhershey";
    version = "0.1.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-DJ9w8HaPozVL3dNCjDYrP4FAJumS+eT3ZhRxZWz0QRk=";
    };

    dependencies = [
      toml
    ];

    pythonImportsCheck = "pyhershey";
    doCheck = false;

    meta = with lib; {
        description = "pyhershey enable simple usage of Hershey fonts within python.";
        homepage = "https://gitlab.com/viggge/pyhershey";
        license = licenses.gpl3;
        maintainers = with maintainers; [ ];
    };
}
