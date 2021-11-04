#include<iostream>
#include <bitset>
#include "softposit.h"
#include "softposit_types.h"
#include "softposit_cpp.h"
#include "primitives.h"
#include "hardposit.h"
int main(){
    posit32 a = posit32(2.0);
    posit32 b = posit32(3.0);
    posit32 c = posit32(4.0);
    std::cout << "a:"  << std::bitset<32>(a.value) <<std::endl;
    std::cout << "b:"  << std::bitset<32>(b.value) <<std::endl;
    std::cout << "a*b:" << std::bitset<32>((a*b).value)  << std::endl;
    init_accel();
    Hardposit a_hard(a.value);
    Hardposit b_hard(b.value);
    std::cout << "a_hard:" << std::bitset<32>(a_hard.get_val())<<std::endl;
    std::cout << "b_hard:" << std::bitset<32>(b_hard.get_val()) <<std::endl;
    Hardposit res = (a_hard*b_hard);
    res.print_val();
}