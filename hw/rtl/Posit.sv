//
// Copyright (c) 2020, Intel Corporation
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// Neither the name of the Intel Corporation nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

`include "ofs_plat_if.vh"
`include "afu_json_info.vh"

//
// CCI-P version of hello world AFU example.
//

module ofs_plat_afu
   (
    // All platform wires, wrapped in one interface.
    ofs_plat_if plat_ifc
    );

    // ====================================================================
    //
    //  Get a CCI-P port from the platform.
    //
    // ====================================================================

    // Instance of a CCI-P interface. The interface wraps usual CCI-P
    // sRx and sTx structs as well as the associated clock and reset.
    ofs_plat_host_ccip_if host_ccip();

    // Use the platform-provided module to map the primary host interface
    // to CCI-P. The "primary" interface is the port that includes the
    // main OPAE-managed MMIO connection. This primary port is always
    // index 0 of plat_ifc.host_chan.ports, indepedent of the platform
    // and the native protocol of the host channel.
    ofs_plat_host_chan_as_ccip
        #(
        .ADD_CLOCK_CROSSING(1),
        .ADD_TIMING_REG_STAGES(3)
        ) primary_ccip
       (
        .to_fiu(plat_ifc.host_chan.ports[0]),
        .to_afu(host_ccip),

        .afu_clk(plat_ifc.clocks.pClkDiv4.clk),
        .afu_reset_n(plat_ifc.clocks.pClkDiv4.reset_n)
        );


    // Each interface names its associated clock and reset.
    logic clk;
    assign clk = host_ccip.clk;
    logic reset_n;
    assign reset_n = host_ccip.reset_n;

    // a register to record the number of req
    logic[63:0] total_mem_req;

    // number of cycles spent in waiting for memory request
    /* perf_cycle_array[i] = 10^i cycles*/
    logic[31:0] perf_cycle_array[11:0];
    

    // an array to track outstanding memory read access
    logic [31:0] perf_cycle_cnt[3:0];

    // ====================================================================
    //
    //  Tie off unused ports.
    //
    // ====================================================================

    // The PIM ties off unused devices, controlled by the AFU indicating
    // which devices it is using. This way, an AFU must know only about
    // the devices it uses. Tie-offs are thus portable, with the PIM
    // managing devices unused by and unknown to the AFU.
    ofs_plat_if_tie_off_unused
      #(
        // Host channel group 0 port 0 is connected. The mask is a
        // bit vector of indices used by the AFU.
        .HOST_CHAN_IN_USE_MASK(1)
        )
        tie_off(plat_ifc);  


    // The AFU ID is a unique ID for a given program.  Here we generated
    // one with the "uuidgen" program and stored it in the AFU's JSON file.
    // ASE and synthesis setup scripts automatically invoke afu_json_mgr
    // to extract the UUID into afu_json_info.vh.
    logic [127:0] afu_id = `AFU_ACCEL_UUID;
    logic [512:0] result_buffer;
    //
    // A valid AFU must implement a device feature list, starting at MMIO
    // address 0.  Every entry in the feature list begins with 5 64-bit
    // words: a device feature header, two AFU UUID words and two reserved
    // words.
    //

    // Is a CSR read request active this cycle?
    logic is_csr_read;
    assign is_csr_read = host_ccip.sRx.c0.mmioRdValid;

    // Is a CSR write request active this cycle?
    logic is_csr_write;
    assign is_csr_write = host_ccip.sRx.c0.mmioWrValid;

    // The MMIO request header is overlayed on the normal c0 memory read
    // response data structure.  Cast the c0Rx header to an MMIO request
    // header.
    t_ccip_c0_ReqMmioHdr mmio_req_hdr;
    assign mmio_req_hdr = t_ccip_c0_ReqMmioHdr'(host_ccip.sRx.c0.hdr);


    //
    // Implement the device feature list by responding to MMIO reads.
    //

    t_ccip_clAddr  req_base_address;
    t_ccip_clAddr  resp_base_address;
    logic[7:0] req_granularity;
    logic[7:0] resp_granularity;

    t_ccip_mmioData mmio_write_data;
    assign mmio_write_data = host_ccip.sRx.c0.data[CCIP_MMIODATA_WIDTH-1:0];
    logic read_meta_data, n_read_meta_data;
    logic[7:0] meta_data_offset;
    always_comb begin
      if(read_meta_data) begin
        n_read_meta_data = 0;
      end
      else if(is_csr_write && mmio_req_hdr.address == 6) begin
        n_read_meta_data = 1;
      end
      else begin
        n_read_meta_data = 0;
      end
    end
    always_ff @(posedge clk) begin
      if(!reset_n) begin
        req_base_address <=  'b0;
        resp_base_address <=  'b0;
        resp_granularity <=  'b0;
        read_meta_data <= 0;
        meta_data_offset <= 0;
      end
      else begin
        read_meta_data <= n_read_meta_data;
        if(is_csr_write)begin
          $fwrite(32'h80000002,"mmio addr:%x\n", mmio_req_hdr.address);
          case (mmio_req_hdr.address)
            0: 
              begin
                $fwrite(32'h80000002,"Writing to read granularity\n");
                req_base_address <=  mmio_write_data[CCIP_CLADDR_WIDTH-1:0];
              end

            2: begin
                $fwrite(32'h80000002,"Writing to write granularity\n");
              resp_base_address <=  mmio_write_data[CCIP_CLADDR_WIDTH-1:0];
              resp_granularity <=  mmio_write_data[CCIP_CLADDR_WIDTH+8-1: CCIP_CLADDR_WIDTH]; 
            end
            6: begin
              meta_data_offset <= mmio_write_data[7:0];
            end
          endcase
        end
      end
    end

    always_ff @(posedge clk)
    begin
        if (!reset_n)
        begin
            host_ccip.sTx.c2.mmioRdValid <= 1'b0;
        end
        else
        begin
            host_ccip.sTx.c2.mmioRdValid <= is_csr_read;

            host_ccip.sTx.c2.hdr.tid <= mmio_req_hdr.tid;


            case (mmio_req_hdr.address)
              0: // AFU DFH (device feature header)
                begin
                    host_ccip.sTx.c2.data <= t_ccip_mmioData'(0);
                    host_ccip.sTx.c2.data[63:60] <= 4'h1;
                    host_ccip.sTx.c2.data[40] <= 1'b1;
                end

              2: host_ccip.sTx.c2.data <= afu_id[63:0];

              4: host_ccip.sTx.c2.data <= afu_id[127:64];

              6: host_ccip.sTx.c2.data <= t_ccip_mmioData'(0);

              8: host_ccip.sTx.c2.data <= t_ccip_mmioData'(0);

              default: host_ccip.sTx.c2.data <= t_ccip_mmioData'(0);
            endcase
        end
    end
    // for req
    logic req_valid;
    logic req_ready;
    logic[2:0][1:0] operands_mode;
    logic[2:0][7:0] operands_value;
    logic[2:0] inst;
    logic[1:0] mode;
    logic[47:0] wr_addr;


    // flip the reset n
    assign req_valid = is_csr_write && (mmio_req_hdr.address == 4);
    assign mode = mmio_write_data[60:59];
    assign inst = mmio_write_data[58:56];
    assign operands_value[2] = mmio_write_data[55:40];
    assign operands_mode[2] = mmio_write_data[55:54];
    assign operands_value[1] = mmio_write_data[39:24];
    assign operands_mode[1] = mmio_write_data[39:38];
    assign operands_value[0] = mmio_write_data[23:8];
    assign operands_mode[0] = mmio_write_data[23:22];
    assign wr_addr = mmio_write_data[7:0];

    // for mem read
    logic mem_read_req_valid;
    t_ccip_clAddr mem_read_req_addr;
    t_ccip_mdata mem_read_req_tag;
    t_ccip_mdata mem_read_resp_tag;
    t_ccip_clData mem_read_req_data;
    logic mem_read_resp_valid;
    assign mem_read_resp_valid = host_ccip.sRx.c0.rspValid && (!host_ccip.sRx.c0.mmioRdValid);
    assign mem_read_resp_tag = host_ccip.sRx.c0.hdr.mdata[7:0];
    assign mem_read_req_data = host_ccip.sRx.c0.data;

    logic mem_write_req_valid;
    logic[7:0] mem_write_bits_wr_addr;
    logic mem_write_bits_result_isZero;
    logic mem_write_bits_result_isNaR;
    logic[31:0] mem_write_bits_result_out;
    logic mem_write_bits_result_lt; 
    logic mem_write_bits_result_eq; 
    logic mem_write_bits_result_gt;
    logic[4:0] mem_write_bits_result_exceptions;

    POSIT_Locality posit_fu(
    .clock(clk),
    .reset(!reset_n), 
    .io_request_ready(req_ready), 
    .io_request_valid(req_valid), 
    .io_request_bits_operands_0_value({24'b0,operands_value[0]}), 
    .io_request_bits_operands_0_mode(operands_mode[0]), 
    .io_request_bits_operands_1_value({24'b0,operands_value[1]}), 
    .io_request_bits_operands_1_mode(operands_mode[1]), 
    .io_request_bits_operands_2_value({24'b0,operands_value[2]}), 
    .io_request_bits_operands_2_mode(operands_mode[2]), 
    .io_request_bits_inst(inst), 
    .io_request_bits_mode(mode), 
    .io_request_bits_wr_addr(wr_addr), 
    .io_mem_write_ready(!host_ccip.sRx.c1TxAlmFull), 
    .io_mem_write_valid(mem_write_req_valid), 
    .io_mem_write_bits_result_isZero(mem_write_bits_result_isZero), 
    .io_mem_write_bits_result_isNaR(mem_write_bits_result_isNaR), 
    .io_mem_write_bits_result_out(mem_write_bits_result_out), 
    .io_mem_write_bits_result_lt(mem_write_bits_result_lt), 
    .io_mem_write_bits_result_eq(mem_write_bits_result_eq), 
    .io_mem_write_bits_result_gt(mem_write_bits_result_gt), 
    .io_mem_write_bits_result_exceptions(mem_write_bits_result_exceptions), 
    .io_mem_write_bits_wr_addr(mem_write_bits_wr_addr), 
    .io_mem_read_req_valid(mem_read_req_valid), 
    .io_mem_read_req_addr(mem_read_req_addr), 
    .io_mem_read_req_tag(mem_read_req_tag),
    .io_mem_read_data(mem_read_req_data), 
    .io_mem_read_resp_valid(mem_read_resp_valid), 
    .io_mem_read_resp_tag(mem_read_resp_tag));

    t_ccip_clAddr rd_mem_hdr_addr;
    assign rd_mem_hdr_addr = req_base_address + mem_read_req_addr;

    always_ff @( posedge clk ) begin
      if(!reset_n) begin
        host_ccip.sTx.c0.hdr <=  CCIP_C0TX_HDR_WIDTH'(0);
        host_ccip.sTx.c0.valid <=  0;        
      end
      else begin
        if ($isunknown(mem_read_req_tag)) $fwrite(32'h80000002, "mem_read_req_tag=%b has x's\n", mem_read_req_tag);
        if ($isunknown(req_base_address)) $fwrite(32'h80000002,  "req_base_address=%b has x's\n", req_base_address);
        if ($isunknown(mem_read_req_addr)) $fwrite(32'h80000002,  "mem_read_req_addr=%b has x's\n", mem_read_req_addr);
        if ($isunknown(rd_mem_hdr_addr)) $fwrite(32'h80000002,  "rd_mem_hdr_addr=%b has x's\n", rd_mem_hdr_addr);
        host_ccip.sTx.c0.hdr.mdata <=  mem_read_req_tag;
        host_ccip.sTx.c0.hdr.address <=  rd_mem_hdr_addr;
        host_ccip.sTx.c0.hdr.req_type <=  eREQ_RDLINE_S;
        host_ccip.sTx.c0.hdr.cl_len <=  eCL_LEN_1;
        host_ccip.sTx.c0.hdr.vc_sel <=  eVC_VA;
        host_ccip.sTx.c0.valid <= mem_read_req_valid;
      end
    end
  generate
    genvar i;
    for(i =0; i < 4; i ++) begin
      always_ff @(posedge clk) begin
        if(!reset_n) begin
          perf_cycle_cnt[i] <= 0;
        end
        else begin
          if(mem_read_req_valid && i == mem_read_req_addr) begin
            perf_cycle_cnt[i] <= 1;
          end 
          else if(mem_read_resp_valid && i == mem_read_resp_tag) begin
            perf_cycle_cnt[i] <= 0;
          end
          else if(perf_cycle_cnt[i] > 0) begin
            perf_cycle_cnt[i] <= perf_cycle_cnt[i] + 1;
          end 
        end
      end
    end
  endgenerate

  always_ff @( posedge clk ) begin
    if(!reset_n) begin
      perf_cycle_array[0] <= 0;
      perf_cycle_array[1] <= 0;
      perf_cycle_array[2] <= 0;
      perf_cycle_array[3] <= 0;
      perf_cycle_array[4] <= 0;
      perf_cycle_array[5] <= 0;
      perf_cycle_array[6] <= 0;
      perf_cycle_array[7] <= 0;
      perf_cycle_array[8] <= 0;
      perf_cycle_array[9] <= 0;
      perf_cycle_array[10] <= 0;
      perf_cycle_array[11] <= 0;
      total_mem_req <= 0;
    end
    else begin
      if(mem_read_resp_valid) begin
        if(perf_cycle_cnt[mem_read_resp_tag] < 10) begin
          perf_cycle_array[0] = perf_cycle_array[0] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 10 && perf_cycle_cnt[mem_read_resp_tag] < 50) begin
          perf_cycle_array[1] = perf_cycle_array[1] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 50 && perf_cycle_cnt[mem_read_resp_tag] < 100) begin
          perf_cycle_array[2] = perf_cycle_array[2] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 100 && perf_cycle_cnt[mem_read_resp_tag] < 200) begin
          perf_cycle_array[3] = perf_cycle_array[3] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 200 && perf_cycle_cnt[mem_read_resp_tag] < 300) begin
          perf_cycle_array[4] = perf_cycle_array[4] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 300 && perf_cycle_cnt[mem_read_resp_tag] < 400) begin
          perf_cycle_array[5] = perf_cycle_array[5] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 400 && perf_cycle_cnt[mem_read_resp_tag] < 500) begin
          perf_cycle_array[6] = perf_cycle_array[6] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 500 && perf_cycle_cnt[mem_read_resp_tag] < 600) begin
          perf_cycle_array[7] = perf_cycle_array[7] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 600 && perf_cycle_cnt[mem_read_resp_tag] < 700) begin
          perf_cycle_array[8] = perf_cycle_array[8] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 800 && perf_cycle_cnt[mem_read_resp_tag] < 900) begin
          perf_cycle_array[9] = perf_cycle_array[9] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 900 && perf_cycle_cnt[mem_read_resp_tag] < 1000) begin
          perf_cycle_array[10] = perf_cycle_array[10] + 1;
        end
        if(perf_cycle_cnt[mem_read_resp_tag] >= 1000) begin
          perf_cycle_array[11] = perf_cycle_array[11] + 1;
        end
      end
      if(mem_read_req_valid) begin
        total_mem_req <= total_mem_req + 1;
      end
    end
  end

    logic[41:0] wr_mem_hdr_addr;
    logic[11:0] wr_byte_offset;

    assign wr_byte_offset = mem_write_bits_wr_addr;
    assign wr_mem_hdr_addr = resp_base_address + wr_byte_offset;
    always_ff @( posedge clk ) begin
      if(!reset_n) begin
        host_ccip.sTx.c1.hdr <=  'b0;
        host_ccip.sTx.c1.valid <=  'b0;
        host_ccip.sTx.c1.data <=  t_ccip_clData'(0);
      end
      else if(!read_meta_data) begin
        host_ccip.sTx.c1.hdr.byte_len <=  0;
        host_ccip.sTx.c1.hdr.byte_start <=  0;
        host_ccip.sTx.c1.hdr.mode <=  eMOD_CL;
        host_ccip.sTx.c1.hdr.vc_sel <=  eVC_VA;
        host_ccip.sTx.c1.hdr.sop <=  'b1;
        host_ccip.sTx.c1.hdr.cl_len <=  eCL_LEN_1;
        host_ccip.sTx.c1.hdr.req_type <=  eREQ_WRPUSH_I;
        host_ccip.sTx.c1.hdr.address <=  wr_mem_hdr_addr;
        host_ccip.sTx.c1.hdr.mdata <= 'b0;
        host_ccip.sTx.c1.data <=  {3'b0, mem_write_bits_result_isZero, mem_write_bits_result_isNaR,
                        mem_write_bits_result_lt, mem_write_bits_result_eq, 
                        mem_write_bits_result_gt, mem_write_bits_result_out};
        host_ccip.sTx.c1.valid <=  mem_write_req_valid;

      end
      else begin
        $fwrite(32'h80000002,"@@@@ meta result being written:%x\n",resp_base_address+meta_data_offset);
        host_ccip.sTx.c1.hdr.byte_len <=  0;
        host_ccip.sTx.c1.hdr.byte_start <=  0;
        host_ccip.sTx.c1.hdr.mode <=  eMOD_CL;
        host_ccip.sTx.c1.hdr.vc_sel <=  eVC_VA;
        host_ccip.sTx.c1.hdr.sop <=  'b1;
        host_ccip.sTx.c1.hdr.cl_len <=  eCL_LEN_1;
        host_ccip.sTx.c1.hdr.req_type <=  eREQ_WRPUSH_I;
        host_ccip.sTx.c1.hdr.address <=  resp_base_address + meta_data_offset;
        host_ccip.sTx.c1.hdr.mdata <= 'b0;
        host_ccip.sTx.c1.data <=  {8'b1, perf_cycle_array[11],perf_cycle_array[10], perf_cycle_array[9], 
          perf_cycle_array[8], perf_cycle_array[7], 
          perf_cycle_array[6], perf_cycle_array[5], 
          perf_cycle_array[4], perf_cycle_array[3], 
          perf_cycle_array[2], perf_cycle_array[1], perf_cycle_array[0], total_mem_req};
        host_ccip.sTx.c1.valid <=  read_meta_data;
      end
        if(host_ccip.sTx.c1.valid) begin
          $fwrite(32'h80000002,"c1 write--- address:%x \n data:%x\n",host_ccip.sTx.c1.hdr.address, host_ccip.sTx.c1.data);
        end
    end


endmodule
