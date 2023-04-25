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
#include <assert.h> 
#include "afu_json_info.h"
#include "hardposit.h"
#include "softposit.h"
#include "softposit_types.h"
#include "softposit_cpp.h"
#include "primitives.h"
#include "config.h"
using namespace opae::fpga::types;
bool finish = false;

static handle::ptr_t accel = nullptr;
static uint64_t global_counter = 0;
uint64_t total_reuse = 0;
uint64_t total_call_memory = 0;
uint64_t total_call_compute = 0;
uint64_t total_effcient_compute = 0;
shared_buffer::ptr_t req;
shared_buffer::ptr_t result;
uint8_t req_q_pointer = 0;
static ResultSlot result_track[NUM_FPGA_ENTRIES];
uint64_t distances[20];

void poll_performance(){
	memset(((void*)result->c_type())+(NUM_FPGA_ENTRIES*WRITE_GRANULARITY), 0, sizeof(Performance_array));
	accel->write_csr64(24, NUM_FPGA_ENTRIES);
	volatile Performance_array* perf = (Performance_array*)(((void*)result->c_type())+(NUM_FPGA_ENTRIES*WRITE_GRANULARITY));
	while(!perf->valid){}
	std::cout <<"Total call memory: "<< total_call_memory<<std::endl;
	std::cout <<"Total reuse: "<< total_reuse<<std::endl;
	std::cout <<"Total call compute: "<< total_call_compute<<std::endl;
	std::cout <<"Total efficient compute: "<< total_effcient_compute<<std::endl;
	std::cout <<"Total created object: "<< Counter<Hardposit>::getCreated() << std::endl;
	std::cout <<"Greatest living object: "<< Counter<Hardposit>::getMost() << std::endl;
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
	for(int i = 0;i < 20; i++){
		std::cout << distances[i]/(double)total_call_memory;
		if(i<19) std::cout<<", ";
		else std::cout <<std::endl;
	}
}

int close_accel(){
	finish = true;
	accel->reset();
	req->release();
	result->release();
	accel->close();
	return 0;
}
int init_accel(){
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
	    memset((void*) req->c_type(), 0,NUM_CACHELINE* SIZE_OF_CACHELINE);
	  	memset((void*)result->c_type(), 0,(NUM_FPGA_ENTRIES+1)*WRITE_GRANULARITY);

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
	return 0;
	// std::cout <<"initliazed success"<<std::endl;
}


/*
 Hardposit:print_val
 print the value of the hardposit
*/
void Hardposit::print_val(){
	std::cout << "Hardposit: " << std::bitset<32>(this->get_val()) << std::endl;
}

void Hardposit::get_val_at_slot(const uint8_t& pos, bool keep){
	// std::cout <<"in get_val_at_slot"<<std::endl;
	// std::cout <<"pos_to_get: "<<(int)pos <<" ptr: "<<(int)result_track[pos].ptr <<" list_size: "<< result_track[pos].crntPosit.size()<<std::endl;
	if((!result_track[pos].crntPosit.empty()) ){
		if( (*(result_track[pos].crntPosit.begin()))->valid){
			for(auto it = result_track[pos].crntPosit.begin(); it != result_track[pos].crntPosit.end(); ++it){
				(*it)->setInFpga(keep);
				(*it)->valid = true;
				(*it)->val = (*(result_track[pos].crntPosit.begin()))->val;
			}
		}else{
			volatile Result* ptr = result_track[pos].ptr;
			if(ptr != nullptr){
				while(!ptr->flags){
					// printf("global counter: %d, pos: %d\n",global_counter, pos);
				}
				uint32_t tmp = 0;
				for(auto it = result_track[pos].crntPosit.begin(); it != result_track[pos].crntPosit.end(); ++it){
					(*it)->setInFpga(keep);
					(*it)->val = ptr->result;
					(*it)->valid = true;
				}
			}
		}
	}
	// std::cout <<"get_val_at_slot success"<<std::endl;
	return; 
}

uint32_t Hardposit::get_val(){
	// std::cout <<"in get_val"<<std::endl;
	if(!this->valid){
		// if(!this->in_fpga){
		// 	assert(("in_fpga should be true but now false", this->in_fpga));
		// }
		get_val_at_slot(this->location, this->in_fpga);
	}
	// std::cout <<"get_val success"<<std::endl;
	return this->val;
}

Hardposit::Hardposit(uint32_t in_val){
	this->val = in_val;
	this->valid = true;
	this->in_fpga = false;
	this->location = 0;
}

Hardposit::Hardposit(int in_val){
	this->val = posit32(in_val).value;
	this->valid = true;
	this->in_fpga = false;
	this->location = 0;
}

