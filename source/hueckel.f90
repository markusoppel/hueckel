! Hueckel theory driver: reads molecule from <molecule>.xyz, builds the
! Hueckel matrix, diagonalizes, and writes <molecule>.out + <molecule>.molden.
program hueckel
use global
use molecule
implicit none

integer :: natoms
integer :: ncarbon,jcarbon
character(len=80)::title
character(len=8) :: date_str
character(len=10) :: time_str

character(len=256) :: inputfile, outputfile, moldenfile, basename
integer :: argc, idx

! Hueckel matrix (maxatomsxmaxatoms, only carbon sub-block is filled)
real(kind=8),dimension(maxatoms,maxatoms)::hmatrix=0.0
! Eigenvalues from diagonalisation
real(kind=8),dimension(maxatoms)::eigval

! Hueckel parameters: alpha (on-site), beta (hopping), bond cutoff (Angstrom)
real(kind=8)::alpha,beta
real(kind=8)::dmax

integer::i,j

! LAPACK dsyev workspace
integer::info
integer,parameter::lwork=3*maxatoms-1
real(kind=8)::work(lwork)

! Get input filename from command line
argc = command_argument_count()
if (argc < 1) then
  write(0,*) "Usage: hueckel.x <molecule>.xyz"
  stop
endif
call get_command_argument(1, inputfile)

! Extract basename by stripping .xyz extension
idx = index(inputfile, '.xyz', back=.true.)
if (idx > 0) then
  basename = inputfile(1:idx-1)
else
  basename = inputfile
endif

outputfile = trim(basename) // '.out'
moldenfile = trim(basename) // '.molden'

! Standard Hueckel parameters for hydrocarbons
alpha=0.0
beta=-1.0
dmax=1.5
ncarbon=0

call readinput(trim(inputfile), title)

call date_and_time(date=date_str, time=time_str)
print *,"Hueckel started ",date_str(1:4),"-",date_str(5:6),"-",date_str(7:8), &
        " at ",time_str(1:2),":",time_str(3:4),":",time_str(5:10)
print *

! Build the Hueckel matrix over carbon atoms only.
! ncarbon counts carbons; the matrix is indexed 1..ncarbon.
! jcarbon tracks the column index for neighbour candidates.
do i=1,molecel%natoms
 if (molecel%atoms(i)%element.eq."C") then
 ncarbon=ncarbon+1
 jcarbon=ncarbon
 hmatrix(ncarbon,ncarbon)=alpha
 do j=i+1,molecel%natoms
    if (molecel%atoms(i)%element.eq."C") then
       jcarbon=jcarbon+1
       if (rij(i,j).le.dmax) then
               hmatrix(ncarbon,jcarbon)=beta
               hmatrix(jcarbon,ncarbon)=hmatrix(ncarbon,jcarbon)
         endif
        endif
  enddo
 endif        
enddo 

! Diagonalize the ncarbonxncarbon Hueckel matrix.
! dsyev('v','l',n,A,lda,W,work,lwork,info) computes all eigenvalues
! and eigenvectors of a real symmetric matrix A.
!   'v' = compute eigenvectors + eigenvalues
!   'l' = lower triangle stored
!   n   = order of the matrix (ncarbon)
!   A   = on entry the matrix, on exit eigenvectors in columns
!   lda = leading dimension (maxatoms)
!   W   = eigenvalues in ascending order
!   work/lwork = workspace array / size
!   info = 0 on success
call dsyev('v','l',ncarbon,hmatrix,maxatoms,eigval,work,lwork,info)

if (info.ne.0) then
write(0,*) "something went wrong the the diagonaliziation, error code:",info
stop
endif

call writeresult(trim(outputfile), title, hmatrix, eigval, ncarbon)
call writemolden(trim(moldenfile), title, hmatrix, eigval, ncarbon)

end program hueckel





