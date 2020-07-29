! -----------------------------------------------------------------------
! > @defgroup dabl  Dummy ABL case user-file
! > (c) 2020 Wim Vanderbauwhede      
! > Contains:
! >
! >  - user specified routines:
! >     - userchk : general purpose routine for checking errors etc. 
! > This is a dummy, not the actual code as that is not Open Source
! >
! > @{
! ----------------------------------------------------------------------
!  drive flow with pressure gradient
! -----------------------------------------------------------------------
module singleton_module_src_dabl

      use singleton_module_src_math
      use singleton_module_src_navier5
      use singleton_module_src_postpro
contains

      subroutine userchk(ab,abmsh,abx1,abx2,aby1,aby2,abz1,abz2,area,atol,avdiff,avtran,b1ia1, &
      b1ia1t,b1mask,b2mask,b2p,b3mask,base_flow,baxm1,bbx1,bbx2,bby1,bby2,bbz1,bbz2,bc,bcf,bctyps, &
      bd,bdivw,bfx,bfxp,bfy,bfyp,bfz,bfzp,bintm1,binvdg,binvm1,bm1,bm1lag,bm2,bm2inv,bmass,bmnv, &
      bmx,bmy,bmz,bpmask,bq,bqp,bx,bxlag,bxyi,by,bylag,bz,bzlag,c_vx,cbc,ccurve,cdof,cerror,cflf, &
      courno,cpfld,cpgrp,cr_h,cr_re2,cs,csize,ctarg,curve,d1,d1t,d2,da,dam1,dam12,dam3,dat,datm1, &
      datm12,datm3,dcm1,dcm12,dcm3,dcount,dct,dctm1,dctm12,dctm3,dg2,dg_face,dg_hndlx,dglg,dglgt, &
      dgtq,dlam,dmpfle,domain_length,dp0thdt,dpdx_mean,dpdy_mean,dpdz_mean,dragpx,dragpy,dragpz, &
      dragvx,dragvy,dragvz,dragx,dragy,dragz,drivc,dt,dtinit,dtinvm,dtlag,dvdfh1,dvdfl2,dvdfl8, &
      dvdfsm,dvnnh1,dvnnl2,dvnnl8,dvnnsm,dvprh1,dvprl2,dvprl8,dvprsm,dxm1,dxm12,dxm3,dxtm1,dxtm12, &
      dxtm3,dym1,dym12,dym3,dytm1,dytm12,dytm3,dzm1,dzm12,dzm3,dztm1,dztm12,dztm3,ediff,eface, &
      eface1,eigaa,eigae,eigas,eigast,eigga,eigge,eiggs,eiggst,eigp,eskip,etalph,etimes,etims0, &
      ev1,ev2,ev3,exx1p,exx2p,exy1p,exy2p,exz1p,exz2p,ffx_new,ffy_new,ffz_new,fh_re2,filtertype, &
      fintim,fldfle,flow_rate,fw,g1m1,g2m1,g3m1,g4m1,g5m1,g6m1,gamma0,gcnnum,gednum,gedtyp,gllel, &
      gllnid,group,gsh,gsh_fld,gtp_cbc,hcode,hisfle,iajl1,iajl2,ialj1,ialj3,iam12,iam13,iam21, &
      iam31,iatjl1,iatjl2,iatlj1,iatlj3,iatm12,iatm13,iatm21,iatm31,ibcsts,icall,icedg,icface, &
      icm12,icm13,icm21,icm31,ictm12,ictm13,ictm21,ictm31,idpss,idsess,ieact,iedge,iedgef,iedgfc, &
      iesolv,if3d,if_full_pres,ifaa,ifadvc,ifae,ifalgn,ifanl2,ifanls,ifas,ifast,ifaxis,ifaziv, &
      ifbase,ifbcor,ifbo,ifchar,ifcons,ifcoup,ifcvfld,ifcvode,ifcyclic,ifdeal,ifdg,ifdgfld,ifdiff, &
      ifdp0dt,ifemat,ifeppm,ifessr,ifexplvis,ifextr,ifexvt,ifflow,iffmtin,ifga,ifge,ifgeom,ifgfdm, &
      ifgmsh3,ifgprnt,ifgs,ifgsh_fld_same,ifgst,ifgtp,ifheat,ifield,ifintq,ifkeps,ifldmhd,iflmsc, &
      iflmse,iflmsf,iflomach,ifmelt,ifmgrid,ifmhd,ifmoab,ifmodel,ifmodp,ifmpiio,ifmscr,ifmseg, &
      ifmsfc,ifmvbd,ifneknek,ifneknekm,ifnonl,ifnskp,ifoutfld,ifpert,ifpo,ifprnt,ifprojfld,ifpsco, &
      ifpso,ifqinp,ifreguo,ifrich,ifrsxy,ifrzer,ifschclob,ifskip,ifsplit,ifssvt,ifstrs,ifstst, &
      ifsurt,ifsync,iftgo,iftmsh,ifto,iftran,ifusermv,ifuservp,ifvarp,ifvcor,ifvcoup,ifvo,ifvps, &
      ifwcno,ifxyo,ifxyo_,ifycrv,ifzper,iggl,igglt,igroup,im1d,im1dt,imatie,imd1,imd1t,imesh, &
      ind23,indx,initc,instep,invedg,iocomm,ioinfodmp,iostep,ipscal,ipsco,irstim,irstt,irstv, &
      isize,istep,ixcn,ixm12,ixm13,ixm21,ixm31,ixtm12,ixtm13,ixtm21,ixtm31,iym12,iym13,iym21, &
      iym31,iytm12,iytm13,iytm21,iytm31,izm12,izm13,izm21,izm31,iztm12,iztm13,iztm21,iztm31,jacm1, &
      jacm2,jacmi,jp,lastep,lcnnum,ldimr,lednum,lex2pst,lglel,lochis,loglevel,lsize,lyap,matids, &
      matindx,matype,maxmlt,mcex,mlp,mpi_argv_null,mpi_argvs_null,mpi_bottom,mpi_errcodes_ignore, &
      mpi_in_place,mpi_status_ignore,mpi_statuses_ignore,mpi_unweighted,mpi_weights_empty,msg_id, &
      msp,nab,nabmsh,nadvc,naxhm,nbbbb,nbd,nbdinp,nbso2,nbsol,ncall,ncccc,ncdtp,ncmp,nconv, &
      nconv_max,ncopy,ncrsl,ncvf,ndadd,ndddd,nddsl,ndg_facex,ndim,ndott,ndsmn,ndsmx,ndsnd,ndsum, &
      neact,nedg,neeee,neigx,neigy,neigz,nekcomm,nekgroup,nekreal,nelfld,nelg,nelgt,nelgv,nelt, &
      nelv,nelx,nelxy,nely,nelz,neslv,nfield,ngcomm,ngeom,ngfdm_p,ngfdm_v,ngop,ngop1,ngop_sync, &
      ngp2,ngsmn,ngsmx,ngspcn,ngsped,ngsum,nhis,nhmhz,nid,ninter,ninv3,ninvc,nio,nktonv,nmember, &
      nmlinv,nmltd,nmxe,nmxh,nmxmf,nmxms,nmxnl,nmxp,nobj,node,node0,noffst,nomlis,np,npert,nprep, &
      npres,npscal,nrefle,nrout,nsett,nslvb,nsolv,nspmax,nspro,nsskip,nsteps,nsyc,ntaubd,nu_star, &
      nullpid,numbcs,numflu,numoth,numscn,numsed,nusbc,nvdss,nvtot,nwal,nx1,nx2,nx3,nxd,ny1,ny2, &
      ny3,nyd,nz1,nz2,nz3,nzd,object,ocode,omask,optlevel,orefle,p0th,param,parfle,part_in, &
      part_out,path,paxhm,pbbbb,pbso2,pbsol,pcccc,pcdtp,pcopy,pcrsl,pdadd,pdddd,pddsl,pdott,pdsmn, &
      pdsmx,pdsnd,pdsum,peeee,peslv,pgop,pgop1,pgop_sync,pgp2,pgsmn,pgsmx,pgsum,phmhz,pi,pid, &
      pinv3,pinvc,pm,pm1,pmask,pmd1,pmd1t,pmlag,pmltd,pmxmf,pmxms,pprep,ppres,pr,prelax,prlag, &
      prlagp,prp,psett,pslvb,psolv,pspro,pst2lex,psyc,pusbc,pvalx,pvaly,pvalz,pvdss,pvecx,pvecy, &
      pvecz,pwal,qinteg,qtl,rct,re2fle,re2off_b,reafle,restol,rname,rstim,rstt,rstv,rx,rx2,rxm1, &
      rxm2,ry2,rym1,rym2,rzm1,rzm2,scale_vf,schfle,session,sij,skpdat,snrm,solver_type,sp,spt,sx2, &
      sxm1,sxm2,sy2,sym1,sym2,szm1,szm2,t,t1x,t1y,t1z,t2x,t2y,t2z,ta2s2,tadc3,tadd2,tadvc,tauss, &
      taxhm,tbbbb,tbso2,tbsol,tcccc,tcdtp,tcol2,tcol3,tcopy,tcrsl,tcvf,tdadd,tdddd,tddsl,tdott, &
      tdsmn,tdsmx,tdsnd,tdsum,teeee,teslv,textsw,tgop,tgop1,tgop_sync,tgp2,tgsmn,tgsmx,tgsum, &
      thmhz,time,timef,timeio,tinit,tinv3,tinvc,tlag,tlagp,tmask,tmean,tmltd,tmult,tmxmf,tmxms, &
      tnrmh1,tnrml2,tnrml8,tnrmsm,tolabs,tolev,tolhdf,tolhe,tolhr,tolhs,tolht,tolhv,tolnl,tolpdf, &
      tolps,tolrel,torqpx,torqpy,torqpz,torqvx,torqvy,torqvz,torqx,torqy,torqz,tp,tpn1,tpn2,tpn3, &
      tprep,tpres,tproj,trx,trz,tschw,tsett,tslvb,tsolv,tspro,tsyc,ttime,ttotal,tttstp,tusbc, &
      tusfq,tvdss,twal,txm1,txm2,txnext,tym1,tym2,tzm1,tzm2,unr,uns,unt,unx,uny,unz,uparam,ur,us, &
      usrdiv,ut,v1mask,v1x,v1y,v1z,v2mask,v2x,v2y,v2z,v3mask,vdiff,vdiff_e,vgradt1,vgradt1p, &
      vgradt2,vgradt2p,vmean,vmult,vnekton,vnrmh1,vnrml2,vnrml8,vnrmsm,vnx,vny,vnz,volel,volfld, &
      voltm1,voltm2,volvm1,volvm2,vr,vs,vt,vtrans,vx,vx_e,vxd,vxlag,vxlagp,vxp,vy,vy_e,vyd,vylag, &
      vylagp,vyp,vz,vz_e,vzd,vzlag,vzlagp,vzp,w1mask,w2am1,w2am2,w2am3,w2cm1,w2cm2,w2cm3,w2d, &
      w2mask,w3m1,w3m2,w3m3,w3mask,wam1,wam2,wam3,wavep,wdsize,wdsizi,wgl,wgl1,wgl2,wglg,wglgt, &
      wgli,wgp,wmult,wr,ws,wt,wx,wxlag,wxm1,wxm2,wxm3,wy,wylag,wym1,wym2,wym3,wz,wzlag,wzm1,wzm2, &
      wzm3,xc,xgtp,xm0,xm1,xm2,xmlt,xsec,xxth,yc,ygtp,yinvm1,ym0,ym1,ym2,ymlt,zam1,zam2,zam3,zc, &
      zgl,zgm1,zgm2,zgm3,zgp,zgtp,zm0,zm1,zm2,zmlt)
!       implicit none
      implicit none
      integer, parameter :: ldim=3
      integer, parameter :: lx1=8
      integer, parameter :: lxd=12
      integer, parameter :: lx2=lx1-2
      integer, parameter :: lelg=30*20*24
      integer, parameter :: lpmin=12
      integer, parameter :: lpmax=1024
      integer, parameter :: ldimt=1
      integer, parameter :: ldimt_proj=1
      integer, parameter :: lhis=1000
      integer, parameter :: maxobj=4
      integer, parameter :: lpert=1
      integer, parameter :: toteq=5
      integer, parameter :: nsessmax=2
      integer, parameter :: lxo=lx1
      integer, parameter :: mxprev=20
      integer, parameter :: lgmres=30
      integer, parameter :: lorder=3
      integer, parameter :: lx1m=lx1
      integer, parameter :: lfdm=0
      integer, parameter :: lelx=1
      integer, parameter :: lely=1
      integer, parameter :: lelz=1
      integer, parameter :: lelt=lelg/lpmin+3
      integer, parameter :: lbelt=1
      integer, parameter :: lpelt=1
      integer, parameter :: lcvelt=lelt
! 
!      Include file to dimension static arrays
!      and to set some hardwired run-time parameters
! 
      ! basic
      ! optional
      ! internals
!  - - SIZE internals
      ! averaging
      ! adjoint
      ! mhd
      real, dimension(1:1) :: ediff_copy
      real, dimension(1:lxyz,1:1) :: gradux_gradm1
      real, dimension(1:lxyz,1:1) :: graduy_gradm1
      real, dimension(1:lxyz,1:1) :: graduz_gradm1
      real, dimension(1:lx1*ly1*lz1*6*lelv) :: sij_torque_calc
      real, dimension(1:1) :: t_copy
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: trx_torque_calc
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: trz_torque_calc
      real, dimension(1:lxyz,1:1) :: vx_gradm1
      real, dimension(1:3) :: x0_rzero
      integer, parameter :: lr=lx1*ly1*lz1
      integer, parameter :: lxyz=lx1*ly1*lz1
      real :: base_flow
      real, dimension(1:lx1*ly1*lz1,1:lelv) :: cs
      real(kind=8), intent(InOut) :: dcount
            integer, parameter :: maxrts=1000
      real(kind=8), dimension(1:maxrts), intent(InOut) :: dct
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: dg2
      real, dimension(1:3,1:4), intent(InOut) :: dgtq
      real :: domain_length
      real, intent(InOut) :: dpdx_mean
      real, intent(InOut) :: dpdy_mean
      real, intent(InOut) :: dpdz_mean
      real, dimension(0:maxobj), intent(InOut) :: dragpx
      real, dimension(0:maxobj), intent(InOut) :: dragpy
      real, dimension(0:maxobj), intent(InOut) :: dragpz
      real, dimension(0:maxobj), intent(InOut) :: dragvx
      real, dimension(0:maxobj), intent(InOut) :: dragvy
      real, dimension(0:maxobj), intent(InOut) :: dragvz
      real, dimension(0:maxobj), intent(InOut) :: dragx
      real, dimension(0:maxobj), intent(InOut) :: dragy
      real, dimension(0:maxobj), intent(InOut) :: dragz
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv), intent(InOut) :: ediff
      real(kind=8), intent(In) :: etimes
      real(kind=8) :: etims0
      real :: ffx_new
      real :: ffy_new
      real :: ffz_new
      real :: flow_rate
      integer, intent(In) :: icall
      logical :: ifsync
      character, dimension(1:1) :: mpi_argv_null
      character, dimension(1:1,1:1) :: mpi_argvs_null
      integer :: mpi_bottom
      integer, dimension(1:1) :: mpi_errcodes_ignore
      integer :: mpi_in_place
            integer, parameter :: mpi_status_size=6
      integer, dimension(1:mpi_status_size) :: mpi_status_ignore
      integer, dimension(1:mpi_status_size,1:1) :: mpi_statuses_ignore
      integer, dimension(1:1) :: mpi_unweighted
      integer, dimension(1:1) :: mpi_weights_empty
      integer :: nadvc
      integer :: naxhm
      integer :: nbbbb
      integer :: nbso2
      integer :: nbsol
      integer, dimension(1:maxrts), intent(InOut) :: ncall
      integer :: ncccc
      integer :: ncdtp
      integer :: ncopy
      integer :: ncrsl
      integer :: ncvf
      integer :: ndadd
      integer :: ndddd
      integer :: nddsl
      integer :: ndott
      integer :: ndsmn
      integer :: ndsmx
      integer :: ndsnd
      integer :: ndsum
      integer :: neeee
      integer :: nekcomm
      integer :: nekgroup
      integer :: nekreal
      integer :: neslv
      integer :: ngop
      integer :: ngop1
      integer :: ngop_sync
      integer :: ngp2
      integer :: ngsmn
      integer :: ngsmx
      integer :: ngsum
      integer :: nhmhz
      integer :: ninv3
      integer :: ninvc
      integer :: nmltd
      integer :: nmxmf
      integer :: nmxms
      integer :: nprep
      integer :: npres
      integer, intent(InOut) :: nrout
      integer :: nsett
      integer :: nslvb
      integer :: nsolv
      integer :: nspro
      integer :: nsyc
      integer :: nusbc
      integer :: nvdss
      integer :: nwal
      real(kind=8) :: paxhm
      real(kind=8) :: pbbbb
      real(kind=8) :: pbso2
      real(kind=8) :: pbsol
      real(kind=8) :: pcccc
      real(kind=8) :: pcdtp
      real(kind=8) :: pcopy
      real(kind=8) :: pcrsl
      real(kind=8) :: pdadd
      real(kind=8) :: pdddd
      real(kind=8) :: pddsl
      real(kind=8) :: pdott
      real(kind=8) :: pdsmn
      real(kind=8) :: pdsmx
      real(kind=8) :: pdsnd
      real(kind=8) :: pdsum
      real(kind=8) :: peeee
      real(kind=8) :: peslv
      real(kind=8) :: pgop
      real(kind=8) :: pgop1
      real(kind=8) :: pgop_sync
      real(kind=8) :: pgp2
      real(kind=8) :: pgsmn
      real(kind=8) :: pgsmx
      real(kind=8) :: pgsum
      real(kind=8) :: phmhz
      real(kind=8) :: pinv3
      real(kind=8) :: pinvc
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv), intent(InOut) :: pm1
      real(kind=8) :: pmltd
      real(kind=8) :: pmxmf
      real(kind=8) :: pmxms
      real(kind=8) :: pprep
      real(kind=8) :: ppres
      real(kind=8) :: psett
      real(kind=8) :: pslvb
      real(kind=8) :: psolv
      real(kind=8) :: pspro
      real(kind=8) :: psyc
      real(kind=8) :: pusbc
      real(kind=8) :: pvdss
      real(kind=8) :: pwal
      real(kind=8), dimension(1:maxrts) :: rct
      character(len=6), dimension(1:maxrts), intent(Out) :: rname
      real, dimension(1:3), intent(In) :: scale_vf
      real, dimension(1:lx1*ly1*lz1,1:ldim,1:ldim), intent(InOut) :: sij
      real, dimension(1:lx1*ly1*lz1,1:lelv), intent(InOut) :: snrm
      real(kind=8) :: ta2s2
      real(kind=8) :: tadc3
      real(kind=8) :: tadd2
      real(kind=8) :: tadvc
      real(kind=8) :: taxhm
      real(kind=8) :: tbbbb
      real(kind=8) :: tbso2
      real(kind=8) :: tbsol
      real(kind=8) :: tcccc
      real(kind=8) :: tcdtp
      real(kind=8) :: tcol2
      real(kind=8) :: tcol3
      real(kind=8) :: tcopy
      real(kind=8) :: tcrsl
      real(kind=8) :: tcvf
      real(kind=8) :: tdadd
      real(kind=8) :: tdddd
      real(kind=8) :: tddsl
      real(kind=8) :: tdott
      real(kind=8) :: tdsmn
      real(kind=8) :: tdsmx
      real(kind=8) :: tdsnd
      real(kind=8) :: tdsum
      real(kind=8) :: teeee
      real(kind=8) :: teslv
      real(kind=8) :: tgop
      real(kind=8) :: tgop1
      real(kind=8) :: tgop_sync
      real(kind=8) :: tgp2
      real(kind=8) :: tgsmn
      real(kind=8) :: tgsmx
      real(kind=8) :: tgsum
      real(kind=8) :: thmhz
      real(kind=8) :: tinit
      real(kind=8) :: tinv3
      real(kind=8) :: tinvc
      real(kind=8) :: tmltd
      real(kind=8), intent(Out) :: tmxmf
      real(kind=8) :: tmxms
      real, dimension(0:maxobj), intent(InOut) :: torqpx
      real, dimension(0:maxobj), intent(InOut) :: torqpy
      real, dimension(0:maxobj), intent(InOut) :: torqpz
      real, dimension(0:maxobj), intent(InOut) :: torqvx
      real, dimension(0:maxobj), intent(InOut) :: torqvy
      real, dimension(0:maxobj), intent(InOut) :: torqvz
      real, dimension(0:maxobj), intent(InOut) :: torqx
      real, dimension(0:maxobj), intent(InOut) :: torqy
      real, dimension(0:maxobj), intent(InOut) :: torqz
      real(kind=8), intent(In) :: tprep
      real(kind=8) :: tpres
      real(kind=8) :: tproj
      real, dimension(1:lx1,1:ly1,1:lz1), intent(InOut) :: trx
      real, dimension(1:lx1,1:ly1,1:lz1), intent(InOut) :: trz
      real(kind=8) :: tschw
      real(kind=8) :: tsett
      real(kind=8) :: tslvb
      real(kind=8) :: tsolv
      real(kind=8) :: tspro
      real(kind=8) :: tsyc
      real(kind=8), intent(In) :: ttime
      real(kind=8), intent(InOut) :: ttotal
      real(kind=8) :: tttstp
      real(kind=8) :: tusbc
      real(kind=8) :: tusfq
      real(kind=8) :: tvdss
      real(kind=8) :: twal
      real, dimension(1:lr), intent(InOut) :: ur
      real, dimension(1:lr), intent(InOut) :: us
      real, dimension(1:lr), intent(InOut) :: ut
      real, dimension(1:lr), intent(InOut) :: vr
      real, dimension(1:lr), intent(InOut) :: vs
      real, dimension(1:lr), intent(InOut) :: vt
      real, dimension(1:lr), intent(InOut) :: wr
      real, dimension(1:lr), intent(InOut) :: ws
      real, dimension(1:lr), intent(InOut) :: wt
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(InOut) :: xm0
      real :: xsec
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(InOut) :: ym0
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(InOut) :: zm0
      integer :: n
      integer :: ngll
      real :: rho
      real :: a_w
      integer :: nio
      ! cvode
      ! nek-nek
      integer :: loglevel
      integer :: optlevel
      integer, intent(In) :: nelv
      integer, intent(In) :: nelt
      integer :: nfield
      integer :: npert
      integer, intent(In) :: nid
      integer :: idsess
      integer, intent(In) :: nx1
      integer, intent(In) :: ny1
      integer, intent(In) :: nz1
      integer :: nx2
      integer :: ny2
      integer :: nz2
      integer :: nx3
      integer :: ny3
      integer :: nz3
      integer :: nxd
      integer :: nyd
      integer :: nzd
      integer :: ndim
      integer :: ldimr
      integer, parameter :: numsts=50
      integer, parameter :: nelgt_max=178956970
      integer, parameter :: lvt1=lx1*ly1*lz1*lelv
      integer, parameter :: lvt2=lx2*ly2*lz2*lelv
      integer, parameter :: lbt1=lbx1*lby1*lbz1*lbelv
      integer, parameter :: lbt2=lbx2*lby2*lbz2*lbelv
      integer, parameter :: lorder2=max(1,lorder-2)
      integer, parameter :: lxq=lx2
