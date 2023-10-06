#!/bin/sh

# requires d2vm
# https://github.com/linka-cloud/d2vm

sudo d2vm build -p root --keep-cache -f Dockerfile -o "POPL 2024 Artifact - Indexed Types for a Statically Safe WebAssembly-disk001.vmdk" .
