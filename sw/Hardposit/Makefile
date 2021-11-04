include ../../common/sw/common_include.mk


CPPFLAGS += $(CFLAGS) -Wno-cpp /homes/chshibo/hardposit-chisel3/sw/SoftPosit/build/Linux-x86_64-GCC/softposit.a -I../SoftPosit/source/include/ -I./include/
SRC_DIR = src
INCLUDE_DIR = include
LIB_DIR = lib
OBJ_DIR = obj
# Files and folders
SRCS = $(SRC_DIR)/hardposit.cpp

FPGA_LIB = libhardpositfpga
ASE_LIB = libhardpositase
AFU_JSON_INFO = include/afu_json_info.h

all: fpga ase ;

fpga: $(AFU_JSON_INFO) $(LIB_DIR)/$(FPGA_LIB).a ;

ase: $(AFU_JSON_INFO) $(LIB_DIR)/$(ASE_LIB).a ;


$(LIB_DIR)/$(FPGA_LIB).a: $(OBJ_DIR)/$(FPGA_LIB).o
	ar crf $@ $^ 

$(OBJ_DIR)/$(FPGA_LIB).o:  $(SRCS) 
	$(CXX) -c  $^ -o $@ $(CPPFLAGS) $(LDFLAGS) $(FPGA_LIBS) -lrt


# AFU info from JSON file, including AFU UUID
$(AFU_JSON_INFO): ../../hw/bdx-rtl.json
	afu_json_mgr json-info --afu-json=$^ --c-hdr=$@

$(LIB_DIR)/$(ASE_LIB).a: $(OBJ_DIR)/$(ASE_LIB).o
	ar crf $@ $^ 

$(OBJ_DIR)/$(ASE_LIB).o: $(SRCS) 
	$(CXX) -c  $^ $(CPPFLAGS) $(LDFLAGS) $(ASE_LIBS) -lrt -o $@

.PHONY: clean

clean:
	rm -rf $(LIB_DIR)/*.a $(OBJ_DIR)/*.o $(AFU_JSON_INFO)

objdir:
	@mkdir -p $(OBJDIR)

.PHONY: all clean
