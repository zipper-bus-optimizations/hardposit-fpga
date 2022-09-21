SHELL=/bin/sh
BENCHMARK=lu
BENCHMARKU=LU

include ../config/make.def

OBJS = lu.o ${COMMON}/c_print_results.o \
       ${COMMON}/c_timers.o ${COMMON}/c_wtime.o

include ../sys/make.common


# npbparams.h is included by applu.incl
# The following rule should do the trick but many make programs (not gmake)
# will do the wrong thing and rebuild the world every time (because the
# mod time on header.h is not changed. One solution would be to 
# touch header.h but this might cause confusion if someone has
# accidentally deleted it. Instead, make the dependency on npbparams.h
# explicit in all the lines below (even though dependence is indirect). 

# applu.incl: npbparams.h
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


lu.o:		lu.cpp applu.h npbparams.h
	${CCOMPILE} lu.cpp

clean:
	- /bin/rm -f npbparams.h
	- /bin/rm -f *.o *~
