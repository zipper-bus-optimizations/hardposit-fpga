#include "hardposit.h"
#include "softposit.h"
#include "softposit_types.h"
#include "softposit_cpp.h"
int main(){
	init_accel();
	Hardposit a = Hardposit(3.0);
	Hardposit b = Hardposit(2.0);
	Hardposit c = Hardposit(2.0);

	Hardposit add = a + b;
	Hardposit minus = a - b;
	Hardposit lt = a < b;
	Hardposit gt = a > b;
	Hardposit eq = (b == c);
	add.print_val();
	minus.print_val();
	lt.print_val();
	gt.print_val();
	eq.print_val();
	close_accel();
	return 0;
}