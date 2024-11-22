#!/bin/bash
set -e

OAREPO_VERSION=${OAREPO_VERSION:-12}
PYTHON=${PYTHON:-python3}

BUILDER_VENV=".venv-builder"
if test -d $BUILDER_VENV ; then
	rm -rf $BUILDER_VENV
fi

${PYTHON} -m venv $BUILDER_VENV
. $BUILDER_VENV/bin/activate
pip install -U setuptools pip wheel
pip install -e .

MODEL="thesis"
VENV=".venv-tests"

if test -d ./build-tests/$MODEL; then
	rm -rf ./build-tests/$MODEL
fi

oarepo-compile-model ./build-tests/$MODEL.yaml --output-directory ./build-tests/$MODEL -vvv
if test -d $VENV ; then
	rm -rf $VENV
fi
${PYTHON} -m venv $VENV
. $VENV/bin/activate
pip install -U setuptools pip wheel

pip install "oarepo[tests]==${OAREPO_VERSION}.*"

pip install -e "./build-tests/${MODEL}[tests]"

(
    cd ./build-tests/$MODEL
    find $MODEL -name '*.py' | grep -v '-' | tr '/' '.' | sed 's/\.__init__\.py//' | sed 's/\.py$//' | sed 's/^/import /'
) > ./build-tests/$MODEL/all_imports.py

python ./build-tests/$MODEL/all_imports.py