! 
!      Elemental derivative operators
! 
      real, dimension(1:lx1,1:lx1), intent(InOut) :: dxm1
      real, dimension(1:lx2,1:lx1) :: dxm12
      real, dimension(1:ly1,1:ly1), intent(InOut) :: dym1
      real, dimension(1:ly2,1:ly1) :: dym12
      real, dimension(1:lz1,1:lz1) :: dzm1
      real, dimension(1:lz2,1:lz1) :: dzm12
      real, dimension(1:lx1,1:lx1), intent(InOut) :: dxtm1
      real, dimension(1:lx1,1:lx2) :: dxtm12
      real, dimension(1:ly1,1:ly1), intent(InOut) :: dytm1
      real, dimension(1:ly1,1:ly2) :: dytm12
      real, dimension(1:lz1,1:lz1) :: dztm1
      real, dimension(1:lz1,1:lz2) :: dztm12
      real, dimension(1:lx3,1:lx3) :: dxm3
      real, dimension(1:lx3,1:lx3) :: dxtm3
      real, dimension(1:ly3,1:ly3) :: dym3
      real, dimension(1:ly3,1:ly3) :: dytm3
      real, dimension(1:lz3,1:lz3) :: dzm3
      real, dimension(1:lz3,1:lz3) :: dztm3
      real, dimension(1:ly1,1:ly1), intent(InOut) :: dcm1
      real, dimension(1:ly1,1:ly1), intent(InOut) :: dctm1
      real, dimension(1:ly3,1:ly3) :: dcm3
      real, dimension(1:ly3,1:ly3) :: dctm3
      real, dimension(1:ly2,1:ly1) :: dcm12
      real, dimension(1:ly1,1:ly2) :: dctm12
      real, dimension(1:ly1,1:ly1), intent(InOut) :: dam1
      real, dimension(1:ly1,1:ly1), intent(InOut) :: datm1
      real, dimension(1:ly2,1:ly1) :: dam12
      real, dimension(1:ly1,1:ly2) :: datm12
      real, dimension(1:ly3,1:ly3) :: dam3
      real, dimension(1:ly3,1:ly3) :: datm3
! 
!     Dealiasing variables
! 
      real, dimension(1:lxd,1:lyd,1:lzd,1:lelv) :: vxd
      real, dimension(1:lxd,1:lyd,1:lzd,1:lelv) :: vyd
      real, dimension(1:lxd,1:lyd,1:lzd,1:lelv) :: vzd
      real, dimension(1:lx1,1:lxd) :: imd1
      real, dimension(1:lxd,1:lx1) :: imd1t
      real, dimension(1:lxd,1:lx1) :: im1d
      real, dimension(1:lx1,1:lxd) :: im1dt
      real, dimension(1:lx1,1:lxd) :: pmd1
      real, dimension(1:lxd,1:lx1) :: pmd1t
! 
!      Eigenvalues
! 
      real :: eigas
      real :: eigaa
      real :: eigast
      real :: eigae
      real :: eigga
      real :: eiggs
      real :: eiggst
      real :: eigge
      logical :: ifaa
      logical :: ifae
      logical :: ifas
      logical :: ifast
      logical :: ifga
      logical :: ifge
      logical :: ifgs
      logical :: ifgst
! 
!      Geometry arrays
! 
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: xm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: ym1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: zm1
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: xm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: ym2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: zm2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: rxm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: sxm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: txm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: rym1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: sym1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: tym1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: rzm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: szm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: tzm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: jacm1
      real, dimension(1:lx1*ly1*lz1,1:lelt), intent(In) :: jacmi
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: rxm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: sxm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: txm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: rym2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: sym2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: tym2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: rzm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: szm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: tzm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: jacm2
      real, dimension(1:lxd*lyd*lzd,1:ldim*ldim,1:lelv) :: rx
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g1m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g2m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g3m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g4m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g5m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g6m1
      real, dimension(1:lx1*lz1,1:6,1:lelt) :: unr
      real, dimension(1:lx1*lz1,1:6,1:lelt) :: uns
      real, dimension(1:lx1*lz1,1:6,1:lelt) :: unt
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: unx
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: uny
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: unz
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t1x
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t1y
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t1z
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t2x
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t2y
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t2z
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: area
      real, dimension(1:lx1*lz1,1:2*ldim,1:lelt) :: etalph
      real :: dlam
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: vnx
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: vny
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: vnz
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v1x
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v1y
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v1z
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v2x
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v2y
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v2z
      logical :: ifgeom
      logical :: ifgmsh3
      logical :: ifvcor
      logical :: ifsurt
      logical :: ifmelt
      logical :: ifwcno
      logical, dimension(1:lelt), intent(In) :: ifrzer
      logical, dimension(1:2*ldim,1:lelv) :: ifqinp
      logical, dimension(1:2*ldim,1:lelv) :: ifeppm
      logical, dimension(0:1) :: iflmsf
      logical, dimension(0:1) :: iflmse
      logical, dimension(0:1) :: iflmsc
      logical, dimension(1:2*ldim,1:lelt,0:1) :: ifmsfc
      logical, dimension(1:12,1:lelt,0:1) :: ifmseg
      logical, dimension(1:8,1:lelt,0:1) :: ifmscr
      logical, dimension(1:8,1:lelt) :: ifnskp
      logical :: ifbcor
! 
!      Input parameters from preprocessors.
! 
!      Note that in parallel implementations, we distinguish between
!      distributed data (LELT) and uniformly distributed data.
! 
!      Input common block structure:
! 
!      INPUT1:  REAL            INPUT5: REAL      with LELT entries
!      INPUT2:  INTEGER         INPUT6: INTEGER   with LELT entries
!      INPUT3:  LOGICAL         INPUT7: LOGICAL   with LELT entries
!      INPUT4:  CHARACTER       INPUT8: CHARACTER with LELT entries
! 
      real, dimension(1:200) :: param
      real :: rstim
      real :: vnekton
      real, dimension(1:ldimt1,1:3) :: cpfld
      real, dimension(-5:10,1:ldimt1,1:3) :: cpgrp
      real, dimension(1:ldimt3,1:maxobj) :: qinteg
      real, dimension(1:20) :: uparam
      real, dimension(0:ldimt1) :: atol
      real, dimension(0:ldimt1) :: restol
      real :: filtertype
      integer, dimension(-5:10,1:ldimt1) :: matype
      integer :: nktonv
      integer :: nhis
      integer, dimension(1:4,1:lhis+maxobj) :: lochis
      integer :: ipscal
      integer :: npscal
      integer :: ipsco
      integer :: ifldmhd
      integer :: irstv
      integer :: irstt
      integer :: irstim
      integer, dimension(1:maxobj) :: nmember
      integer :: nobj
      integer :: ngeom
      integer, dimension(1:ldimt) :: idpss
      logical, intent(In) :: if3d
      logical :: ifflow
      logical :: ifheat
      logical :: iftran
      logical, intent(In) :: ifaxis
      logical :: ifstrs
      logical :: ifsplit
      logical :: ifmgrid
      logical, dimension(1:ldimt1) :: ifadvc
      logical, dimension(1:ldimt1) :: ifdiff
      logical, dimension(1:ldimt1) :: ifdeal
      logical, dimension(0:ldimt1) :: ifprojfld
      logical, dimension(0:ldimt1) :: iftmsh
      logical, dimension(0:ldimt1) :: ifdgfld
      logical :: ifdg
      logical :: ifmvbd
      logical :: ifchar
      logical, dimension(1:ldimt1) :: ifnonl
      logical, dimension(1:ldimt1) :: ifvarp
      logical, dimension(1:ldimt1) :: ifpsco
      logical :: ifvps
      logical :: ifmodel
      logical :: ifkeps
      logical :: ifintq
      logical :: ifcons
      logical :: ifxyo
      logical :: ifpo
      logical :: ifvo
      logical :: ifto
      logical :: iftgo
      logical, dimension(1:ldimt1) :: ifpso
      logical :: iffmtin
      logical :: ifbo
      logical :: ifanls
      logical :: ifanl2
      logical :: ifmhd
      logical :: ifessr
      logical :: ifpert
      logical :: ifbase
      logical :: ifcvode
      logical :: iflomach
      logical :: ifexplvis
      logical :: ifschclob
      logical, intent(In) :: ifuservp
      logical :: ifcyclic
      logical :: ifmoab
      logical :: ifcoup
      logical :: ifvcoup
      logical :: ifusermv
      logical :: ifreguo
      logical :: ifxyo_
      logical :: ifaziv
      logical, intent(In) :: ifneknek
      logical :: ifneknekm
      logical, dimension(1:ldimt1) :: ifcvfld
      logical :: ifdp0dt
      logical :: ifmpiio
      logical :: ifrich
      logical :: ifnav
      character(len=1), dimension(1:11,1:lhis+maxobj) :: hcode
      character(len=2), dimension(1:8) :: ocode
      character(len=10), dimension(1:5) :: drivc
      character(len=14) :: rstv
      character(len=14) :: rstt
      character(len=40), dimension(1:100,1:2) :: textsw
      character(len=132), dimension(1:15) :: initc
      character(len=40) :: turbmod
      character(len=132) :: reafle
      character(len=132) :: fldfle
      character(len=132) :: dmpfle
      character(len=132) :: hisfle
      character(len=132) :: schfle
      character(len=132) :: orefle
      character(len=132) :: nrefle
      character(len=132) :: session
      character(len=132) :: path
      character(len=132) :: re2fle
      character(len=132) :: parfle
      integer :: cr_re2
      integer :: fh_re2
      integer(kind=8) :: re2off_b
! 
!  proportional to LELT
! 
      real, dimension(1:8,1:lelt) :: xc
      real, dimension(1:8,1:lelt) :: yc
      real, dimension(1:8,1:lelt) :: zc
      real, dimension(1:5,1:6,1:lelt,0:ldimt1) :: bc
      real, dimension(1:6,1:12,1:lelt) :: curve
      real, dimension(1:lelt) :: cerror
      integer, dimension(1:lelt) :: igroup
      integer, dimension(1:maxobj,1:maxmbr,1:2) :: object
      character(len=1), dimension(1:12,1:lelt) :: ccurve
      character(len=1), dimension(1:6,1:lelt) :: cdof
      character(len=3), dimension(1:6,1:lelt,0:ldimt1) :: cbc
      character(len=3) :: solver_type
      integer, dimension(1:lelt) :: ieact
      integer :: neact
! 
!  material set ids, BC set ids, materials (f=fluid, s=solid), bc types
! 
      integer :: numflu
      integer :: numoth
      integer :: numbcs
      integer, dimension(1:numsts) :: matindx
      integer, dimension(1:numsts) :: matids
      integer, dimension(1:lelt) :: imatie
      integer, dimension(1:numsts) :: ibcsts
      integer, dimension(1:numsts) :: bcf
      character(len=3), dimension(1:numsts) :: bctyps
! 
!      Interpolation operators
! 
      real, dimension(1:lx2,1:lx1) :: ixm12
      real, dimension(1:lx1,1:lx2) :: ixm21
      real, dimension(1:ly2,1:ly1) :: iym12
      real, dimension(1:ly1,1:ly2) :: iym21
      real, dimension(1:lz2,1:lz1) :: izm12
      real, dimension(1:lz1,1:lz2) :: izm21
      real, dimension(1:lx1,1:lx2) :: ixtm12
      real, dimension(1:lx2,1:lx1) :: ixtm21
      real, dimension(1:ly1,1:ly2) :: iytm12
      real, dimension(1:ly2,1:ly1) :: iytm21
      real, dimension(1:lz1,1:lz2) :: iztm12
      real, dimension(1:lz2,1:lz1) :: iztm21
      real, dimension(1:lx3,1:lx1) :: ixm13
      real, dimension(1:lx1,1:lx3) :: ixm31
      real, dimension(1:ly3,1:ly1) :: iym13
      real, dimension(1:ly1,1:ly3) :: iym31
      real, dimension(1:lz3,1:lz1) :: izm13
      real, dimension(1:lz1,1:lz3) :: izm31
      real, dimension(1:lx1,1:lx3) :: ixtm13
      real, dimension(1:lx3,1:lx1) :: ixtm31
      real, dimension(1:ly1,1:ly3) :: iytm13
      real, dimension(1:ly3,1:ly1) :: iytm31
      real, dimension(1:lz1,1:lz3) :: iztm13
      real, dimension(1:lz3,1:lz1) :: iztm31
      real, dimension(1:ly2,1:ly1) :: iam12
      real, dimension(1:ly1,1:ly2) :: iam21
      real, dimension(1:ly1,1:ly2) :: iatm12
      real, dimension(1:ly2,1:ly1) :: iatm21
      real, dimension(1:ly3,1:ly1) :: iam13
      real, dimension(1:ly1,1:ly3) :: iam31
      real, dimension(1:ly1,1:ly3) :: iatm13
      real, dimension(1:ly3,1:ly1) :: iatm31
      real, dimension(1:ly2,1:ly1) :: icm12
      real, dimension(1:ly1,1:ly2) :: icm21
      real, dimension(1:ly1,1:ly2) :: ictm12
      real, dimension(1:ly2,1:ly1) :: ictm21
      real, dimension(1:ly3,1:ly1) :: icm13
      real, dimension(1:ly1,1:ly3) :: icm31
      real, dimension(1:ly1,1:ly3) :: ictm13
      real, dimension(1:ly3,1:ly1) :: ictm31
      real, dimension(1:ly1,1:ly1) :: iajl1
      real, dimension(1:ly1,1:ly1) :: iatjl1
      real, dimension(1:ly2,1:ly2) :: iajl2
      real, dimension(1:ly2,1:ly2) :: iatjl2
      real, dimension(1:ly3,1:ly3) :: ialj3
      real, dimension(1:ly3,1:ly3) :: iatlj3
      real, dimension(1:ly1,1:ly1) :: ialj1
      real, dimension(1:ly1,1:ly1) :: iatlj1
