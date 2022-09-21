SHELL=/bin/sh
BENCHMARK=cg
BENCHMARKU=CG

include ../config/make.def

OBJS = cg.o ${COMMON}/c_print_results.o  \
       ${COMMON}/c_${RAND}.o ${COMMON}/c_timers.o ${COMMON}/c_wtime.o

include ../sys/make.common

${PROGRAM}: config ${OBJS} ${PROGRAM}.fpga ${PROGRAM}.ase ${PROGRAM}_NOREUSE.fpga ${PROGRAM}_NOREUSE.ase ${PROGRAM}_BASELINE.fpga ${PROGRAM}_BASELINE.ase;

${PROGRAM}.fpga: config ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSFPGA} -o $@  ${OBJS} $(CLINK_LIBFPGA) ${C_LIB} 

${PROGRAM}.ase: config ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSASE} -o $@ ${OBJS} $(CLINK_LIBASE) ${C_LIB} 

${PROGRAM}_NOREUSE.fpga: config ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSFPGA} -o $@  ${OBJS} $(CLINK_LIBFPGA_NOREUSE) ${C_LIB} 

${PROGRAM}_NOREUSE.ase: config ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSASE} -o $@ ${OBJS} $(CLINK_LIBASE_NOREUSE) ${C_LIB} 

${PROGRAM}_BASELINE.fpga: config ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSFPGA} -o $@  ${OBJS} $(CLINK_LIBFPGA_BASELINE) ${C_LIB} 

${PROGRAM}_BASELINE.ase: config ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSASE} -o $@ ${OBJS} $(CLINK_LIBASE_BASELINE) ${C_LIB} 



cg.o:		cg.cpp  npbparams.h
	${CCOMPILE} cg.cpp

clean:
	- rm -f *.o *~ 
	- rm -f npbparams.h core

