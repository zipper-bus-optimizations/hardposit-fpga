#ifndef __COMPUTE_RESIDUAL_H__
#define __COMPUTE_RESIDUAL_H__

#include "softposit_cpp.h"
#include "hardposit.h"
#include <quadmath.h>
#include <type_traits>

template<class T>
typename std::enable_if<std::is_same<T, Hardposit>::value, void>::type
compute_residual(int iter, T *a, T *z, T *x, int NA, int firstrow, int lastrow, int firstcol, int lastcol, int *rowstr, int *colidx)
{
	/* compute r */
	static Hardposit d, explicit_r;
	Hardposit tmp_r[NA+2+1];	/* r[1:NA+2] */
	static int j, k;

	for (j = 1; j <= lastrow-firstrow+1; j++) {
		d = 0.0q;
		for (k = rowstr[j]; k <= rowstr[j+1]-1; k++) {
			d = d + a[k]*z[colidx[k]];
		}
		tmp_r[j] = d;
	}

	/*--------------------------------------------------------------------
	  c  At this point, r contains A.z
	  c-------------------------------------------------------------------*/
	explicit_r = 0.0q;

	for (j = 1; j <= lastcol-firstcol+1; j++) {
		tmp_r[j] = x[j].toDouble() - tmp_r[j];

		explicit_r = explicit_r + tmp_r[j]*tmp_r[j]; 
	}

	printf("CG:\t%d\t%20.14Qe\n", iter, sqrtq(explicit_r.toDouble()));
}

#endif
