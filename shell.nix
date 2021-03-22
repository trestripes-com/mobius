{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  pyEnv = lib.mkPython {
    requirements = ''
      # jupyter
      jupyterlab
      ipywidgets

      nbstripout == 0.3.7

      # core
      numpy >= 1.15.0
      scipy >= 1.0.0
      scikit-learn >= 0.14.0, != 0.19.0
      matplotlib >= 2.0.0, < 3.3
      Pillow
    '';
  };

  notebook = writeShellScriptBin "notebook" ''
    jupyter lab --notebook-dir=$(pwd)
  '';
in

mkShell {
  buildInputs = [
    git
    pre-commit
    gnumake

    pyEnv
    notebook
  ];
  shellHook = ''
    export PROJECT_ROOT=$(pwd)
    export IMAGES_DIR=$(pwd)/images
  '';
}
