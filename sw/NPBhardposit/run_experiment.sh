#!/bin/sh
declare -a benchmarks=("bt" "cg" "ft" "lu" "mg")
declare -a configs=("" "_NOREUSE" "_BASELINE")

# pushd sw
# pushd Hardposit
# make clean; make
# popd
# pushd NPBhardposit
# make clean; make suite
# pushd bin
# if [ "$FPGATYPE" == "pac" ]
# then
    # fpgaconf ../../../hw_discrete/build_fpga_coalesce/bdx-rtl.gbs
    for benchmark in "${benchmarks[@]}"
    do
        for config in "${configs[@]}"
        do
            ./bin/${benchmark}.S${config}.fpga > log/discrete_${benchmark}.S${config}_coalesce.log
        done
    done
    # fpgaconf ../../../hw_discrete/build_fpga_nocoalesce/bdx-rtl.gbs
    # for benchmark in "${benchmarks[@]}"
    # do
    #     for config in "${configs[@]}"
    #     do
    #         ./${benchmark}.S${config}.fpga 2>&1 | tee ../log/discrete_${benchmark}.S${config}_nocoalesce.log
    #     done
    # done
# else
    # fpgaconf ../../../hw_bdx/build_fpga_coalesce/bdx-rtl.gbs
    # for benchmark in "${benchmarks[@]}"
    # do
    #     for config in "${configs[@]}"
    #     do
    #         ./${benchmark}.S${config}.fpga 2>&1 | tee ../log/bdx_${benchmark}.S${config}_coalesce.log
    #     done
    # done
    # fpgaconf ../../../hw_bdx/build_fpga_nocoalesce/bdx-rtl.gbs
#     for benchmark in "${benchmarks[@]}"
#     do
#         for config in "${configs[@]}"
#         do
#             ./${benchmark}.S${config}.fpga 2>&1 | tee ../log/bdx_${benchmark}.S${config}_nocoalesce.log
#         done
#     done
# fi