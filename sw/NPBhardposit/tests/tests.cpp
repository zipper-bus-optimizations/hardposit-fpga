#include "hardposit.h"
#include "softposit.h"
#include "softposit_types.h"
#include "softposit_cpp.h"
#include <iostream>
int main(){
	init_accel();
	Hardposit a = Hardposit(1.0);
	Hardposit b = Hardposit(2.0);
	Hardposit c = Hardposit(3.0);
	Hardposit d = Hardposit(4.0);
	Hardposit e = Hardposit(5.0);
	Hardposit f = Hardposit(6.0);
	Hardposit g = Hardposit(7.0);
	Hardposit h = Hardposit(8.0);
	Hardposit i = Hardposit(9.0);

	Hardposit add = a + b; //3
	Hardposit minus = a - b; //-1
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	add = a + b;
	// Hardposit add1 = add + a; //4
	// Hardposit add2 = add1 + a;  //5
	// Hardposit add3 = add2 + a; //6
	// Hardposit add4 = add3 + a; //7
	// Hardposit add5 = add4 + a; //8
	// Hardposit add6 = add5 + a; //9
	// Hardposit add7 = add6 + a; //10
	// Hardposit add8 = add1 + add2; //9
	// Hardposit add9 = add7 + add8; // 19
	// Hardposit add10 = add8 + add9; // 28
	// Hardposit add11 = add1 + add10; // 32
	// std::cout<< "add1: "<<add1.toDouble()<<std::endl;
	// std::cout<< "add11: "<<add11.toDouble()<<std::endl;
	// add11 = add11 + add1; //36
	// std::cout<< "add11: "<<add11.toDouble()<<std::endl;
	// Hardposit add12 = add1 + add2;
	// Hardposit add13 = add1 + add2;
	// Hardposit add14 = add12 + add13;

	// Hardposit lt = a < b;
	// Hardposit gt = a > b;
	// Hardposit eq = (b == c);

	// std::cout<< "add: "<<add.toDouble()<<std::endl;
	// std::cout<< "minus: "<<minus.toDouble()<<std::endl;
	// std::cout<< "add1: "<<add1.toDouble()<<std::endl;
	// std::cout<< "add2: "<<add2.toDouble()<<std::endl;
	// std::cout<< "add3: "<<add3.toDouble()<<std::endl;
	// std::cout<< "add4: "<<add4.toDouble()<<std::endl;
	// std::cout<< "add5: "<< add5.toDouble()<<std::endl;
	// std::cout<< "add6: "<<add6.toDouble()<<std::endl;
	// std::cout<< "add7: "<<add7.toDouble()<<std::endl;
	// std::cout<< "add8: "<<add8.toDouble()<<std::endl;
	// std::cout<< "add9: "<<add9.toDouble()<<std::endl;
	// std::cout<< "add10: "<<add10.toDouble()<<std::endl;
	// std::cout<< "add11: "<<add11.toDouble()<<std::endl;
	// std::cout<< "add14: "<<add14.toDouble()<<std::endl;

	// lt.print_val();
	// gt.print_val();
	// eq.print_val();
	close_accel();
	return 0;
}