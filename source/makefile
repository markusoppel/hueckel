########################################################################
# This file is part of Hueckel.                                        #
#                                                                      #
# Hueckel is free software; you can redistribute it and/or modify      #
# it under the terms of the GNU Lesser General Public License, v. 2.1. #
# Hueckel is distributed in the hope that it will be useful, but it    #
# is provided "as is" and without any express or implied warranties.   #
# For more details see the full text of the license in the file        #
# LICENSE or in <http://www.gnu.org/licenses/>.                        #
########################################################################

# Fortran compiler and flags
FC= gfortran
#FOPT=    -fpp -O2  -g -qopenmp -mkl
FOPT= -O2  
# LAPACK/BLAS for dsyev
LIB=-llapack -lblas

# Object file dependencies
OBJ= hueckel.o  readinput.o writeresult.o writemolden.o global.o molecule.o

# Link target: combine all objects with LAPACK/BLAS
hueckel.x: $(OBJ)
	$(FC) $(FOPT) -o $@ $(OBJ) $(LIB) 

# Generic Fortran compilation; requires compiled module files
%.o: %.f90 global.mod molecule.mod
	$(FC)  $(FOPT) -c $<

# molecule.mod depends on global.mod (uses 'use global')
molecule.mod: molecule.f90 global.mod
	$(FC) -c $<

# global.mod has no module dependencies
global.mod: global.f90
	$(FC) -c $<

clean:
	rm -rf *.o *.x *.mod

