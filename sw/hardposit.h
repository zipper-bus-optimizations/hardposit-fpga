#include <opae/cxx/core/handle.h>
#include <opae/cxx/core/properties.h>
#include <opae/cxx/core/shared_buffer.h>
#include <opae/cxx/core/token.h>
#include <opae/cxx/core/version.h>
#include <cstdint>
#include "config.h"
#ifndef __OPAE_CPP_HARDPOSIT_H__
#define __OPAE_CPP_HARDPOSIT_H__

using namespace opae::fpga::types;

void init_accel();
enum CmpType {NONE, LT, EQ, GT};
enum Inst{NOOP, ADDSUB, CMP, FMA, MUL, SQRTDIV};
struct Operand{
	uint8_t addr_mode = 0;
	uint8_t addr = 0;
};
struct Result{
		/* 3-bit pad, 1-bit isZero, 1-bit isNaR,
    1-bit lt, 1-bit eq, 1-bit gt*/
	bool flags = 0;
	uint32_t reuslt = 0;
};

class Hardposit_cmp{
	public: 
		bool val;
		CmpType type;
		Result* ptr;
		bool valid;
		void print_val();
		bool get_val();
		Hardposit_cmp(bool in_val);
		Hardposit_cmp():Hardposit_cmp(false){}
		void operator = (Hardposit_cmp const &obj);
		~Hardposit_cmp();
};

class Hardposit {
	public:
		uint32_t val;
		Result* ptr;
		bool valid;
		uint8_t location;
		uint32_t counter;

		void print_val();
		uint32_t get_val();
		Hardposit(uint32_t in_val);
		Hardposit(): Hardposit(0){};
		~Hardposit();
		Hardposit compute(Hardposit const &obj1, Hardposit const &obj2, Inst inst, bool mode);
		Hardposit_cmp compute_cmp(Hardposit const &obj, Inst inst, bool mode);
		Hardposit operator + (Hardposit const &obj);
		Hardposit operator - (Hardposit const &obj);
		Hardposit operator / (Hardposit const &obj);
		Hardposit operator * (Hardposit const &obj);
		Hardposit_cmp operator < (Hardposit const &obj);
		Hardposit_cmp operator > (Hardposit const &obj);
		Hardposit_cmp operator == (Hardposit const &obj);
		Hardposit sqrt(Hardposit const &obj);
		Hardposit FMA(Hardposit const &obj1, Hardposit const &obj2);
		void operator = (Hardposit const &obj);

};




#endif