! 
!      Mass matrix
! 
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: bm1
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: bm2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: binvm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: bintm1
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelt) :: bm2inv
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: baxm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:lorder-1) :: bm1lag
      real :: volvm1
      real :: volvm2
      real :: voltm1
      real :: voltm2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: yinvm1
      real, dimension(1:lx1*ly1*lz1,1:lelt) :: binvdg
! 
!      Moving mesh variables
! 
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: wx
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: wy
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: wz
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt,1:lorder-1) :: wxlag
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt,1:lorder-1) :: wylag
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt,1:lorder-1) :: wzlag
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: w1mask
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: w2mask
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: w3mask
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: wmult
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelv) :: ev1
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelv) :: ev2
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelv) :: ev3
! 
!      Communication information
!      NOTE: NID is stored in 'SIZE' for greater accessibility
      integer :: node
      integer :: pid
      integer, intent(In) :: np
      integer :: nullpid
      integer :: node0
! 
!      Maximum number of elements (limited to 2**31/12, at least for now)
      integer(kind=8), intent(In) :: nvtot
      integer, dimension(0:ldimt1) :: nelg
      integer, dimension(1:lelt) :: lglel
      integer, dimension(1:lelg) :: gllel
      integer, dimension(1:lelg) :: gllnid
      integer :: nelgv
      integer :: nelgt
      logical :: ifgprnt
      integer :: wdsize
      integer :: isize
      integer :: lsize
      integer :: csize
      integer :: wdsizi
!      crystal-router, gather-scatter, and xxt handles (xxt=csr grid solve)
! 
      integer :: cr_h
      integer :: gsh
      integer, dimension(0:ldimt3) :: gsh_fld
      integer, dimension(1:ldimt3) :: xxth
      logical :: ifgsh_fld_same
!      These arrays need to be reconciled with cmt (pff, 11/03/15)
      integer, dimension(1:lx1*lz1*2*ldim*lelt) :: dg_face
      integer :: dg_hndlx
      integer :: ndg_facex
! 
!      Main storage of simulation variables
! 
! 
!      Solution and data
! 
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: bq
!      Can be used for post-processing runs (SIZE .gt. 10+3*LDIMT flds)
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv,1:2) :: vxlag
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv,1:2) :: vylag
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv,1:2) :: vzlag
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:lorder-1,1:ldimt) :: tlag
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: vgradt1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: vgradt2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: abx1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: aby1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: abz1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: abx2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: aby2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: abz2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: vdiff_e
!      Solution data
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv), intent(InOut) :: vx
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv), intent(InOut) :: vy
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv), intent(InOut) :: vz
      real, dimension(1:lx1*ly1*lz1*lelv) :: vx_e
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: vy_e
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: vz_e
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt), intent(InOut) :: t
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt1) :: vtrans
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt1) :: vdiff
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: bfx
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: bfy
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: bfz
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: cflf
      real, dimension(1:lx1*ly1*lz1*lelv*ldim,1:lorder+1) :: bmnv
      real, dimension(1:lx1*ly1*lz1*lelv*ldim,1:lorder+1) :: bmass
      real, dimension(1:lx1*ly1*lz1*lelv*ldim,1:lorder+1) :: bdivw
      real, dimension(1:lxd*lyd*lzd*lelv*ldim,1:lorder+1) :: c_vx
      real, dimension(1:2*ldim,1:lelt) :: fw
!      Solution data for magnetic field
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bx
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: by
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bz
      real, dimension(1:lbx2,1:lby2,1:lbz2,1:lbelv) :: pm
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bmx
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bmy
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bmz
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bbx1
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bby1
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bbz1
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bbx2
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bby2
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bbz2
      real, dimension(1:lbx1*lby1*lbz1*lbelv,1:lorder-1) :: bxlag
      real, dimension(1:lbx1*lby1*lbz1*lbelv,1:lorder-1) :: bylag
      real, dimension(1:lbx1*lby1*lbz1*lbelv,1:lorder-1) :: bzlag
      real, dimension(1:lbx2*lby2*lbz2*lbelv,1:lorder2) :: pmlag
      real :: nu_star
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: pr
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv,1:lorder2) :: prlag
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelt) :: qtl
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelt) :: usrdiv
      real :: p0th
      real :: dp0thdt
      real :: gamma0
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: v1mask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: v2mask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: v3mask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: pmask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: tmask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: omask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: vmult
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: tmult
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: b1mask
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: b2mask
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: b3mask
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bpmask
! 
! 
!      Solution and data for perturbation fields
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: vxp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: vyp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: vzp
       real, dimension(1:lpx2*lpy2*lpz2*lpelv,1:lpert) :: prp
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lpert) :: tp
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lpert) :: bqp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: bfxp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: bfyp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: bfzp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lorder-1,1:lpert) :: vxlagp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lorder-1,1:lpert) :: vylagp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lorder-1,1:lpert) :: vzlagp
       real, dimension(1:lpx2*lpy2*lpz2*lpelv,1:lorder2,1:lpert) :: prlagp
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lorder-1,1:lpert) :: tlagp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exx1p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exy1p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exz1p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exx2p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exy2p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exz2p
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lpert) :: vgradt1p
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lpert) :: vgradt2p
      integer :: jp
! 
!      Steady variables
! 
      real, dimension(1:ldimt1) :: tauss
      real, dimension(1:ldimt1) :: txnext
      integer :: nsskip
      logical :: ifskip
      logical :: ifmodp
      logical :: ifssvt
      logical, dimension(1:ldimt1) :: ifstst
      logical :: ifexvt
      logical, dimension(1:ldimt1) :: ifextr
      real :: dvnnh1
      real :: dvnnsm
      real :: dvnnl2
      real :: dvnnl8
      real :: dvdfh1
      real :: dvdfsm
      real :: dvdfl2
      real :: dvdfl8
      real :: dvprh1
      real :: dvprsm
      real :: dvprl2
      real :: dvprl8
! 
!      Arrays for direct stiffness summation
! 
      integer, dimension(1:2,1:3) :: nomlis
      integer, dimension(1:6) :: nmlinv
      integer, dimension(1:6) :: group
      integer, dimension(1:6,1:6) :: skpdat
      integer, dimension(1:6) :: eface
      integer, dimension(1:6) :: eface1
      integer, dimension(-12:12,1:3) :: eskip
      integer, dimension(1:3) :: nedg
      integer :: ncmp
      integer, dimension(1:8) :: ixcn
      integer, dimension(1:3,0:ldimt1) :: noffst
      integer :: maxmlt
      integer, dimension(0:ldimt1) :: nspmax
      integer, dimension(0:ldimt1) :: ngspcn
      integer, dimension(1:3,0:ldimt1) :: ngsped
      integer, dimension(1:lelt,0:ldimt1) :: numscn
      integer, dimension(1:lelt,0:ldimt1) :: numsed
      integer, dimension(1:8,1:lelt,0:ldimt1) :: gcnnum
      integer, dimension(1:8,1:lelt,0:ldimt1) :: lcnnum
      integer, dimension(1:12,1:lelt,0:ldimt1) :: gednum
      integer, dimension(1:12,1:lelt,0:ldimt1) :: lednum
      integer, dimension(1:12,1:lelt,0:ldimt1) :: gedtyp
      integer, dimension(1:2,0:ldimt1) :: ngcomm
      integer, dimension(1:20) :: iedge
      integer, dimension(1:2,1:4,1:6,0:1) :: iedgef
      integer, dimension(1:3,1:16) :: icedg
      integer, dimension(1:4,1:6) :: iedgfc
      integer, dimension(1:4,1:10) :: icface
      integer, dimension(1:8) :: indx
      integer, dimension(1:27) :: invedg
!  
!      Variables related to time integration
! 
      real :: time
      real :: timef
      real :: fintim
      real :: timeio
      real :: dt
      real, dimension(1:10) :: dtlag
      real :: dtinit
      real :: dtinvm
      real :: courno
      real :: ctarg
      real, dimension(1:10) :: ab
      real, dimension(1:10) :: bd
      real, dimension(1:10) :: abmsh
      real, dimension(1:ldimt1) :: avdiff
      real, dimension(1:ldimt1) :: avtran
      real, dimension(0:ldimt1) :: volfld
      real :: tolrel
      real :: tolabs
      real :: tolhdf
      real :: tolpdf
      real :: tolev
      real :: tolnl
      real :: prelax
      real :: tolps
      real :: tolhs
      real :: tolhr
      real :: tolhv
      real, dimension(1:ldimt1) :: tolht
      real :: tolhe
      real :: vnrmh1
      real :: vnrmsm
      real :: vnrml2
      real :: vnrml8
      real :: vmean
      real, dimension(1:ldimt) :: tnrmh1
      real, dimension(1:ldimt) :: tnrmsm
      real, dimension(1:ldimt) :: tnrml2
      real, dimension(1:ldimt) :: tnrml8
      real, dimension(1:ldimt) :: tmean
      integer :: ifield
      integer :: imesh
      integer, intent(In) :: istep
      integer :: nsteps
      integer :: iostep
      integer :: lastep
      integer :: iocomm
      integer :: instep
      integer :: nab
      integer :: nabmsh
      integer :: nbd
      integer :: nbdinp
      integer :: ntaubd
      integer :: nmxh
      integer :: nmxp
      integer :: nmxe
      integer :: nmxnl
      integer :: ninter
      integer, dimension(0:ldimt1) :: nelfld
      integer :: nconv
      integer :: nconv_max
      integer :: ioinfodmp
      real :: pi
      logical :: ifprnt
      logical :: if_full_pres
      logical :: ifoutfld
      real, dimension(1:3,1:lpert) :: lyap
! 
!      Variables for E-solver
! 
      integer :: iesolv
      logical, dimension(1:lelv) :: ifalgn
      logical, dimension(1:lelv) :: ifrsxy
      real, dimension(1:lelv) :: volel
! 
!      Gauss-Labotto and Gauss points
! 
      real, dimension(1:lx1,1:3) :: zgm1
      real, dimension(1:lx2,1:3) :: zgm2
      real, dimension(1:lx3,1:3) :: zgm3
      real, dimension(1:lx1) :: zam1
      real, dimension(1:lx2) :: zam2
      real, dimension(1:lx3) :: zam3
! 
!     Weights
! 
      real, dimension(1:lx1) :: wxm1
      real, dimension(1:ly1) :: wym1
      real, dimension(1:lz1) :: wzm1
      real, dimension(1:lx1,1:ly1,1:lz1) :: w3m1
      real, dimension(1:lx2) :: wxm2
      real, dimension(1:ly2) :: wym2
      real, dimension(1:lz2) :: wzm2
      real, dimension(1:lx2,1:ly2,1:lz2) :: w3m2
      real, dimension(1:lx3) :: wxm3
      real, dimension(1:ly3) :: wym3
      real, dimension(1:lz3) :: wzm3
      real, dimension(1:lx3,1:ly3,1:lz3) :: w3m3
      real, dimension(1:ly1) :: wam1
      real, dimension(1:ly2) :: wam2
      real, dimension(1:ly3) :: wam3
      real, dimension(1:lx1,1:ly1) :: w2am1
      real, dimension(1:lx1,1:ly1) :: w2cm1
      real, dimension(1:lx2,1:ly2) :: w2am2
      real, dimension(1:lx2,1:ly2) :: w2cm2
      real, dimension(1:lx3,1:ly3) :: w2am3
      real, dimension(1:lx3,1:ly3) :: w2cm3
! 
!      Points (z) and weights (w) on velocity, pressure
! 
!      zgl -- velocity points on Gauss-Lobatto points i = 1,...nx
!      zgp -- pressure points on Gauss         points i = 1,...nxp (nxp = nx-2)
! 
!      integer    lxm ! defined in HSMG
!      parameter (lxm = lx1)
! 
      real, dimension(1:lx1) :: zgl
      real, dimension(1:lx1) :: wgl
      real, dimension(1:lx1) :: zgp
      real, dimension(1:lxq) :: wgp
! 
!      Tensor- (outer-) product of 1D weights   (for volumetric integration)
! 
      real, dimension(1:lx1*lx1) :: wgl1
      real, dimension(1:lxq*lxq) :: wgl2
      real, dimension(1:lx1*lx1) :: wgli
! 
! 
!     Frequently used derivative matrices:
! 
!     D1, D1t   ---  differentiate on mesh 1 (velocity mesh)
!     D2, D2t   ---  differentiate on mesh 2 (pressure mesh)
! 
!     DXd,DXdt  ---  differentiate from velocity mesh ONTO dealiased mesh
!                    (currently the same as D1 and D1t...)
! 
! 
      real, dimension(1:lx1*lx1) :: d1
      real, dimension(1:lx1*lx1) :: d1t
      real, dimension(1:lx1*lx1) :: d2
      real, dimension(1:lx1*lx1) :: b2p
      real, dimension(1:lx1*lx1) :: b1ia1
      real, dimension(1:lx1*lx1) :: b1ia1t
      real, dimension(1:lx1*lx1) :: da
      real, dimension(1:lx1*lx1) :: dat
      real, dimension(1:lx1*lxq) :: iggl
      real, dimension(1:lx1*lxq) :: igglt
      real, dimension(1:lx1*lxq) :: dglg
      real, dimension(1:lx1*lxq) :: dglgt
      real, dimension(1:lx1*lxq) :: wglg
      real, dimension(1:lx1*lxq) :: wglgt
      integer, parameter :: lfdm0=1-lfdm
      integer, parameter :: lelg_sm=lfdm0+lfdm*lelg
      integer, parameter :: ltfdm2=lfdm0+lfdm*2*lx2*ly2*lz2*lelt
      integer, parameter :: leig2=lfdm0+lfdm*2*lx2*lx2*(lelx*lelx+lely*lely+lelz*lelz)
      integer, parameter :: leig=lfdm0+lfdm*2*lx2*(lelx+lely+lelz)
      integer, parameter :: lp_small=256
      integer, parameter :: lfdx=lfdm0+lfdm*lx2*lelx
      integer, parameter :: lfdy=lfdm0+lfdm*ly2*lely
      integer, parameter :: lfdz=lfdm0+lfdm*lz2*lelz
! 
!      Perturbation variables
! 
!      Eigenvalue arrays and pointers for Global Tensor Product 
!      parameter (lelg_sm=2)
!      parameter (ltfdm2 =2)
!      parameter (lelg_sm=lelg)
!      parameter (ltfdm2=2*lx2*ly2*lz2*lelt)
!      parameter (leig2=2*lx2*lx2*(lelx*lelx+lely*lely+lelz*lelz))
!      parameter (leig =2*lx2*(lelx+lely+lelz))
      integer :: neigx
      integer :: neigy
      integer :: neigz
      integer :: pvalx
      integer :: pvaly
      integer :: pvalz
      integer :: pvecx
      integer :: pvecy
      integer :: pvecz
      real, dimension(1:leig2) :: sp
      real, dimension(1:leig2) :: spt
      real, dimension(1:leig) :: eigp
      real, dimension(1:ltfdm2) :: wavep
! 
      integer, dimension(1:3,1:2) :: msp
      integer, dimension(1:3,1:2) :: mlp
!      Logical, array and geometry data for tensor-product box
      logical :: ifycrv
      logical :: ifzper
      logical :: ifgfdm
      logical :: ifgtp
      logical :: ifemat
      integer :: nelx
      integer :: nely
      integer :: nelz
      integer :: nelxy
      integer, dimension(1:3) :: lex2pst
      integer, dimension(1:3) :: pst2lex
      integer, dimension(1:3) :: ngfdm_p
      integer, dimension(1:3,1:2) :: ngfdm_v
!      Complete exchange arrays for pressure
!      real part_in(0:lp),part_out(0:lp)
!      common /gfdmcx/  part_in,part_out
      integer, dimension(0:lp_small) :: part_in
      integer, dimension(0:lp_small) :: part_out
      integer, dimension(0:lp_small,1:2) :: msg_id
      integer :: mcex
!      Permutation arrays for gfdm pressure solve
      integer, dimension(1:ltfdm2) :: tpn1
      integer, dimension(1:ltfdm2) :: tpn2
      integer, dimension(1:ltfdm2) :: tpn3
      integer, dimension(1:ltfdm2) :: ind23
      real, dimension(0:lelx) :: xgtp
      real, dimension(0:lely) :: ygtp
      real, dimension(0:lelz) :: zgtp
      real, dimension(1:lfdx) :: xmlt
      real, dimension(1:lfdy) :: ymlt
      real, dimension(1:lfdz) :: zmlt
!      Metrics for 2D x tensor-product solver
      real, dimension(1:lx2,1:ly2,1:lelv) :: rx2
      real, dimension(1:lx2,1:ly2,1:lelv) :: ry2
      real, dimension(1:lx2,1:ly2,1:lelv) :: sx2
      real, dimension(1:lx2,1:ly2,1:lelv) :: sy2
      real, dimension(1:lx2,1:ly2,1:lelv) :: w2d
      real, dimension(1:lx1,1:ly1,1:lelv) :: bxyi
      character(len=3), dimension(1:6,0:ldimt1+1) :: gtp_cbc
      integer :: e
      integer :: i
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: gradux
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: graduy
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: graduz
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: vgrad
      real, dimension(1:3) :: x0
      real :: utau
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: utauv
      save x0
