SHELL=/bin/sh
BENCHMARK=bt
BENCHMARKU=BT

include ../config/make.def


OBJS =	bt.o \
	${COMMON}/c_print_results.o ${COMMON}/c_timers.o ${COMMON}/c_wtime.o

include ../sys/make.common

# npbparams.h is included by header.h
# The following rule should do the trick but many make programs (not gmake)
# will do the wrong thing and rebuild the world every time (because the
# mod time on header.h is not changed. One solution would be to 
# touch header.h but this might cause confusion if someone has
# accidentally deleted it. Instead, make the dependency on npbparams.h
# explicit in all the lines below (even though dependence is indirect). 

# header.h: npbparams.h

${PROGRAM}: config ${OBJS} ${PROGRAM}.fpga ${PROGRAM}.ase ;

${PROGRAM}.fpga: config ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSFPGA} -o $@  ${OBJS} $(CLINK_LIBFPGA) ${C_LIB} 

${PROGRAM}.ase: config ${OBJS}
	${CLINK} ${CPPFLAGS} ${CLINKFLAGSASE} -o $@ ${OBJS} $(CLINK_LIBASE) ${C_LIB} 


bt.o: bt.cpp  header.h npbparams.h
	${CCOMPILE} $<

clean:
	- rm -f *.o *~ mputil*
	- rm -f  npbparams.h core