/*--------------------------------------------------------------------
c---------------------------------------------------------------------
c
c  header.h
c
c---------------------------------------------------------------------
c-------------------------------------------------------------------*/
 

/*--------------------------------------------------------------------
c The following include file is generated automatically by the
c "setparams" utility. It defines 
c      maxcells:      the square root of the maximum number of processors
c      problem_size:  12, 64, 102, 162 (for class T, A, B, C)
c      dt_default:    default time step for this problem size if no
c                     config file
c      niter_default: default number of iterations for this problem size
--------------------------------------------------------------------*/

#include "npbparams.h"

#define	AA		0
#define BB		1
#define CC		2
#define	BLOCK_SIZE	5

/* COMMON block: global */
static int grid_points[3];	/* grid_ponts(1:3) */

/* COMMON block: constants */
static Hardposit tx1, tx2, tx3, ty1, ty2, ty3, tz1, tz2, tz3;
static Hardposit dx1, dx2, dx3, dx4, dx5;
static Hardposit dy1, dy2, dy3, dy4, dy5;
static Hardposit dz1, dz2, dz3, dz4, dz5;
static Hardposit dssp, dt;
static Hardposit ce[5][13];	/* ce(5,13) */
static Hardposit dxmax, dymax, dzmax;
static Hardposit xxcon1, xxcon2, xxcon3, xxcon4, xxcon5;
static Hardposit dx1tx1, dx2tx1, dx3tx1, dx4tx1, dx5tx1;
static Hardposit yycon1, yycon2, yycon3, yycon4, yycon5;
static Hardposit dy1ty1, dy2ty1, dy3ty1, dy4ty1, dy5ty1;
static Hardposit zzcon1, zzcon2, zzcon3, zzcon4, zzcon5;
static Hardposit dz1tz1, dz2tz1, dz3tz1, dz4tz1, dz5tz1;
static Hardposit dnxm1, dnym1, dnzm1, c1c2, c1c5, c3c4, c1345;
static Hardposit conz1, c1, c2, c3, c4, c5, c4dssp, c5dssp, dtdssp;
static Hardposit dttx1, dttx2, dtty1, dtty2, dttz1, dttz2;
static Hardposit c2dttx1, c2dtty1, c2dttz1, comz1, comz4, comz5, comz6;
static Hardposit c3c4tx3, c3c4ty3, c3c4tz3, c2iv, con43, con16;

#define	IMAX	PROBLEM_SIZE
#define	JMAX	PROBLEM_SIZE
#define	KMAX	PROBLEM_SIZE

/*
c   to improve cache performance, grid dimensions padded by 1 
c   for even number sizes only.
*/

/* COMMON block: fields */
static Hardposit us[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1];
static Hardposit vs[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1];
static Hardposit ws[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1];
static Hardposit qs[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1];
static Hardposit rho_i[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1];
static Hardposit square[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1];
static Hardposit forcing[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1][5+1];
static Hardposit u[(IMAX+1)/2*2+1][(JMAX+1)/2*2+1][(KMAX+1)/2*2+1][5];
static Hardposit rhs[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1][5];
static Hardposit lhs[IMAX/2*2+1][JMAX/2*2+1][KMAX/2*2+1][3][5][5];

/* COMMON block: work_1d */
static Hardposit cuf[PROBLEM_SIZE];
static Hardposit q[PROBLEM_SIZE];
static Hardposit ue[PROBLEM_SIZE][5];
static Hardposit buf[PROBLEM_SIZE][5];
#pragma omp threadprivate(cuf, q, ue, buf)

/*
c   to improve cache performance, grid dimensions (first two for these
c   to arrays) padded by 1 for even number sizes only.
*/

/* COMMON block: work_lhs */
static Hardposit fjac[IMAX/2*2+1][JMAX/2*2+1][KMAX-1+1][5][5];
/* fjac(5, 5, 0:IMAX/2*2, 0:JMAX/2*2, 0:KMAX-1) */
static Hardposit njac[IMAX/2*2+1][JMAX/2*2+1][KMAX-1+1][5][5];
/* njac(5, 5, 0:IMAX/2*2, 0:JMAX/2*2, 0:KMAX-1) */
static Hardposit tmp1, tmp2, tmp3;

