! Writes a Molden-format file containing atoms, GTO basis,
! and MO coefficients. Only the pz (third AO) per carbon carries the
! Hueckel coefficient; s/px/py for carbon and the s for H are set to zero.
subroutine writemolden(fname,title,hmatrix,eigval,ncarbon)
use global
use molecule
implicit none

character(len=*),intent(in)::fname
character(len=80)::title
real(kind=8),dimension(maxatoms,maxatoms)::hmatrix
real(kind=8),dimension(maxatoms)::eigval
integer::ncarbon

integer::i,imo,ao
! cmap maps full-atom index -> carbon-only index (1..ncarbon)
integer::cmap(maxatoms)

cmap=0
ao=0
do i=1,molecel%natoms
  if (molecel%atoms(i)%element.eq."C") then
    ao=ao+1
    cmap(i)=ao
  endif
enddo

open(10,file=fname,status="replace",action="write")

write(10,'(a)') "[Molden Format]"

! [Atoms] section: element, atom index, nuclear charge, x y z (Angstrom)
write(10,'(a)') "[Atoms] (Angs)"
do i=1,molecel%natoms
  if (molecel%atoms(i)%element.eq."H") then
    write(10,'(a,1x,i0,1x,i1,3(1x,f14.6))') "H",i,1,molecel%atoms(i)%coordinates
  else if (molecel%atoms(i)%element.eq."C") then
    write(10,'(a,1x,i0,1x,i1,3(1x,f14.6))') "C",i,6,molecel%atoms(i)%coordinates
  else if (molecel%atoms(i)%element.eq."N") then
    write(10,'(a,1x,i0,1x,i1,3(1x,f14.6))') "N",i,7,molecel%atoms(i)%coordinates
  else if (molecel%atoms(i)%element.eq."O") then
    write(10,'(a,1x,i0,1x,i1,3(1x,f14.6))') "O",i,8,molecel%atoms(i)%coordinates
  else
    write(10,'(a,1x,i0,1x,i1,3(1x,f14.6))') trim(adjustl(molecel%atoms(i)%element)),i,0,molecel%atoms(i)%coordinates
  endif
enddo

! [GTO] section: minimal basis - p-type for C, s-type for H and others.
write(10,'(a)') "[GTO]"
do i=1,molecel%natoms
  write(10,'(i0)') i
  if (molecel%atoms(i)%element.eq."C") then
    write(10,'(a)') "p 1 1.00"
    write(10,'(2f12.6)') 1.625d0,1.0d0
  else
    write(10,'(a)') "s 1 1.00"
    write(10,'(2f12.6)') 1.0d0,1.0d0
  endif
  write(10,*)
enddo

! [MO] section: each MO lists AO indices with coefficients.
! AO ordering: for each C atom, 3 AOs (px, py, pz) - only pz gets the
! Hueckel coefficient; for non-C, 1 AO (s) set to zero.
! Occupancy: 2 for lowest ncarbon/2 MOs (doubly occupied),
! 1 for a singly occupied non-bonding (odd carbon count), 0 for virtual.
write(10,'(a)') "[MO]"
do imo=1,ncarbon
  write(10,'(a,a)') "Sym= ","A"
  write(10,'(a,f12.6)') "Ene= ",eigval(imo)
  write(10,'(a,a)') "Spin= ","Alpha"
  if (imo.le.ncarbon/2) then
    write(10,'(a,i0)') "Occup= ",2
  else if (imo.eq.ncarbon/2+1.and.mod(ncarbon,2).eq.1) then
    write(10,'(a,i0)') "Occup= ",1
  else
    write(10,'(a,i0)') "Occup= ",0
  endif

  ao=0
  do i=1,molecel%natoms
    if (molecel%atoms(i)%element.eq."C") then
      ao=ao+1; write(10,'(i0,1x,f12.6)') ao,0.0d0  ! px
      ao=ao+1; write(10,'(i0,1x,f12.6)') ao,0.0d0  ! py
      ao=ao+1; write(10,'(i0,1x,f12.6)') ao,hmatrix(cmap(i),imo)  ! pz
    else
      ao=ao+1; write(10,'(i0,1x,f12.6)') ao,0.0d0  ! s
    endif
  enddo
enddo

close(10)
print *,"Molden file written: ",trim(fname)

return
end subroutine writemolden
