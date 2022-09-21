include ../../common/sw/common_include.mk


CPPFLAGS += $(CFLAGS) -Wno-cpp /homes/chshibo/Shibo/hardposit-chisel3/sw/SoftPosit/build/Linux-x86_64-GCC/softposit.a -I../SoftPosit/source/include/ -I./include/
SRC_DIR = src
INCLUDE_DIR = include
LIB_DIR = lib
OBJ_DIR = obj
# Files and folders
SRCS = $(SRC_DIR)/hardposit.cpp

FPGA_LIB = libhardpositfpga
ASE_LIB = libhardpositase
AFU_JSON_INFO = include/afu_json_info.h

all: all_reuse all_noreuse all_baseline;

all_reuse: fpga ase ;

all_noreuse: fpga_noreuse ase_noreuse ;

all_baseline: fpga_baseline ase_baseline ;

fpga: $(AFU_JSON_INFO) $(LIB_DIR)/$(FPGA_LIB).a ;

ase: $(AFU_JSON_INFO) $(LIB_DIR)/$(ASE_LIB).a ;

fpga_noreuse: $(AFU_JSON_INFO) $(LIB_DIR)/$(FPGA_LIB)_noreuse.a ;

ase_noreuse: $(AFU_JSON_INFO) $(LIB_DIR)/$(ASE_LIB)_noreuse.a ;

fpga_baseline: $(AFU_JSON_INFO) $(LIB_DIR)/$(FPGA_LIB)_baseline.a ;

ase_baseline: $(AFU_JSON_INFO) $(LIB_DIR)/$(ASE_LIB)_baseline.a ;

$(LIB_DIR)/$(FPGA_LIB).a: $(OBJ_DIR)/$(FPGA_LIB).o
	ar crf $@ $^ 

$(LIB_DIR)/$(FPGA_LIB)_noreuse.a: $(OBJ_DIR)/$(FPGA_LIB)_noreuse.o
	ar crf $@ $^ 

$(LIB_DIR)/$(FPGA_LIB)_baseline.a: $(OBJ_DIR)/$(FPGA_LIB)_baseline.o 
	ar crf $@ $^ 

$(OBJ_DIR)/$(FPGA_LIB).o:  $(SRCS) 
	$(CXX) -c  $^ -o $@ $(CPPFLAGS) -D REUSE $(LDFLAGS) $(FPGA_LIBS) -lrt

$(OBJ_DIR)/$(FPGA_LIB)_noreuse.o:  $(SRCS) 
	$(CXX) -c  $^ -o $@ $(CPPFLAGS) -D NOREUSE $(LDFLAGS) $(FPGA_LIBS) -lrt

$(OBJ_DIR)/$(FPGA_LIB)_baseline.o:  $(SRCS) 
	$(CXX) -c  $^ -o $@ $(CPPFLAGS) -D BASELINE $(LDFLAGS) $(FPGA_LIBS) -lrt

# AFU info from JSON file, including AFU UUID
$(AFU_JSON_INFO): ../../hw/bdx-rtl.json
	afu_json_mgr json-info --afu-json=$^ --c-hdr=$@

$(LIB_DIR)/$(ASE_LIB).a: $(OBJ_DIR)/$(ASE_LIB).o
	ar crf $@ $^ 

$(LIB_DIR)/$(ASE_LIB)_noreuse.a: $(OBJ_DIR)/$(ASE_LIB)_noreuse.o
	ar crf $@ $^ 

$(LIB_DIR)/$(ASE_LIB)_baseline.a: $(OBJ_DIR)/$(ASE_LIB)_baseline.o 
	ar crf $@ $^ 

$(OBJ_DIR)/$(ASE_LIB).o: $(SRCS) 
	$(CXX) -c  $^ $(CPPFLAGS) -D REUSE $(LDFLAGS) $(ASE_LIBS) -lrt -o $@

$(OBJ_DIR)/$(ASE_LIB)_noreuse.o: $(SRCS) 
	$(CXX) -c  $^ $(CPPFLAGS) -D NOREUSE $(LDFLAGS) $(ASE_LIBS) -lrt -o $@

$(OBJ_DIR)/$(ASE_LIB)_baseline.o: $(SRCS) 
	$(CXX) -c  $^ $(CPPFLAGS) -D BASELINE $(LDFLAGS) $(ASE_LIBS) -lrt -o $@

.PHONY: clean

clean:
	rm -rf $(LIB_DIR)/*.a $(OBJ_DIR)/*.o $(AFU_JSON_INFO)

objdir:
	@mkdir -p $(OBJDIR)

.PHONY: all clean
