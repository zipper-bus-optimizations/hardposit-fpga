#include <opae/cxx/core/handle.h>
#include <opae/cxx/core/properties.h>
#include <opae/cxx/core/shared_buffer.h>
#include <opae/cxx/core/token.h>
#include <opae/cxx/core/version.h>
#include <cstdint>
#include <list>
#include "config.h"
#include "softposit.h"
#include "softposit_types.h"
#include "softposit_cpp.h"
#ifndef __OPAE_CPP_HARDPOSIT_H__
#define __OPAE_CPP_HARDPOSIT_H__

using namespace opae::fpga::types;

int close_accel();
int init_accel();
enum Inst{NOOP, ADDSUB, CMP, FMA, MUL, SQRTDIV, LT, EQ, GT};
struct OpAddr{
	/*2 bits for mode, if mode == 2, then the least significant bit is for id*/
	/*one hot encoding for cachline*/
	/*offset inside the cacheline*/
	uint16_t addr = 0;
};
struct Result{
		/* 3-bit pad, 1-bit isZero, 1-bit isNaR,
    1-bit lt, 1-bit eq, 1-bit gt*/
	volatile uint32_t result = 0;
	volatile uint32_t flags = 0;
};

struct Performance_array{
	uint64_t total_cycles = 0;
	uint32_t mem_req_cycles[12]= {0};
	bool valid = 0;
};

class Hardposit {
	public:

		uint32_t val;
		bool valid;
		bool in_fpga;
		uint8_t location;

		void print_val();
		uint32_t get_val();
		Hardposit(uint32_t in_val);
		Hardposit(int in_val);
		Hardposit(float in_val);
		Hardposit(double in_val);
		Hardposit(): Hardposit((uint32_t)0){
			this->valid = true; 
			this->location = 0;
			this->in_fpga = false;
		};
		~Hardposit();
		Hardposit compute(Hardposit const& obj1, Hardposit const& obj2, Inst inst, bool mode);
		Hardposit operator + (Hardposit const& obj);
		Hardposit operator - (Hardposit const& obj);
		Hardposit& operator- ();
		Hardposit operator / (Hardposit const& obj);
		Hardposit operator * (Hardposit const& obj);
		bool operator < (Hardposit& obj);
		bool operator > (Hardposit& obj);
		bool operator == (Hardposit& obj);
		Hardposit sqrt();
		Hardposit FMA(Hardposit const& obj1, Hardposit const& obj2);
		static void get_val_at_slot(const uint8_t& pos, bool keep);
		Hardposit& operator = (Hardposit const& obj);
		Hardposit& operator = (float const& obj);
		double toDouble();
		int toInt();
		operator bool () const;
};


inline Hardposit hp32(int a){
	return Hardposit(p32(a).value);
}

inline Hardposit hp32(float a){
	return Hardposit(p32(a).value);
}

inline Hardposit hp32(double a){
	return Hardposit(p32(a).value);
}

inline Hardposit operator/(const float& a, const Hardposit& b){
	return hp32(a)/b;
}

inline Hardposit operator+(const float& a, const Hardposit& b){
	return hp32(a)+b;
}
inline Hardposit operator-(const float& a, const Hardposit& b){
	return hp32(a)-b;
}

inline Hardposit operator/(const double& a, const Hardposit& b){
	return hp32(a)/b;
}

inline Hardposit operator/(const Hardposit& a, const int& b){
	return (Hardposit)a/ (Hardposit)hp32(b);
}

inline Hardposit operator+(const double& a, const Hardposit& b){
	return hp32(a)+b;
}
inline Hardposit operator-(const double& a, const Hardposit& b){
	return hp32(a)-b;
}

inline bool  operator!=(Hardposit& b, const float& a){
	return ! (hp32(a)==b);
}
inline bool operator==(Hardposit& b, const float& a){
	return hp32(a)==b;
}

inline bool  operator!=(Hardposit& b, const double& a){
	return ! hp32(a)==b;
}
inline bool operator==(Hardposit& b, const double& a){
	return hp32(a)==b;
}


inline Hardposit operator*(const float& a, const Hardposit& b){
	return Hardposit(a)*b;
}

inline Hardposit operator*(const Hardposit& b, const float& a){
	return Hardposit(a)*b;
}

inline Hardposit sqrt(Hardposit& a){
	return a.sqrt();
}


void poll_performance();

struct ResultSlot{
		volatile Result* ptr = nullptr;
		std::list<Hardposit*> crntPosit;
};

#endif
