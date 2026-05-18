subroutine writemolden(title,hmatrix,eigval,ncarbon)
use global
use molecule
implicit none

character(len=80)::title
real(kind=8),dimension(maxatoms,maxatoms)::hmatrix
real(kind=8),dimension(maxatoms)::eigval
integer::ncarbon

integer::i,imo,ao
integer::cmap(maxatoms)

cmap=0
ao=0
do i=1,molecel%natoms
  if (molecel%atoms(i)%element.eq."C") then
    ao=ao+1
    cmap(i)=ao
  endif
enddo

open(10,file="hueckel.molden",status="replace",action="write")

write(10,'(a)') "[Molden Format]"

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
      ao=ao+1; write(10,'(i0,1x,f12.6)') ao,0.0d0
      ao=ao+1; write(10,'(i0,1x,f12.6)') ao,0.0d0
      ao=ao+1; write(10,'(i0,1x,f12.6)') ao,hmatrix(cmap(i),imo)
    else
      ao=ao+1; write(10,'(i0,1x,f12.6)') ao,0.0d0
    endif
  enddo
enddo

close(10)
print *,"Molden file written: hueckel.molden"

return
end subroutine writemolden
