/*--------------------------------------------------------------------
c---------------------------------------------------------------------
c---  applu.h
c---------------------------------------------------------------------
c-------------------------------------------------------------------*/

/*--------------------------------------------------------------------
c   npbparams.h defines parameters that depend on the class and 
c   number of nodes
c-------------------------------------------------------------------*/

#include "npbparams.h"

#include <quadmath.h>

/*--------------------------------------------------------------------
c   parameters which can be overridden in runtime config file
c   isiz1,isiz2,isiz3 give the maximum size
c   ipr = 1 to print out verbose information
c   omega = 2.0 is correct for all classes
c   tolrsd is tolerance levels for steady state residuals
c-------------------------------------------------------------------*/

#define IPR_DEFAULT	1
#define	OMEGA_DEFAULT	1.2

#define	TOLRSD1_DEF	hp32(1.0e-8)
#define	TOLRSD2_DEF	hp32(1.0e-8)
#define	TOLRSD3_DEF	hp32(1.0e-8)
#define	TOLRSD4_DEF	hp32(1.0e-8)
#define	TOLRSD5_DEF	hp32(1.0e-8)

#define	C1		hp32(1.40e+00)
#define	C2		hp32(0.40e+00)
#define	C3		hp32(1.00e-01)
#define	C4		hp32(1.00e+00)
#define	C5		hp32(1.40e+00)

/*--------------------------------------------------------------------
c   grid
c-------------------------------------------------------------------*/

/* common /cgcon/ */
static int nx, ny, nz;
static int nx0, ny0, nz0;
static int ist, iend;
static int jst, jend;
static int ii1, ii2;
static int ji1, ji2;
static int ki1, ki2;
static Hardposit dxi, deta, dzeta;
static Hardposit tx1, tx2, tx3;
static Hardposit ty1, ty2, ty3;
static Hardposit tz1, tz2, tz3;

/*--------------------------------------------------------------------
c   dissipation
c-------------------------------------------------------------------*/

/* common /disp/ */
static Hardposit dx1, dx2, dx3, dx4, dx5;
static Hardposit dy1, dy2, dy3, dy4, dy5;
static Hardposit dz1, dz2, dz3, dz4, dz5;
static Hardposit dssp;

/*--------------------------------------------------------------------
c   field variables and residuals
c   to improve cache performance, second two dimensions padded by 1 
c   for even number sizes only.
c   Note: corresponding array (called "v") in routines blts, buts, 
c   and l2norm are similarly padded
c-------------------------------------------------------------------*/

/* common /cvar/ */
static Hardposit u[ISIZ1][ISIZ2/2*2+1][ISIZ3/2*2+1][5];
static Hardposit rsd[ISIZ1][ISIZ2/2*2+1][ISIZ3/2*2+1][5];
static Hardposit frct[ISIZ1][ISIZ2/2*2+1][ISIZ3/2*2+1][5];
static Hardposit flux[ISIZ1][ISIZ2/2*2+1][ISIZ3/2*2+1][5];

/*--------------------------------------------------------------------
c   output control parameters
c-------------------------------------------------------------------*/

/* common /cprcon/ */
static int ipr, inorm;

/*--------------------------------------------------------------------
c   newton-raphson iteration control parameters
c-------------------------------------------------------------------*/

/* common /ctscon/ */
static int itmax, invert;
static Hardposit dt, omega, tolrsd[5], rsdnm[5], frc, ttotal;
static Hardposit errnm[5];
  
/* common /cjac/ */
static Hardposit a[ISIZ1][ISIZ2][5][5];
static Hardposit b[ISIZ1][ISIZ2][5][5];
static Hardposit c[ISIZ1][ISIZ2][5][5];
static Hardposit d[ISIZ1][ISIZ2][5][5];

/*--------------------------------------------------------------------
c   coefficients of the exact solution
c-------------------------------------------------------------------*/

/* common /cexact/ */
static Hardposit ce[5][13];

/*--------------------------------------------------------------------
c   multi-processor common blocks
c-------------------------------------------------------------------*/

/* common /timer/ */
static double maxtime;

/*--------------------------------------------------------------------
c   end of include file
c-------------------------------------------------------------------*/
