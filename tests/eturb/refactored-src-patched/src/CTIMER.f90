module CTIMER
      real(kind=8          ) :: tmxmf
      real(kind=8          ) :: tmxms
      real(kind=8          ) :: tdsum
      real(kind=8          ) :: taxhm
      real(kind=8          ) :: tcopy
      real(kind=8          ) :: tinvc
      real(kind=8          ) :: tinv3
      real(kind=8          ) :: tinit
      real(kind=8          ) :: tadc3
      real(kind=8          ) :: tcol3
      real(kind=8          ) :: ta2s2
      real(kind=8          ) :: tcol2
      real(kind=8          ) :: tadd2
      real(kind=8          ) :: tsolv
      real(kind=8          ) :: tgsum
      real(kind=8          ) :: tdsnd
      real(kind=8          ) :: tdadd
      real(kind=8          ) :: tcdtp
      real(kind=8          ) :: tmltd
      real(kind=8          ) :: tprep
      real(kind=8          ) :: tpres
      real(kind=8          ) :: thmhz
      real(kind=8          ) :: tgop
      real(kind=8          ) :: tgop1
      real(kind=8          ) :: tdott
      real(kind=8          ) :: tbsol
      real(kind=8          ) :: tbso2
      real(kind=8          ) :: tsett
      real(kind=8          ) :: tslvb
      real(kind=8          ) :: tusbc
      real(kind=8          ) :: tddsl
      real(kind=8          ) :: tcrsl
      real(kind=8          ) :: tdsmx
      real(kind=8          ) :: tdsmn
      real(kind=8          ) :: tgsmn
      real(kind=8          ) :: tgsmx
      real(kind=8          ) :: teslv
      real(kind=8          ) :: tbbbb
      real(kind=8          ) :: tcccc
      real(kind=8          ) :: tdddd
      real(kind=8          ) :: teeee
      real(kind=8          ) :: tvdss
      real(kind=8          ) :: tschw
      real(kind=8          ) :: tadvc
      real(kind=8          ) :: tspro
      real(kind=8          ) :: tgop_sync
      real(kind=8          ) :: tsyc
      real(kind=8          ) :: twal
      real(kind=8          ) :: tgp2
      real(kind=8          ) :: tcvf
      real(kind=8          ) :: tproj
      real(kind=8          ) :: tusfq
      integer :: nmxmf
      integer :: nmxms
      integer :: ndsum
      integer :: naxhm
      integer :: ncopy
      integer :: ninvc
      integer :: ninv3
      integer :: nsolv
      integer :: ngsum
      integer :: ndsnd
      integer :: ndadd
      integer :: ncdtp
      integer :: nmltd
      integer :: nprep
      integer :: npres
      integer :: nhmhz
      integer :: ngop
      integer :: ngop1
      integer :: ndott
      integer :: nbsol
      integer :: nbso2
      integer :: nsett
      integer :: nslvb
      integer :: nusbc
      integer :: nddsl
      integer :: ncrsl
      integer :: ndsmx
      integer :: ndsmn
      integer :: ngsmn
      integer :: ngsmx
      integer :: neslv
      integer :: nbbbb
      integer :: ncccc
      integer :: ndddd
      integer :: neeee
      integer :: nvdss
      integer :: nadvc
      integer :: nspro
      integer :: ngop_sync
      integer :: nsyc
      integer :: nwal
      integer :: ngp2
      integer :: ncvf
      real(kind=8          ) :: pmxmf
      real(kind=8          ) :: pmxms
      real(kind=8          ) :: pdsum
      real(kind=8          ) :: paxhm
      real(kind=8          ) :: pcopy
      real(kind=8          ) :: pinvc
      real(kind=8          ) :: pinv3
      real(kind=8          ) :: psolv
      real(kind=8          ) :: pgsum
      real(kind=8          ) :: pdsnd
      real(kind=8          ) :: pdadd
      real(kind=8          ) :: pcdtp
      real(kind=8          ) :: pmltd
      real(kind=8          ) :: pprep
      real(kind=8          ) :: ppres
      real(kind=8          ) :: phmhz
      real(kind=8          ) :: pgop
      real(kind=8          ) :: pgop1
      real(kind=8          ) :: pdott
      real(kind=8          ) :: pbsol
      real(kind=8          ) :: pbso2
      real(kind=8          ) :: psett
      real(kind=8          ) :: pslvb
      real(kind=8          ) :: pusbc
      real(kind=8          ) :: pddsl
      real(kind=8          ) :: pcrsl
      real(kind=8          ) :: pdsmx
      real(kind=8          ) :: pdsmn
      real(kind=8          ) :: pgsmn
      real(kind=8          ) :: pgsmx
      real(kind=8          ) :: peslv
      real(kind=8          ) :: pbbbb
      real(kind=8          ) :: pcccc
      real(kind=8          ) :: pdddd
      real(kind=8          ) :: peeee
      real(kind=8          ) :: pvdss
      real(kind=8          ) :: pspro
      real(kind=8          ) :: pgop_sync
      real(kind=8          ) :: psyc
      real(kind=8          ) :: pwal
      real(kind=8          ) :: pgp2
      real(kind=8 ) :: etime1
      real(kind=8 ) :: etime2
      real(kind=8 ) :: etime0
      real(kind=8 ) :: gtime1
      real(kind=8 ) :: tscrtch

      real(kind=8 ) :: dnekclock
      real(kind=8 ) :: dnekclock_sync
      real(kind=8          ) :: etimes
      real(kind=8          ) :: ttotal
      real(kind=8          ) :: tttstp
      real(kind=8          ) :: etims0
      real(kind=8          ) :: ttime
      integer :: icalld
      save    icalld
      data icalld / 0 / 

      logical :: ifsync

end module CTIMER