!      call common blocks
! 
      n=nx1*ny1*nz1*nelv
      ngll=nx1*ny1*nz1
      if(ifuservp) then
        do e=1,nelv
           call eddy_visc(e,ab,abmsh,abx1,abx2,aby1,aby2,abz1,abz2,area,atol,avdiff,avtran,b1ia1, &
      b1ia1t,b1mask,b2mask,b2p,b3mask,baxm1,bbx1,bbx2,bby1,bby2,bbz1,bbz2,bc,bcf,bctyps,bd,bdivw, &
      bfx,bfxp,bfy,bfyp,bfz,bfzp,bintm1,binvdg,binvm1,bm1,bm1lag,bm2,bm2inv,bmass,bmnv,bmx,bmy, &
      bmz,bpmask,bq,bqp,bx,bxlag,bxyi,by,bylag,bz,bzlag,c_vx,cbc,ccurve,cdof,cerror,cflf,courno, &
      cpfld,cpgrp,cr_h,cr_re2,cs,csize,ctarg,curve,d1,d1t,d2,da,dam1,dam12,dam3,dat,datm1,datm12, &
      datm3,dcm1,dcm12,dcm3,dcount,dct,dctm1,dctm12,dctm3,dg2,dg_face,dg_hndlx,dglg,dglgt,dlam, &
      dmpfle,dp0thdt,drivc,dt,dtinit,dtinvm,dtlag,dvdfh1,dvdfl2,dvdfl8,dvdfsm,dvnnh1,dvnnl2, &
      dvnnl8,dvnnsm,dvprh1,dvprl2,dvprl8,dvprsm,dxm1,dxm12,dxm3,dxtm1,dxtm12,dxtm3,dym1,dym12, &
      dym3,dytm1,dytm12,dytm3,dzm1,dzm12,dzm3,dztm1,dztm12,dztm3,ediff,eface,eface1,eigaa,eigae, &
      eigas,eigast,eigga,eigge,eiggs,eiggst,eigp,eskip,etalph,etimes,etims0,ev1,ev2,ev3,exx1p, &
      exx2p,exy1p,exy2p,exz1p,exz2p,fh_re2,filtertype,fintim,fldfle,fw,g1m1,g2m1,g3m1,g4m1,g5m1, &
      g6m1,gamma0,gcnnum,gednum,gedtyp,gllel,gllnid,group,gsh,gsh_fld,gtp_cbc,hcode,hisfle,iajl1, &
      iajl2,ialj1,ialj3,iam12,iam13,iam21,iam31,iatjl1,iatjl2,iatlj1,iatlj3,iatm12,iatm13,iatm21, &
      iatm31,ibcsts,icall,icedg,icface,icm12,icm13,icm21,icm31,ictm12,ictm13,ictm21,ictm31,idpss, &
      idsess,ieact,iedge,iedgef,iedgfc,iesolv,if3d,if_full_pres,ifaa,ifadvc,ifae,ifalgn,ifanl2, &
      ifanls,ifas,ifast,ifaxis,ifaziv,ifbase,ifbcor,ifbo,ifchar,ifcons,ifcoup,ifcvfld,ifcvode, &
      ifcyclic,ifdeal,ifdg,ifdgfld,ifdiff,ifdp0dt,ifemat,ifeppm,ifessr,ifexplvis,ifextr,ifexvt, &
      ifflow,iffmtin,ifga,ifge,ifgeom,ifgfdm,ifgmsh3,ifgprnt,ifgs,ifgsh_fld_same,ifgst,ifgtp, &
      ifheat,ifield,ifintq,ifkeps,ifldmhd,iflmsc,iflmse,iflmsf,iflomach,ifmelt,ifmgrid,ifmhd, &
      ifmoab,ifmodel,ifmodp,ifmpiio,ifmscr,ifmseg,ifmsfc,ifmvbd,ifneknek,ifneknekm,ifnonl,ifnskp, &
      ifoutfld,ifpert,ifpo,ifprnt,ifprojfld,ifpsco,ifpso,ifqinp,ifreguo,ifrich,ifrsxy,ifrzer, &
      ifschclob,ifskip,ifsplit,ifssvt,ifstrs,ifstst,ifsurt,ifsync,iftgo,iftmsh,ifto,iftran, &
      ifusermv,ifuservp,ifvarp,ifvcor,ifvcoup,ifvo,ifvps,ifwcno,ifxyo,ifxyo_,ifycrv,ifzper,iggl, &
      igglt,igroup,im1d,im1dt,imatie,imd1,imd1t,imesh,ind23,indx,initc,instep,invedg,iocomm, &
      ioinfodmp,iostep,ipscal,ipsco,irstim,irstt,irstv,isize,istep,ixcn,ixm12,ixm13,ixm21,ixm31, &
      ixtm12,ixtm13,ixtm21,ixtm31,iym12,iym13,iym21,iym31,iytm12,iytm13,iytm21,iytm31,izm12,izm13, &
      izm21,izm31,iztm12,iztm13,iztm21,iztm31,jacm1,jacm2,jacmi,jp,lastep,lcnnum,ldimr,lednum, &
      lex2pst,lglel,lochis,loglevel,lsize,lyap,matids,matindx,matype,maxmlt,mcex,mlp, &
      mpi_argv_null,mpi_argvs_null,mpi_bottom,mpi_errcodes_ignore,mpi_in_place,mpi_status_ignore, &
      mpi_statuses_ignore,mpi_unweighted,mpi_weights_empty,msg_id,msp,nab,nabmsh,nadvc,naxhm, &
      nbbbb,nbd,nbdinp,nbso2,nbsol,ncall,ncccc,ncdtp,ncmp,nconv,nconv_max,ncopy,ncrsl,ncvf,ndadd, &
      ndddd,nddsl,ndg_facex,ndim,ndott,ndsmn,ndsmx,ndsnd,ndsum,neact,nedg,neeee,neigx,neigy,neigz, &
      nekcomm,nekgroup,nekreal,nelfld,nelg,nelgt,nelgv,nelt,nelv,nelx,nelxy,nely,nelz,neslv, &
      nfield,ngcomm,ngeom,ngfdm_p,ngfdm_v,ngop,ngop1,ngop_sync,ngp2,ngsmn,ngsmx,ngspcn,ngsped, &
      ngsum,nhis,nhmhz,nid,ninter,ninv3,ninvc,nio,nktonv,nmember,nmlinv,nmltd,nmxe,nmxh,nmxmf, &
      nmxms,nmxnl,nmxp,nobj,node,node0,noffst,nomlis,np,npert,nprep,npres,npscal,nrefle,nrout, &
      nsett,nslvb,nsolv,nspmax,nspro,nsskip,nsteps,nsyc,ntaubd,nu_star,nullpid,numbcs,numflu, &
      numoth,numscn,numsed,nusbc,nvdss,nvtot,nwal,nx1,nx2,nx3,nxd,ny1,ny2,ny3,nyd,nz1,nz2,nz3,nzd, &
      object,ocode,omask,optlevel,orefle,p0th,param,parfle,part_in,part_out,path,paxhm,pbbbb, &
      pbso2,pbsol,pcccc,pcdtp,pcopy,pcrsl,pdadd,pdddd,pddsl,pdott,pdsmn,pdsmx,pdsnd,pdsum,peeee, &
      peslv,pgop,pgop1,pgop_sync,pgp2,pgsmn,pgsmx,pgsum,phmhz,pi,pid,pinv3,pinvc,pm,pmask,pmd1, &
      pmd1t,pmlag,pmltd,pmxmf,pmxms,pprep,ppres,pr,prelax,prlag,prlagp,prp,psett,pslvb,psolv, &
      pspro,pst2lex,psyc,pusbc,pvalx,pvaly,pvalz,pvdss,pvecx,pvecy,pvecz,pwal,qinteg,qtl,rct, &
      re2fle,re2off_b,reafle,restol,rname,rstim,rstt,rstv,rx,rx2,rxm1,rxm2,ry2,rym1,rym2,rzm1, &
      rzm2,schfle,session,sij,skpdat,snrm,solver_type,sp,spt,sx2,sxm1,sxm2,sy2,sym1,sym2,szm1, &
      szm2,t,t1x,t1y,t1z,t2x,t2y,t2z,ta2s2,tadc3,tadd2,tadvc,tauss,taxhm,tbbbb,tbso2,tbsol,tcccc, &
      tcdtp,tcol2,tcol3,tcopy,tcrsl,tcvf,tdadd,tdddd,tddsl,tdott,tdsmn,tdsmx,tdsnd,tdsum,teeee, &
      teslv,textsw,tgop,tgop1,tgop_sync,tgp2,tgsmn,tgsmx,tgsum,thmhz,time,timef,timeio,tinit, &
      tinv3,tinvc,tlag,tlagp,tmask,tmean,tmltd,tmult,tmxmf,tmxms,tnrmh1,tnrml2,tnrml8,tnrmsm, &
      tolabs,tolev,tolhdf,tolhe,tolhr,tolhs,tolht,tolhv,tolnl,tolpdf,tolps,tolrel,tp,tpn1,tpn2, &
      tpn3,tprep,tpres,tproj,tschw,tsett,tslvb,tsolv,tspro,tsyc,ttime,ttotal,tttstp,tusbc,tusfq, &
      tvdss,twal,txm1,txm2,txnext,tym1,tym2,tzm1,tzm2,unr,uns,unt,unx,uny,unz,uparam,usrdiv, &
      v1mask,v1x,v1y,v1z,v2mask,v2x,v2y,v2z,v3mask,vdiff,vdiff_e,vgradt1,vgradt1p,vgradt2, &
      vgradt2p,vmean,vmult,vnekton,vnrmh1,vnrml2,vnrml8,vnrmsm,vnx,vny,vnz,volel,volfld,voltm1, &
      voltm2,volvm1,volvm2,vtrans,vx,vx_e,vxd,vxlag,vxlagp,vxp,vy,vy_e,vyd,vylag,vylagp,vyp,vz, &
      vz_e,vzd,vzlag,vzlagp,vzp,w1mask,w2am1,w2am2,w2am3,w2cm1,w2cm2,w2cm3,w2d,w2mask,w3m1,w3m2, &
      w3m3,w3mask,wam1,wam2,wam3,wavep,wdsize,wdsizi,wgl,wgl1,wgl2,wglg,wglgt,wgli,wgp,wmult,wx, &
      wxlag,wxm1,wxm2,wxm3,wy,wylag,wym1,wym2,wym3,wz,wzlag,wzm1,wzm2,wzm3,xc,xgtp,xm1,xm2,xmlt, &
      xxth,yc,ygtp,yinvm1,ym1,ym2,ymlt,zam1,zam2,zam3,zc,zgl,zgm1,zgm2,zgm3,zgp,zgtp,zm1,zm2, &
      zmlt)
      ifnav = ifadvc(1)
      turbmod = textsw(1,1)
        enddo
        t_copy = reshape(t,shape(t_copy))
        ediff_copy = reshape(ediff,shape(ediff_copy))
        call copy(t_copy,ediff_copy,n)

        t = reshape(t_copy, shape(t))
        ediff = reshape(ediff_copy, shape(ediff))
      endif
      if (istep == 0) then
         x0_rzero = reshape(x0,shape(x0_rzero))
         call rzero(x0_rzero,3)

         x0 = reshape(x0_rzero, shape(x0))
      endif
      sij_torque_calc = reshape(sij,shape(sij_torque_calc))
      trx_torque_calc = reshape(trx,shape(trx_torque_calc))
      trz_torque_calc = reshape(trz,shape(trz_torque_calc))
      call torque_calc(1.0,x0,.false.,.false.,dragx,dragpx,dragvx,dragy,dragpy,dragvy,dragz,dragpz, &
      dragvz,torqx,torqpx,torqvx,torqy,torqpy,torqvy,torqz,torqpz,torqvz,dpdx_mean,dpdy_mean, &
      dpdz_mean,dgtq,flow_rate,base_flow,domain_length,xsec,scale_vf,pm1,sij_torque_calc,ur,us,ut, &
      vr,vs,vt,wr,ws,wt,trx_torque_calc,trz_torque_calc,zm0)
      sij = reshape(sij_torque_calc, shape(sij))
      trx = reshape(trx_torque_calc, shape(trx))
      trz = reshape(trz_torque_calc, shape(trz))
      rho    = 1.
      a_w    = 19.7
      utau= sqrt(dragx(1)**2+dragz(1)**2)/a_w
      utau=sqrt(utau)
      gradux_gradm1 = reshape(gradux,shape(gradux_gradm1))
      graduy_gradm1 = reshape(graduy,shape(graduy_gradm1))
      graduz_gradm1 = reshape(graduz,shape(graduz_gradm1))
      vx_gradm1 = reshape(vx,shape(vx_gradm1))
      call gradm1(gradux_gradm1,graduy_gradm1,graduz_gradm1,vx_gradm1,ab,abmsh,abx1,abx2,aby1,aby2, &
      abz1,abz2,area,atol,avdiff,avtran,b1ia1,b1ia1t,b1mask,b2mask,b2p,b3mask,baxm1,bbx1,bbx2, &
      bby1,bby2,bbz1,bbz2,bc,bcf,bctyps,bd,bdivw,bfx,bfxp,bfy,bfyp,bfz,bfzp,bintm1,binvdg,binvm1, &
      bm1,bm1lag,bm2,bm2inv,bmass,bmnv,bmx,bmy,bmz,bpmask,bq,bqp,bx,bxlag,by,bylag,bz,bzlag,c_vx, &
      cbc,ccurve,cdof,cerror,cflf,courno,cpfld,cpgrp,cr_h,cr_re2,csize,ctarg,curve,d1,d1t,d2,da, &
      dam1,dam12,dam3,dat,datm1,datm12,datm3,dcm1,dcm12,dcm3,dcount,dct,dctm1,dctm12,dctm3, &
      dg_face,dg_hndlx,dglg,dglgt,dlam,dmpfle,dp0thdt,drivc,dt,dtinit,dtinvm,dtlag,dvdfh1,dvdfl2, &
      dvdfl8,dvdfsm,dvnnh1,dvnnl2,dvnnl8,dvnnsm,dvprh1,dvprl2,dvprl8,dvprsm,dxm1,dxm12,dxm3,dxtm1, &
      dxtm12,dxtm3,dym1,dym12,dym3,dytm1,dytm12,dytm3,dzm1,dzm12,dzm3,dztm1,dztm12,dztm3,eface, &
      eface1,eigaa,eigae,eigas,eigast,eigga,eigge,eiggs,eiggst,eskip,etalph,etimes,etims0,ev1,ev2, &
      ev3,exx1p,exx2p,exy1p,exy2p,exz1p,exz2p,fh_re2,filtertype,fintim,fldfle,fw,g1m1,g2m1,g3m1, &
      g4m1,g5m1,g6m1,gamma0,gcnnum,gednum,gedtyp,gllel,gllnid,group,gsh,gsh_fld,hcode,hisfle, &
      iajl1,iajl2,ialj1,ialj3,iam12,iam13,iam21,iam31,iatjl1,iatjl2,iatlj1,iatlj3,iatm12,iatm13, &
      iatm21,iatm31,ibcsts,icedg,icface,icm12,icm13,icm21,icm31,ictm12,ictm13,ictm21,ictm31,idpss, &
      idsess,ieact,iedge,iedgef,iedgfc,iesolv,if3d,if_full_pres,ifaa,ifadvc,ifae,ifalgn,ifanl2, &
      ifanls,ifas,ifast,ifaxis,ifaziv,ifbase,ifbcor,ifbo,ifchar,ifcons,ifcoup,ifcvfld,ifcvode, &
      ifcyclic,ifdeal,ifdg,ifdgfld,ifdiff,ifdp0dt,ifeppm,ifessr,ifexplvis,ifextr,ifexvt,ifflow, &
      iffmtin,ifga,ifge,ifgeom,ifgmsh3,ifgprnt,ifgs,ifgsh_fld_same,ifgst,ifheat,ifield,ifintq, &
      ifkeps,ifldmhd,iflmsc,iflmse,iflmsf,iflomach,ifmelt,ifmgrid,ifmhd,ifmoab,ifmodel,ifmodp, &
      ifmpiio,ifmscr,ifmseg,ifmsfc,ifmvbd,ifneknek,ifneknekm,ifnonl,ifnskp,ifoutfld,ifpert,ifpo, &
      ifprnt,ifprojfld,ifpsco,ifpso,ifqinp,ifreguo,ifrich,ifrsxy,ifrzer,ifschclob,ifskip,ifsplit, &
      ifssvt,ifstrs,ifstst,ifsurt,ifsync,iftgo,iftmsh,ifto,iftran,ifusermv,ifuservp,ifvarp,ifvcor, &
      ifvcoup,ifvo,ifvps,ifwcno,ifxyo,ifxyo_,iggl,igglt,igroup,im1d,im1dt,imatie,imd1,imd1t,imesh, &
      indx,initc,instep,invedg,iocomm,ioinfodmp,iostep,ipscal,ipsco,irstim,irstt,irstv,isize, &
      istep,ixcn,ixm12,ixm13,ixm21,ixm31,ixtm12,ixtm13,ixtm21,ixtm31,iym12,iym13,iym21,iym31, &
      iytm12,iytm13,iytm21,iytm31,izm12,izm13,izm21,izm31,iztm12,iztm13,iztm21,iztm31,jacm1,jacm2, &
      jacmi,jp,lastep,lcnnum,ldimr,lednum,lglel,lochis,loglevel,lsize,lyap,matids,matindx,matype, &
      maxmlt,mpi_argv_null,mpi_argvs_null,mpi_bottom,mpi_errcodes_ignore,mpi_in_place, &
      mpi_status_ignore,mpi_statuses_ignore,mpi_unweighted,mpi_weights_empty,nab,nabmsh,nadvc, &
      naxhm,nbbbb,nbd,nbdinp,nbso2,nbsol,ncall,ncccc,ncdtp,ncmp,nconv,nconv_max,ncopy,ncrsl,ncvf, &
      ndadd,ndddd,nddsl,ndg_facex,ndim,ndott,ndsmn,ndsmx,ndsnd,ndsum,neact,nedg,neeee,nelfld,nelg, &
      nelgt,nelgv,nelt,nelv,neslv,nfield,ngcomm,ngeom,ngop,ngop1,ngop_sync,ngp2,ngsmn,ngsmx, &
      ngspcn,ngsped,ngsum,nhis,nhmhz,nid,ninter,ninv3,ninvc,nio,nktonv,nmember,nmlinv,nmltd,nmxe, &
      nmxh,nmxmf,nmxms,nmxnl,nmxp,nobj,node,node0,noffst,nomlis,np,npert,nprep,npres,npscal, &
      nrefle,nrout,nsett,nslvb,nsolv,nspmax,nspro,nsskip,nsteps,nsyc,ntaubd,nu_star,nullpid, &
      numbcs,numflu,numoth,numscn,numsed,nusbc,nvdss,nvtot,nwal,nx1,nx2,nx3,nxd,ny1,ny2,ny3,nyd, &
      nz1,nz2,nz3,nzd,object,ocode,omask,optlevel,orefle,p0th,param,parfle,path,paxhm,pbbbb,pbso2, &
      pbsol,pcccc,pcdtp,pcopy,pcrsl,pdadd,pdddd,pddsl,pdott,pdsmn,pdsmx,pdsnd,pdsum,peeee,peslv, &
      pgop,pgop1,pgop_sync,pgp2,pgsmn,pgsmx,pgsum,phmhz,pi,pid,pinv3,pinvc,pm,pmask,pmd1,pmd1t, &
      pmlag,pmltd,pmxmf,pmxms,pprep,ppres,pr,prelax,prlag,prlagp,prp,psett,pslvb,psolv,pspro,psyc, &
      pusbc,pvdss,pwal,qinteg,qtl,rct,re2fle,re2off_b,reafle,restol,rname,rstim,rstt,rstv,rx,rxm1, &
      rxm2,rym1,rym2,rzm1,rzm2,schfle,session,skpdat,solver_type,sxm1,sxm2,sym1,sym2,szm1,szm2,t, &
      t1x,t1y,t1z,t2x,t2y,t2z,ta2s2,tadc3,tadd2,tadvc,tauss,taxhm,tbbbb,tbso2,tbsol,tcccc,tcdtp, &
      tcol2,tcol3,tcopy,tcrsl,tcvf,tdadd,tdddd,tddsl,tdott,tdsmn,tdsmx,tdsnd,tdsum,teeee,teslv, &
      textsw,tgop,tgop1,tgop_sync,tgp2,tgsmn,tgsmx,tgsum,thmhz,time,timef,timeio,tinit,tinv3, &
      tinvc,tlag,tlagp,tmask,tmean,tmltd,tmult,tmxmf,tmxms,tnrmh1,tnrml2,tnrml8,tnrmsm,tolabs, &
      tolev,tolhdf,tolhe,tolhr,tolhs,tolht,tolhv,tolnl,tolpdf,tolps,tolrel,tp,tprep,tpres,tproj, &
      tschw,tsett,tslvb,tsolv,tspro,tsyc,ttime,ttotal,tttstp,tusbc,tusfq,tvdss,twal,txm1,txm2, &
      txnext,tym1,tym2,tzm1,tzm2,unr,uns,unt,unx,uny,unz,uparam,ur,us,usrdiv,ut,v1mask,v1x,v1y, &
      v1z,v2mask,v2x,v2y,v2z,v3mask,vdiff,vdiff_e,vgradt1,vgradt1p,vgradt2,vgradt2p,vmean,vmult, &
      vnekton,vnrmh1,vnrml2,vnrml8,vnrmsm,vnx,vny,vnz,volel,volfld,voltm1,voltm2,volvm1,volvm2, &
      vtrans,vx_e,vxd,vxlag,vxlagp,vxp,vy,vy_e,vyd,vylag,vylagp,vyp,vz,vz_e,vzd,vzlag,vzlagp,vzp, &
      w1mask,w2am1,w2am2,w2am3,w2cm1,w2cm2,w2cm3,w2mask,w3m1,w3m2,w3m3,w3mask,wam1,wam2,wam3, &
      wdsize,wdsizi,wgl,wgl1,wgl2,wglg,wglgt,wgli,wgp,wmult,wx,wxlag,wxm1,wxm2,wxm3,wy,wylag,wym1, &
      wym2,wym3,wz,wzlag,wzm1,wzm2,wzm3,xc,xm1,xm2,xxth,yc,yinvm1,ym1,ym2,zam1,zam2,zam3,zc,zgl, &
      zgm1,zgm2,zgm3,zgp,zm1,zm2)
      ifnav = ifadvc(1)
      turbmod = textsw(1,1)
      gradux = reshape(gradux_gradm1, shape(gradux))
      graduy = reshape(graduy_gradm1, shape(graduy))
      graduz = reshape(graduz_gradm1, shape(graduz))
      vx = reshape(vx_gradm1, shape(vx))
      end subroutine userchk
      subroutine eddy_visc(e,ab,abmsh,abx1,abx2,aby1,aby2,abz1,abz2,area,atol,avdiff,avtran,b1ia1, &
      b1ia1t,b1mask,b2mask,b2p,b3mask,baxm1,bbx1,bbx2,bby1,bby2,bbz1,bbz2,bc,bcf,bctyps,bd,bdivw, &
      bfx,bfxp,bfy,bfyp,bfz,bfzp,bintm1,binvdg,binvm1,bm1,bm1lag,bm2,bm2inv,bmass,bmnv,bmx,bmy, &
      bmz,bpmask,bq,bqp,bx,bxlag,bxyi,by,bylag,bz,bzlag,c_vx,cbc,ccurve,cdof,cerror,cflf,courno, &
      cpfld,cpgrp,cr_h,cr_re2,cs,csize,ctarg,curve,d1,d1t,d2,da,dam1,dam12,dam3,dat,datm1,datm12, &
      datm3,dcm1,dcm12,dcm3,dcount,dct,dctm1,dctm12,dctm3,dg2,dg_face,dg_hndlx,dglg,dglgt,dlam, &
      dmpfle,dp0thdt,drivc,dt,dtinit,dtinvm,dtlag,dvdfh1,dvdfl2,dvdfl8,dvdfsm,dvnnh1,dvnnl2, &
      dvnnl8,dvnnsm,dvprh1,dvprl2,dvprl8,dvprsm,dxm1,dxm12,dxm3,dxtm1,dxtm12,dxtm3,dym1,dym12, &
      dym3,dytm1,dytm12,dytm3,dzm1,dzm12,dzm3,dztm1,dztm12,dztm3,ediff,eface,eface1,eigaa,eigae, &
      eigas,eigast,eigga,eigge,eiggs,eiggst,eigp,eskip,etalph,etimes,etims0,ev1,ev2,ev3,exx1p, &
      exx2p,exy1p,exy2p,exz1p,exz2p,fh_re2,filtertype,fintim,fldfle,fw,g1m1,g2m1,g3m1,g4m1,g5m1, &
      g6m1,gamma0,gcnnum,gednum,gedtyp,gllel,gllnid,group,gsh,gsh_fld,gtp_cbc,hcode,hisfle,iajl1, &
      iajl2,ialj1,ialj3,iam12,iam13,iam21,iam31,iatjl1,iatjl2,iatlj1,iatlj3,iatm12,iatm13,iatm21, &
      iatm31,ibcsts,icall,icedg,icface,icm12,icm13,icm21,icm31,ictm12,ictm13,ictm21,ictm31,idpss, &
      idsess,ieact,iedge,iedgef,iedgfc,iesolv,if3d,if_full_pres,ifaa,ifadvc,ifae,ifalgn,ifanl2, &
      ifanls,ifas,ifast,ifaxis,ifaziv,ifbase,ifbcor,ifbo,ifchar,ifcons,ifcoup,ifcvfld,ifcvode, &
      ifcyclic,ifdeal,ifdg,ifdgfld,ifdiff,ifdp0dt,ifemat,ifeppm,ifessr,ifexplvis,ifextr,ifexvt, &
      ifflow,iffmtin,ifga,ifge,ifgeom,ifgfdm,ifgmsh3,ifgprnt,ifgs,ifgsh_fld_same,ifgst,ifgtp, &
      ifheat,ifield,ifintq,ifkeps,ifldmhd,iflmsc,iflmse,iflmsf,iflomach,ifmelt,ifmgrid,ifmhd, &
      ifmoab,ifmodel,ifmodp,ifmpiio,ifmscr,ifmseg,ifmsfc,ifmvbd,ifneknek,ifneknekm,ifnonl,ifnskp, &
      ifoutfld,ifpert,ifpo,ifprnt,ifprojfld,ifpsco,ifpso,ifqinp,ifreguo,ifrich,ifrsxy,ifrzer, &
      ifschclob,ifskip,ifsplit,ifssvt,ifstrs,ifstst,ifsurt,ifsync,iftgo,iftmsh,ifto,iftran, &
      ifusermv,ifuservp,ifvarp,ifvcor,ifvcoup,ifvo,ifvps,ifwcno,ifxyo,ifxyo_,ifycrv,ifzper,iggl, &
      igglt,igroup,im1d,im1dt,imatie,imd1,imd1t,imesh,ind23,indx,initc,instep,invedg,iocomm, &
      ioinfodmp,iostep,ipscal,ipsco,irstim,irstt,irstv,isize,istep,ixcn,ixm12,ixm13,ixm21,ixm31, &
      ixtm12,ixtm13,ixtm21,ixtm31,iym12,iym13,iym21,iym31,iytm12,iytm13,iytm21,iytm31,izm12,izm13, &
      izm21,izm31,iztm12,iztm13,iztm21,iztm31,jacm1,jacm2,jacmi,jp,lastep,lcnnum,ldimr,lednum, &
      lex2pst,lglel,lochis,loglevel,lsize,lyap,matids,matindx,matype,maxmlt,mcex,mlp, &
      mpi_argv_null,mpi_argvs_null,mpi_bottom,mpi_errcodes_ignore,mpi_in_place,mpi_status_ignore, &
      mpi_statuses_ignore,mpi_unweighted,mpi_weights_empty,msg_id,msp,nab,nabmsh,nadvc,naxhm, &
      nbbbb,nbd,nbdinp,nbso2,nbsol,ncall,ncccc,ncdtp,ncmp,nconv,nconv_max,ncopy,ncrsl,ncvf,ndadd, &
      ndddd,nddsl,ndg_facex,ndim,ndott,ndsmn,ndsmx,ndsnd,ndsum,neact,nedg,neeee,neigx,neigy,neigz, &
      nekcomm,nekgroup,nekreal,nelfld,nelg,nelgt,nelgv,nelt,nelv,nelx,nelxy,nely,nelz,neslv, &
      nfield,ngcomm,ngeom,ngfdm_p,ngfdm_v,ngop,ngop1,ngop_sync,ngp2,ngsmn,ngsmx,ngspcn,ngsped, &
      ngsum,nhis,nhmhz,nid,ninter,ninv3,ninvc,nio,nktonv,nmember,nmlinv,nmltd,nmxe,nmxh,nmxmf, &
      nmxms,nmxnl,nmxp,nobj,node,node0,noffst,nomlis,np,npert,nprep,npres,npscal,nrefle,nrout, &
      nsett,nslvb,nsolv,nspmax,nspro,nsskip,nsteps,nsyc,ntaubd,nu_star,nullpid,numbcs,numflu, &
      numoth,numscn,numsed,nusbc,nvdss,nvtot,nwal,nx1,nx2,nx3,nxd,ny1,ny2,ny3,nyd,nz1,nz2,nz3,nzd, &
      object,ocode,omask,optlevel,orefle,p0th,param,parfle,part_in,part_out,path,paxhm,pbbbb, &
      pbso2,pbsol,pcccc,pcdtp,pcopy,pcrsl,pdadd,pdddd,pddsl,pdott,pdsmn,pdsmx,pdsnd,pdsum,peeee, &
      peslv,pgop,pgop1,pgop_sync,pgp2,pgsmn,pgsmx,pgsum,phmhz,pi,pid,pinv3,pinvc,pm,pmask,pmd1, &
      pmd1t,pmlag,pmltd,pmxmf,pmxms,pprep,ppres,pr,prelax,prlag,prlagp,prp,psett,pslvb,psolv, &
      pspro,pst2lex,psyc,pusbc,pvalx,pvaly,pvalz,pvdss,pvecx,pvecy,pvecz,pwal,qinteg,qtl,rct, &
      re2fle,re2off_b,reafle,restol,rname,rstim,rstt,rstv,rx,rx2,rxm1,rxm2,ry2,rym1,rym2,rzm1, &
      rzm2,schfle,session,sij,skpdat,snrm,solver_type,sp,spt,sx2,sxm1,sxm2,sy2,sym1,sym2,szm1, &
      szm2,t,t1x,t1y,t1z,t2x,t2y,t2z,ta2s2,tadc3,tadd2,tadvc,tauss,taxhm,tbbbb,tbso2,tbsol,tcccc, &
      tcdtp,tcol2,tcol3,tcopy,tcrsl,tcvf,tdadd,tdddd,tddsl,tdott,tdsmn,tdsmx,tdsnd,tdsum,teeee, &
      teslv,textsw,tgop,tgop1,tgop_sync,tgp2,tgsmn,tgsmx,tgsum,thmhz,time,timef,timeio,tinit, &
      tinv3,tinvc,tlag,tlagp,tmask,tmean,tmltd,tmult,tmxmf,tmxms,tnrmh1,tnrml2,tnrml8,tnrmsm, &
      tolabs,tolev,tolhdf,tolhe,tolhr,tolhs,tolht,tolhv,tolnl,tolpdf,tolps,tolrel,tp,tpn1,tpn2, &
      tpn3,tprep,tpres,tproj,tschw,tsett,tslvb,tsolv,tspro,tsyc,ttime,ttotal,tttstp,tusbc,tusfq, &
      tvdss,twal,txm1,txm2,txnext,tym1,tym2,tzm1,tzm2,unr,uns,unt,unx,uny,unz,uparam,usrdiv, &
      v1mask,v1x,v1y,v1z,v2mask,v2x,v2y,v2z,v3mask,vdiff,vdiff_e,vgradt1,vgradt1p,vgradt2, &
      vgradt2p,vmean,vmult,vnekton,vnrmh1,vnrml2,vnrml8,vnrmsm,vnx,vny,vnz,volel,volfld,voltm1, &
      voltm2,volvm1,volvm2,vtrans,vx,vx_e,vxd,vxlag,vxlagp,vxp,vy,vy_e,vyd,vylag,vylagp,vyp,vz, &
      vz_e,vzd,vzlag,vzlagp,vzp,w1mask,w2am1,w2am2,w2am3,w2cm1,w2cm2,w2cm3,w2d,w2mask,w3m1,w3m2, &
      w3m3,w3mask,wam1,wam2,wam3,wavep,wdsize,wdsizi,wgl,wgl1,wgl2,wglg,wglgt,wgli,wgp,wmult,wx, &
      wxlag,wxm1,wxm2,wxm3,wy,wylag,wym1,wym2,wym3,wz,wzlag,wzm1,wzm2,wzm3,xc,xgtp,xm1,xm2,xmlt, &
      xxth,yc,ygtp,yinvm1,ym1,ym2,ymlt,zam1,zam2,zam3,zc,zgl,zgm1,zgm2,zgm3,zgp,zgtp,zm1,zm2,zmlt)
      implicit none
      integer, parameter :: ldim=3
      integer, parameter :: lx1=8
      integer, parameter :: lxd=12
      integer, parameter :: lx2=lx1-2
      integer, parameter :: lelg=30*20*24
      integer, parameter :: lpmin=12
      integer, parameter :: lpmax=1024
      integer, parameter :: ldimt=1
      integer, parameter :: ldimt_proj=1
      integer, parameter :: lhis=1000
      integer, parameter :: maxobj=4
      integer, parameter :: lpert=1
      integer, parameter :: toteq=5
      integer, parameter :: nsessmax=2
      integer, parameter :: lxo=lx1
      integer, parameter :: mxprev=20
      integer, parameter :: lgmres=30
      integer, parameter :: lorder=3
      integer, parameter :: lx1m=lx1
      integer, parameter :: lfdm=0
      integer, parameter :: lelx=1
      integer, parameter :: lely=1
      integer, parameter :: lelz=1
      integer, parameter :: lelt=lelg/lpmin+3
      integer, parameter :: lbelt=1
      integer, parameter :: lpelt=1
      integer, parameter :: lcvelt=lelt
