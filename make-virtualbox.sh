#!/bin/sh

# requires d2vm
# https://github.com/linka-cloud/d2vm

sudo d2vm build -p root --keep-cache -f Dockerfile -o "POPL2024Artifact-IndexedTypesforaStaticallySafeWebAssembly-disk001.vmdk" .
