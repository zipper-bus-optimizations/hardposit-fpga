include ../../common/sw/common_include.mk

# Primary test name
TEST = test
# Build directory

AFU_JSON_INFO = afu_json_info.h

CPPFLAGS += $(CFLAGS) -Wno-cpp 


FPGA_CPPFLAGS = $(CPPFLAGS) ../Hardposit/lib/libhardpositfpga.a /homes/chshibo/Shibo/hardposit-chisel3/sw/SoftPosit/build/Linux-x86_64-GCC/softposit.a -I../SoftPosit/source/include/ -I../Hardposit/include
ASE_CPPFLAGS = $(CPPFLAGS) ../Hardposit/lib/libhardpositase.a /homes/chshibo/Shibo/hardposit-chisel3/sw/SoftPosit/build/Linux-x86_64-GCC/softposit.a -I../SoftPosit/source/include/ -I../Hardposit/include

# Files and folders
SRCS = $(TEST).cpp 

all: fpga ase ;

fpga: $(AFU_JSON_INFO) $(TEST)_fpga;

ase: $(AFU_JSON_INFO) $(TEST)_ase  ;

test_fpga: $(SRCS)
	$(CXX) -o $@  $^ $(FPGA_CPPFLAGS) $(LDFLAGS) $(FPGA_LIBS) -lrt

$(AFU_JSON_INFO): ../../hw/bdx-rtl.json
	afu_json_mgr json-info --afu-json=$^ --c-hdr=$@

$(TEST)_ase: $(SRCS)
	$(CXX) -o $@ $^ $(ASE_CPPFLAGS) $(LDFLAGS) $(ASE_LIBS) -lrt


clean:
	rm -rf $(TEST)_fpga $(TEST)_ase 


.PHONY: all clean
