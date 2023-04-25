#!/bin/bash
declare -a benchmarks=("bt" "cg" "ft" "lu" "mg")
declare -a configs=("" "_NOREUSE" "_BASELINE")
# declare -a configs=("")
# pushd sw/NPBhardposit/bin
# pushd Hardposit
# make clean; make
# popd
# pushd NPBhardposit
# make clean; make suite
# pushd bin

# fpgaconf ../../../hw_bdx/build_fpga_coalesce/bdx-rtl.gbs
# for benchmark in "${benchmarks[@]}"
# do
#     for config in "${configs[@]}"
#     do
#         ./sw/NPBhardposit/bin/${benchmark}.S${config}.fpga 2>&1 > log/bdx_${benchmark}.S${config}_coalesce.log
#     done
# done

for benchmark in "${benchmarks[@]}"
do
    for config in "${configs[@]}"
    do
        ./sw/NPBhardposit/bin/${benchmark}.S${config}.fpga 2>&1 > log/8-nocoalesce/bdx_${benchmark}.S${config}.log
    done
done
