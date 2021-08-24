include ../common/sw/common_include.mk

# Primary test name
TEST = test
# Build directory

CFLAGS += -I./$(OBJDIR)
CPPFLAGS += $(CFLAGS) -Wno-cpp ../SoftPosit/build/Linux-x86_64-GCC/softposit.a -I../SoftPosit/source/include/ 

# Files and folders
SRCS = $(TEST).cpp hardposit.cpp
OBJS = $(addprefix $(OBJDIR)/,$(patsubst %.c,%.o,$(SRCS)))

# Targets (build only $(TEST)_ase by default)
all: $(TEST) $(TEST)_ase 

test: $(SRCS)
	$(CXX) -o $@  $^ $(CPPFLAGS) $(LDFLAGS) $(FPGA_LIBS) -lrt
setup_environ:
	export ASE_WORKDIR=//homes/chshibo/hardposit-chisel3/hw/build_sim/work

# AFU info from JSON file, including AFU UUID
AFU_JSON_INFO = $(OBJDIR)/afu_json_info.h
$(AFU_JSON_INFO): ../hw/rtl/$(TEST).json | objdir
	afu_json_mgr json-info --afu-json=$^ --c-hdr=$@

$(TEST)_ase: $(SRCS)
	$(CXX) -o $@ $^ $(CPPFLAGS) $(LDFLAGS) $(ASE_LIBS) -lrt


clean:
	rm -rf $(TEST) $(TEST)_ase $(OBJDIR)

objdir:
	@mkdir -p $(OBJDIR)

.PHONY: all clean