! 
!      Include file to dimension static arrays
!      and to set some hardwired run-time parameters
! 
      ! basic
      ! optional
      ! internals
!  - - SIZE internals
      ! averaging
      ! adjoint
      ! mhd
      integer, parameter :: maxrts=1000
      real(kind=8), intent(InOut) :: dcount
      real(kind=8), dimension(1:maxrts), intent(InOut) :: dct
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: dg2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: ediff
      real(kind=8), intent(In) :: etimes
      real(kind=8) :: etims0
      integer, intent(In) :: icall
      logical :: ifsync
      character, dimension(1:1) :: mpi_argv_null
      character, dimension(1:1,1:1) :: mpi_argvs_null
      integer :: mpi_bottom
      integer, dimension(1:1) :: mpi_errcodes_ignore
      integer :: mpi_in_place
            integer, parameter :: mpi_status_size=6
      integer, dimension(1:mpi_status_size) :: mpi_status_ignore
      integer, dimension(1:mpi_status_size,1:1) :: mpi_statuses_ignore
      integer, dimension(1:1) :: mpi_unweighted
      integer, dimension(1:1) :: mpi_weights_empty
      integer :: nadvc
      integer :: naxhm
      integer :: nbbbb
      integer :: nbso2
      integer :: nbsol
      integer, dimension(1:maxrts), intent(InOut) :: ncall
      integer :: ncccc
      integer :: ncdtp
      integer :: ncopy
      integer :: ncrsl
      integer :: ncvf
      integer :: ndadd
      integer :: ndddd
      integer :: nddsl
      integer :: ndott
      integer :: ndsmn
      integer :: ndsmx
      integer :: ndsnd
      integer :: ndsum
      integer :: neeee
      integer :: nekcomm
      integer :: nekgroup
      integer :: nekreal
      integer :: neslv
      integer :: ngop
      integer :: ngop1
      integer :: ngop_sync
      integer :: ngp2
      integer :: ngsmn
      integer :: ngsmx
      integer :: ngsum
      integer :: nhmhz
      integer :: ninv3
      integer :: ninvc
      integer :: nmltd
      integer :: nmxmf
      integer :: nmxms
      integer :: nprep
      integer :: npres
      integer, intent(InOut) :: nrout
      integer :: nsett
      integer :: nslvb
      integer :: nsolv
      integer :: nspro
      integer :: nsyc
      integer :: nusbc
      integer :: nvdss
      integer :: nwal
      real(kind=8) :: paxhm
      real(kind=8) :: pbbbb
      real(kind=8) :: pbso2
      real(kind=8) :: pbsol
      real(kind=8) :: pcccc
      real(kind=8) :: pcdtp
      real(kind=8) :: pcopy
      real(kind=8) :: pcrsl
      real(kind=8) :: pdadd
      real(kind=8) :: pdddd
      real(kind=8) :: pddsl
      real(kind=8) :: pdott
      real(kind=8) :: pdsmn
      real(kind=8) :: pdsmx
      real(kind=8) :: pdsnd
      real(kind=8) :: pdsum
      real(kind=8) :: peeee
      real(kind=8) :: peslv
      real(kind=8) :: pgop
      real(kind=8) :: pgop1
      real(kind=8) :: pgop_sync
      real(kind=8) :: pgp2
      real(kind=8) :: pgsmn
      real(kind=8) :: pgsmx
      real(kind=8) :: pgsum
      real(kind=8) :: phmhz
      real(kind=8) :: pinv3
      real(kind=8) :: pinvc
      real(kind=8) :: pmltd
      real(kind=8) :: pmxmf
      real(kind=8) :: pmxms
      real(kind=8) :: pprep
      real(kind=8) :: ppres
      real(kind=8) :: psett
      real(kind=8) :: pslvb
      real(kind=8) :: psolv
      real(kind=8) :: pspro
      real(kind=8) :: psyc
      real(kind=8) :: pusbc
      real(kind=8) :: pvdss
      real(kind=8) :: pwal
      real(kind=8), dimension(1:maxrts) :: rct
      character(len=6), dimension(1:maxrts), intent(Out) :: rname
      real(kind=8) :: ta2s2
      real(kind=8) :: tadc3
      real(kind=8) :: tadd2
      real(kind=8) :: tadvc
      real(kind=8) :: taxhm
      real(kind=8) :: tbbbb
      real(kind=8) :: tbso2
      real(kind=8) :: tbsol
      real(kind=8) :: tcccc
      real(kind=8) :: tcdtp
      real(kind=8) :: tcol2
      real(kind=8) :: tcol3
      real(kind=8) :: tcopy
      real(kind=8) :: tcrsl
      real(kind=8) :: tcvf
      real(kind=8) :: tdadd
      real(kind=8) :: tdddd
      real(kind=8) :: tddsl
      real(kind=8) :: tdott
      real(kind=8) :: tdsmn
      real(kind=8) :: tdsmx
      real(kind=8) :: tdsnd
      real(kind=8) :: tdsum
      real(kind=8) :: teeee
      real(kind=8) :: teslv
      real(kind=8) :: tgop
      real(kind=8) :: tgop1
      real(kind=8) :: tgop_sync
      real(kind=8) :: tgp2
      real(kind=8) :: tgsmn
      real(kind=8) :: tgsmx
      real(kind=8) :: tgsum
      real(kind=8) :: thmhz
      real(kind=8) :: tinit
      real(kind=8) :: tinv3
      real(kind=8) :: tinvc
      real(kind=8) :: tmltd
      real(kind=8), intent(Out) :: tmxmf
      real(kind=8) :: tmxms
      real(kind=8), intent(In) :: tprep
      real(kind=8) :: tpres
      real(kind=8) :: tproj
      real(kind=8) :: tschw
      real(kind=8) :: tsett
      real(kind=8) :: tslvb
      real(kind=8) :: tsolv
      real(kind=8) :: tspro
      real(kind=8) :: tsyc
      real(kind=8), intent(In) :: ttime
      real(kind=8), intent(InOut) :: ttotal
      real(kind=8) :: tttstp
      real(kind=8) :: tusbc
      real(kind=8) :: tusfq
      real(kind=8) :: tvdss
      real(kind=8) :: twal
      integer :: ntot
      integer :: nio
      ! cvode
      ! nek-nek
      integer :: loglevel
      integer :: optlevel
      integer :: nelv
      integer :: nelt
      integer :: nfield
      integer :: npert
      integer, intent(In) :: nid
      integer :: idsess
      integer, intent(In) :: nx1
      integer, intent(In) :: ny1
      integer, intent(In) :: nz1
      integer :: nx2
      integer :: ny2
      integer :: nz2
      integer :: nx3
      integer :: ny3
      integer :: nz3
      integer :: nxd
      integer :: nyd
      integer :: nzd
      integer :: ndim
      integer :: ldimr
      integer, parameter :: numsts=50
      integer, parameter :: nelgt_max=178956970
      integer, parameter :: lvt1=lx1*ly1*lz1*lelv
      integer, parameter :: lvt2=lx2*ly2*lz2*lelv
      integer, parameter :: lbt1=lbx1*lby1*lbz1*lbelv
      integer, parameter :: lbt2=lbx2*lby2*lbz2*lbelv
      integer, parameter :: lorder2=max(1,lorder-2)
      integer, parameter :: lxq=lx2
