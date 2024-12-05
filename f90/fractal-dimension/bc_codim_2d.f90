! Box-assisted algorithm
program boxcount
  implicit none

  ! constants
  real*8, parameter :: pi=2.d0*asin(1.d0)
  integer, parameter :: ndim=2  
  real*8, parameter :: xlx=2.d0*pi,xly=xlx
  ! parameters
  integer, parameter :: ifr1=6,ifr2=6,ndep=10
  integer, parameter :: nx=2048,ny=nx,nr=nx/2
  real*8, parameter :: dr=xlx/nr,rmin=0.5d0*dr
  ! variables
  real*8, allocatable :: xp(:,:)
  real*4, allocatable :: dumxp(:,:)
  real*8, dimension(nr) :: g,f
  real*8 :: dxp(ndim),r,scra,norm
  integer :: ifr,idep,nptot,npl
  integer :: i,j,k,ip,jp,ipl,ir,jr,icount
  character*80 :: filename

  nptot=0
  icount=0
  g=0.d0
  f=0.d0
  
  do ifr=ifr1,ifr2
     do idep=1,ndep
        
        write(filename,"('./Post/iso.'i3.3'.'i3.3)")ifr,idep
        open(unit=11,file=filename,form='unformatted')
        read(11)npl
        write(6,*)npl
        allocate(dumxp(ndim+1,npl),xp(ndim+1,npl))
        read(11)dumxp
        xp=dble(dumxp)
        close(11)
        deallocate(dumxp)  
        
        do ip=1,npl
           do jp=1,npl
              if (ip.eq.jp) cycle
              dxp(:)=dabs(xp(:,ip)-xp(:,jp))
              r=dsqrt(dxp(1)**2.+dxp(2)**2.)
              ir=int((r-rmin)/dr)+1
              if ((ir.ge.1).and.(ir.le.nr)) then
                 icount=icount+1
                 f(ir)=f(ir)+1.d0
                 do jr=ir,nr
                    g(jr)=g(jr)+1.d0
                 enddo
              endif
           enddo
        enddo
        
        ! sum points
        nptot=nptot+npl
        
        deallocate(xp)
        
     enddo
  enddo

  ! normalization of g(r)
  norm=real(ifr2-ifr1+1)*dble(icount)
  g(:)=g(:)/norm

  ! normalization of f(r)
  norm=0.d0
  do ir=1,nr
     norm=norm+dr*f(ir)
  enddo
  f(:)=f(:)/norm

  write(filename,"('./Post/codim.dat')")
  open(unit=100,file=filename,status='unknown')  
  do ir=1,nr
     r=dr*dble(ir-1)+rmin
     write(100,99)real(r),real(g(ir)),real(f(ir))
  end do
  close(100)
  
99 format(4g)

end program boxcount
! rebox
function gp(x,dx,xl)
  implicit none
  real*8 x,dx,xl,gp
  
  gp=x+dx
  
10 if (gp.lt.0.d0) then
     gp=gp+xl
     goto 10
  end if
  
20 if (gp.ge.xl) then
     gp=gp-xl
     goto 20
  end if
  
  return
end function gp
