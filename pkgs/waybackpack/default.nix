{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "waybackpack";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "waybackpack";
    rev = "v${version}";
    sha256 = "sha256-tDL8nWIesla4DTY1hy1ampJmcY1jb4ZfbWOLGQ99jho=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];

  propagatedBuildInputs = [ 
    python3.pkgs.requests
    python3.pkgs.tqdm
  ];

  meta = with lib; {
    # ...
  };
}