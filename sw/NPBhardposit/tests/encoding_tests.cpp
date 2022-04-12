#include <iostream>
#include <bitset>
#include "softposit.h"
#include "softposit_types.h"
#include "softposit_cpp.h"
#include "primitives.h"
#include "hardposit.h"
int main(){
	std::cout<<"Check the setup"<<std::endl;
	std::cout<<"NUM_OPERAND_ENTRIES: "<< NUM_OPERAND_ENTRIES<<std::endl;
	std::cout<<"SIZE_OF_OPERAND: "<< sizeof(Operand)<<std::endl;
	std::cout<<"READ_GRANULARITY: "<< READ_GRANULARITY<<std::endl;
	std::cout<<"NUM_OPERAND_PER_CACHELINE: "<< NUM_OPERAND_PER_CACHELINE<<std::endl;
	std::cout<<"NUM_CACHELINE: "<< NUM_CACHELINE<<std::endl;
	std::cout<<"BITS_FOR_OFFSET: "<< BITS_FOR_OFFSET<<std::endl;

	int i = 0;
	for(;i<100;i++){
		uint16_t offset = CALC_OFFSET(i);
		uint16_t cacheline = CALC_CACHELINE_ONE_HOT(i);
		uint8_t id = CALC_ID(i);
		uint16_t addr = offset + cacheline + (id << 14) + (1 << 15);
		std::cout <<"i: "<< i << std::endl;
		std::cout <<"offset: "<<std::bitset<16>(offset) << std::endl;
		std::cout <<"cacheline: "<< std::bitset<16>(cacheline) << std::endl;
		std::cout <<"id: "<< std::bitset<8>(id) << std::endl;
		std::cout <<"cacheline & offset in bytes: "<<CALC_OFFSET_IN_BYTE(i) + CALC_CACHELINE_OFFSET_IN_BYTE(i)<<std::endl;
		std::cout <<"addr: "<< std::bitset<16>(addr) << std::endl;
	}
}