Hardposit::Hardposit(float in_val){
	this->val = posit32(in_val).value;
	this->valid = true;
	this->in_fpga = false;
	this->location = 0;
}
Hardposit::Hardposit(double in_val){
	this->val = posit32(in_val).value;
	this->valid = true;
	this->in_fpga = false;
	this->location = 0;
}
Hardposit Hardposit::compute(Hardposit const& obj1, Hardposit const& obj2, Inst inst, bool mode){
	// std::cout <<"in compute"<<std::endl;
	total_call_compute++;
	OpAddr ops[3];
	uint8_t flag = 0;
	Hardposit ret;
	uint8_t result_q_pointer = global_counter % NUM_FPGA_ENTRIES;
	uint64_t mask = (1<<9-1)<<4;
	/*with reuse*/
	#ifdef REUSE
	total_call_memory++;
	if(this->was_computed){
		uint64_t distance = global_counter-this->global_location;
		if(distance>=20){
			distances[19]++;
		}else if(distance >=1){
			distances[distance-1]++;
		}
	}
	if( this->in_fpga && (result_q_pointer%8)!= (this->location%8)){
		total_reuse++;
		ops[0].addr = this->location + (1 << 14);
	}else{
		flag = 1;
		uint16_t offset = CALC_OFFSET(req_q_pointer);
		uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
		uint8_t id = CALC_ID(req_q_pointer);
		ops[0].addr = offset + cacheline + (id << 14) + (1 << 15);
		Operand op;
		op.val = this->get_val();
		op.valid_w_id = id + 2;
		// std::cout <<"cacheline: "<<std::bitset<16>(cacheline)<<" offset: "<< offset<<" id: "<<(int)id<<std::endl;
		mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, sizeof(op));
		// std::cout <<"offset: "<<offset<<" cacheline: "<<std::bitset<16>(cacheline) <<std::endl;
		req_q_pointer++;
	}
	if(obj1.was_computed){
		uint64_t distance = global_counter-obj1.global_location;
		if(distance>=20){
			distances[19]++;
		}else if(distance >=1){
			distances[distance-1]++;
		}
	}
	total_call_memory++;
	if( obj1.in_fpga &&  (result_q_pointer%8)!= (obj1.location%8)){
		total_reuse++;
		ops[1].addr = obj1.location + (1 << 14);
	}else{
		flag = 1;
		uint16_t offset = CALC_OFFSET(req_q_pointer);
		uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
		uint8_t id = CALC_ID(req_q_pointer);
		ops[1].addr = offset + cacheline + (id << 14) + (1 << 15);
		Operand op;
		op.val = obj1.get_val();
		op.valid_w_id = id + 2;
		// std::cout <<"cacheline: "<<std::bitset<16>(cacheline)<<" offset: "<< offset<<" id: "<<id<<std::endl;
		mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, sizeof(op));
		req_q_pointer++;
	}
	#endif
	/*no reuse*/
	#if defined(NOREUSE) || defined(BASELINE)
	uint16_t offset = CALC_OFFSET(req_q_pointer);
	uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
	uint8_t id = CALC_ID(req_q_pointer);
	ops[0].addr = offset + cacheline + (id << 14) + (1 << 15);
	Operand op;
	op.val = this->get_val();
	op.valid_w_id = id + 2;
	mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, sizeof(op));
	req_q_pointer++;
	offset = CALC_OFFSET(req_q_pointer);
	cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
	id = CALC_ID(req_q_pointer);
	ops[1].addr = offset + cacheline + (id << 14) + (1 << 15);
	op.val = obj1.get_val();
	op.valid_w_id = id + 2;
	mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, sizeof(op));
	req_q_pointer++;
	#endif

	if(inst == Inst::FMA){
		if(obj2.was_computed){
			uint64_t distance = global_counter-obj2.global_location;
			if(distance>=20){
				distances[19]++;
			}else if(distance >=1){
				distances[distance-1]++;
			}
		}
		/*with reuse*/
		#ifdef REUSE
		total_call_memory++;
		if(obj2.in_fpga && (result_q_pointer%8)!= (obj2.location%8)  ){
			total_reuse++;
			ops[2].addr = obj2.location  + (1 << 14);
		}else{
			flag = 1;
			uint16_t offset = CALC_OFFSET(req_q_pointer);
			uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
			uint8_t id = CALC_ID(req_q_pointer);
			ops[2].addr = offset + cacheline + (id << 14) + (1 << 15);
			Operand op;
			op.val = obj2.get_val();
			op.valid_w_id = id + 2;
			mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, sizeof(op));
			req_q_pointer++;
		}
		#endif
		/*no reuse*/
		#if defined(NOREUSE) || defined(BASELINE)
		uint16_t offset = CALC_OFFSET(req_q_pointer);
		uint16_t cacheline = CALC_CACHELINE_ONE_HOT(req_q_pointer);
		uint8_t id = CALC_ID(req_q_pointer);
		ops[2].addr = offset + cacheline + (id << 14) + (1 << 15);
		Operand op;
		op.val = obj2.get_val();
		op.valid_w_id = id + 2;
		mempcpy(((void*)req->c_type() + CALC_OFFSET_IN_BYTE(req_q_pointer) + CALC_CACHELINE_OFFSET_IN_BYTE(req_q_pointer)), &op, sizeof(op));	
		req_q_pointer++;
		#endif
	}else{
		ops[2].addr = 0;
	}

	#ifdef REUSE
	if (flag == 0) {total_effcient_compute++;}
	#endif

	get_val_at_slot((result_q_pointer+8-SIMULATED_ENTRIES)%8, false);
	result_track[result_q_pointer].ptr = nullptr;
	result_track[result_q_pointer].crntPosit.clear();

	ret.valid = false;
	ret.location = result_q_pointer;
	ret.setInFpga(true);
	ret.was_computed = true;
	ret.global_location = global_counter;

	result_track[result_q_pointer].ptr = (Result*)((void*)result->c_type() +result_q_pointer*WRITE_GRANULARITY);
	uint64_t write_req = 0;

	write_req += result_q_pointer;


	mempcpy(((uint8_t*)&write_req)+1, ops, 3*sizeof(OpAddr));
	uint8_t insmod =  inst + (mode << 3);
	write_req += ((uint64_t)insmod) << 56;

	global_counter ++;
	memset((void*)& (result_track[result_q_pointer].ptr->flags),0, sizeof(result_track[result_q_pointer].ptr->flags));

	result_track[result_q_pointer].crntPosit.push_back(&ret);

  __sync_synchronize();

	accel->write_csr64(16, write_req);
	// std::cout <<"compute success"<<std::endl;
	#ifdef BASELINE
		ret.get_val();
	#endif

	return ret;
}
Hardposit::Hardposit(const Hardposit& obj){
	this->val = obj.val;
	this->valid = obj.valid;
	this->setInFpga(obj.in_fpga);
	this->location = obj.location;
	this->was_computed = obj.was_computed;
	this->global_location = obj.global_location;
	if(this->in_fpga){
		result_track[this->location].crntPosit.push_back(this);
	}
}

