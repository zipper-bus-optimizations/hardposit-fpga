SHELL=/bin/sh


include ../config/make.def

include ../sys/make.common

PROGRAM= ../bin/tests
OBJS= tests.o
all: ${PROGRAM}

${PROGRAM}: ${PROGRAM}.fpga ${PROGRAM}.ase ${PROGRAM}_NOREUSE.fpga ${PROGRAM}_NOREUSE.ase;

${PROGRAM}.fpga: ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSFPGA} -o $@  ${OBJS} $(CLINK_LIBFPGA) ${C_LIB} 

${PROGRAM}.ase:  ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSASE} -o $@ ${OBJS} $(CLINK_LIBASE) ${C_LIB} 

${PROGRAM}_NOREUSE.fpga: ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSFPGA} -o $@  ${OBJS} $(CLINK_LIBFPGA_NOREUSE) ${C_LIB} 

${PROGRAM}_NOREUSE.ase: ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSASE} -o $@ ${OBJS} $(CLINK_LIBASE_NOREUSE) ${C_LIB} 


tests.o:		tests.cpp
	${CCOMPILE} tests.cpp

clean:
	- rm -f *.o *~ *.ase *.fpga



