{ lib
, buildPythonPackage
, dictdiffer
, diskcache
, dvc-objects
, fetchFromGitHub
, funcy
, nanotime
, pygtrie
, pythonOlder
, setuptools-scm
, shortuuid
, sqltrie
}:

buildPythonPackage rec {
  pname = "dvc-data";
  version = "2.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xRfe1k5i67aAI2bbZq85pGwn+KOY8P8bkvWLW7f/L+o=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dictdiffer
    diskcache
    dvc-objects
    funcy
    nanotime
    pygtrie
    shortuuid
    sqltrie
  ];

  # Tests depend on upath which is unmaintained and only available as wheel
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "dvc-objects==" "dvc-objects>="
  '';

  pythonImportsCheck = [
    "dvc_data"
  ];

  meta = with lib; {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/iterative/dvc-data";
    changelog = "https://github.com/iterative/dvc-data/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
