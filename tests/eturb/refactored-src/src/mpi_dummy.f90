module singleton_module_src_mpi_dummy

contains

      subroutine mpi_allreduce(data1,data2,n,datatype,operation,comm,ierror)
      implicit none
      integer, parameter :: mpi_comm_world=0
      integer, parameter :: mpi_failure=1
      integer, parameter :: mpi_success=0
      integer, parameter :: mpi_status_size=3
      integer, parameter :: mpi_source=1
      integer, parameter :: mpi_tag=2
      integer, parameter :: mpi_count=3
      integer, dimension(1:mpi_status_size) :: mpi_status_ignore
      integer, parameter :: mpi_info_null=0
      integer, parameter :: mpi_any_source=-1
      integer, parameter :: mpi_any_tag=-1
      integer, parameter :: mpi_integer=1
      integer, parameter :: mpi_integer8=6
      integer, parameter :: mpi_real=2
      integer, parameter :: mpi_double_precision=3
      integer, parameter :: mpi_logical=4
      integer, parameter :: mpi_character=5
      integer, parameter :: mpi_byte=1
      integer, parameter :: mpi_sum=1
      integer, parameter :: mpi_max=2
      integer, parameter :: mpi_min=3
      integer, parameter :: mpi_product=4
      real(kind=8) :: mpi_wtime
      integer, parameter :: mpi_mode_create=1
      integer, parameter :: mpi_mode_rdonly=2
      integer, parameter :: mpi_mode_wronly=4
      integer, intent(In) :: n
      integer :: comm
      integer, dimension(1:n), intent(In) :: data1
      integer, dimension(1:n), intent(InOut) :: data2
      integer, intent(In) :: datatype
      integer, intent(InOut) :: ierror
      integer, intent(In) :: operation
      ierror = mpi_success
      if ( datatype  ==  mpi_double_precision ) then
        call mpi_reduce_double_precision (     data1, data2, n, operation, ierror )
      else if ( datatype  ==  mpi_integer ) then
        call mpi_reduce_integer (     data1, data2, n, operation, ierror )
      else if ( datatype  ==  mpi_integer8 ) then
        call mpi_reduce_integer8(     data1, data2, n, operation, ierror )
      else if ( datatype  ==  mpi_real ) then
        call mpi_reduce_real (     data1, data2, n, operation, ierror )
      else
        ierror = mpi_failure
      end if
      return
      end subroutine mpi_allreduce
      subroutine mpi_barrier(comm,ierror)
      implicit none
      integer :: comm
      integer, intent(Out) :: ierror
      integer, parameter :: mpi_failure=1
      integer, parameter :: mpi_success=0
      ierror = mpi_failure
      return
      end subroutine mpi_barrier
      subroutine mpi_finalize(ierror)
      implicit none
      integer, intent(Out) :: ierror
      integer, parameter :: mpi_failure=1
      integer, parameter :: mpi_success=0
      ierror = mpi_success
      return
      end subroutine mpi_finalize
      subroutine mpi_reduce_double_precision(data1,data2,n,operation,ierror)
      implicit none
      integer, parameter :: mpi_comm_world=0
      integer, parameter :: mpi_failure=1
      integer, parameter :: mpi_success=0
      integer, parameter :: mpi_status_size=3
      integer, parameter :: mpi_source=1
      integer, parameter :: mpi_tag=2
      integer, parameter :: mpi_count=3
      integer, dimension(1:mpi_status_size) :: mpi_status_ignore
      integer, parameter :: mpi_info_null=0
      integer, parameter :: mpi_any_source=-1
      integer, parameter :: mpi_any_tag=-1
      integer, parameter :: mpi_integer=1
      integer, parameter :: mpi_integer8=6
      integer, parameter :: mpi_real=2
      integer, parameter :: mpi_double_precision=3
      integer, parameter :: mpi_logical=4
      integer, parameter :: mpi_character=5
      integer, parameter :: mpi_byte=1
      integer, parameter :: mpi_sum=1
      integer, parameter :: mpi_max=2
      integer, parameter :: mpi_min=3
      integer, parameter :: mpi_product=4
      real(kind=8) :: mpi_wtime
      integer, parameter :: mpi_mode_create=1
      integer, parameter :: mpi_mode_rdonly=2
      integer, parameter :: mpi_mode_wronly=4
      integer, intent(In) :: n
      real(kind=8), dimension(1:n), intent(In) :: data1
      real(kind=8), dimension(1:n), intent(Out) :: data2
      integer :: i
      integer, intent(Out) :: ierror
      integer :: operation
      ierror = mpi_success
      do i = 1, n
        data2(i) = data1(i)
      end do
      return
      end subroutine mpi_reduce_double_precision
      subroutine mpi_reduce_integer8(data1,data2,n,operation,ierror)
      implicit none
      integer, parameter :: mpi_comm_world=0
      integer, parameter :: mpi_failure=1
      integer, parameter :: mpi_success=0
      integer, parameter :: mpi_status_size=3
      integer, parameter :: mpi_source=1
      integer, parameter :: mpi_tag=2
      integer, parameter :: mpi_count=3
      integer, dimension(1:mpi_status_size) :: mpi_status_ignore
      integer, parameter :: mpi_info_null=0
      integer, parameter :: mpi_any_source=-1
      integer, parameter :: mpi_any_tag=-1
      integer, parameter :: mpi_integer=1
      integer, parameter :: mpi_integer8=6
      integer, parameter :: mpi_real=2
      integer, parameter :: mpi_double_precision=3
      integer, parameter :: mpi_logical=4
      integer, parameter :: mpi_character=5
      integer, parameter :: mpi_byte=1
      integer, parameter :: mpi_sum=1
      integer, parameter :: mpi_max=2
      integer, parameter :: mpi_min=3
      integer, parameter :: mpi_product=4
      real(kind=8) :: mpi_wtime
      integer, parameter :: mpi_mode_create=1
      integer, parameter :: mpi_mode_rdonly=2
      integer, parameter :: mpi_mode_wronly=4
      integer, intent(In) :: n
      integer(kind=8), dimension(1:n), intent(In) :: data1
      integer(kind=8), dimension(1:n), intent(Out) :: data2
      integer :: i
      integer, intent(Out) :: ierror
      integer :: operation
      ierror = mpi_success
      do i = 1, n
         data2(i) = data1(i)
      end do
      ierror = mpi_failure
      return
      end subroutine mpi_reduce_integer8
      subroutine mpi_reduce_integer(data1,data2,n,operation,ierror)
      implicit none
      integer, parameter :: mpi_comm_world=0
      integer, parameter :: mpi_failure=1
      integer, parameter :: mpi_success=0
      integer, parameter :: mpi_status_size=3
      integer, parameter :: mpi_source=1
      integer, parameter :: mpi_tag=2
      integer, parameter :: mpi_count=3
      integer, dimension(1:mpi_status_size) :: mpi_status_ignore
      integer, parameter :: mpi_info_null=0
      integer, parameter :: mpi_any_source=-1
      integer, parameter :: mpi_any_tag=-1
      integer, parameter :: mpi_integer=1
      integer, parameter :: mpi_integer8=6
      integer, parameter :: mpi_real=2
      integer, parameter :: mpi_double_precision=3
      integer, parameter :: mpi_logical=4
      integer, parameter :: mpi_character=5
      integer, parameter :: mpi_byte=1
      integer, parameter :: mpi_sum=1
      integer, parameter :: mpi_max=2
      integer, parameter :: mpi_min=3
      integer, parameter :: mpi_product=4
      real(kind=8) :: mpi_wtime
      integer, parameter :: mpi_mode_create=1
      integer, parameter :: mpi_mode_rdonly=2
      integer, parameter :: mpi_mode_wronly=4
      integer, intent(In) :: n
      integer, dimension(1:n), intent(In) :: data1
      integer, dimension(1:n), intent(Out) :: data2
      integer :: i
      integer, intent(Out) :: ierror
      integer :: operation
      ierror = mpi_success
      do i = 1, n
         data2(i) = data1(i)
      end do
      ierror = mpi_failure
      return
      end subroutine mpi_reduce_integer
      subroutine mpi_reduce_real(data1,data2,n,operation,ierror)
      implicit none
      integer, parameter :: mpi_comm_world=0
      integer, parameter :: mpi_failure=1
      integer, parameter :: mpi_success=0
      integer, parameter :: mpi_status_size=3
      integer, parameter :: mpi_source=1
      integer, parameter :: mpi_tag=2
      integer, parameter :: mpi_count=3
      integer, dimension(1:mpi_status_size) :: mpi_status_ignore
      integer, parameter :: mpi_info_null=0
      integer, parameter :: mpi_any_source=-1
      integer, parameter :: mpi_any_tag=-1
      integer, parameter :: mpi_integer=1
      integer, parameter :: mpi_integer8=6
      integer, parameter :: mpi_real=2
      integer, parameter :: mpi_double_precision=3
      integer, parameter :: mpi_logical=4
      integer, parameter :: mpi_character=5
      integer, parameter :: mpi_byte=1
      integer, parameter :: mpi_sum=1
      integer, parameter :: mpi_max=2
      integer, parameter :: mpi_min=3
      integer, parameter :: mpi_product=4
      real(kind=8) :: mpi_wtime
      integer, parameter :: mpi_mode_create=1
      integer, parameter :: mpi_mode_rdonly=2
      integer, parameter :: mpi_mode_wronly=4
      integer, intent(In) :: n
      real, dimension(1:n), intent(In) :: data1
      real, dimension(1:n), intent(Out) :: data2
      integer :: i
      integer, intent(Out) :: ierror
      integer :: operation
      ierror = mpi_success
        do i = 1, n
          data2(i) = data1(i)
        end do
      return
      end subroutine mpi_reduce_real
      real(kind=8) function mpi_wtime()
      implicit none
      real(kind=4), dimension(1:2) :: a
      real(kind=4) :: etime
      a(1)=0.0
      a(2)=0.0
      mpi_wtime = etime(a)
      return
      end function mpi_wtime

end module singleton_module_src_mpi_dummy

