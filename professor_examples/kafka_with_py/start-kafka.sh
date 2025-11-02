#!/bin/bash
set -e

if [ -z "${PYTHON_APP}" ]; then
  echo "PYTHON_APP not defined"
  exit 1
fi

echo "Running ${PYTHON_APP}..."
python3 "${PYTHON_APP}"