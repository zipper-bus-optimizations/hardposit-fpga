include ../config/make.def

# Note that COMPILE is also defined in make.common and should
# be the same. We can't include make.common because it has a lot
# of other garbage. 
FCOMPILE = $(F77) -c $(F_INC) $(FFLAGS)

all: setparams 

# setparams creates an npbparam.h file for each benchmark 
# configuration. npbparams.h also contains info about how a benchmark
# was compiled and linked

setparams: setparams.c ../config/make.def
	$(UCC) -o setparams setparams.c -fPIC


clean: 
	-rm -f setparams setparams.h npbparams.h
	-rm -f *~ *.o

