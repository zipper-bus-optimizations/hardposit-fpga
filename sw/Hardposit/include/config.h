#include <cstdint>

#ifndef __SW_CONFIG_H__
#define __SW_CONFIG_H__
static const uint64_t NUM_OPERAND = 3;
static const uint64_t NUM_FPGA_ENTRIES = 8;
static const uint64_t NUM_OPERAND_ENTRIES  = NUM_OPERAND*NUM_FPGA_ENTRIES;
static const uint64_t WRITE_GRANULATIRY = 64;
static const uint64_t READ_GRANULATIRY = 4;
#define CACHELINE_BYTES 64
#define CL(x) ((x) * CACHELINE_BYTES)

#endif