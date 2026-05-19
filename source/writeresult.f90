! Prints input geometry, Hueckel eigenvalues, and the Hueckel matrix to a file.
! The matrix and eigenvalues cover the carbon-only subspace (size ncarbon).
subroutine writeresult(fname,title,hmatrix,eigval,ncarbon)
use global
use molecule
implicit none

character(len=*),intent(in)::fname
integer::natoms,ncarbon
character(len=80)::title
real(kind=8),dimension(maxatoms,maxatoms)::hmatrix
real(kind=8),dimension(maxatoms)::eigval

integer::i

open(unit=12, file=fname, status='replace', action='write')

write(12,*) "Input structure"
write(12,*)
write(12,*) title
write(12,100)
do i=1,molecel%natoms
        write(12,200) i, molecel%atoms(i)%element,molecel%atoms(i)%coordinates(1:3)
enddo

write(12,*) "Eigenvalues"
write(12,*)
do i=1,ncarbon
        write(12,*) i, eigval(i)
enddo

write(12,*) "Hueckel matrix"
write(12,*)
do i=1,ncarbon
        write(12,*) i, hmatrix(i,1:ncarbon)
enddo

write(12,*)
write(12,*) "Happy landing"

100 format(X,'NATOM',X,'Element',3X,'X',9X,'Y',9X,'Z')
200 format(X,I3,4X,A2,3X,3F10.5)

close(12)

return
end subroutine writeresult
