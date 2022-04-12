#include <opae/cxx/core/handle.h>
#include <opae/cxx/core/properties.h>
#include <opae/cxx/core/shared_buffer.h>
#include <opae/cxx/core/token.h>
#include <opae/cxx/core/version.h>
#include <uuid/uuid.h>
#include <algorithm>
#include <chrono>
#include <iostream>
#include <string>
#include <thread>
#include <bitset>
#include <vector>
#include <cstring>
#include <stdlib.h>
#include "afu_json_info.h"
#include "hardposit.h"
#include "softposit.h"
#include "softposit_types.h"
#include "softposit_cpp.h"
#include "primitives.h"
#include "config.h"
using namespace opae::fpga::types;


static handle::ptr_t accel = nullptr;
static uint64_t global_counter = 0;
shared_buffer::ptr_t req;
shared_buffer::ptr_t result;
uint8_t req_q_pointer = 0;
static Hardposit* result_track[NUM_FPGA_ENTRIES];


void poll_performance(){
	memset(((void*)result->c_type())+(NUM_FPGA_ENTRIES*WRITE_GRANULARITY), 0, sizeof(Performance_array));
	accel->write_csr64(24, NUM_FPGA_ENTRIES);
	volatile Performance_array* perf = (Performance_array*)(((void*)result->c_type())+(NUM_FPGA_ENTRIES*WRITE_GRANULARITY));
	while(!perf->valid){}
	std::cout <<"Total req: "<< perf->total_cycles<<std::endl;
	std::cout <<"[0, 10)"<< perf->mem_req_cycles[0] <<std::endl;
	std::cout <<"[10, 50)"<< perf->mem_req_cycles[1] <<std::endl;
	std::cout <<"[50, 100)"<< perf->mem_req_cycles[2] <<std::endl;
	std::cout <<"[100, 200)"<< perf->mem_req_cycles[3] <<std::endl;
	std::cout <<"[200, 300)"<< perf->mem_req_cycles[4] <<std::endl;
	std::cout <<"[300, 400)"<< perf->mem_req_cycles[5] <<std::endl;
	std::cout <<"[400, 500)"<< perf->mem_req_cycles[6] <<std::endl;
	std::cout <<"[500, 600)"<< perf->mem_req_cycles[7] <<std::endl;
	std::cout <<"[600, 700)"<< perf->mem_req_cycles[8] <<std::endl;
	std::cout <<"[700, 800)"<< perf->mem_req_cycles[9] <<std::endl;
	std::cout <<"[800, 900)"<< perf->mem_req_cycles[10] <<std::endl;
	std::cout <<"[900, 1000)"<< perf->mem_req_cycles[11] <<std::endl;
	std::cout <<"[1000, )"<< perf->mem_req_cycles[12] <<std::endl;
}

void close_accel(){
	accel->reset();
	req->release();
	result->release();
	accel->close();
}
void init_accel(){
	if(!accel){
		properties::ptr_t filter = properties::get();
		filter->guid.parse(AFU_ACCEL_UUID);
		filter->type = FPGA_ACCELERATOR;

		std::vector<token::ptr_t> tokens = token::enumerate({filter});

		// assert we have found at least one
		if (tokens.size() < 1) {
			std::cerr << "accelerator not found\n";
			return -1;
		}
		token::ptr_t tok = tokens[0];
		accel = handle::open(tok, FPGA_OPEN_SHARED);
		accel->reset();
		req = shared_buffer::allocate(accel, NUM_CACHELINE* SIZE_OF_CACHELINE);
		result = shared_buffer::allocate(accel,(NUM_FPGA_ENTRIES+1)*WRITE_GRANULARITY);
	  std::fill_n(req->c_type(), NUM_OPERAND_ENTRIES*READ_GRANULARITY, 0);
	  std::fill_n(result->c_type(), (NUM_FPGA_ENTRIES+1)*WRITE_GRANULARITY, 0);

		// open accelerator and map MMIO
		accel->reset();

		uint64_t read_setup = 0;
		read_setup += ((req->io_address())>>6);
		uint64_t write_setup = 0;
		write_setup += ((result->io_address())>>6);
		write_setup += (WRITE_GRANULARITY << 42);
	  __sync_synchronize();
		accel->write_csr64(0, read_setup);
		accel->write_csr64(8, write_setup);
	}
}


