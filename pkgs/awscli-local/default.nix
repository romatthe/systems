{ lib
, python3Packages
, fetchPypi
}:
python3Packages.buildPythonApplication rec {
  pname = "awscli-local";
  version = "0.22.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "awscli_local";
    sha256 = "sha256-B8Uyw3J1O/XxVCZFHckdbuyd6HeXSASTKamogr2sigs=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    localstack-client
    packaging
  ];

  # Can’t run `pytestCheckHook` because the tests are integration tests and expect localstack to be present, which in turn expects docker to be running.
  doCheck = false;

  # There is no `pythonImportsCheck` because the package only outputs a binary: tflocal
  dontUsePythonImportsCheck = true;

  meta = with lib; {
    description = "AWS CLI wrapper to interact directly with LocalStack";
    homepage = "https://github.com/localstack/awscli-local";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
