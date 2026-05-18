# Hueckel - AGENTS.md

## Build

```sh
cd source && make
```

Output binary: `source/hueckel.x`. Requires `gfortran`, `liblapack-dev`, `libblas-dev`.

Clean: `make -C source clean`.

## Test

```sh
source/hueckel.x < test/ethylene.xyz
source/hueckel.x < test/benzene.xyz
```

The program reads XYZ from stdin — first line = atom count, second = title, then element + x/y/z per line. Checks for `"Happy landing"` in output.

## CI

Workflows in `.github/workflows/` — `test.yml` (ubuntu-latest, installs deps), `runner.yml` (self-hosted), `final.yml`, `cloudbuild.yml`. Trigger on push/PR to `master`.

## Project structure

- `source/` — Fortran 90 source files with Makefile
- `test/` — XYZ input files (`ethylene.xyz`, `benzene.xyz`)
- `.gitignore` — ignores `*.o`, `*.x`, `*.mod`

## Output

- `hueckel.molden` — Molden format file written alongside stdout, containing atoms, GTO basis (p-type for C, s-type for H), and MOs with coefficients on pz components of each C.

## Known quirks

- `global.mod` and `molecule.mod` are build artifacts from `global.f90` and `molecule.f90`. Build produces them automatically via the makefile dependency chain.
- The program only considers carbon atoms (hardcoded `element(i).eq."C"` in `hueckel.f90`).
- Bond cutoff `dmax=1.4 Å`, Hückel parameters `alpha=0.0`, `beta=-1.0`.
- `rij.f90` was removed; `rij` is now a module procedure in `molecule.f90`.
- No test framework; manual check for `"Happy landing"` in output.
- `test/ethylene.out` is a stale reference output from an older version.
