#!/bin/sh
# Build the Hueckel binary and run a quick smoke test on ethylene.
cd source
make
cd ../test
../source/hueckel.x ethylene.xyz
cat ethylene.out
grep "Happy landing" ethylene.out