! 
!      Elemental derivative operators
! 
      real, dimension(1:lx1,1:lx1), intent(InOut) :: dxm1
      real, dimension(1:lx2,1:lx1) :: dxm12
      real, dimension(1:ly1,1:ly1) :: dym1
      real, dimension(1:ly2,1:ly1) :: dym12
      real, dimension(1:lz1,1:lz1) :: dzm1
      real, dimension(1:lz2,1:lz1) :: dzm12
      real, dimension(1:lx1,1:lx1), intent(InOut) :: dxtm1
      real, dimension(1:lx1,1:lx2) :: dxtm12
      real, dimension(1:ly1,1:ly1) :: dytm1
      real, dimension(1:ly1,1:ly2) :: dytm12
      real, dimension(1:lz1,1:lz1) :: dztm1
      real, dimension(1:lz1,1:lz2) :: dztm12
      real, dimension(1:lx3,1:lx3) :: dxm3
      real, dimension(1:lx3,1:lx3) :: dxtm3
      real, dimension(1:ly3,1:ly3) :: dym3
      real, dimension(1:ly3,1:ly3) :: dytm3
      real, dimension(1:lz3,1:lz3) :: dzm3
      real, dimension(1:lz3,1:lz3) :: dztm3
      real, dimension(1:ly1,1:ly1) :: dcm1
      real, dimension(1:ly1,1:ly1) :: dctm1
      real, dimension(1:ly3,1:ly3) :: dcm3
      real, dimension(1:ly3,1:ly3) :: dctm3
      real, dimension(1:ly2,1:ly1) :: dcm12
      real, dimension(1:ly1,1:ly2) :: dctm12
      real, dimension(1:ly1,1:ly1) :: dam1
      real, dimension(1:ly1,1:ly1) :: datm1
      real, dimension(1:ly2,1:ly1) :: dam12
      real, dimension(1:ly1,1:ly2) :: datm12
      real, dimension(1:ly3,1:ly3) :: dam3
      real, dimension(1:ly3,1:ly3) :: datm3
! 
!     Dealiasing variables
! 
      real, dimension(1:lxd,1:lyd,1:lzd,1:lelv) :: vxd
      real, dimension(1:lxd,1:lyd,1:lzd,1:lelv) :: vyd
      real, dimension(1:lxd,1:lyd,1:lzd,1:lelv) :: vzd
      real, dimension(1:lx1,1:lxd) :: imd1
      real, dimension(1:lxd,1:lx1) :: imd1t
      real, dimension(1:lxd,1:lx1) :: im1d
      real, dimension(1:lx1,1:lxd) :: im1dt
      real, dimension(1:lx1,1:lxd) :: pmd1
      real, dimension(1:lxd,1:lx1) :: pmd1t
! 
!      Eigenvalues
! 
      real :: eigas
      real :: eigaa
      real :: eigast
      real :: eigae
      real :: eigga
      real :: eiggs
      real :: eiggst
      real :: eigge
      logical :: ifaa
      logical :: ifae
      logical :: ifas
      logical :: ifast
      logical :: ifga
      logical :: ifge
      logical :: ifgs
      logical :: ifgst
! 
!      Geometry arrays
! 
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: xm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: ym1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: zm1
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: xm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: ym2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: zm2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: rxm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: sxm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: txm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: rym1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: sym1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: tym1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: rzm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: szm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt), intent(In) :: tzm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: jacm1
      real, dimension(1:lx1*ly1*lz1,1:lelt), intent(In) :: jacmi
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: rxm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: sxm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: txm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: rym2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: sym2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: tym2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: rzm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: szm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: tzm2
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: jacm2
      real, dimension(1:lxd*lyd*lzd,1:ldim*ldim,1:lelv) :: rx
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g1m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g2m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g3m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g4m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g5m1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: g6m1
      real, dimension(1:lx1*lz1,1:6,1:lelt) :: unr
      real, dimension(1:lx1*lz1,1:6,1:lelt) :: uns
      real, dimension(1:lx1*lz1,1:6,1:lelt) :: unt
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: unx
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: uny
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: unz
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t1x
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t1y
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t1z
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t2x
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t2y
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: t2z
      real, dimension(1:lx1,1:lz1,1:6,1:lelt) :: area
      real, dimension(1:lx1*lz1,1:2*ldim,1:lelt) :: etalph
      real :: dlam
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: vnx
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: vny
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: vnz
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v1x
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v1y
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v1z
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v2x
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v2y
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: v2z
      logical :: ifgeom
      logical :: ifgmsh3
      logical :: ifvcor
      logical :: ifsurt
      logical :: ifmelt
      logical :: ifwcno
      logical, dimension(1:lelt) :: ifrzer
      logical, dimension(1:2*ldim,1:lelv) :: ifqinp
      logical, dimension(1:2*ldim,1:lelv) :: ifeppm
      logical, dimension(0:1) :: iflmsf
      logical, dimension(0:1) :: iflmse
      logical, dimension(0:1) :: iflmsc
      logical, dimension(1:2*ldim,1:lelt,0:1) :: ifmsfc
      logical, dimension(1:12,1:lelt,0:1) :: ifmseg
      logical, dimension(1:8,1:lelt,0:1) :: ifmscr
      logical, dimension(1:8,1:lelt) :: ifnskp
      logical :: ifbcor
! 
!      Input parameters from preprocessors.
! 
!      Note that in parallel implementations, we distinguish between
!      distributed data (LELT) and uniformly distributed data.
! 
!      Input common block structure:
! 
!      INPUT1:  REAL            INPUT5: REAL      with LELT entries
!      INPUT2:  INTEGER         INPUT6: INTEGER   with LELT entries
!      INPUT3:  LOGICAL         INPUT7: LOGICAL   with LELT entries
!      INPUT4:  CHARACTER       INPUT8: CHARACTER with LELT entries
! 
      real, dimension(1:200) :: param
      real :: rstim
      real :: vnekton
      real, dimension(1:ldimt1,1:3) :: cpfld
      real, dimension(-5:10,1:ldimt1,1:3) :: cpgrp
      real, dimension(1:ldimt3,1:maxobj) :: qinteg
      real, dimension(1:20) :: uparam
      real, dimension(0:ldimt1) :: atol
      real, dimension(0:ldimt1) :: restol
      real :: filtertype
      integer, dimension(-5:10,1:ldimt1) :: matype
      integer :: nktonv
      integer :: nhis
      integer, dimension(1:4,1:lhis+maxobj) :: lochis
      integer :: ipscal
      integer :: npscal
      integer :: ipsco
      integer :: ifldmhd
      integer :: irstv
      integer :: irstt
      integer :: irstim
      integer, dimension(1:maxobj) :: nmember
      integer :: nobj
      integer :: ngeom
      integer, dimension(1:ldimt) :: idpss
      logical, intent(In) :: if3d
      logical :: ifflow
      logical :: ifheat
      logical :: iftran
      logical, intent(In) :: ifaxis
      logical :: ifstrs
      logical :: ifsplit
      logical :: ifmgrid
      logical, dimension(1:ldimt1) :: ifadvc
      logical, dimension(1:ldimt1) :: ifdiff
      logical, dimension(1:ldimt1) :: ifdeal
      logical, dimension(0:ldimt1) :: ifprojfld
      logical, dimension(0:ldimt1) :: iftmsh
      logical, dimension(0:ldimt1) :: ifdgfld
      logical :: ifdg
      logical :: ifmvbd
      logical :: ifchar
      logical, dimension(1:ldimt1) :: ifnonl
      logical, dimension(1:ldimt1) :: ifvarp
      logical, dimension(1:ldimt1) :: ifpsco
      logical :: ifvps
      logical :: ifmodel
      logical :: ifkeps
      logical :: ifintq
      logical :: ifcons
      logical :: ifxyo
      logical :: ifpo
      logical :: ifvo
      logical :: ifto
      logical :: iftgo
      logical, dimension(1:ldimt1) :: ifpso
      logical :: iffmtin
      logical :: ifbo
      logical :: ifanls
      logical :: ifanl2
      logical :: ifmhd
      logical :: ifessr
      logical :: ifpert
      logical :: ifbase
      logical :: ifcvode
      logical :: iflomach
      logical :: ifexplvis
      logical :: ifschclob
      logical :: ifuservp
      logical :: ifcyclic
      logical :: ifmoab
      logical :: ifcoup
      logical :: ifvcoup
      logical :: ifusermv
      logical :: ifreguo
      logical :: ifxyo_
      logical :: ifaziv
      logical, intent(In) :: ifneknek
      logical :: ifneknekm
      logical, dimension(1:ldimt1) :: ifcvfld
      logical :: ifdp0dt
      logical :: ifmpiio
      logical :: ifrich
      logical :: ifnav
      character(len=1), dimension(1:11,1:lhis+maxobj) :: hcode
      character(len=2), dimension(1:8) :: ocode
      character(len=10), dimension(1:5) :: drivc
      character(len=14) :: rstv
      character(len=14) :: rstt
      character(len=40), dimension(1:100,1:2) :: textsw
      character(len=132), dimension(1:15) :: initc
      character(len=40) :: turbmod
      character(len=132) :: reafle
      character(len=132) :: fldfle
      character(len=132) :: dmpfle
      character(len=132) :: hisfle
      character(len=132) :: schfle
      character(len=132) :: orefle
      character(len=132) :: nrefle
      character(len=132) :: session
      character(len=132) :: path
      character(len=132) :: re2fle
      character(len=132) :: parfle
      integer :: cr_re2
      integer :: fh_re2
      integer(kind=8) :: re2off_b
! 
!  proportional to LELT
! 
      real, dimension(1:8,1:lelt) :: xc
      real, dimension(1:8,1:lelt) :: yc
      real, dimension(1:8,1:lelt) :: zc
      real, dimension(1:5,1:6,1:lelt,0:ldimt1) :: bc
      real, dimension(1:6,1:12,1:lelt) :: curve
      real, dimension(1:lelt) :: cerror
      integer, dimension(1:lelt) :: igroup
      integer, dimension(1:maxobj,1:maxmbr,1:2) :: object
      character(len=1), dimension(1:12,1:lelt) :: ccurve
      character(len=1), dimension(1:6,1:lelt) :: cdof
      character(len=3), dimension(1:6,1:lelt,0:ldimt1) :: cbc
      character(len=3) :: solver_type
      integer, dimension(1:lelt) :: ieact
      integer :: neact
! 
!  material set ids, BC set ids, materials (f=fluid, s=solid), bc types
! 
      integer :: numflu
      integer :: numoth
      integer :: numbcs
      integer, dimension(1:numsts) :: matindx
      integer, dimension(1:numsts) :: matids
      integer, dimension(1:lelt) :: imatie
      integer, dimension(1:numsts) :: ibcsts
      integer, dimension(1:numsts) :: bcf
      character(len=3), dimension(1:numsts) :: bctyps
! 
!      Interpolation operators
! 
      real, dimension(1:lx2,1:lx1) :: ixm12
      real, dimension(1:lx1,1:lx2) :: ixm21
      real, dimension(1:ly2,1:ly1) :: iym12
      real, dimension(1:ly1,1:ly2) :: iym21
      real, dimension(1:lz2,1:lz1) :: izm12
      real, dimension(1:lz1,1:lz2) :: izm21
      real, dimension(1:lx1,1:lx2) :: ixtm12
      real, dimension(1:lx2,1:lx1) :: ixtm21
      real, dimension(1:ly1,1:ly2) :: iytm12
      real, dimension(1:ly2,1:ly1) :: iytm21
      real, dimension(1:lz1,1:lz2) :: iztm12
      real, dimension(1:lz2,1:lz1) :: iztm21
      real, dimension(1:lx3,1:lx1) :: ixm13
      real, dimension(1:lx1,1:lx3) :: ixm31
      real, dimension(1:ly3,1:ly1) :: iym13
      real, dimension(1:ly1,1:ly3) :: iym31
      real, dimension(1:lz3,1:lz1) :: izm13
      real, dimension(1:lz1,1:lz3) :: izm31
      real, dimension(1:lx1,1:lx3) :: ixtm13
      real, dimension(1:lx3,1:lx1) :: ixtm31
      real, dimension(1:ly1,1:ly3) :: iytm13
      real, dimension(1:ly3,1:ly1) :: iytm31
      real, dimension(1:lz1,1:lz3) :: iztm13
      real, dimension(1:lz3,1:lz1) :: iztm31
      real, dimension(1:ly2,1:ly1) :: iam12
      real, dimension(1:ly1,1:ly2) :: iam21
      real, dimension(1:ly1,1:ly2) :: iatm12
      real, dimension(1:ly2,1:ly1) :: iatm21
      real, dimension(1:ly3,1:ly1) :: iam13
      real, dimension(1:ly1,1:ly3) :: iam31
      real, dimension(1:ly1,1:ly3) :: iatm13
      real, dimension(1:ly3,1:ly1) :: iatm31
      real, dimension(1:ly2,1:ly1) :: icm12
      real, dimension(1:ly1,1:ly2) :: icm21
      real, dimension(1:ly1,1:ly2) :: ictm12
      real, dimension(1:ly2,1:ly1) :: ictm21
      real, dimension(1:ly3,1:ly1) :: icm13
      real, dimension(1:ly1,1:ly3) :: icm31
      real, dimension(1:ly1,1:ly3) :: ictm13
      real, dimension(1:ly3,1:ly1) :: ictm31
      real, dimension(1:ly1,1:ly1) :: iajl1
      real, dimension(1:ly1,1:ly1) :: iatjl1
      real, dimension(1:ly2,1:ly2) :: iajl2
      real, dimension(1:ly2,1:ly2) :: iatjl2
      real, dimension(1:ly3,1:ly3) :: ialj3
      real, dimension(1:ly3,1:ly3) :: iatlj3
      real, dimension(1:ly1,1:ly1) :: ialj1
      real, dimension(1:ly1,1:ly1) :: iatlj1
