# Hueckel - AGENTS.md

## Build

```sh
cd source && make
```

Output binary: `source/hueckel.x`. Requires `gfortran`, `liblapack-dev`, `libblas-dev`.

Clean: `make -C source clean`.

## Test

```sh
./build.sh
```

This builds, runs `ethylene.xyz` through `hueckel.x`, then greps for `"Happy landing"` in the output.

To run manually:
```sh
source/hueckel.x < test/ethylene.xyz
```

Only `test/ethylene.xyz` exists as a test input. The program reads XYZ from stdin — first line = atom count, second = title, then element + x/y/z per line.

## CI

Two workflows in `.github/workflows/` — `test.yml` (ubuntu-latest, installs deps) and `runner.yml` (self-hosted, no dep install). Both trigger on push/PR to `master`.

## Project structure

- `source/` — Fortran 90 source files with Makefile
- `test/` — XYZ input and reference output
- `build.sh` — convenience build + test script
- `.gitignore` ignores `*.o` and `*.x`

## Known quirks

- `global.mod` is a build artifact from `global.f90`. If missing, build produces it automatically via the makefile dependency chain.
- The program only considers carbon atoms (hardcoded `element(i).eq."C"` check in `hueckel.f90`).
- Bond cutoff `dmax=1.4 Å`, Hückel parameters `alpha=0.0`, `beta=1.0`.
- No test framework; the sole test is the shell check in `build.sh`.
