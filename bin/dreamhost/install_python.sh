#!/bin/bash

PYTHON_VERSION=3.8.9

mkdir ~/py3_tmp
pushd ~/py3_tmp/
wget "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"
tar zxvf "Python-${PYTHON_VERSION}.tgz"
pushd "Python-${PYTHON_VERSION}"
./configure --prefix="$HOME/opt/python-${PYTHON_VERSION}"
make
make install
echo "export PATH=\$HOME/opt/python-${PYTHON_VERSION}/bin:\$PATH" >>~/.bash_profile

source ~/.bash_profile
which python3 && which pip3 && python3 --version && pip3 --version

popd # pushd "Python-${PYTHON_VERSION}"
popd # pushd ~/py3_tmp/

rm -rf ~/py3_tmp/