! 
!      Mass matrix
! 
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: bm1
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: bm2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: binvm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: bintm1
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelt) :: bm2inv
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: baxm1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:lorder-1) :: bm1lag
      real :: volvm1
      real :: volvm2
      real :: voltm1
      real :: voltm2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: yinvm1
      real, dimension(1:lx1*ly1*lz1,1:lelt) :: binvdg
! 
!      Moving mesh variables
! 
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: wx
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: wy
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: wz
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt,1:lorder-1) :: wxlag
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt,1:lorder-1) :: wylag
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt,1:lorder-1) :: wzlag
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: w1mask
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: w2mask
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: w3mask
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelt) :: wmult
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelv) :: ev1
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelv) :: ev2
      real, dimension(1:lx1m,1:ly1m,1:lz1m,1:lelv) :: ev3
! 
!      Communication information
!      NOTE: NID is stored in 'SIZE' for greater accessibility
      integer :: node
      integer :: pid
      integer, intent(In) :: np
      integer :: nullpid
      integer :: node0
! 
!      Maximum number of elements (limited to 2**31/12, at least for now)
      integer(kind=8), intent(In) :: nvtot
      integer, dimension(0:ldimt1) :: nelg
      integer, dimension(1:lelt) :: lglel
      integer, dimension(1:lelg) :: gllel
      integer, dimension(1:lelg) :: gllnid
      integer :: nelgv
      integer :: nelgt
      logical :: ifgprnt
      integer :: wdsize
      integer :: isize
      integer :: lsize
      integer :: csize
      integer :: wdsizi
!      crystal-router, gather-scatter, and xxt handles (xxt=csr grid solve)
! 
      integer :: cr_h
      integer :: gsh
      integer, dimension(0:ldimt3) :: gsh_fld
      integer, dimension(1:ldimt3) :: xxth
      logical :: ifgsh_fld_same
!      These arrays need to be reconciled with cmt (pff, 11/03/15)
      integer, dimension(1:lx1*lz1*2*ldim*lelt) :: dg_face
      integer :: dg_hndlx
      integer :: ndg_facex
! 
!      Main storage of simulation variables
! 
! 
!      Solution and data
! 
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: bq
!      Can be used for post-processing runs (SIZE .gt. 10+3*LDIMT flds)
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv,1:2) :: vxlag
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv,1:2) :: vylag
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv,1:2) :: vzlag
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:lorder-1,1:ldimt) :: tlag
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: vgradt1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: vgradt2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: abx1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: aby1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: abz1
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: abx2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: aby2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: abz2
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: vdiff_e
!      Solution data
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv), intent(InOut) :: vx
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv), intent(InOut) :: vy
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv), intent(InOut) :: vz
      real, dimension(1:lx1*ly1*lz1*lelv) :: vx_e
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: vy_e
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: vz_e
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: t
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt1) :: vtrans
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt1) :: vdiff
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: bfx
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: bfy
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: bfz
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: cflf
      real, dimension(1:lx1*ly1*lz1*lelv*ldim,1:lorder+1) :: bmnv
      real, dimension(1:lx1*ly1*lz1*lelv*ldim,1:lorder+1) :: bmass
      real, dimension(1:lx1*ly1*lz1*lelv*ldim,1:lorder+1) :: bdivw
      real, dimension(1:lxd*lyd*lzd*lelv*ldim,1:lorder+1) :: c_vx
      real, dimension(1:2*ldim,1:lelt) :: fw
!      Solution data for magnetic field
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bx
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: by
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bz
      real, dimension(1:lbx2,1:lby2,1:lbz2,1:lbelv) :: pm
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bmx
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bmy
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bmz
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bbx1
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bby1
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bbz1
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bbx2
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bby2
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bbz2
      real, dimension(1:lbx1*lby1*lbz1*lbelv,1:lorder-1) :: bxlag
      real, dimension(1:lbx1*lby1*lbz1*lbelv,1:lorder-1) :: bylag
      real, dimension(1:lbx1*lby1*lbz1*lbelv,1:lorder-1) :: bzlag
      real, dimension(1:lbx2*lby2*lbz2*lbelv,1:lorder2) :: pmlag
      real :: nu_star
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv) :: pr
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelv,1:lorder2) :: prlag
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelt) :: qtl
      real, dimension(1:lx2,1:ly2,1:lz2,1:lelt) :: usrdiv
      real :: p0th
      real :: dp0thdt
      real :: gamma0
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: v1mask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: v2mask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: v3mask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: pmask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: tmask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt) :: omask
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelv) :: vmult
      real, dimension(1:lx1,1:ly1,1:lz1,1:lelt,1:ldimt) :: tmult
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: b1mask
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: b2mask
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: b3mask
      real, dimension(1:lbx1,1:lby1,1:lbz1,1:lbelv) :: bpmask
! 
! 
!      Solution and data for perturbation fields
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: vxp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: vyp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: vzp
       real, dimension(1:lpx2*lpy2*lpz2*lpelv,1:lpert) :: prp
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lpert) :: tp
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lpert) :: bqp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: bfxp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: bfyp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: bfzp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lorder-1,1:lpert) :: vxlagp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lorder-1,1:lpert) :: vylagp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lorder-1,1:lpert) :: vzlagp
       real, dimension(1:lpx2*lpy2*lpz2*lpelv,1:lorder2,1:lpert) :: prlagp
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lorder-1,1:lpert) :: tlagp
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exx1p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exy1p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exz1p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exx2p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exy2p
       real, dimension(1:lpx1*lpy1*lpz1*lpelv,1:lpert) :: exz2p
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lpert) :: vgradt1p
       real, dimension(1:lpx1*lpy1*lpz1*lpelt,1:ldimt,1:lpert) :: vgradt2p
      integer :: jp
! 
!      Steady variables
! 
      real, dimension(1:ldimt1) :: tauss
      real, dimension(1:ldimt1) :: txnext
      integer :: nsskip
      logical :: ifskip
      logical :: ifmodp
      logical :: ifssvt
      logical, dimension(1:ldimt1) :: ifstst
      logical :: ifexvt
      logical, dimension(1:ldimt1) :: ifextr
      real :: dvnnh1
      real :: dvnnsm
      real :: dvnnl2
      real :: dvnnl8
      real :: dvdfh1
      real :: dvdfsm
      real :: dvdfl2
      real :: dvdfl8
      real :: dvprh1
      real :: dvprsm
      real :: dvprl2
      real :: dvprl8
! 
!      Arrays for direct stiffness summation
! 
      integer, dimension(1:2,1:3) :: nomlis
      integer, dimension(1:6) :: nmlinv
      integer, dimension(1:6) :: group
      integer, dimension(1:6,1:6) :: skpdat
      integer, dimension(1:6) :: eface
      integer, dimension(1:6) :: eface1
      integer, dimension(-12:12,1:3) :: eskip
      integer, dimension(1:3) :: nedg
      integer :: ncmp
      integer, dimension(1:8) :: ixcn
      integer, dimension(1:3,0:ldimt1) :: noffst
      integer :: maxmlt
      integer, dimension(0:ldimt1) :: nspmax
      integer, dimension(0:ldimt1) :: ngspcn
      integer, dimension(1:3,0:ldimt1) :: ngsped
      integer, dimension(1:lelt,0:ldimt1) :: numscn
      integer, dimension(1:lelt,0:ldimt1) :: numsed
      integer, dimension(1:8,1:lelt,0:ldimt1) :: gcnnum
      integer, dimension(1:8,1:lelt,0:ldimt1) :: lcnnum
      integer, dimension(1:12,1:lelt,0:ldimt1) :: gednum
      integer, dimension(1:12,1:lelt,0:ldimt1) :: lednum
      integer, dimension(1:12,1:lelt,0:ldimt1) :: gedtyp
      integer, dimension(1:2,0:ldimt1) :: ngcomm
      integer, dimension(1:20) :: iedge
      integer, dimension(1:2,1:4,1:6,0:1) :: iedgef
      integer, dimension(1:3,1:16) :: icedg
      integer, dimension(1:4,1:6) :: iedgfc
      integer, dimension(1:4,1:10) :: icface
      integer, dimension(1:8) :: indx
      integer, dimension(1:27) :: invedg
!  
!      Variables related to time integration
! 
      real :: time
      real :: timef
      real :: fintim
      real :: timeio
      real :: dt
      real, dimension(1:10) :: dtlag
      real :: dtinit
      real :: dtinvm
      real :: courno
      real :: ctarg
      real, dimension(1:10) :: ab
      real, dimension(1:10) :: bd
      real, dimension(1:10) :: abmsh
      real, dimension(1:ldimt1) :: avdiff
      real, dimension(1:ldimt1) :: avtran
      real, dimension(0:ldimt1) :: volfld
      real :: tolrel
      real :: tolabs
      real :: tolhdf
      real :: tolpdf
      real :: tolev
      real :: tolnl
      real :: prelax
      real :: tolps
      real :: tolhs
      real :: tolhr
      real :: tolhv
      real, dimension(1:ldimt1) :: tolht
      real :: tolhe
      real :: vnrmh1
      real :: vnrmsm
      real :: vnrml2
      real :: vnrml8
      real :: vmean
      real, dimension(1:ldimt) :: tnrmh1
      real, dimension(1:ldimt) :: tnrmsm
      real, dimension(1:ldimt) :: tnrml2
      real, dimension(1:ldimt) :: tnrml8
      real, dimension(1:ldimt) :: tmean
      integer :: ifield
      integer :: imesh
      integer, intent(In) :: istep
      integer :: nsteps
      integer :: iostep
      integer :: lastep
      integer :: iocomm
      integer :: instep
      integer :: nab
      integer :: nabmsh
      integer :: nbd
      integer :: nbdinp
      integer :: ntaubd
      integer :: nmxh
      integer :: nmxp
      integer :: nmxe
      integer :: nmxnl
      integer :: ninter
      integer, dimension(0:ldimt1) :: nelfld
      integer :: nconv
      integer :: nconv_max
      integer :: ioinfodmp
      real :: pi
      logical :: ifprnt
      logical :: if_full_pres
      logical :: ifoutfld
      real, dimension(1:3,1:lpert) :: lyap
! 
!      Variables for E-solver
! 
      integer :: iesolv
      logical, dimension(1:lelv) :: ifalgn
      logical, dimension(1:lelv) :: ifrsxy
      real, dimension(1:lelv) :: volel
! 
!      Gauss-Labotto and Gauss points
! 
      real, dimension(1:lx1,1:3) :: zgm1
      real, dimension(1:lx2,1:3) :: zgm2
      real, dimension(1:lx3,1:3) :: zgm3
      real, dimension(1:lx1) :: zam1
      real, dimension(1:lx2) :: zam2
      real, dimension(1:lx3) :: zam3
! 
!     Weights
! 
      real, dimension(1:lx1) :: wxm1
      real, dimension(1:ly1) :: wym1
      real, dimension(1:lz1) :: wzm1
      real, dimension(1:lx1,1:ly1,1:lz1) :: w3m1
      real, dimension(1:lx2) :: wxm2
      real, dimension(1:ly2) :: wym2
      real, dimension(1:lz2) :: wzm2
      real, dimension(1:lx2,1:ly2,1:lz2) :: w3m2
      real, dimension(1:lx3) :: wxm3
      real, dimension(1:ly3) :: wym3
      real, dimension(1:lz3) :: wzm3
      real, dimension(1:lx3,1:ly3,1:lz3) :: w3m3
      real, dimension(1:ly1) :: wam1
      real, dimension(1:ly2) :: wam2
      real, dimension(1:ly3) :: wam3
      real, dimension(1:lx1,1:ly1) :: w2am1
      real, dimension(1:lx1,1:ly1) :: w2cm1
      real, dimension(1:lx2,1:ly2) :: w2am2
      real, dimension(1:lx2,1:ly2) :: w2cm2
      real, dimension(1:lx3,1:ly3) :: w2am3
      real, dimension(1:lx3,1:ly3) :: w2cm3
! 
!      Points (z) and weights (w) on velocity, pressure
! 
!      zgl -- velocity points on Gauss-Lobatto points i = 1,...nx
!      zgp -- pressure points on Gauss         points i = 1,...nxp (nxp = nx-2)
! 
!      integer    lxm ! defined in HSMG
!      parameter (lxm = lx1)
! 
      real, dimension(1:lx1) :: zgl
      real, dimension(1:lx1) :: wgl
      real, dimension(1:lx1) :: zgp
      real, dimension(1:lxq) :: wgp
! 
!      Tensor- (outer-) product of 1D weights   (for volumetric integration)
! 
      real, dimension(1:lx1*lx1) :: wgl1
      real, dimension(1:lxq*lxq) :: wgl2
      real, dimension(1:lx1*lx1) :: wgli
! 
! 
!     Frequently used derivative matrices:
! 
!     D1, D1t   ---  differentiate on mesh 1 (velocity mesh)
!     D2, D2t   ---  differentiate on mesh 2 (pressure mesh)
! 
!     DXd,DXdt  ---  differentiate from velocity mesh ONTO dealiased mesh
!                    (currently the same as D1 and D1t...)
! 
! 
      real, dimension(1:lx1*lx1) :: d1
      real, dimension(1:lx1*lx1) :: d1t
      real, dimension(1:lx1*lx1) :: d2
      real, dimension(1:lx1*lx1) :: b2p
      real, dimension(1:lx1*lx1) :: b1ia1
      real, dimension(1:lx1*lx1) :: b1ia1t
      real, dimension(1:lx1*lx1) :: da
      real, dimension(1:lx1*lx1) :: dat
      real, dimension(1:lx1*lxq) :: iggl
      real, dimension(1:lx1*lxq) :: igglt
      real, dimension(1:lx1*lxq) :: dglg
      real, dimension(1:lx1*lxq) :: dglgt
      real, dimension(1:lx1*lxq) :: wglg
      real, dimension(1:lx1*lxq) :: wglgt
      integer, parameter :: lfdm0=1-lfdm
      integer, parameter :: lelg_sm=lfdm0+lfdm*lelg
      integer, parameter :: ltfdm2=lfdm0+lfdm*2*lx2*ly2*lz2*lelt
      integer, parameter :: leig2=lfdm0+lfdm*2*lx2*lx2*(lelx*lelx+lely*lely+lelz*lelz)
      integer, parameter :: leig=lfdm0+lfdm*2*lx2*(lelx+lely+lelz)
      integer, parameter :: lp_small=256
      integer, parameter :: lfdx=lfdm0+lfdm*lx2*lelx
      integer, parameter :: lfdy=lfdm0+lfdm*ly2*lely
      integer, parameter :: lfdz=lfdm0+lfdm*lz2*lelz
! 
!      Perturbation variables
! 
!      Eigenvalue arrays and pointers for Global Tensor Product 
!      parameter (lelg_sm=2)
!      parameter (ltfdm2 =2)
!      parameter (lelg_sm=lelg)
!      parameter (ltfdm2=2*lx2*ly2*lz2*lelt)
!      parameter (leig2=2*lx2*lx2*(lelx*lelx+lely*lely+lelz*lelz))
!      parameter (leig =2*lx2*(lelx+lely+lelz))
      integer :: neigx
      integer :: neigy
      integer :: neigz
      integer :: pvalx
      integer :: pvaly
      integer :: pvalz
      integer :: pvecx
      integer :: pvecy
      integer :: pvecz
      real, dimension(1:leig2) :: sp
      real, dimension(1:leig2) :: spt
      real, dimension(1:leig) :: eigp
      real, dimension(1:ltfdm2) :: wavep
! 
      integer, dimension(1:3,1:2) :: msp
      integer, dimension(1:3,1:2) :: mlp
!      Logical, array and geometry data for tensor-product box
      logical :: ifycrv
      logical :: ifzper
      logical :: ifgfdm
      logical :: ifgtp
      logical :: ifemat
      integer :: nelx
      integer :: nely
      integer :: nelz
      integer :: nelxy
      integer, dimension(1:3) :: lex2pst
      integer, dimension(1:3) :: pst2lex
      integer, dimension(1:3) :: ngfdm_p
      integer, dimension(1:3,1:2) :: ngfdm_v
!      Complete exchange arrays for pressure
!      real part_in(0:lp),part_out(0:lp)
!      common /gfdmcx/  part_in,part_out
      integer, dimension(0:lp_small) :: part_in
      integer, dimension(0:lp_small) :: part_out
      integer, dimension(0:lp_small,1:2) :: msg_id
      integer :: mcex
!      Permutation arrays for gfdm pressure solve
      integer, dimension(1:ltfdm2) :: tpn1
      integer, dimension(1:ltfdm2) :: tpn2
      integer, dimension(1:ltfdm2) :: tpn3
      integer, dimension(1:ltfdm2) :: ind23
      real, dimension(0:lelx) :: xgtp
      real, dimension(0:lely) :: ygtp
      real, dimension(0:lelz) :: zgtp
      real, dimension(1:lfdx) :: xmlt
      real, dimension(1:lfdy) :: ymlt
      real, dimension(1:lfdz) :: zmlt
