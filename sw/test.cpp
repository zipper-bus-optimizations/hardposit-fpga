#include<iostream>
#include "softposit.h"
#include "softposit_types.h"
#include "softposit_cpp.h"
#include "primitives.h"
#include "hardposit.h"
int main(){
    posit32 a = posit32(2.0);
    posit32 b = posit32(3.0);
    posit32 c = posit32(4.0);

    std::cout << (a*b).value  << std::endl;
    init_accel();
    Hardposit a_hard(a.value);
    Hardposit b_hard(b.value);
    (a_hard*b_hard).print_val();
}