/*
 Hardposit:print_val
 print the value of the hardposit
*/
void Hardposit::print_val(){
	std::cout << "Hardposit: " << std::bitset<32>(this->get_val()) << std::endl;
}

uint32_t Hardposit::get_val(){
	if(!this->valid && this->ptr!=nullptr){
		while(!this->ptr->flags){}
		this->valid = true;
		uint32_t tmp = 0;
		switch (static_cast<Inst>(this->val))
		{
			case LT:
				tmp = this->ptr->flags & 4;
				break;
			case EQ:
				tmp = this->ptr->flags & 2;
				break;
			case GT:
				tmp = this->ptr->flags & 1;
				break;
			default:
				tmp = this->ptr->result;
				break;
		}
		this->val = tmp;
		result_track[this->location] = nullptr;
	}
	return this->val;
}

Hardposit::Hardposit(uint32_t in_val){
	this->val = in_val;
	this->valid = true;
	this->ptr = nullptr;
	this->location = 0;
	this->counter = 0;
}

Hardposit::Hardposit(int in_val){
	this->val = posit32(in_val).value;
	this->valid = true;
	this->ptr = nullptr;
	this->location = 0;
	this->counter = 0;
}

Hardposit::Hardposit(float in_val){
	this->val = posit32(in_val).value;
	this->ptr = nullptr;
	this->valid = true;
	this->location = 0;
	this->counter = 0;
}
Hardposit::Hardposit(double in_val){
	this->val = posit32(in_val).value;
	this->ptr = nullptr;
	this->valid = true;
	this->location = 0;
	this->counter = 0;
}
Hardposit Hardposit::compute(Hardposit const &obj1, Hardposit const &obj2, Inst inst, bool mode){
	OpAddr ops[3];
	Hardposit ret;
	uint8_t result_q_pointer = global_counter % NUM_FPGA_ENTRIES;
	uint64_t mask = (1<<9-1)<<4;
	/*with reuse*/
	#ifdef REUSE
	if(this->ptr && (global_counter-this->counter) < NUM_FPGA_ENTRIES ){
		ops[0].addr = this->location + (1 << 14);
	}else{
		uint16_t offset = CALC_OFFSET(req_q_pointer);
		uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
		uint8_t id = CALC_ID(req_q_pointer);
		ops[0].addr = offset + cacheline + (id << 14) + (1 << 15);
		Operand op;
		op.val = this->get_val();
		op.valid_w_id = id + 2;
		mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, READ_GRANULARITY);
		req_q_pointer++;
	}

	if(obj1.ptr && (global_counter-obj1.counter) < NUM_FPGA_ENTRIES ){
		ops[1].addr = obj1.location + (1 << 14);
	}else{
		uint16_t offset = CALC_OFFSET(req_q_pointer);
		uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
		uint8_t id = CALC_ID(req_q_pointer);
		ops[1].addr = offset + cacheline + (id << 14) + (1 << 15);
		Operand op;
		op.val = obj1.get_val();
		op.valid_w_id = id + 2;
		mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, READ_GRANULARITY);
		req_q_pointer++;
	}
	#endif
	/*no reuse*/
	#ifdef NOREUSE
	uint16_t offset = CALC_OFFSET(req_q_pointer);
	uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
	uint8_t id = CALC_ID(req_q_pointer);
	ops[0].addr = offset + cacheline + (id << 14) + (1 << 15);
	Operand op;
	op.val = this->get_val();
	op.valid_w_id = id + 2;
	mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, READ_GRANULARITY);
	req_q_pointer++;
	offset = CALC_OFFSET(req_q_pointer);
	cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
	id = CALC_ID(req_q_pointer);
	ops[1].addr = offset + cacheline + (id << 14) + (1 << 15);
	op.val = obj1.get_val();
	op.valid_w_id = id + 2;
	mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, READ_GRANULARITY);
	req_q_pointer++;
	#endif

	if(inst == Inst::FMA){
		/*with reuse*/
		#ifdef REUSE
		if(obj2.ptr && (global_counter -obj2.counter) < NUM_FPGA_ENTRIES ){
			ops[2].addr = obj2.location  + (1 << 14);
		}else{
			uint16_t offset = CALC_OFFSET(req_q_pointer);
			uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
			uint8_t id = CALC_ID(req_q_pointer);
			ops[2].addr = offset + cacheline + (id << 14) + (1 << 15);
			Operand op;
			op.val = obj2.get_val();
			op.valid_w_id = id + 2;
			mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, READ_GRANULARITY);
			req_q_pointer++;
		}
		#endif
		/*no reuse*/
		#ifdef NOREUSE
		uint16_t offset = CALC_OFFSET(req_q_pointer);
		uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
		uint8_t id = CALC_ID(req_q_pointer);
		ops[2].addr = offset + cacheline + (id << 14) + (1 << 15);
		Operand op;
		op.val = obj2.get_val();
		op.valid_w_id = id + 2;
		mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, READ_GRANULARITY);	
		req_q_pointer++;
		#endif
	}else{
		ops[2].addr = 0;
	}

	Hardposit* res = result_track[result_q_pointer] ;
	if( res != nullptr){
		if(!res->valid){
			res->get_val();
		}
	}


	ret.valid = false;

	ret.ptr = (Result*)((void*)result->c_type() +result_q_pointer*WRITE_GRANULARITY);
	ret.counter = global_counter;
	ret.location = result_q_pointer;
	uint64_t write_req = 0;

	write_req += result_q_pointer;


	mempcpy((uint8_t*)&write_req+1, ops, 3*sizeof(OpAddr));
	uint8_t insmod =  inst + (mode << 3);
	write_req += ((uint64_t)insmod) << 56;

	global_counter ++;
	ret.ptr->flags = 0;

	result_track[result_q_pointer] = &ret;
  __sync_synchronize();
	accel->write_csr64(16, write_req);
	return ret;
}

