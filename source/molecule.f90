! Molecule module: defines atom/molecule types and holds the global molecule instance.
module molecule
use global

! A single atom: element label and 3-D Cartesian coordinates (Angstrom).
type atom
        character(len=2)::element
        real(kind=8),dimension(3)::coordinates
end type atom

! Collection of atoms forming the molecule.
type molec
        integer::natoms
        type(atom),dimension(maxatoms)::atoms
end type molec

! Global molecule state, read by readinput and used everywhere.
type(molec)::molecel

contains

! Euclidean distance between atoms i and j in the global molecule.
real(kind=8) function rij(i,j)
implicit none

integer,intent(in)::i,j

real(kind=8),dimension(3)::dij

dij=molecel%atoms(i)%coordinates-molecel%atoms(j)%coordinates
rij=sqrt(dot_product(dij,dij))

return
end function rij

end module molecule
