RTL=./rtl
SOURCE=${RTL}/sources.txt
BUILD_DIR=build_fpga

rebuild: clean build
	cd build_fpga

build: setup
	cd build_fpga; qsub-synth

setup: ${SOURCE} ${RTL}/Posit.sv ${RTL}/POSIT_Locality.v
	afu_synth_setup -s ${SOURCE} ${BUILD_DIR}

.PHONY:clean

clean:
	rm -rf ${BUILD_DIR}
