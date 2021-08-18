#include <cstdint>

#ifndef __SW_CONFIG_H__
#define __SW_CONFIG_H__
static const char* NLB0_AFUID = "D8424DC4-A4A3-C413-F89E-433683F9040B";
static const uint64_t NUM_ENTRIES = 64;
static const uint64_t FPGA_ENTRIES = 64;
static const uint64_t WRITE_GRANULATIRY = 5;
static const uint64_t READ_GRANULATIRY = 4;
#define CACHELINE_BYTES 64
#define CL(x) ((x) * CACHELINE_BYTES)

#endif