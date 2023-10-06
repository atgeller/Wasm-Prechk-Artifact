#!/bin/sh

# requires d2vm
# https://github.com/linka-cloud/d2vm

sudo d2vm build -p root -f Dockerfile -o wasm-prechk-artifact.vdi .
