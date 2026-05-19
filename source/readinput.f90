! Reads XYZ-format molecular geometry from a file.
! First line: number of atoms. Second line: title.
! Subsequent lines: element symbol + x y z coordinates (Angstrom).
subroutine readinput(fname, title)
use global
use molecule
implicit none

character(len=*),intent(in)::fname
character(len=80)::title

integer i

open(unit=11, file=fname, status='old', action='read')
read(11,*) molecel%natoms
read(11,*) title
do i=1,molecel%natoms
        read(11,*) molecel%atoms(i)%element,molecel%atoms(i)%coordinates(1:3)
enddo
close(11)

return
end subroutine readinput