Hardposit::~Hardposit(){
	if(this->ptr && !this->valid){
		this->get_val();
	}
}


Hardposit Hardposit::operator + (Hardposit const &obj){
	return this->compute(obj, Hardposit(), ADDSUB, false);
}

Hardposit Hardposit::operator - (Hardposit const &obj){
	return this->compute(obj, Hardposit(), ADDSUB, true);
}

Hardposit Hardposit::operator- (){
	if(!this->valid){
		this->get_val();
	}
	this->val ^= (1<<31);
}

Hardposit Hardposit::operator / (Hardposit const &obj){
	return this->compute(obj, Hardposit(), SQRTDIV, false);
}
Hardposit Hardposit::operator * (Hardposit const &obj){
	return this->compute(obj, Hardposit(), MUL, false);
}

Hardposit Hardposit::sqrt(){
	return this->compute(Hardposit(), Hardposit(), SQRTDIV, true);
}
Hardposit Hardposit::FMA(Hardposit const &obj1, Hardposit const &obj2)
{
	return this->compute(obj1, obj2, Inst::FMA, false);
}
void Hardposit::operator = (Hardposit const &obj){
	this->val = obj.val;
	this->valid = obj.valid;
	this->ptr = obj.ptr;
	this->location = obj.location;
	this->counter = obj.counter;
}

void Hardposit::operator = (float const &obj){
	this->val = posit32(obj).value;
	this->ptr = nullptr;
	this->valid = true;
	this->location = 0;
	this->counter = 0;
}

double Hardposit::toDouble(){
	return posit32(this->val).toDouble();
}

int Hardposit::toInt(){
	return posit32(this->val).toInt();
}

Hardposit::operator bool () const{
	return (this->get_val() !=0);
};

Hardposit Hardposit::operator < (Hardposit const &obj){
	Hardposit result = this->compute(obj, Hardposit(), CMP, false);
	result.val = LT;
	return result;
}
Hardposit Hardposit::operator > (Hardposit const &obj){
	Hardposit result = this->compute(obj, Hardposit(), CMP, false);
	result.val = GT;
	return result;
}
Hardposit Hardposit::operator == (Hardposit const &obj){
	Hardposit result = this->compute(obj, Hardposit(), CMP, false);
	result.val = EQ;
	return result;
}