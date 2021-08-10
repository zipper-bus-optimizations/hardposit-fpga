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
        .ADD_CLOCK_CROSSING(1)
        ) primary_ccip
       (
        .to_fiu(plat_ifc.host_chan.ports[0]),
        .to_afu(host_ccip),

        .afu_clk(plat_ifc.clocks.pClk.clk),
        .afu_reset_n(plat_ifc.clocks.pClk.reset_n)
        );


    // Each interface names its associated clock and reset.
    logic clk;
    assign clk =plat_ifc.clocks.pClk.clk;
    logic reset_n;
    assign reset_n =plat_ifc.clocks.pClk.reset_n;


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

    assign host_ccip.sTx.c2.mmioRdValid = 1'b0;
    t_ccip_clAdd  req_base_address;
    t_ccip_clAdd  resp_base_address;
    logic[7:0] req_granularity;
    logic[7:0] resp_granularity;

    t_ccip_mmioData mmio_write_data;
    assign mmio_write_data = host_ccip.sRx.c0.data[CCIP_MMIODATA_WIDTH-1:0];
    always_ff @(posedge clk) begin
      if(is_csr_write)begin
        if(mmio_write_data[CCIP_MMIODATA_WIDTH-1] == 1'b1) begin // this is initialization message
          if(mmio_write_data[CCIP_MMIODATA_WIDTH-2] == 1'b0) begin // this is read 
            req_base_address <= #1 mmio_write_data[CCIP_CLADDR_WIDTH-1:0];
            req_granularity <= #1 mmio_write_data[ CCIP_CLADDR_WIDTH+8-1: CCIP_CLADDR_WIDTH];
          end
          else begin
            resp_base_address <= #1 mmio_write_data[CCIP_CLADDR_WIDTH-1:0];
            resp_granularity <= #1 mmio_write_data[ CCIP_CLADDR_WIDTH+8-1: CCIP_CLADDR_WIDTH];
          end
        end
      end
    end

    // for req
    logic reset;
    logic req_valid;
    logic req_ready;
    logic[2:0][1:0] operands_mode;
    logic[2:0][7:0] operands_value;
    logic[2:0] inst;
    logic[1:0] mode;
    logic[47:0] wr_addr;


    // flip the reset n
    assign reset = ~reset_n;
    assign req_valid = is_csr_write && (mmio_write_data[CCIP_MMIODATA_WIDTH-1] == 'b0);
    assign mode = mmio_write_data[42:41];
    assign inst = mmio_write_data[40:38];
    assign operands_mode[0] = mmio_write_data[37:36];
    assign operands_value[0] = mmio_write_data[35:28];
    assign operands_mode[1] = mmio_write_data[27:26];
    assign operands_value[1] = mmio_write_data[25:18];
    assign operands_mode[2] = mmio_write_data[17:16];
    assign operands_value[2] = mmio_write_data[16:8];
    assign wr_addr = resp_base_address + resp_granularity*mmio_write_data[7:0];

    // for mem read
    logic mem_read_req_valid;
    logic[7:0] mem_read_req_addr;
    logic[32:0] mem_read_req_data;
    logic mem_read_resp_valid;
    logic[7:0] mem_read_resp_tag;
    assign mem_read_resp_valid = host_ccip.sRx.c0.rspValid && (!host_ccip.sRx.c0.mmioRdValid);
    assign mem_read_resp_tag = host_ccip.sRx.c0.hdr.mdata[7:0];
    always_comb begin
      case (mem_read_resp_tag[3:0])
        4'd0: mem_read_req_data = host_ccip.sRx.c0.data[31:0];
        4'd1: mem_read_req_data = host_ccip.sRx.c0.data[63:32];
        4'd2: mem_read_req_data = host_ccip.sRx.c0.data[95:64];
        4'd3: mem_read_req_data = host_ccip.sRx.c0.data[127:96];
        4'd4: mem_read_req_data = host_ccip.sRx.c0.data[159:128];
        4'd5: mem_read_req_data = host_ccip.sRx.c0.data[191:160];
        4'd6: mem_read_req_data = host_ccip.sRx.c0.data[224:192];
        4'd7: mem_read_req_data = host_ccip.sRx.c0.data[255:224];
        4'd8: mem_read_req_data = host_ccip.sRx.c0.data[287:256];
        4'd9: mem_read_req_data = host_ccip.sRx.c0.data[319:288];
        4'd10: mem_read_req_data = host_ccip.sRx.c0.data[351:320];
        4'd11: mem_read_req_data = host_ccip.sRx.c0.data[383:352];
        4'd12: mem_read_req_data = host_ccip.sRx.c0.data[415:384];
        4'd13: mem_read_req_data = host_ccip.sRx.c0.data[447:416];
        4'd14: mem_read_req_data = host_ccip.sRx.c0.data[479:448];
        4'd15: mem_read_req_data = host_ccip.sRx.c0.data[511:480];
        default: mem_read_req_data = host_ccip.sRx.c0.data[31:0];
      endcase
    end

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
    .reset(reset), 
    .io_request_ready(req_ready), 
    .io_request_valid(req_valid), 
    .io_request_bits_operands_0_value(operands_value[0]), 
    .io_request_bits_operands_0_mode(operands_mode[0]), 
    .io_request_bits_operands_1_value(operands_value[1]), 
    .io_request_bits_operands_1_mode(operands_mode[1]), 
    .io_request_bits_operands_2_value(operands_value[2]), 
    .io_request_bits_operands_2_mode(operands_mode[2]), 
    .io_request_bits_inst(inst), 
    .io_request_bits_mode(mode), 
    .io_request_bits_wr_addr(wr_addr), 
    .io_mem_write_ready(!host_ccip.sRx.c1.c1TxAlmFull), 
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
    .io_mem_read_data(mem_read_req_data), 
    .io_mem_read_resp_valid(mem_read_resp_valid), 
    .io_mem_read_resp_tag(mem_read_resp_tag));

    logic[41:0] rd_mem_hdr_addr;
    assign rd_mem_hdr_addr = req_base_address + ((req_granularity*mem_read_req_addr)>>6);
    always_ff @( posedge clk ) begin
      host_ccip.sTx.c0.hdr.mdata <= #1 {8'b0, mem_read_req_addr};
      host_ccip.sTx.c0.hdr.address <= #1 mem_hdr_addr;
      host_ccip.sTx.c0.hdr.req_type <= # eREQ_RDLINE_S;
      host_ccip.sTx.c0.hdr.cl_len <= #1 2'b0;
      host_ccip.sTx.c0.hdr.vc_sel <= #1 2'b0;
      host_ccip.sTx.c0.valid <= #1 rd_mem_read_req_valid;
    end

    logic[41:0] wr_mem_hdr_addr;
    logic[11:0] wr_byte_offset;
    assign wr_byte_offset = resp_granularity*mem_write_bits_wr_addr;
    assign wr_mem_hdr_addr = resp_base_address + (wr_byte_offset>>6);
    always_ff @( posedge clk ) begin
      host_ccip.sTx.c1.hdr.byte_len <= #1 wr_byte_offset[5:0];
      host_ccip.sTx.c1.hdr.vc_sel <= #1 2'b0;
      host_ccip.sTx.c1.hdr.sop <= #1 'b1;
      host_ccip.sTx.c1.hdr.mode <= #1 eMOD_BYTE;
      host_ccip.sTx.c1.hdr.cl_len <= #1 2'b0;
      host_ccip.sTx.c1.hdr.req_type <= #1 eREQ_RDLINE_S;
      host_ccip.sTx.c1.hdr.address <= #1 eREQ_WRLINE_I ;
      host_ccip.sTx.c1.hdr.mdata <= #1'b0;
      host_ccip.sTx.c1.data <= #1 { mem_write_bits_result_out,
                      3'b0, mem_write_bits_result_isZero, mem_write_bits_result_isNaR,
                      mem_write_bits_result_lt, mem_write_bits_result_eq, 
                      mem_write_bits_result_gt, 4'b0,mem_write_bits_result_exceptions};
      host_ccip.sTx.c1.valid <= #1 mem_write_req_valid;
    end


endmodule
