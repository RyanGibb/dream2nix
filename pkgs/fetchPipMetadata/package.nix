{
  lib,
  # This python is for the locking logic, not the python to lock packages for.
  python3,
  gitMinimal,
  nix-prefetch-scripts,
}: let
  package = python3.pkgs.buildPythonPackage {
    name = "fetch_pip_metadata";
    format = "flit";
    src = ./src;
    nativeBuildInputs = [
      gitMinimal
      python3.pkgs.pytestCheckHook
      nix-prefetch-scripts
    ];
    propagatedBuildInputs = with python3.pkgs; [
      packaging
      certifi
      python-dateutil
      pip
    ];
  };
in
  package