Hardposit::~Hardposit(){
	// std::cout <<"in ~Hardposit"<<std::endl;
	if(!finish && this->in_fpga){
		result_track[this->location].crntPosit.remove(this);
	}
	// std::cout <<"~Hardposit success"<<std::endl;
}


Hardposit Hardposit::operator + (Hardposit const& obj){
	return this->compute(obj, Hardposit(), ADDSUB, false);
}

Hardposit Hardposit::operator - (Hardposit const& obj){
	return this->compute(obj, Hardposit(), ADDSUB, true);
}

Hardposit& Hardposit::operator- (){
	if(!this->valid){
		this->get_val();
	}
	this->val ^= (1<<31);
	return *this;
}

Hardposit Hardposit::operator / (Hardposit const& obj){
	return this->compute(obj, Hardposit(), SQRTDIV, false);
}
Hardposit Hardposit::operator * (Hardposit const& obj){
	return this->compute(obj, Hardposit(), MUL, false);
}

Hardposit Hardposit::sqrt(){
	return this->compute(Hardposit(), Hardposit(), SQRTDIV, true);
}
Hardposit Hardposit::FMA(Hardposit const& obj1, Hardposit const& obj2)
{
	return this->compute(obj1, obj2, Inst::FMA, false);
}
Hardposit& Hardposit::operator = (Hardposit const& obj){
	if(this->in_fpga){
		result_track[this->location].crntPosit.remove(this);
	}
	this->val = obj.val;
	this->valid = obj.valid;
	this->setInFpga(obj.in_fpga);
	this->location = obj.location;
	this->was_computed = obj.was_computed;
	this->global_location = obj.global_location;
	if(this->in_fpga){
		result_track[this->location].crntPosit.push_back(this);
	}
	return *this;
}

Hardposit& Hardposit::operator = (float const& obj){
	this->val = posit32(obj).value;
	this->in_fpga = false;
	this->valid = true;
	this->location = 0;
	return *this;
}

double Hardposit::toDouble(){
	return convertP32ToDouble(castP32(this->get_val()));
}

int Hardposit::toInt(){
	return p32_int(castP32(this->get_val()));
}

Hardposit::operator bool () const{
	return (this->get_val() !=0);
}

bool Hardposit::operator < (Hardposit& obj){
	posit32 a;
	posit32 b;
	a.value = this->get_val();
	b.value = obj.get_val();

	return a < b;
}
bool Hardposit::operator > (Hardposit& obj){
	posit32 a;
	posit32 b;
	a.value = this->get_val();
	b.value = obj.get_val();

	return a > b;
}
bool Hardposit::operator == (Hardposit& obj){
	posit32 a;
	posit32 b;
	a.value = this->get_val();
	b.value = obj.get_val();

	return a == b;
}
