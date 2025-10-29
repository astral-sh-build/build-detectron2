#!/bin/bash
# Script to prepare the build environment for detectron2.
#
# Example usage:
#   ./prepare_for_build.sh a9c0821a12ad353fb2a96f019515990d5460c5ac

set -euxo pipefail

# When run from CI, this script is in build_scripts/prepare_for_build.sh
# and needs to reference patches from that directory
export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT=`pwd`

if [ $# -ne 1 ]; then
    echo "Usage: $0 <detectron2-version>"
    echo "Example: $0 a9c0821a12ad353fb2a96f019515990d5460c5ac"
    exit 1
fi

DETECTRON2_VERSION=$1

# Ensure that the detectron2 version is supported.
if [ ! -d "${SCRIPT_DIR}/patches/${DETECTRON2_VERSION}" ]; then
    echo "Error: patches/${DETECTRON2_VERSION} directory does not exist"
    exit 1
fi

# Apply patches.
for patch in "${SCRIPT_DIR}/patches/${DETECTRON2_VERSION}"/*.patch; do
    patch -p1 -d ${ROOT} -i ${patch}
done