!      Metrics for 2D x tensor-product solver
      real, dimension(1:lx2,1:ly2,1:lelv) :: rx2
      real, dimension(1:lx2,1:ly2,1:lelv) :: ry2
      real, dimension(1:lx2,1:ly2,1:lelv) :: sx2
      real, dimension(1:lx2,1:ly2,1:lelv) :: sy2
      real, dimension(1:lx2,1:ly2,1:lelv) :: w2d
      real, dimension(1:lx1,1:ly1,1:lelv) :: bxyi
      character(len=3), dimension(1:6,0:ldimt1+1) :: gtp_cbc
      integer, intent(In) :: e
      real, dimension(1:lx1*ly1*lz1,1:ldim,1:ldim), intent(InOut) :: sij
      real, dimension(1:lx1*ly1*lz1,1:lelv), intent(InOut) :: snrm
      real, dimension(1:lx1*ly1*lz1,1:lelv) :: cs
      real :: csa
      real :: csb
      ntot = nx1*ny1*nz1
      call comp_gije(sij,vx(1,1,1,e),vy(1,1,1,e),vz(1,1,1,e),e,ab,abmsh,abx1,abx2,aby1,aby2,abz1, &
      abz2,area,atol,avdiff,avtran,b1ia1,b1ia1t,b1mask,b2mask,b2p,b3mask,baxm1,bbx1,bbx2,bby1, &
      bby2,bbz1,bbz2,bc,bcf,bctyps,bd,bdivw,bfx,bfxp,bfy,bfyp,bfz,bfzp,bintm1,binvdg,binvm1,bm1, &
      bm1lag,bm2,bm2inv,bmass,bmnv,bmx,bmy,bmz,bpmask,bq,bqp,bx,bxlag,by,bylag,bz,bzlag,c_vx,cbc, &
      ccurve,cdof,cerror,cflf,courno,cpfld,cpgrp,cr_h,cr_re2,csize,ctarg,curve,d1,d1t,d2,da,dam1, &
      dam12,dam3,dat,datm1,datm12,datm3,dcm1,dcm12,dcm3,dcount,dct,dctm1,dctm12,dctm3,dg_face, &
      dg_hndlx,dglg,dglgt,dlam,dmpfle,dp0thdt,drivc,dt,dtinit,dtinvm,dtlag,dvdfh1,dvdfl2,dvdfl8, &
      dvdfsm,dvnnh1,dvnnl2,dvnnl8,dvnnsm,dvprh1,dvprl2,dvprl8,dvprsm,dxm1,dxm12,dxm3,dxtm1,dxtm12, &
      dxtm3,dym1,dym12,dym3,dytm1,dytm12,dytm3,dzm1,dzm12,dzm3,dztm1,dztm12,dztm3,eface,eface1, &
      eigaa,eigae,eigas,eigast,eigga,eigge,eiggs,eiggst,eskip,etalph,etimes,etims0,ev1,ev2,ev3, &
      exx1p,exx2p,exy1p,exy2p,exz1p,exz2p,fh_re2,filtertype,fintim,fldfle,fw,g1m1,g2m1,g3m1,g4m1, &
      g5m1,g6m1,gamma0,gcnnum,gednum,gedtyp,gllel,gllnid,group,gsh,gsh_fld,hcode,hisfle,iajl1, &
      iajl2,ialj1,ialj3,iam12,iam13,iam21,iam31,iatjl1,iatjl2,iatlj1,iatlj3,iatm12,iatm13,iatm21, &
      iatm31,ibcsts,icall,icedg,icface,icm12,icm13,icm21,icm31,ictm12,ictm13,ictm21,ictm31,idpss, &
      idsess,ieact,iedge,iedgef,iedgfc,iesolv,if3d,if_full_pres,ifaa,ifadvc,ifae,ifalgn,ifanl2, &
      ifanls,ifas,ifast,ifaxis,ifaziv,ifbase,ifbcor,ifbo,ifchar,ifcons,ifcoup,ifcvfld,ifcvode, &
      ifcyclic,ifdeal,ifdg,ifdgfld,ifdiff,ifdp0dt,ifeppm,ifessr,ifexplvis,ifextr,ifexvt,ifflow, &
      iffmtin,ifga,ifge,ifgeom,ifgmsh3,ifgprnt,ifgs,ifgsh_fld_same,ifgst,ifheat,ifield,ifintq, &
      ifkeps,ifldmhd,iflmsc,iflmse,iflmsf,iflomach,ifmelt,ifmgrid,ifmhd,ifmoab,ifmodel,ifmodp, &
      ifmpiio,ifmscr,ifmseg,ifmsfc,ifmvbd,ifneknek,ifneknekm,ifnonl,ifnskp,ifoutfld,ifpert,ifpo, &
      ifprnt,ifprojfld,ifpsco,ifpso,ifqinp,ifreguo,ifrich,ifrsxy,ifrzer,ifschclob,ifskip,ifsplit, &
      ifssvt,ifstrs,ifstst,ifsurt,ifsync,iftgo,iftmsh,ifto,iftran,ifusermv,ifuservp,ifvarp,ifvcor, &
      ifvcoup,ifvo,ifvps,ifwcno,ifxyo,ifxyo_,iggl,igglt,igroup,im1d,im1dt,imatie,imd1,imd1t,imesh, &
      indx,initc,instep,invedg,iocomm,ioinfodmp,iostep,ipscal,ipsco,irstim,irstt,irstv,isize, &
      istep,ixcn,ixm12,ixm13,ixm21,ixm31,ixtm12,ixtm13,ixtm21,ixtm31,iym12,iym13,iym21,iym31, &
      iytm12,iytm13,iytm21,iytm31,izm12,izm13,izm21,izm31,iztm12,iztm13,iztm21,iztm31,jacm1,jacm2, &
      jacmi,jp,lastep,lcnnum,ldimr,lednum,lglel,lochis,loglevel,lsize,lyap,matids,matindx,matype, &
      maxmlt,mpi_argv_null,mpi_argvs_null,mpi_bottom,mpi_errcodes_ignore,mpi_in_place, &
      mpi_status_ignore,mpi_statuses_ignore,mpi_unweighted,mpi_weights_empty,nab,nabmsh,nadvc, &
      naxhm,nbbbb,nbd,nbdinp,nbso2,nbsol,ncall,ncccc,ncdtp,ncmp,nconv,nconv_max,ncopy,ncrsl,ncvf, &
      ndadd,ndddd,nddsl,ndg_facex,ndim,ndott,ndsmn,ndsmx,ndsnd,ndsum,neact,nedg,neeee,nekcomm, &
      nekgroup,nekreal,nelfld,nelg,nelgt,nelgv,nelt,nelv,neslv,nfield,ngcomm,ngeom,ngop,ngop1, &
      ngop_sync,ngp2,ngsmn,ngsmx,ngspcn,ngsped,ngsum,nhis,nhmhz,nid,ninter,ninv3,ninvc,nio,nktonv, &
      nmember,nmlinv,nmltd,nmxe,nmxh,nmxmf,nmxms,nmxnl,nmxp,nobj,node,node0,noffst,nomlis,np, &
      npert,nprep,npres,npscal,nrefle,nrout,nsett,nslvb,nsolv,nspmax,nspro,nsskip,nsteps,nsyc, &
      ntaubd,nu_star,nullpid,numbcs,numflu,numoth,numscn,numsed,nusbc,nvdss,nvtot,nwal,nx1,nx2, &
      nx3,nxd,ny1,ny2,ny3,nyd,nz1,nz2,nz3,nzd,object,ocode,omask,optlevel,orefle,p0th,param, &
      parfle,path,paxhm,pbbbb,pbso2,pbsol,pcccc,pcdtp,pcopy,pcrsl,pdadd,pdddd,pddsl,pdott,pdsmn, &
      pdsmx,pdsnd,pdsum,peeee,peslv,pgop,pgop1,pgop_sync,pgp2,pgsmn,pgsmx,pgsum,phmhz,pi,pid, &
      pinv3,pinvc,pm,pmask,pmd1,pmd1t,pmlag,pmltd,pmxmf,pmxms,pprep,ppres,pr,prelax,prlag,prlagp, &
      prp,psett,pslvb,psolv,pspro,psyc,pusbc,pvdss,pwal,qinteg,qtl,rct,re2fle,re2off_b,reafle, &
      restol,rname,rstim,rstt,rstv,rx,rxm1,rxm2,rym1,rym2,rzm1,rzm2,schfle,session,skpdat, &
      solver_type,sxm1,sxm2,sym1,sym2,szm1,szm2,t,t1x,t1y,t1z,t2x,t2y,t2z,ta2s2,tadc3,tadd2,tadvc, &
      tauss,taxhm,tbbbb,tbso2,tbsol,tcccc,tcdtp,tcol2,tcol3,tcopy,tcrsl,tcvf,tdadd,tdddd,tddsl, &
      tdott,tdsmn,tdsmx,tdsnd,tdsum,teeee,teslv,textsw,tgop,tgop1,tgop_sync,tgp2,tgsmn,tgsmx, &
      tgsum,thmhz,time,timef,timeio,tinit,tinv3,tinvc,tlag,tlagp,tmask,tmean,tmltd,tmult,tmxmf, &
      tmxms,tnrmh1,tnrml2,tnrml8,tnrmsm,tolabs,tolev,tolhdf,tolhe,tolhr,tolhs,tolht,tolhv,tolnl, &
      tolpdf,tolps,tolrel,tp,tprep,tpres,tproj,tschw,tsett,tslvb,tsolv,tspro,tsyc,ttime,ttotal, &
      tttstp,tusbc,tusfq,tvdss,twal,txm1,txm2,txnext,tym1,tym2,tzm1,tzm2,unr,uns,unt,unx,uny,unz, &
      uparam,usrdiv,v1mask,v1x,v1y,v1z,v2mask,v2x,v2y,v2z,v3mask,vdiff,vdiff_e,vgradt1,vgradt1p, &
      vgradt2,vgradt2p,vmean,vmult,vnekton,vnrmh1,vnrml2,vnrml8,vnrmsm,vnx,vny,vnz,volel,volfld, &
      voltm1,voltm2,volvm1,volvm2,vtrans,vx,vx_e,vxd,vxlag,vxlagp,vxp,vy,vy_e,vyd,vylag,vylagp, &
      vyp,vz,vz_e,vzd,vzlag,vzlagp,vzp,w1mask,w2am1,w2am2,w2am3,w2cm1,w2cm2,w2cm3,w2mask,w3m1, &
      w3m2,w3m3,w3mask,wam1,wam2,wam3,wdsize,wdsizi,wgl,wgl1,wgl2,wglg,wglgt,wgli,wgp,wmult,wx, &
      wxlag,wxm1,wxm2,wxm3,wy,wylag,wym1,wym2,wym3,wz,wzlag,wzm1,wzm2,wzm3,xc,xm1,xm2,xxth,yc, &
      yinvm1,ym1,ym2,zam1,zam2,zam3,zc,zgl,zgm1,zgm2,zgm3,zgp,zm1,zm2)
      ifnav = ifadvc(1)
      turbmod = textsw(1,1)
      call comp_sije(sij,ab,abmsh,abx1,abx2,aby1,aby2,abz1,abz2,area,atol,avdiff,avtran,b1ia1, &
      b1ia1t,b1mask,b2mask,b2p,b3mask,baxm1,bbx1,bbx2,bby1,bby2,bbz1,bbz2,bc,bcf,bctyps,bd,bdivw, &
      bfx,bfxp,bfy,bfyp,bfz,bfzp,bintm1,binvdg,binvm1,bm1,bm1lag,bm2,bm2inv,bmass,bmnv,bmx,bmy, &
      bmz,bpmask,bq,bqp,bx,bxlag,by,bylag,bz,bzlag,c_vx,cbc,ccurve,cdof,cerror,cflf,courno,cpfld, &
      cpgrp,cr_h,cr_re2,csize,ctarg,curve,d1,d1t,d2,da,dam1,dam12,dam3,dat,datm1,datm12,datm3, &
      dcm1,dcm12,dcm3,dctm1,dctm12,dctm3,dg_face,dg_hndlx,dglg,dglgt,dlam,dmpfle,dp0thdt,drivc,dt, &
      dtinit,dtinvm,dtlag,dvdfh1,dvdfl2,dvdfl8,dvdfsm,dvnnh1,dvnnl2,dvnnl8,dvnnsm,dvprh1,dvprl2, &
      dvprl8,dvprsm,dxm1,dxm12,dxm3,dxtm1,dxtm12,dxtm3,dym1,dym12,dym3,dytm1,dytm12,dytm3,dzm1, &
      dzm12,dzm3,dztm1,dztm12,dztm3,eface,eface1,eigaa,eigae,eigas,eigast,eigga,eigge,eiggs, &
      eiggst,eskip,etalph,ev1,ev2,ev3,exx1p,exx2p,exy1p,exy2p,exz1p,exz2p,fh_re2,filtertype, &
      fintim,fldfle,fw,g1m1,g2m1,g3m1,g4m1,g5m1,g6m1,gamma0,gcnnum,gednum,gedtyp,gllel,gllnid, &
      group,gsh,gsh_fld,hcode,hisfle,iajl1,iajl2,ialj1,ialj3,iam12,iam13,iam21,iam31,iatjl1, &
      iatjl2,iatlj1,iatlj3,iatm12,iatm13,iatm21,iatm31,ibcsts,icedg,icface,icm12,icm13,icm21, &
      icm31,ictm12,ictm13,ictm21,ictm31,idpss,idsess,ieact,iedge,iedgef,iedgfc,iesolv,if3d, &
      if_full_pres,ifaa,ifadvc,ifae,ifalgn,ifanl2,ifanls,ifas,ifast,ifaxis,ifaziv,ifbase,ifbcor, &
      ifbo,ifchar,ifcons,ifcoup,ifcvfld,ifcvode,ifcyclic,ifdeal,ifdg,ifdgfld,ifdiff,ifdp0dt, &
      ifeppm,ifessr,ifexplvis,ifextr,ifexvt,ifflow,iffmtin,ifga,ifge,ifgeom,ifgmsh3,ifgprnt,ifgs, &
      ifgsh_fld_same,ifgst,ifheat,ifield,ifintq,ifkeps,ifldmhd,iflmsc,iflmse,iflmsf,iflomach, &
      ifmelt,ifmgrid,ifmhd,ifmoab,ifmodel,ifmodp,ifmpiio,ifmscr,ifmseg,ifmsfc,ifmvbd,ifneknek, &
      ifneknekm,ifnonl,ifnskp,ifoutfld,ifpert,ifpo,ifprnt,ifprojfld,ifpsco,ifpso,ifqinp,ifreguo, &
      ifrich,ifrsxy,ifrzer,ifschclob,ifskip,ifsplit,ifssvt,ifstrs,ifstst,ifsurt,iftgo,iftmsh,ifto, &
      iftran,ifusermv,ifuservp,ifvarp,ifvcor,ifvcoup,ifvo,ifvps,ifwcno,ifxyo,ifxyo_,iggl,igglt, &
      igroup,im1d,im1dt,imatie,imd1,imd1t,imesh,indx,initc,instep,invedg,iocomm,ioinfodmp,iostep, &
      ipscal,ipsco,irstim,irstt,irstv,isize,istep,ixcn,ixm12,ixm13,ixm21,ixm31,ixtm12,ixtm13, &
      ixtm21,ixtm31,iym12,iym13,iym21,iym31,iytm12,iytm13,iytm21,iytm31,izm12,izm13,izm21,izm31, &
      iztm12,iztm13,iztm21,iztm31,jacm1,jacm2,jacmi,jp,lastep,lcnnum,ldimr,lednum,lglel,lochis, &
      loglevel,lsize,lyap,matids,matindx,matype,maxmlt,nab,nabmsh,nbd,nbdinp,ncmp,nconv,nconv_max, &
      ndg_facex,ndim,neact,nedg,nelfld,nelg,nelgt,nelgv,nelt,nelv,nfield,ngcomm,ngeom,ngspcn, &
      ngsped,nhis,nid,ninter,nio,nktonv,nmember,nmlinv,nmxe,nmxh,nmxnl,nmxp,nobj,node,node0, &
      noffst,nomlis,np,npert,npscal,nrefle,nspmax,nsskip,nsteps,ntaubd,nu_star,nullpid,numbcs, &
      numflu,numoth,numscn,numsed,nvtot,nx1,nx2,nx3,nxd,ny1,ny2,ny3,nyd,nz1,nz2,nz3,nzd,object, &
      ocode,omask,optlevel,orefle,p0th,param,parfle,path,pi,pid,pm,pmask,pmd1,pmd1t,pmlag,pr, &
      prelax,prlag,prlagp,prp,qinteg,qtl,re2fle,re2off_b,reafle,restol,rstim,rstt,rstv,rx,rxm1, &
      rxm2,rym1,rym2,rzm1,rzm2,schfle,session,skpdat,solver_type,sxm1,sxm2,sym1,sym2,szm1,szm2,t, &
      t1x,t1y,t1z,t2x,t2y,t2z,tauss,textsw,time,timef,timeio,tlag,tlagp,tmask,tmean,tmult,tnrmh1, &
      tnrml2,tnrml8,tnrmsm,tolabs,tolev,tolhdf,tolhe,tolhr,tolhs,tolht,tolhv,tolnl,tolpdf,tolps, &
      tolrel,tp,txm1,txm2,txnext,tym1,tym2,tzm1,tzm2,unr,uns,unt,unx,uny,unz,uparam,usrdiv,v1mask, &
      v1x,v1y,v1z,v2mask,v2x,v2y,v2z,v3mask,vdiff,vdiff_e,vgradt1,vgradt1p,vgradt2,vgradt2p,vmean, &
      vmult,vnekton,vnrmh1,vnrml2,vnrml8,vnrmsm,vnx,vny,vnz,volel,volfld,voltm1,voltm2,volvm1, &
      volvm2,vtrans,vx,vx_e,vxd,vxlag,vxlagp,vxp,vy,vy_e,vyd,vylag,vylagp,vyp,vz,vz_e,vzd,vzlag, &
      vzlagp,vzp,w1mask,w2am1,w2am2,w2am3,w2cm1,w2cm2,w2cm3,w2mask,w3m1,w3m2,w3m3,w3mask,wam1, &
      wam2,wam3,wdsize,wdsizi,wgl,wgl1,wgl2,wglg,wglgt,wgli,wgp,wmult,wx,wxlag,wxm1,wxm2,wxm3,wy, &
      wylag,wym1,wym2,wym3,wz,wzlag,wzm1,wzm2,wzm3,xc,xm1,xm2,xxth,yc,yinvm1,ym1,ym2,zam1,zam2, &
      zam3,zc,zgl,zgm1,zgm2,zgm3,zgp,zm1,zm2)
      ifnav = ifadvc(1)
      turbmod = textsw(1,1)
      call mag_tensor_e(snrm(1,e),sij,dcount,dct,idsess,ldimr,loglevel,ncall,ndim,nelt,nelv,nfield, &
      nid,nio,npert,nrout,nx1,nx2,nx3,nxd,ny1,ny2,ny3,nyd,nz1,nz2,nz3,nzd,optlevel,rct,rname)
      call cmult(snrm(1,e),2.0,ntot,dcount,dct,ncall,nrout,rct,rname)

! ---------------------------
      end subroutine eddy_visc

end module singleton_module_src_dabl

