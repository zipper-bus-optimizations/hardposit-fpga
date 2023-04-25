module PositAddCore(
  input         clock,
  input         io_num1_sign,
  input  [8:0]  io_num1_exponent,
  input  [27:0] io_num1_fraction,
  input         io_num1_isZero,
  input         io_num1_isNaR,
  input         io_num2_sign,
  input  [8:0]  io_num2_exponent,
  input  [27:0] io_num2_fraction,
  input         io_num2_isZero,
  input         io_num2_isNaR,
  input         io_sub,
  input         io_input_valid,
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [8:0]  io_out_exponent,
  output [27:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR,
  output        io_output_valid
);
  wire  _T = $signed(io_num1_exponent) > $signed(io_num2_exponent); // @[PositAdd.scala 25:20]
  wire  _T_1 = $signed(io_num1_exponent) == $signed(io_num2_exponent); // @[PositAdd.scala 26:21]
  wire  _T_2 = io_num1_fraction > io_num2_fraction; // @[PositAdd.scala 27:22]
  wire  _T_3 = _T_1 & _T_2; // @[PositAdd.scala 26:39]
  wire  num1magGt = _T | _T_3; // @[PositAdd.scala 25:37]
  wire  num2AdjSign = io_num2_sign ^ io_sub; // @[PositAdd.scala 28:31]
  wire  largeSign = num1magGt ? io_num1_sign : num2AdjSign; // @[PositAdd.scala 30:22]
  wire [8:0] largeExp = num1magGt ? $signed(io_num1_exponent) : $signed(io_num2_exponent); // @[PositAdd.scala 31:22]
  wire [27:0] _T_4 = num1magGt ? io_num1_fraction : io_num2_fraction; // @[PositAdd.scala 33:12]
  wire  smallSign = num1magGt ? num2AdjSign : io_num1_sign; // @[PositAdd.scala 35:22]
  wire [8:0] smallExp = num1magGt ? $signed(io_num2_exponent) : $signed(io_num1_exponent); // @[PositAdd.scala 36:22]
  wire [27:0] _T_5 = num1magGt ? io_num2_fraction : io_num1_fraction; // @[PositAdd.scala 38:12]
  wire [30:0] smallFrac = {_T_5,3'h0}; // @[Cat.scala 30:58]
  wire [8:0] expDiff = $signed(largeExp) - $signed(smallExp); // @[PositAdd.scala 40:45]
  wire  _T_9 = expDiff < 9'h1f; // @[PositAdd.scala 42:17]
  wire [30:0] _T_10 = smallFrac >> expDiff; // @[PositAdd.scala 42:59]
  wire  _T_19 = largeSign ^ smallSign; // @[PositAdd.scala 48:32]
  reg  isAddition_n; // @[PositAdd.scala 50:29]
  reg [31:0] _RAND_0;
  reg [30:0] shiftedSmallFrac_n; // @[PositAdd.scala 51:35]
  reg [31:0] _RAND_1;
  reg [30:0] largeFrac_n; // @[PositAdd.scala 52:28]
  reg [31:0] _RAND_2;
  reg [8:0] largeExp_n; // @[PositAdd.scala 53:27]
  reg [31:0] _RAND_3;
  reg  valid_n; // @[PositAdd.scala 54:24]
  reg [31:0] _RAND_4;
  wire [30:0] _T_20 = ~shiftedSmallFrac_n; // @[PositAdd.scala 57:43]
  wire [30:0] _T_22 = _T_20 + 31'h1; // @[PositAdd.scala 57:63]
  wire [30:0] signedSmallerFrac = isAddition_n ? shiftedSmallFrac_n : _T_22; // @[PositAdd.scala 57:8]
  wire [31:0] adderFrac = largeFrac_n + signedSmallerFrac; // @[PositAdd.scala 59:56]
  wire  sumOverflow = isAddition_n & adderFrac[31]; // @[PositAdd.scala 61:34]
  wire  _T_25 = isAddition_n & adderFrac[31]; // @[PositAdd.scala 63:52]
  wire [8:0] _GEN_1 = {9{_T_25}}; // @[PositAdd.scala 63:32]
  wire [8:0] adjAdderExp = $signed(largeExp_n) - $signed(_GEN_1); // @[PositAdd.scala 63:32]
  wire [30:0] adjAdderFrac = sumOverflow ? adderFrac[31:1] : adderFrac[30:0]; // @[PositAdd.scala 65:8]
  wire  sumStickyBit = sumOverflow & adderFrac[0]; // @[PositAdd.scala 66:34]
  wire [4:0] _T_62 = adjAdderFrac[1] ? 5'h1d : 5'h1e; // @[Mux.scala 47:69]
  wire [4:0] _T_63 = adjAdderFrac[2] ? 5'h1c : _T_62; // @[Mux.scala 47:69]
  wire [4:0] _T_64 = adjAdderFrac[3] ? 5'h1b : _T_63; // @[Mux.scala 47:69]
  wire [4:0] _T_65 = adjAdderFrac[4] ? 5'h1a : _T_64; // @[Mux.scala 47:69]
  wire [4:0] _T_66 = adjAdderFrac[5] ? 5'h19 : _T_65; // @[Mux.scala 47:69]
  wire [4:0] _T_67 = adjAdderFrac[6] ? 5'h18 : _T_66; // @[Mux.scala 47:69]
  wire [4:0] _T_68 = adjAdderFrac[7] ? 5'h17 : _T_67; // @[Mux.scala 47:69]
  wire [4:0] _T_69 = adjAdderFrac[8] ? 5'h16 : _T_68; // @[Mux.scala 47:69]
  wire [4:0] _T_70 = adjAdderFrac[9] ? 5'h15 : _T_69; // @[Mux.scala 47:69]
  wire [4:0] _T_71 = adjAdderFrac[10] ? 5'h14 : _T_70; // @[Mux.scala 47:69]
  wire [4:0] _T_72 = adjAdderFrac[11] ? 5'h13 : _T_71; // @[Mux.scala 47:69]
  wire [4:0] _T_73 = adjAdderFrac[12] ? 5'h12 : _T_72; // @[Mux.scala 47:69]
  wire [4:0] _T_74 = adjAdderFrac[13] ? 5'h11 : _T_73; // @[Mux.scala 47:69]
  wire [4:0] _T_75 = adjAdderFrac[14] ? 5'h10 : _T_74; // @[Mux.scala 47:69]
  wire [4:0] _T_76 = adjAdderFrac[15] ? 5'hf : _T_75; // @[Mux.scala 47:69]
  wire [4:0] _T_77 = adjAdderFrac[16] ? 5'he : _T_76; // @[Mux.scala 47:69]
  wire [4:0] _T_78 = adjAdderFrac[17] ? 5'hd : _T_77; // @[Mux.scala 47:69]
  wire [4:0] _T_79 = adjAdderFrac[18] ? 5'hc : _T_78; // @[Mux.scala 47:69]
  wire [4:0] _T_80 = adjAdderFrac[19] ? 5'hb : _T_79; // @[Mux.scala 47:69]
  wire [4:0] _T_81 = adjAdderFrac[20] ? 5'ha : _T_80; // @[Mux.scala 47:69]
  wire [4:0] _T_82 = adjAdderFrac[21] ? 5'h9 : _T_81; // @[Mux.scala 47:69]
  wire [4:0] _T_83 = adjAdderFrac[22] ? 5'h8 : _T_82; // @[Mux.scala 47:69]
  wire [4:0] _T_84 = adjAdderFrac[23] ? 5'h7 : _T_83; // @[Mux.scala 47:69]
  wire [4:0] _T_85 = adjAdderFrac[24] ? 5'h6 : _T_84; // @[Mux.scala 47:69]
  wire [4:0] _T_86 = adjAdderFrac[25] ? 5'h5 : _T_85; // @[Mux.scala 47:69]
  wire [4:0] _T_87 = adjAdderFrac[26] ? 5'h4 : _T_86; // @[Mux.scala 47:69]
  wire [4:0] _T_88 = adjAdderFrac[27] ? 5'h3 : _T_87; // @[Mux.scala 47:69]
  wire [4:0] _T_89 = adjAdderFrac[28] ? 5'h2 : _T_88; // @[Mux.scala 47:69]
  wire [4:0] _T_90 = adjAdderFrac[29] ? 5'h1 : _T_89; // @[Mux.scala 47:69]
  wire [4:0] normalizationFactor = adjAdderFrac[30] ? 5'h0 : _T_90; // @[Mux.scala 47:69]
  wire [4:0] _T_91 = adjAdderFrac[30] ? 5'h0 : _T_90; // @[PositAdd.scala 70:62]
  wire [8:0] _GEN_2 = {{4{_T_91[4]}},_T_91}; // @[PositAdd.scala 70:34]
  wire [61:0] _GEN_3 = {{31'd0}, adjAdderFrac}; // @[PositAdd.scala 71:35]
  wire [61:0] normFraction = _GEN_3 << normalizationFactor; // @[PositAdd.scala 71:35]
  wire  _T_95 = io_num1_isZero & io_num2_isZero; // @[PositAdd.scala 74:35]
  wire  _T_96 = adderFrac == 32'h0; // @[PositAdd.scala 74:64]
  assign io_trailingBits = normFraction[2:1]; // @[PositAdd.scala 79:19]
  assign io_stickyBit = sumStickyBit | normFraction[0]; // @[PositAdd.scala 80:19]
  assign io_out_sign = num1magGt ? io_num1_sign : num2AdjSign; // @[PositAdd.scala 82:10]
  assign io_out_exponent = $signed(adjAdderExp) - $signed(_GEN_2); // @[PositAdd.scala 82:10]
  assign io_out_fraction = normFraction[30:3]; // @[PositAdd.scala 82:10]
  assign io_out_isZero = _T_95 | _T_96; // @[PositAdd.scala 82:10]
  assign io_out_isNaR = io_num1_isNaR | io_num2_isNaR; // @[PositAdd.scala 82:10]
  assign io_output_valid = valid_n; // @[PositAdd.scala 83:19]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  isAddition_n = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  shiftedSmallFrac_n = _RAND_1[30:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  largeFrac_n = _RAND_2[30:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  largeExp_n = _RAND_3[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  valid_n = _RAND_4[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    isAddition_n <= ~_T_19;
    if (_T_9) begin
      shiftedSmallFrac_n <= _T_10;
    end else begin
      shiftedSmallFrac_n <= 31'h0;
    end
    largeFrac_n <= {_T_4,3'h0};
    if (num1magGt) begin
      largeExp_n <= io_num1_exponent;
    end else begin
      largeExp_n <= io_num2_exponent;
    end
    valid_n <= io_input_valid;
  end
endmodule
module PositCompare(
  input  [31:0] io_num1,
  input  [31:0] io_num2,
  output        io_lt,
  output        io_eq,
  output        io_gt,
  input         io_validIn,
  output        io_validOut
);
  wire  _T_2 = ~io_lt; // @[PositCompare.scala 18:13]
  wire  _T_3 = ~io_eq; // @[PositCompare.scala 18:23]
  assign io_lt = $signed(io_num1) < $signed(io_num2); // @[PositCompare.scala 16:9]
  assign io_eq = $signed(io_num1) == $signed(io_num2); // @[PositCompare.scala 17:9]
  assign io_gt = _T_2 & _T_3; // @[PositCompare.scala 18:9]
  assign io_validOut = io_validIn; // @[PositCompare.scala 15:15]
endmodule
module PositFMACore(
  input         clock,
  input         io_num1_sign,
  input  [8:0]  io_num1_exponent,
  input  [27:0] io_num1_fraction,
  input         io_num1_isZero,
  input         io_num1_isNaR,
  input         io_num2_sign,
  input  [8:0]  io_num2_exponent,
  input  [27:0] io_num2_fraction,
  input         io_num2_isZero,
  input         io_num2_isNaR,
  input         io_num3_sign,
  input  [8:0]  io_num3_exponent,
  input  [27:0] io_num3_fraction,
  input         io_num3_isZero,
  input         io_num3_isNaR,
  input         io_sub,
  input         io_negate,
  input         io_input_valid,
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [8:0]  io_out_exponent,
  output [27:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR,
  output        io_output_valid
);
  wire [9:0] productExponent = $signed(io_num1_exponent) + $signed(io_num2_exponent); // @[PositFMA.scala 25:39]
  wire [55:0] productFraction = io_num1_fraction * io_num2_fraction; // @[PositFMA.scala 27:63]
  wire  prodOverflow = productFraction[55]; // @[PositFMA.scala 29:44]
  wire [54:0] normProductFraction = prodOverflow ? productFraction[55:1] : productFraction[54:0]; // @[PositFMA.scala 31:8]
  wire [1:0] _T_4 = {1'h0,prodOverflow}; // @[PositFMA.scala 32:76]
  wire [9:0] _GEN_0 = {{8{_T_4[1]}},_T_4}; // @[PositFMA.scala 32:45]
  wire [9:0] normProductExponent = $signed(productExponent) + $signed(_GEN_0); // @[PositFMA.scala 32:45]
  wire  prodStickyBit = prodOverflow & productFraction[0]; // @[PositFMA.scala 33:42]
  wire [54:0] _T_8 = {io_num3_fraction,27'h0}; // @[Cat.scala 30:58]
  wire [54:0] addendFraction = io_num3_isZero ? 55'h0 : _T_8; // @[PositFMA.scala 36:27]
  wire  _T_9 = io_num1_sign ^ io_num2_sign; // @[PositFMA.scala 39:39]
  reg  productSign; // @[PositFMA.scala 39:28]
  reg [31:0] _RAND_0;
  wire  _T_11 = io_num3_sign ^ io_negate; // @[PositFMA.scala 40:39]
  reg  addendSign; // @[PositFMA.scala 40:28]
  reg [31:0] _RAND_1;
  reg [8:0] addendExponent_n; // @[PositFMA.scala 41:33]
  reg [31:0] _RAND_2;
  reg [9:0] normProductExponent_n; // @[PositFMA.scala 42:38]
  reg [31:0] _RAND_3;
  reg [54:0] addendFraction_n; // @[PositFMA.scala 43:33]
  reg [63:0] _RAND_4;
  reg [54:0] normProductFraction_n; // @[PositFMA.scala 44:38]
  reg [63:0] _RAND_5;
  wire  _T_13 = ~io_num3_isZero; // @[PositFMA.scala 46:13]
  wire [9:0] _GEN_1 = {{1{io_num3_exponent[8]}},io_num3_exponent}; // @[PositFMA.scala 47:24]
  wire  _T_14 = $signed(_GEN_1) > $signed(normProductExponent); // @[PositFMA.scala 47:24]
  wire  _T_15 = $signed(_GEN_1) == $signed(normProductExponent); // @[PositFMA.scala 48:25]
  wire  _T_16 = addendFraction > normProductFraction; // @[PositFMA.scala 48:68]
  wire  _T_17 = _T_15 & _T_16; // @[PositFMA.scala 48:49]
  wire  _T_18 = _T_14 | _T_17; // @[PositFMA.scala 47:47]
  reg  isAddendGtProduct; // @[PositFMA.scala 46:12]
  reg [31:0] _RAND_6;
  wire [9:0] gExp = isAddendGtProduct ? $signed({{1{addendExponent_n[8]}},addendExponent_n}) : $signed(normProductExponent_n); // @[PositFMA.scala 50:18]
  wire [54:0] gFrac = isAddendGtProduct ? addendFraction_n : normProductFraction_n; // @[PositFMA.scala 51:18]
  wire  gSign = isAddendGtProduct ? addendSign : productSign; // @[PositFMA.scala 52:18]
  wire [9:0] lExp = isAddendGtProduct ? $signed(normProductExponent_n) : $signed({{1{addendExponent_n[8]}},addendExponent_n}); // @[PositFMA.scala 54:18]
  wire [54:0] lFrac = isAddendGtProduct ? normProductFraction_n : addendFraction_n; // @[PositFMA.scala 55:18]
  wire  lSign = isAddendGtProduct ? productSign : addendSign; // @[PositFMA.scala 56:18]
  wire [9:0] expDiff = $signed(gExp) - $signed(lExp); // @[PositFMA.scala 58:37]
  wire  shftInBound = expDiff < 10'h37; // @[PositFMA.scala 59:29]
  wire [54:0] _T_23 = lFrac >> expDiff; // @[PositFMA.scala 61:28]
  wire [55:0] shiftedLFrac = shftInBound ? {{1'd0}, _T_23} : 56'h0; // @[PositFMA.scala 61:8]
  wire [1023:0] _T_24 = 1024'h1 << expDiff; // @[OneHot.scala 58:35]
  wire [1023:0] _T_26 = _T_24 - 1024'h1; // @[common.scala 23:44]
  wire [55:0] lfracStickyMask = _T_26[55:0]; // @[PositFMA.scala 63:26]
  wire [55:0] _GEN_3 = {{1'd0}, lFrac}; // @[PositFMA.scala 64:31]
  wire [55:0] _T_27 = _GEN_3 & lfracStickyMask; // @[PositFMA.scala 64:31]
  wire  lFracStickyBit = _T_27 != 56'h0; // @[PositFMA.scala 64:53]
  wire  _T_28 = gSign ^ lSign; // @[PositFMA.scala 66:28]
  wire  isAddition = ~_T_28; // @[PositFMA.scala 66:20]
  wire [55:0] _T_29 = ~shiftedLFrac; // @[PositFMA.scala 68:35]
  wire [55:0] _T_31 = _T_29 + 56'h1; // @[PositFMA.scala 68:49]
  wire [55:0] signedLFrac = isAddition ? shiftedLFrac : _T_31; // @[PositFMA.scala 68:8]
  wire [55:0] _GEN_4 = {{1'd0}, gFrac}; // @[PositFMA.scala 70:55]
  wire [56:0] _T_32 = _GEN_4 + signedLFrac; // @[PositFMA.scala 70:55]
  wire [55:0] fmaFraction = _T_32[55:0];
  wire  fmaOverflow = isAddition & fmaFraction[55]; // @[PositFMA.scala 72:32]
  wire [55:0] _T_35 = {fmaFraction[54:0],1'h0}; // @[Cat.scala 30:58]
  wire [55:0] adjFmaFraction = fmaOverflow ? fmaFraction : _T_35; // @[PositFMA.scala 74:8]
  wire [1:0] _T_37 = {1'h0,fmaOverflow}; // @[PositFMA.scala 75:59]
  wire [9:0] _GEN_5 = {{8{_T_37[1]}},_T_37}; // @[PositFMA.scala 75:29]
  wire [9:0] adjFmaExponent = $signed(gExp) + $signed(_GEN_5); // @[PositFMA.scala 75:29]
  wire [5:0] _T_96 = adjFmaFraction[1] ? 6'h36 : 6'h37; // @[Mux.scala 47:69]
  wire [5:0] _T_97 = adjFmaFraction[2] ? 6'h35 : _T_96; // @[Mux.scala 47:69]
  wire [5:0] _T_98 = adjFmaFraction[3] ? 6'h34 : _T_97; // @[Mux.scala 47:69]
  wire [5:0] _T_99 = adjFmaFraction[4] ? 6'h33 : _T_98; // @[Mux.scala 47:69]
  wire [5:0] _T_100 = adjFmaFraction[5] ? 6'h32 : _T_99; // @[Mux.scala 47:69]
  wire [5:0] _T_101 = adjFmaFraction[6] ? 6'h31 : _T_100; // @[Mux.scala 47:69]
  wire [5:0] _T_102 = adjFmaFraction[7] ? 6'h30 : _T_101; // @[Mux.scala 47:69]
  wire [5:0] _T_103 = adjFmaFraction[8] ? 6'h2f : _T_102; // @[Mux.scala 47:69]
  wire [5:0] _T_104 = adjFmaFraction[9] ? 6'h2e : _T_103; // @[Mux.scala 47:69]
  wire [5:0] _T_105 = adjFmaFraction[10] ? 6'h2d : _T_104; // @[Mux.scala 47:69]
  wire [5:0] _T_106 = adjFmaFraction[11] ? 6'h2c : _T_105; // @[Mux.scala 47:69]
  wire [5:0] _T_107 = adjFmaFraction[12] ? 6'h2b : _T_106; // @[Mux.scala 47:69]
  wire [5:0] _T_108 = adjFmaFraction[13] ? 6'h2a : _T_107; // @[Mux.scala 47:69]
  wire [5:0] _T_109 = adjFmaFraction[14] ? 6'h29 : _T_108; // @[Mux.scala 47:69]
  wire [5:0] _T_110 = adjFmaFraction[15] ? 6'h28 : _T_109; // @[Mux.scala 47:69]
  wire [5:0] _T_111 = adjFmaFraction[16] ? 6'h27 : _T_110; // @[Mux.scala 47:69]
  wire [5:0] _T_112 = adjFmaFraction[17] ? 6'h26 : _T_111; // @[Mux.scala 47:69]
  wire [5:0] _T_113 = adjFmaFraction[18] ? 6'h25 : _T_112; // @[Mux.scala 47:69]
  wire [5:0] _T_114 = adjFmaFraction[19] ? 6'h24 : _T_113; // @[Mux.scala 47:69]
  wire [5:0] _T_115 = adjFmaFraction[20] ? 6'h23 : _T_114; // @[Mux.scala 47:69]
  wire [5:0] _T_116 = adjFmaFraction[21] ? 6'h22 : _T_115; // @[Mux.scala 47:69]
  wire [5:0] _T_117 = adjFmaFraction[22] ? 6'h21 : _T_116; // @[Mux.scala 47:69]
  wire [5:0] _T_118 = adjFmaFraction[23] ? 6'h20 : _T_117; // @[Mux.scala 47:69]
  wire [5:0] _T_119 = adjFmaFraction[24] ? 6'h1f : _T_118; // @[Mux.scala 47:69]
  wire [5:0] _T_120 = adjFmaFraction[25] ? 6'h1e : _T_119; // @[Mux.scala 47:69]
  wire [5:0] _T_121 = adjFmaFraction[26] ? 6'h1d : _T_120; // @[Mux.scala 47:69]
  wire [5:0] _T_122 = adjFmaFraction[27] ? 6'h1c : _T_121; // @[Mux.scala 47:69]
  wire [5:0] _T_123 = adjFmaFraction[28] ? 6'h1b : _T_122; // @[Mux.scala 47:69]
  wire [5:0] _T_124 = adjFmaFraction[29] ? 6'h1a : _T_123; // @[Mux.scala 47:69]
  wire [5:0] _T_125 = adjFmaFraction[30] ? 6'h19 : _T_124; // @[Mux.scala 47:69]
  wire [5:0] _T_126 = adjFmaFraction[31] ? 6'h18 : _T_125; // @[Mux.scala 47:69]
  wire [5:0] _T_127 = adjFmaFraction[32] ? 6'h17 : _T_126; // @[Mux.scala 47:69]
  wire [5:0] _T_128 = adjFmaFraction[33] ? 6'h16 : _T_127; // @[Mux.scala 47:69]
  wire [5:0] _T_129 = adjFmaFraction[34] ? 6'h15 : _T_128; // @[Mux.scala 47:69]
  wire [5:0] _T_130 = adjFmaFraction[35] ? 6'h14 : _T_129; // @[Mux.scala 47:69]
  wire [5:0] _T_131 = adjFmaFraction[36] ? 6'h13 : _T_130; // @[Mux.scala 47:69]
  wire [5:0] _T_132 = adjFmaFraction[37] ? 6'h12 : _T_131; // @[Mux.scala 47:69]
  wire [5:0] _T_133 = adjFmaFraction[38] ? 6'h11 : _T_132; // @[Mux.scala 47:69]
  wire [5:0] _T_134 = adjFmaFraction[39] ? 6'h10 : _T_133; // @[Mux.scala 47:69]
  wire [5:0] _T_135 = adjFmaFraction[40] ? 6'hf : _T_134; // @[Mux.scala 47:69]
  wire [5:0] _T_136 = adjFmaFraction[41] ? 6'he : _T_135; // @[Mux.scala 47:69]
  wire [5:0] _T_137 = adjFmaFraction[42] ? 6'hd : _T_136; // @[Mux.scala 47:69]
  wire [5:0] _T_138 = adjFmaFraction[43] ? 6'hc : _T_137; // @[Mux.scala 47:69]
  wire [5:0] _T_139 = adjFmaFraction[44] ? 6'hb : _T_138; // @[Mux.scala 47:69]
  wire [5:0] _T_140 = adjFmaFraction[45] ? 6'ha : _T_139; // @[Mux.scala 47:69]
  wire [5:0] _T_141 = adjFmaFraction[46] ? 6'h9 : _T_140; // @[Mux.scala 47:69]
  wire [5:0] _T_142 = adjFmaFraction[47] ? 6'h8 : _T_141; // @[Mux.scala 47:69]
  wire [5:0] _T_143 = adjFmaFraction[48] ? 6'h7 : _T_142; // @[Mux.scala 47:69]
  wire [5:0] _T_144 = adjFmaFraction[49] ? 6'h6 : _T_143; // @[Mux.scala 47:69]
  wire [5:0] _T_145 = adjFmaFraction[50] ? 6'h5 : _T_144; // @[Mux.scala 47:69]
  wire [5:0] _T_146 = adjFmaFraction[51] ? 6'h4 : _T_145; // @[Mux.scala 47:69]
  wire [5:0] _T_147 = adjFmaFraction[52] ? 6'h3 : _T_146; // @[Mux.scala 47:69]
  wire [5:0] _T_148 = adjFmaFraction[53] ? 6'h2 : _T_147; // @[Mux.scala 47:69]
  wire [5:0] _T_149 = adjFmaFraction[54] ? 6'h1 : _T_148; // @[Mux.scala 47:69]
  wire [5:0] normalizationFactor = adjFmaFraction[55] ? 6'h0 : _T_149; // @[Mux.scala 47:69]
  wire [5:0] _T_150 = adjFmaFraction[55] ? 6'h0 : _T_149; // @[PositFMA.scala 78:69]
  wire [9:0] _GEN_6 = {{4{_T_150[5]}},_T_150}; // @[PositFMA.scala 78:40]
  wire [10:0] normFmaExponent = $signed(adjFmaExponent) - $signed(_GEN_6); // @[PositFMA.scala 78:40]
  wire [118:0] _GEN_7 = {{63'd0}, adjFmaFraction}; // @[PositFMA.scala 79:41]
  wire [118:0] _T_151 = _GEN_7 << normalizationFactor; // @[PositFMA.scala 79:41]
  wire [55:0] normFmaFraction = _T_151[55:0]; // @[PositFMA.scala 79:64]
  wire  _T_152 = io_num1_isNaR | io_num2_isNaR; // @[PositFMA.scala 83:41]
  reg  result_isNaR; // @[PositFMA.scala 83:29]
  reg [31:0] _RAND_7;
  wire  _T_154 = io_num1_isZero | io_num2_isZero; // @[PositFMA.scala 84:56]
  reg  result_isZero_second_half; // @[PositFMA.scala 84:42]
  reg [31:0] _RAND_8;
  reg  intermediate_valid; // @[PositFMA.scala 85:35]
  reg [31:0] _RAND_9;
  wire  _T_156 = ~result_isNaR; // @[PositFMA.scala 87:22]
  wire  _T_160 = prodStickyBit | lFracStickyBit; // @[PositFMA.scala 93:36]
  wire  _T_162 = normFmaFraction[25:0] != 26'h0; // @[PositFMA.scala 93:130]
  assign io_trailingBits = normFmaFraction[27:26]; // @[PositFMA.scala 92:19]
  assign io_stickyBit = _T_160 | _T_162; // @[PositFMA.scala 93:19]
  assign io_out_sign = isAddendGtProduct ? addendSign : productSign; // @[PositFMA.scala 95:10]
  assign io_out_exponent = normFmaExponent[8:0]; // @[PositFMA.scala 95:10]
  assign io_out_fraction = normFmaFraction[55:28]; // @[PositFMA.scala 95:10]
  assign io_out_isZero = _T_156 & result_isZero_second_half; // @[PositFMA.scala 95:10]
  assign io_out_isNaR = result_isNaR; // @[PositFMA.scala 95:10]
  assign io_output_valid = intermediate_valid; // @[PositFMA.scala 96:19]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  productSign = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  addendSign = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  addendExponent_n = _RAND_2[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  normProductExponent_n = _RAND_3[9:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {2{`RANDOM}};
  addendFraction_n = _RAND_4[54:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {2{`RANDOM}};
  normProductFraction_n = _RAND_5[54:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  isAddendGtProduct = _RAND_6[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  result_isNaR = _RAND_7[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  result_isZero_second_half = _RAND_8[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  intermediate_valid = _RAND_9[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    productSign <= _T_9 ^ io_negate;
    addendSign <= _T_11 ^ io_sub;
    addendExponent_n <= io_num3_exponent;
    normProductExponent_n <= $signed(productExponent) + $signed(_GEN_0);
    if (io_num3_isZero) begin
      addendFraction_n <= 55'h0;
    end else begin
      addendFraction_n <= _T_8;
    end
    if (prodOverflow) begin
      normProductFraction_n <= productFraction[55:1];
    end else begin
      normProductFraction_n <= productFraction[54:0];
    end
    isAddendGtProduct <= _T_13 & _T_18;
    result_isNaR <= _T_152 | io_num3_isNaR;
    result_isZero_second_half <= _T_154 & io_num3_isZero;
    intermediate_valid <= io_input_valid;
  end
endmodule
module PositDivSqrtCore(
  input         clock,
  input         reset,
  input         io_validIn,
  input         io_sqrtOp,
  input         io_num1_sign,
  input  [8:0]  io_num1_exponent,
  input  [27:0] io_num1_fraction,
  input         io_num1_isZero,
  input         io_num1_isNaR,
  input         io_num2_sign,
  input  [8:0]  io_num2_exponent,
  input  [27:0] io_num2_fraction,
  input         io_num2_isZero,
  input         io_num2_isNaR,
  output        io_validOut_div,
  output        io_validOut_sqrt,
  output [4:0]  io_exceptions,
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [8:0]  io_out_exponent,
  output [27:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR
);
  reg [5:0] cycleCount; // @[PositDivSqrt.scala 27:27]
  reg [31:0] _RAND_0;
  reg  sqrtOp_stored; // @[PositDivSqrt.scala 29:26]
  reg [31:0] _RAND_1;
  reg  isNaR_out; // @[PositDivSqrt.scala 30:26]
  reg [31:0] _RAND_2;
  reg  isZero_out; // @[PositDivSqrt.scala 31:26]
  reg [31:0] _RAND_3;
  reg [4:0] exec_out; // @[PositDivSqrt.scala 32:30]
  reg [31:0] _RAND_4;
  reg  sign_out; // @[PositDivSqrt.scala 33:26]
  reg [31:0] _RAND_5;
  reg [8:0] divSqrtExp; // @[PositDivSqrt.scala 34:30]
  reg [31:0] _RAND_6;
  reg [31:0] divSqrtFrac; // @[PositDivSqrt.scala 35:30]
  reg [31:0] _RAND_7;
  reg [28:0] remLo; // @[PositDivSqrt.scala 40:24]
  reg [31:0] _RAND_8;
  reg [31:0] remHi; // @[PositDivSqrt.scala 41:24]
  reg [31:0] _RAND_9;
  reg [31:0] divisor; // @[PositDivSqrt.scala 42:24]
  reg [31:0] _RAND_10;
  wire  _T_2 = ~io_sqrtOp; // @[PositDivSqrt.scala 44:21]
  wire  divZ = _T_2 & io_num2_isZero; // @[PositDivSqrt.scala 44:32]
  wire  _T_3 = io_num1_sign | io_num1_isNaR; // @[PositDivSqrt.scala 45:46]
  wire  _T_4 = io_num1_isNaR | io_num2_isNaR; // @[PositDivSqrt.scala 45:71]
  wire  _T_5 = _T_4 | divZ; // @[PositDivSqrt.scala 45:84]
  wire  isNaR = io_sqrtOp ? _T_3 : _T_5; // @[PositDivSqrt.scala 45:24]
  wire  specialCase = isNaR | io_num1_isZero; // @[PositDivSqrt.scala 47:27]
  wire [8:0] expDiff = $signed(io_num1_exponent) - $signed(io_num2_exponent); // @[PositDivSqrt.scala 48:35]
  wire  idle = cycleCount == 6'h0; // @[PositDivSqrt.scala 50:28]
  wire  readyIn = cycleCount <= 6'h1; // @[PositDivSqrt.scala 51:28]
  wire  starting = readyIn & io_validIn; // @[PositDivSqrt.scala 53:34]
  wire  _T_8 = ~specialCase; // @[PositDivSqrt.scala 54:38]
  wire  started_normally = starting & _T_8; // @[PositDivSqrt.scala 54:35]
  wire  _T_11 = io_sqrtOp & io_num1_exponent[0]; // @[PositDivSqrt.scala 56:32]
  wire [28:0] _T_12 = {io_num1_fraction, 1'h0}; // @[PositDivSqrt.scala 56:76]
  wire [28:0] radicand = _T_11 ? _T_12 : {{1'd0}, io_num1_fraction}; // @[PositDivSqrt.scala 56:21]
  wire  _T_13 = ~idle; // @[PositDivSqrt.scala 58:8]
  wire  _T_14 = _T_13 | io_validIn; // @[PositDivSqrt.scala 58:14]
  wire  _T_15 = starting & specialCase; // @[PositDivSqrt.scala 59:32]
  wire [1:0] _T_16 = _T_15 ? 2'h2 : 2'h0; // @[PositDivSqrt.scala 59:22]
  wire [5:0] _T_17 = started_normally ? 6'h20 : 6'h0; // @[PositDivSqrt.scala 60:22]
  wire [5:0] _GEN_9 = {{4'd0}, _T_16}; // @[PositDivSqrt.scala 59:58]
  wire [5:0] _T_18 = _GEN_9 | _T_17; // @[PositDivSqrt.scala 59:58]
  wire [5:0] _T_21 = cycleCount - 6'h1; // @[PositDivSqrt.scala 61:41]
  wire [5:0] _T_22 = _T_13 ? _T_21 : 6'h0; // @[PositDivSqrt.scala 61:22]
  wire [5:0] _T_23 = _T_18 | _T_22; // @[PositDivSqrt.scala 60:72]
  wire [3:0] _T_24 = divZ ? 4'h8 : 4'h0; // @[PositDivSqrt.scala 70:26]
  wire  _T_25 = io_num1_sign ^ io_num2_sign; // @[PositDivSqrt.scala 74:53]
  wire [7:0] _T_27 = io_num1_exponent[8:1]; // @[PositDivSqrt.scala 75:48]
  wire  _T_30 = started_normally & _T_2; // @[PositDivSqrt.scala 78:25]
  wire  _T_31 = readyIn & io_sqrtOp; // @[PositDivSqrt.scala 82:24]
  wire [30:0] _T_32 = {radicand, 2'h0}; // @[PositDivSqrt.scala 82:47]
  wire [30:0] _T_33 = _T_31 ? _T_32 : 31'h0; // @[PositDivSqrt.scala 82:15]
  wire  _T_34 = ~readyIn; // @[PositDivSqrt.scala 83:16]
  wire  _T_35 = _T_34 & sqrtOp_stored; // @[PositDivSqrt.scala 83:25]
  wire [30:0] _T_36 = {remLo, 2'h0}; // @[PositDivSqrt.scala 83:49]
  wire [30:0] _T_37 = _T_35 ? _T_36 : 31'h0; // @[PositDivSqrt.scala 83:15]
  wire [30:0] _T_38 = _T_33 | _T_37; // @[PositDivSqrt.scala 82:58]
  wire [1:0] _T_41 = _T_31 ? radicand[28:27] : 2'h0; // @[PositDivSqrt.scala 85:16]
  wire  _T_43 = readyIn & _T_2; // @[PositDivSqrt.scala 86:17]
  wire [28:0] _T_44 = _T_43 ? radicand : 29'h0; // @[PositDivSqrt.scala 86:8]
  wire [28:0] _GEN_10 = {{27'd0}, _T_41}; // @[PositDivSqrt.scala 85:118]
  wire [28:0] _T_45 = _GEN_10 | _T_44; // @[PositDivSqrt.scala 85:118]
  wire [33:0] _GEN_11 = {remHi, 2'h0}; // @[PositDivSqrt.scala 87:42]
  wire [34:0] _T_48 = {{1'd0}, _GEN_11}; // @[PositDivSqrt.scala 87:42]
  wire [28:0] _T_49 = {{27'd0}, remLo[28:27]}; // @[PositDivSqrt.scala 87:57]
  wire [34:0] _GEN_13 = {{6'd0}, _T_49}; // @[PositDivSqrt.scala 87:49]
  wire [34:0] _T_50 = _T_48 | _GEN_13; // @[PositDivSqrt.scala 87:49]
  wire [34:0] _T_51 = _T_35 ? _T_50 : 35'h0; // @[PositDivSqrt.scala 87:8]
  wire [34:0] _GEN_14 = {{6'd0}, _T_45}; // @[PositDivSqrt.scala 86:56]
  wire [34:0] _T_52 = _GEN_14 | _T_51; // @[PositDivSqrt.scala 86:56]
  wire  _T_54 = ~sqrtOp_stored; // @[PositDivSqrt.scala 88:21]
  wire  _T_55 = _T_34 & _T_54; // @[PositDivSqrt.scala 88:18]
  wire [32:0] _T_56 = {remHi, 1'h0}; // @[PositDivSqrt.scala 88:43]
  wire [32:0] _T_57 = _T_55 ? _T_56 : 33'h0; // @[PositDivSqrt.scala 88:8]
  wire [34:0] _GEN_15 = {{2'd0}, _T_57}; // @[PositDivSqrt.scala 87:84]
  wire [34:0] rem = _T_52 | _GEN_15; // @[PositDivSqrt.scala 87:84]
  wire [27:0] _T_62 = _T_43 ? io_num2_fraction : 28'h0; // @[PositDivSqrt.scala 93:8]
  wire [27:0] _GEN_16 = {{27'd0}, _T_31}; // @[PositDivSqrt.scala 92:41]
  wire [27:0] _T_63 = _GEN_16 | _T_62; // @[PositDivSqrt.scala 92:41]
  wire [32:0] _T_66 = {divSqrtFrac, 1'h0}; // @[PositDivSqrt.scala 94:52]
  wire [33:0] _T_67 = {_T_66,1'h1}; // @[Cat.scala 30:58]
  wire [33:0] _T_68 = _T_35 ? _T_67 : 34'h0; // @[PositDivSqrt.scala 94:8]
  wire [33:0] _GEN_17 = {{6'd0}, _T_63}; // @[PositDivSqrt.scala 93:52]
  wire [33:0] _T_69 = _GEN_17 | _T_68; // @[PositDivSqrt.scala 93:52]
  wire [31:0] _T_73 = _T_55 ? divisor : 32'h0; // @[PositDivSqrt.scala 95:8]
  wire [33:0] _GEN_18 = {{2'd0}, _T_73}; // @[PositDivSqrt.scala 94:71]
  wire [33:0] testDiv = _T_69 | _GEN_18; // @[PositDivSqrt.scala 94:71]
  wire [35:0] _T_74 = {1'b0,$signed(rem)}; // @[PositDivSqrt.scala 97:21]
  wire [34:0] _T_75 = {1'b0,$signed(testDiv)}; // @[PositDivSqrt.scala 97:36]
  wire [35:0] _GEN_19 = {{1{_T_75[34]}},_T_75}; // @[PositDivSqrt.scala 97:26]
  wire [35:0] testRem = $signed(_T_74) - $signed(_GEN_19); // @[PositDivSqrt.scala 97:26]
  wire  nextBit = $signed(testRem) >= 36'sh0; // @[PositDivSqrt.scala 98:25]
  wire  _T_78 = cycleCount > 6'h2; // @[PositDivSqrt.scala 100:39]
  wire  _T_79 = started_normally | _T_78; // @[PositDivSqrt.scala 100:25]
  wire [35:0] _T_80 = $signed(_T_74) - $signed(_GEN_19); // @[PositDivSqrt.scala 101:41]
  wire [35:0] _T_81 = nextBit ? _T_80 : {{1'd0}, rem}; // @[PositDivSqrt.scala 101:17]
  wire [35:0] _GEN_8 = _T_79 ? _T_81 : {{4'd0}, remHi}; // @[PositDivSqrt.scala 100:46]
  wire [32:0] nextFraction = {divSqrtFrac,nextBit}; // @[Cat.scala 30:58]
  wire  _T_82 = started_normally & nextBit; // @[PositDivSqrt.scala 105:21]
  wire [32:0] _T_84 = _T_34 ? nextFraction : 33'h0; // @[PositDivSqrt.scala 106:17]
  wire [32:0] _GEN_20 = {{32'd0}, _T_82}; // @[PositDivSqrt.scala 105:54]
  wire [32:0] _T_85 = _GEN_20 | _T_84; // @[PositDivSqrt.scala 105:54]
  wire  normReq = ~divSqrtFrac[31]; // @[PositDivSqrt.scala 108:17]
  wire [32:0] _T_87 = {divSqrtFrac,1'h0}; // @[Cat.scala 30:58]
  wire [32:0] _T_88 = normReq ? _T_87 : {{1'd0}, divSqrtFrac}; // @[PositDivSqrt.scala 109:18]
  wire  _T_89 = ~divSqrtFrac[31]; // @[PositDivSqrt.scala 110:42]
  wire [8:0] _GEN_21 = {9{_T_89}}; // @[PositDivSqrt.scala 110:26]
  wire [31:0] frac_out = _T_88[31:0]; // @[PositDivSqrt.scala 109:12]
  wire  validOut = cycleCount == 6'h1; // @[PositDivSqrt.scala 118:29]
  wire  _T_99 = frac_out[1:0] != 2'h0; // @[PositDivSqrt.scala 125:59]
  wire  _T_100 = remHi != 32'h0; // @[PositDivSqrt.scala 125:73]
  assign io_validOut_div = validOut & _T_54; // @[PositDivSqrt.scala 120:20]
  assign io_validOut_sqrt = validOut & sqrtOp_stored; // @[PositDivSqrt.scala 121:20]
  assign io_exceptions = exec_out; // @[PositDivSqrt.scala 122:20]
  assign io_trailingBits = frac_out[3:2]; // @[PositDivSqrt.scala 124:19]
  assign io_stickyBit = _T_99 | _T_100; // @[PositDivSqrt.scala 125:19]
  assign io_out_sign = sign_out; // @[PositDivSqrt.scala 127:10]
  assign io_out_exponent = $signed(divSqrtExp) + $signed(_GEN_21); // @[PositDivSqrt.scala 127:10]
  assign io_out_fraction = frac_out[31:4]; // @[PositDivSqrt.scala 127:10]
  assign io_out_isZero = isZero_out; // @[PositDivSqrt.scala 127:10]
  assign io_out_isNaR = isNaR_out; // @[PositDivSqrt.scala 127:10]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cycleCount = _RAND_0[5:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  sqrtOp_stored = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  isNaR_out = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  isZero_out = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  exec_out = _RAND_4[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  sign_out = _RAND_5[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  divSqrtExp = _RAND_6[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  divSqrtFrac = _RAND_7[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  remLo = _RAND_8[28:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  remHi = _RAND_9[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  divisor = _RAND_10[31:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      cycleCount <= 6'h0;
    end else if (_T_14) begin
      cycleCount <= _T_23;
    end
    if (starting) begin
      sqrtOp_stored <= io_sqrtOp;
    end
    if (starting) begin
      if (io_sqrtOp) begin
        isNaR_out <= _T_3;
      end else begin
        isNaR_out <= _T_5;
      end
    end
    if (starting) begin
      isZero_out <= io_num1_isZero;
    end
    if (reset) begin
      exec_out <= 5'h0;
    end else if (starting) begin
      exec_out <= {{1'd0}, _T_24};
    end
    if (started_normally) begin
      if (io_sqrtOp) begin
        sign_out <= 1'h0;
      end else begin
        sign_out <= _T_25;
      end
    end
    if (reset) begin
      divSqrtExp <= 9'sh0;
    end else if (started_normally) begin
      if (io_sqrtOp) begin
        divSqrtExp <= {{1{_T_27[7]}},_T_27};
      end else begin
        divSqrtExp <= expDiff;
      end
    end
    if (reset) begin
      divSqrtFrac <= 32'h0;
    end else begin
      divSqrtFrac <= _T_85[31:0];
    end
    if (reset) begin
      remLo <= 29'h0;
    end else begin
      remLo <= _T_38[28:0];
    end
    if (reset) begin
      remHi <= 32'h0;
    end else begin
      remHi <= _GEN_8[31:0];
    end
    if (reset) begin
      divisor <= 32'h0;
    end else if (_T_30) begin
      divisor <= {{4'd0}, io_num2_fraction};
    end
  end
endmodule
module PositMulCore(
  input         io_num1_sign,
  input  [8:0]  io_num1_exponent,
  input  [27:0] io_num1_fraction,
  input         io_num1_isZero,
  input         io_num1_isNaR,
  input         io_num2_sign,
  input  [8:0]  io_num2_exponent,
  input  [27:0] io_num2_fraction,
  input         io_num2_isZero,
  input         io_num2_isNaR,
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [8:0]  io_out_exponent,
  output [27:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR,
  input         io_validIn,
  output        io_validOut
);
  wire [8:0] prodExp = $signed(io_num1_exponent) + $signed(io_num2_exponent); // @[PositMul.scala 22:31]
  wire [55:0] prodFrac = io_num1_fraction * io_num2_fraction; // @[PositMul.scala 24:63]
  wire  prodOverflow = prodFrac[55]; // @[PositMul.scala 25:30]
  wire  _T_3 = ~prodOverflow; // @[PositMul.scala 27:39]
  wire [56:0] _GEN_0 = {{1'd0}, prodFrac}; // @[PositMul.scala 27:35]
  wire [56:0] normProductFrac = _GEN_0 << _T_3; // @[PositMul.scala 27:35]
  wire [1:0] _T_4 = prodOverflow ? $signed(2'sh1) : $signed(2'sh0); // @[PositMul.scala 28:38]
  wire [8:0] _GEN_1 = {{7{_T_4[1]}},_T_4}; // @[PositMul.scala 28:33]
  assign io_trailingBits = normProductFrac[27:26]; // @[PositMul.scala 37:19]
  assign io_stickyBit = normProductFrac[25:0] != 26'h0; // @[PositMul.scala 38:19]
  assign io_out_sign = io_num1_sign ^ io_num2_sign; // @[PositMul.scala 40:10]
  assign io_out_exponent = $signed(prodExp) + $signed(_GEN_1); // @[PositMul.scala 40:10]
  assign io_out_fraction = normProductFrac[55:28]; // @[PositMul.scala 40:10]
  assign io_out_isZero = io_num1_isZero | io_num2_isZero; // @[PositMul.scala 40:10]
  assign io_out_isNaR = io_num1_isNaR | io_num2_isNaR; // @[PositMul.scala 40:10]
  assign io_validOut = io_validIn; // @[PositMul.scala 18:15]
endmodule
module PositExtractor(
  input  [31:0] io_in,
  output        io_out_sign,
  output [8:0]  io_out_exponent,
  output [27:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR
);
  wire  sign = io_in[31]; // @[PositExtractor.scala 12:21]
  wire [31:0] _T = ~io_in; // @[PositExtractor.scala 13:26]
  wire [31:0] _T_2 = _T + 32'h1; // @[PositExtractor.scala 13:33]
  wire [31:0] absIn = sign ? _T_2 : io_in; // @[PositExtractor.scala 13:19]
  wire  negExp = ~absIn[30]; // @[PositExtractor.scala 14:16]
  wire [30:0] regExpFrac = absIn[30:0]; // @[PositExtractor.scala 16:26]
  wire [30:0] _T_4 = ~regExpFrac; // @[PositExtractor.scala 17:45]
  wire [30:0] zerosRegime = negExp ? regExpFrac : _T_4; // @[PositExtractor.scala 17:24]
  wire  _T_5 = zerosRegime != 31'h0; // @[common.scala 61:41]
  wire  _T_6 = ~_T_5; // @[common.scala 61:33]
  wire [4:0] _T_38 = zerosRegime[1] ? 5'h1d : 5'h1e; // @[Mux.scala 47:69]
  wire [4:0] _T_39 = zerosRegime[2] ? 5'h1c : _T_38; // @[Mux.scala 47:69]
  wire [4:0] _T_40 = zerosRegime[3] ? 5'h1b : _T_39; // @[Mux.scala 47:69]
  wire [4:0] _T_41 = zerosRegime[4] ? 5'h1a : _T_40; // @[Mux.scala 47:69]
  wire [4:0] _T_42 = zerosRegime[5] ? 5'h19 : _T_41; // @[Mux.scala 47:69]
  wire [4:0] _T_43 = zerosRegime[6] ? 5'h18 : _T_42; // @[Mux.scala 47:69]
  wire [4:0] _T_44 = zerosRegime[7] ? 5'h17 : _T_43; // @[Mux.scala 47:69]
  wire [4:0] _T_45 = zerosRegime[8] ? 5'h16 : _T_44; // @[Mux.scala 47:69]
  wire [4:0] _T_46 = zerosRegime[9] ? 5'h15 : _T_45; // @[Mux.scala 47:69]
  wire [4:0] _T_47 = zerosRegime[10] ? 5'h14 : _T_46; // @[Mux.scala 47:69]
  wire [4:0] _T_48 = zerosRegime[11] ? 5'h13 : _T_47; // @[Mux.scala 47:69]
  wire [4:0] _T_49 = zerosRegime[12] ? 5'h12 : _T_48; // @[Mux.scala 47:69]
  wire [4:0] _T_50 = zerosRegime[13] ? 5'h11 : _T_49; // @[Mux.scala 47:69]
  wire [4:0] _T_51 = zerosRegime[14] ? 5'h10 : _T_50; // @[Mux.scala 47:69]
  wire [4:0] _T_52 = zerosRegime[15] ? 5'hf : _T_51; // @[Mux.scala 47:69]
  wire [4:0] _T_53 = zerosRegime[16] ? 5'he : _T_52; // @[Mux.scala 47:69]
  wire [4:0] _T_54 = zerosRegime[17] ? 5'hd : _T_53; // @[Mux.scala 47:69]
  wire [4:0] _T_55 = zerosRegime[18] ? 5'hc : _T_54; // @[Mux.scala 47:69]
  wire [4:0] _T_56 = zerosRegime[19] ? 5'hb : _T_55; // @[Mux.scala 47:69]
  wire [4:0] _T_57 = zerosRegime[20] ? 5'ha : _T_56; // @[Mux.scala 47:69]
  wire [4:0] _T_58 = zerosRegime[21] ? 5'h9 : _T_57; // @[Mux.scala 47:69]
  wire [4:0] _T_59 = zerosRegime[22] ? 5'h8 : _T_58; // @[Mux.scala 47:69]
  wire [4:0] _T_60 = zerosRegime[23] ? 5'h7 : _T_59; // @[Mux.scala 47:69]
  wire [4:0] _T_61 = zerosRegime[24] ? 5'h6 : _T_60; // @[Mux.scala 47:69]
  wire [4:0] _T_62 = zerosRegime[25] ? 5'h5 : _T_61; // @[Mux.scala 47:69]
  wire [4:0] _T_63 = zerosRegime[26] ? 5'h4 : _T_62; // @[Mux.scala 47:69]
  wire [4:0] _T_64 = zerosRegime[27] ? 5'h3 : _T_63; // @[Mux.scala 47:69]
  wire [4:0] _T_65 = zerosRegime[28] ? 5'h2 : _T_64; // @[Mux.scala 47:69]
  wire [4:0] _T_66 = zerosRegime[29] ? 5'h1 : _T_65; // @[Mux.scala 47:69]
  wire [4:0] _T_67 = zerosRegime[30] ? 5'h0 : _T_66; // @[Mux.scala 47:69]
  wire [4:0] _T_68 = _T_6 ? 5'h1f : _T_67; // @[PositExtractor.scala 20:10]
  wire [5:0] regimeCount = {1'h0,_T_68}; // @[Cat.scala 30:58]
  wire [5:0] _T_69 = ~regimeCount; // @[PositExtractor.scala 22:17]
  wire [5:0] _T_71 = _T_69 + 6'h1; // @[PositExtractor.scala 22:30]
  wire [5:0] _T_73 = regimeCount - 6'h1; // @[PositExtractor.scala 22:49]
  wire [5:0] regime = negExp ? _T_71 : _T_73; // @[PositExtractor.scala 22:8]
  wire [5:0] _T_75 = regimeCount + 6'h2; // @[PositExtractor.scala 24:39]
  wire [94:0] _GEN_0 = {{63'd0}, absIn}; // @[PositExtractor.scala 24:23]
  wire [94:0] expFrac = _GEN_0 << _T_75; // @[PositExtractor.scala 24:23]
  wire [1:0] extractedExp = expFrac[31:30]; // @[PositExtractor.scala 26:24]
  wire [26:0] frac = expFrac[29:3]; // @[PositExtractor.scala 28:21]
  wire  _T_78 = io_in[30:0] != 31'h0; // @[common.scala 27:71]
  wire  _T_79 = ~_T_78; // @[common.scala 27:53]
  wire  _T_81 = io_in != 32'h0; // @[common.scala 61:41]
  wire [7:0] _T_84 = {regime,extractedExp}; // @[PositExtractor.scala 37:11]
  assign io_out_sign = io_in[31]; // @[PositExtractor.scala 33:19]
  assign io_out_exponent = {{1{_T_84[7]}},_T_84}; // @[PositExtractor.scala 34:19]
  assign io_out_fraction = {1'h1,frac}; // @[PositExtractor.scala 38:19]
  assign io_out_isZero = ~_T_81; // @[PositExtractor.scala 31:19]
  assign io_out_isNaR = sign & _T_79; // @[PositExtractor.scala 30:19]
endmodule
module PositGenerator(
  input         io_in_sign,
  input  [8:0]  io_in_exponent,
  input  [27:0] io_in_fraction,
  input         io_in_isZero,
  input         io_in_isNaR,
  input  [1:0]  io_trailingBits,
  input         io_stickyBit,
  output [31:0] io_out
);
  wire [26:0] fraction = io_in_fraction[26:0]; // @[PositGenerator.scala 15:32]
  wire  negExp = $signed(io_in_exponent) < 9'sh0; // @[PositGenerator.scala 16:31]
  wire [6:0] _T_2 = 7'h0 - io_in_exponent[8:2]; // @[PositGenerator.scala 19:17]
  wire [6:0] regime = negExp ? _T_2 : io_in_exponent[8:2]; // @[PositGenerator.scala 19:8]
  wire [1:0] exponent = io_in_exponent[1:0]; // @[PositGenerator.scala 20:32]
  wire  _T_4 = regime != 7'h1f; // @[PositGenerator.scala 22:31]
  wire  _T_5 = negExp & _T_4; // @[PositGenerator.scala 22:22]
  wire [6:0] _GEN_0 = {{6'd0}, _T_5}; // @[PositGenerator.scala 22:12]
  wire [6:0] offset = regime - _GEN_0; // @[PositGenerator.scala 22:12]
  wire [1:0] _T_7 = negExp ? 2'h1 : 2'h2; // @[PositGenerator.scala 26:14]
  wire [32:0] expFrac = {_T_7,exponent,fraction,io_trailingBits}; // @[PositGenerator.scala 26:87]
  wire [32:0] uT_uS_posit = $signed(expFrac) >>> offset; // @[PositGenerator.scala 31:40]
  wire [30:0] uR_uS_posit = uT_uS_posit[32:2]; // @[PositGenerator.scala 32:32]
  wire [127:0] _T_12 = 128'h1 << offset; // @[OneHot.scala 58:35]
  wire [127:0] _T_14 = _T_12 - 128'h1; // @[common.scala 23:44]
  wire [29:0] stickyBitMask = _T_14[29:0]; // @[PositGenerator.scala 34:43]
  wire [1:0] gr = uT_uS_posit[1:0]; // @[PositGenerator.scala 36:16]
  wire [32:0] _T_15 = {_T_7,exponent,fraction,io_trailingBits}; // @[PositGenerator.scala 38:35]
  wire [32:0] _GEN_1 = {{3'd0}, stickyBitMask}; // @[PositGenerator.scala 38:38]
  wire [32:0] _T_16 = _T_15 & _GEN_1; // @[PositGenerator.scala 38:38]
  wire  _T_17 = _T_16 != 33'h0; // @[PositGenerator.scala 38:58]
  wire  stickyBit = io_stickyBit | _T_17; // @[PositGenerator.scala 38:18]
  wire  _T_19 = uR_uS_posit == 31'h7fffffff; // @[PositGenerator.scala 43:25]
  wire  _T_22 = ~uR_uS_posit[0]; // @[PositGenerator.scala 44:17]
  wire  _T_24 = _T_22 & gr[1]; // @[PositGenerator.scala 44:33]
  wire  _T_26 = ~gr[0]; // @[PositGenerator.scala 44:43]
  wire  _T_27 = _T_24 & _T_26; // @[PositGenerator.scala 44:41]
  wire  _T_28 = ~stickyBit; // @[PositGenerator.scala 44:52]
  wire  _T_29 = _T_27 & _T_28; // @[PositGenerator.scala 44:50]
  wire  _T_30 = ~_T_29; // @[PositGenerator.scala 44:15]
  wire  _T_31 = gr[1] & _T_30; // @[PositGenerator.scala 44:13]
  wire  roundingBit = _T_19 ? 1'h0 : _T_31; // @[PositGenerator.scala 43:8]
  wire [30:0] _GEN_2 = {{30'd0}, roundingBit}; // @[PositGenerator.scala 45:32]
  wire [30:0] R_uS_posit = uR_uS_posit + _GEN_2; // @[PositGenerator.scala 45:32]
  wire  _T_33 = R_uS_posit != 31'h0; // @[common.scala 61:41]
  wire  _T_34 = ~_T_33; // @[common.scala 61:33]
  wire [30:0] _GEN_3 = {{30'd0}, _T_34}; // @[PositGenerator.scala 49:30]
  wire [30:0] _T_35 = R_uS_posit | _GEN_3; // @[PositGenerator.scala 49:30]
  wire [31:0] uFC_R_uS_posit = {1'h0,_T_35}; // @[Cat.scala 30:58]
  wire [31:0] _T_36 = ~uFC_R_uS_posit; // @[PositGenerator.scala 52:21]
  wire [31:0] _T_38 = _T_36 + 32'h1; // @[PositGenerator.scala 52:37]
  wire [31:0] R_S_posit = io_in_sign ? _T_38 : uFC_R_uS_posit; // @[PositGenerator.scala 52:8]
  wire  _T_40 = io_in_fraction == 28'h0; // @[PositGenerator.scala 55:25]
  wire  _T_41 = _T_40 | io_in_isZero; // @[PositGenerator.scala 55:34]
  wire [31:0] _T_42 = _T_41 ? 32'h0 : R_S_posit; // @[PositGenerator.scala 55:8]
  assign io_out = io_in_isNaR ? 32'h80000000 : _T_42; // @[PositGenerator.scala 54:10]
endmodule
module Posit(
  input         clock,
  input         reset,
  output        io_request_ready,
  input         io_request_valid,
  input  [31:0] io_request_bits_num1,
  input  [31:0] io_request_bits_num2,
  input  [31:0] io_request_bits_num3,
  input  [2:0]  io_request_bits_inst,
  input  [1:0]  io_request_bits_mode,
  input         io_result_ready,
  output        io_result_valid,
  output        io_result_bits_isZero,
  output        io_result_bits_isNaR,
  output [31:0] io_result_bits_out,
  output        io_result_bits_lt,
  output        io_result_bits_eq,
  output        io_result_bits_gt,
  output [4:0]  io_result_bits_exceptions,
  input  [1:0]  io_in_idx,
  output [1:0]  io_out_idx
);
  wire  positAddCore_clock; // @[POSIT.scala 44:34]
  wire  positAddCore_io_num1_sign; // @[POSIT.scala 44:34]
  wire [8:0] positAddCore_io_num1_exponent; // @[POSIT.scala 44:34]
  wire [27:0] positAddCore_io_num1_fraction; // @[POSIT.scala 44:34]
  wire  positAddCore_io_num1_isZero; // @[POSIT.scala 44:34]
  wire  positAddCore_io_num1_isNaR; // @[POSIT.scala 44:34]
  wire  positAddCore_io_num2_sign; // @[POSIT.scala 44:34]
  wire [8:0] positAddCore_io_num2_exponent; // @[POSIT.scala 44:34]
  wire [27:0] positAddCore_io_num2_fraction; // @[POSIT.scala 44:34]
  wire  positAddCore_io_num2_isZero; // @[POSIT.scala 44:34]
  wire  positAddCore_io_num2_isNaR; // @[POSIT.scala 44:34]
  wire  positAddCore_io_sub; // @[POSIT.scala 44:34]
  wire  positAddCore_io_input_valid; // @[POSIT.scala 44:34]
  wire [1:0] positAddCore_io_trailingBits; // @[POSIT.scala 44:34]
  wire  positAddCore_io_stickyBit; // @[POSIT.scala 44:34]
  wire  positAddCore_io_out_sign; // @[POSIT.scala 44:34]
  wire [8:0] positAddCore_io_out_exponent; // @[POSIT.scala 44:34]
  wire [27:0] positAddCore_io_out_fraction; // @[POSIT.scala 44:34]
  wire  positAddCore_io_out_isZero; // @[POSIT.scala 44:34]
  wire  positAddCore_io_out_isNaR; // @[POSIT.scala 44:34]
  wire  positAddCore_io_output_valid; // @[POSIT.scala 44:34]
  wire [31:0] positCompare_io_num1; // @[POSIT.scala 45:34]
  wire [31:0] positCompare_io_num2; // @[POSIT.scala 45:34]
  wire  positCompare_io_lt; // @[POSIT.scala 45:34]
  wire  positCompare_io_eq; // @[POSIT.scala 45:34]
  wire  positCompare_io_gt; // @[POSIT.scala 45:34]
  wire  positCompare_io_validIn; // @[POSIT.scala 45:34]
  wire  positCompare_io_validOut; // @[POSIT.scala 45:34]
  wire  positFMACore_clock; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num1_sign; // @[POSIT.scala 46:34]
  wire [8:0] positFMACore_io_num1_exponent; // @[POSIT.scala 46:34]
  wire [27:0] positFMACore_io_num1_fraction; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num1_isZero; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num1_isNaR; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num2_sign; // @[POSIT.scala 46:34]
  wire [8:0] positFMACore_io_num2_exponent; // @[POSIT.scala 46:34]
  wire [27:0] positFMACore_io_num2_fraction; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num2_isZero; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num2_isNaR; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num3_sign; // @[POSIT.scala 46:34]
  wire [8:0] positFMACore_io_num3_exponent; // @[POSIT.scala 46:34]
  wire [27:0] positFMACore_io_num3_fraction; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num3_isZero; // @[POSIT.scala 46:34]
  wire  positFMACore_io_num3_isNaR; // @[POSIT.scala 46:34]
  wire  positFMACore_io_sub; // @[POSIT.scala 46:34]
  wire  positFMACore_io_negate; // @[POSIT.scala 46:34]
  wire  positFMACore_io_input_valid; // @[POSIT.scala 46:34]
  wire [1:0] positFMACore_io_trailingBits; // @[POSIT.scala 46:34]
  wire  positFMACore_io_stickyBit; // @[POSIT.scala 46:34]
  wire  positFMACore_io_out_sign; // @[POSIT.scala 46:34]
  wire [8:0] positFMACore_io_out_exponent; // @[POSIT.scala 46:34]
  wire [27:0] positFMACore_io_out_fraction; // @[POSIT.scala 46:34]
  wire  positFMACore_io_out_isZero; // @[POSIT.scala 46:34]
  wire  positFMACore_io_out_isNaR; // @[POSIT.scala 46:34]
  wire  positFMACore_io_output_valid; // @[POSIT.scala 46:34]
  wire  positDivSqrtCore_clock; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_reset; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_validIn; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_sqrtOp; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_num1_sign; // @[POSIT.scala 47:38]
  wire [8:0] positDivSqrtCore_io_num1_exponent; // @[POSIT.scala 47:38]
  wire [27:0] positDivSqrtCore_io_num1_fraction; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_num1_isZero; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_num1_isNaR; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_num2_sign; // @[POSIT.scala 47:38]
  wire [8:0] positDivSqrtCore_io_num2_exponent; // @[POSIT.scala 47:38]
  wire [27:0] positDivSqrtCore_io_num2_fraction; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_num2_isZero; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_num2_isNaR; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_validOut_div; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_validOut_sqrt; // @[POSIT.scala 47:38]
  wire [4:0] positDivSqrtCore_io_exceptions; // @[POSIT.scala 47:38]
  wire [1:0] positDivSqrtCore_io_trailingBits; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_stickyBit; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_out_sign; // @[POSIT.scala 47:38]
  wire [8:0] positDivSqrtCore_io_out_exponent; // @[POSIT.scala 47:38]
  wire [27:0] positDivSqrtCore_io_out_fraction; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_out_isZero; // @[POSIT.scala 47:38]
  wire  positDivSqrtCore_io_out_isNaR; // @[POSIT.scala 47:38]
  wire  positMulCore_io_num1_sign; // @[POSIT.scala 48:34]
  wire [8:0] positMulCore_io_num1_exponent; // @[POSIT.scala 48:34]
  wire [27:0] positMulCore_io_num1_fraction; // @[POSIT.scala 48:34]
  wire  positMulCore_io_num1_isZero; // @[POSIT.scala 48:34]
  wire  positMulCore_io_num1_isNaR; // @[POSIT.scala 48:34]
  wire  positMulCore_io_num2_sign; // @[POSIT.scala 48:34]
  wire [8:0] positMulCore_io_num2_exponent; // @[POSIT.scala 48:34]
  wire [27:0] positMulCore_io_num2_fraction; // @[POSIT.scala 48:34]
  wire  positMulCore_io_num2_isZero; // @[POSIT.scala 48:34]
  wire  positMulCore_io_num2_isNaR; // @[POSIT.scala 48:34]
  wire [1:0] positMulCore_io_trailingBits; // @[POSIT.scala 48:34]
  wire  positMulCore_io_stickyBit; // @[POSIT.scala 48:34]
  wire  positMulCore_io_out_sign; // @[POSIT.scala 48:34]
  wire [8:0] positMulCore_io_out_exponent; // @[POSIT.scala 48:34]
  wire [27:0] positMulCore_io_out_fraction; // @[POSIT.scala 48:34]
  wire  positMulCore_io_out_isZero; // @[POSIT.scala 48:34]
  wire  positMulCore_io_out_isNaR; // @[POSIT.scala 48:34]
  wire  positMulCore_io_validIn; // @[POSIT.scala 48:34]
  wire  positMulCore_io_validOut; // @[POSIT.scala 48:34]
  wire [31:0] num1Extractor_io_in; // @[POSIT.scala 74:35]
  wire  num1Extractor_io_out_sign; // @[POSIT.scala 74:35]
  wire [8:0] num1Extractor_io_out_exponent; // @[POSIT.scala 74:35]
  wire [27:0] num1Extractor_io_out_fraction; // @[POSIT.scala 74:35]
  wire  num1Extractor_io_out_isZero; // @[POSIT.scala 74:35]
  wire  num1Extractor_io_out_isNaR; // @[POSIT.scala 74:35]
  wire [31:0] num2Extractor_io_in; // @[POSIT.scala 75:35]
  wire  num2Extractor_io_out_sign; // @[POSIT.scala 75:35]
  wire [8:0] num2Extractor_io_out_exponent; // @[POSIT.scala 75:35]
  wire [27:0] num2Extractor_io_out_fraction; // @[POSIT.scala 75:35]
  wire  num2Extractor_io_out_isZero; // @[POSIT.scala 75:35]
  wire  num2Extractor_io_out_isNaR; // @[POSIT.scala 75:35]
  wire [31:0] num3Extractor_io_in; // @[POSIT.scala 76:35]
  wire  num3Extractor_io_out_sign; // @[POSIT.scala 76:35]
  wire [8:0] num3Extractor_io_out_exponent; // @[POSIT.scala 76:35]
  wire [27:0] num3Extractor_io_out_fraction; // @[POSIT.scala 76:35]
  wire  num3Extractor_io_out_isZero; // @[POSIT.scala 76:35]
  wire  num3Extractor_io_out_isNaR; // @[POSIT.scala 76:35]
  wire  positGenerator_io_in_sign; // @[POSIT.scala 197:36]
  wire [8:0] positGenerator_io_in_exponent; // @[POSIT.scala 197:36]
  wire [27:0] positGenerator_io_in_fraction; // @[POSIT.scala 197:36]
  wire  positGenerator_io_in_isZero; // @[POSIT.scala 197:36]
  wire  positGenerator_io_in_isNaR; // @[POSIT.scala 197:36]
  wire [1:0] positGenerator_io_trailingBits; // @[POSIT.scala 197:36]
  wire  positGenerator_io_stickyBit; // @[POSIT.scala 197:36]
  wire [31:0] positGenerator_io_out; // @[POSIT.scala 197:36]
  wire  PositGenerator_io_in_sign; // @[POSIT.scala 203:50]
  wire [8:0] PositGenerator_io_in_exponent; // @[POSIT.scala 203:50]
  wire [27:0] PositGenerator_io_in_fraction; // @[POSIT.scala 203:50]
  wire  PositGenerator_io_in_isZero; // @[POSIT.scala 203:50]
  wire  PositGenerator_io_in_isNaR; // @[POSIT.scala 203:50]
  wire [1:0] PositGenerator_io_trailingBits; // @[POSIT.scala 203:50]
  wire  PositGenerator_io_stickyBit; // @[POSIT.scala 203:50]
  wire [31:0] PositGenerator_io_out; // @[POSIT.scala 203:50]
  wire  PositGenerator_1_io_in_sign; // @[POSIT.scala 204:47]
  wire [8:0] PositGenerator_1_io_in_exponent; // @[POSIT.scala 204:47]
  wire [27:0] PositGenerator_1_io_in_fraction; // @[POSIT.scala 204:47]
  wire  PositGenerator_1_io_in_isZero; // @[POSIT.scala 204:47]
  wire  PositGenerator_1_io_in_isNaR; // @[POSIT.scala 204:47]
  wire [1:0] PositGenerator_1_io_trailingBits; // @[POSIT.scala 204:47]
  wire  PositGenerator_1_io_stickyBit; // @[POSIT.scala 204:47]
  wire [31:0] PositGenerator_1_io_out; // @[POSIT.scala 204:47]
  wire  PositGenerator_2_io_in_sign; // @[POSIT.scala 205:47]
  wire [8:0] PositGenerator_2_io_in_exponent; // @[POSIT.scala 205:47]
  wire [27:0] PositGenerator_2_io_in_fraction; // @[POSIT.scala 205:47]
  wire  PositGenerator_2_io_in_isZero; // @[POSIT.scala 205:47]
  wire  PositGenerator_2_io_in_isNaR; // @[POSIT.scala 205:47]
  wire [1:0] PositGenerator_2_io_trailingBits; // @[POSIT.scala 205:47]
  wire  PositGenerator_2_io_stickyBit; // @[POSIT.scala 205:47]
  wire [31:0] PositGenerator_2_io_out; // @[POSIT.scala 205:47]
  wire  PositGenerator_3_io_in_sign; // @[POSIT.scala 206:51]
  wire [8:0] PositGenerator_3_io_in_exponent; // @[POSIT.scala 206:51]
  wire [27:0] PositGenerator_3_io_in_fraction; // @[POSIT.scala 206:51]
  wire  PositGenerator_3_io_in_isZero; // @[POSIT.scala 206:51]
  wire  PositGenerator_3_io_in_isNaR; // @[POSIT.scala 206:51]
  wire [1:0] PositGenerator_3_io_trailingBits; // @[POSIT.scala 206:51]
  wire  PositGenerator_3_io_stickyBit; // @[POSIT.scala 206:51]
  wire [31:0] PositGenerator_3_io_out; // @[POSIT.scala 206:51]
  reg [31:0] init_num1; // @[POSIT.scala 51:32]
  reg [31:0] _RAND_0;
  reg [31:0] init_num2; // @[POSIT.scala 52:32]
  reg [31:0] _RAND_1;
  reg [31:0] init_num3; // @[POSIT.scala 53:32]
  reg [31:0] _RAND_2;
  reg [2:0] init_inst; // @[POSIT.scala 55:32]
  reg [31:0] _RAND_3;
  reg [1:0] init_mode; // @[POSIT.scala 56:32]
  reg [31:0] _RAND_4;
  reg  init_valid; // @[POSIT.scala 57:33]
  reg [31:0] _RAND_5;
  reg [1:0] init_idx; // @[POSIT.scala 58:31]
  reg [31:0] _RAND_6;
  reg  result_valid; // @[POSIT.scala 60:35]
  reg [31:0] _RAND_7;
  reg  exec_valid; // @[POSIT.scala 61:33]
  reg [31:0] _RAND_8;
  wire  _T = io_request_valid & io_request_ready; // @[POSIT.scala 63:31]
  wire  _T_1 = ~result_valid; // @[POSIT.scala 71:21]
  wire  _T_2 = ~exec_valid; // @[POSIT.scala 71:39]
  wire  _T_3 = _T_1 & _T_2; // @[POSIT.scala 71:36]
  wire  _T_4 = _T_3 & init_valid; // @[POSIT.scala 71:51]
  reg  exec_num1_sign; // @[POSIT.scala 81:32]
  reg [31:0] _RAND_9;
  reg [8:0] exec_num1_exponent; // @[POSIT.scala 81:32]
  reg [31:0] _RAND_10;
  reg [27:0] exec_num1_fraction; // @[POSIT.scala 81:32]
  reg [31:0] _RAND_11;
  reg  exec_num1_isZero; // @[POSIT.scala 81:32]
  reg [31:0] _RAND_12;
  reg  exec_num1_isNaR; // @[POSIT.scala 81:32]
  reg [31:0] _RAND_13;
  reg  exec_num2_sign; // @[POSIT.scala 82:32]
  reg [31:0] _RAND_14;
  reg [8:0] exec_num2_exponent; // @[POSIT.scala 82:32]
  reg [31:0] _RAND_15;
  reg [27:0] exec_num2_fraction; // @[POSIT.scala 82:32]
  reg [31:0] _RAND_16;
  reg  exec_num2_isZero; // @[POSIT.scala 82:32]
  reg [31:0] _RAND_17;
  reg  exec_num2_isNaR; // @[POSIT.scala 82:32]
  reg [31:0] _RAND_18;
  reg  exec_num3_sign; // @[POSIT.scala 83:32]
  reg [31:0] _RAND_19;
  reg [8:0] exec_num3_exponent; // @[POSIT.scala 83:32]
  reg [31:0] _RAND_20;
  reg [27:0] exec_num3_fraction; // @[POSIT.scala 83:32]
  reg [31:0] _RAND_21;
  reg  exec_num3_isZero; // @[POSIT.scala 83:32]
  reg [31:0] _RAND_22;
  reg  exec_num3_isNaR; // @[POSIT.scala 83:32]
  reg [31:0] _RAND_23;
  reg [31:0] comp_num1; // @[POSIT.scala 84:32]
  reg [31:0] _RAND_24;
  reg [31:0] comp_num2; // @[POSIT.scala 85:32]
  reg [31:0] _RAND_25;
  reg [2:0] exec_inst; // @[POSIT.scala 87:32]
  reg [31:0] _RAND_26;
  reg [1:0] exec_mode; // @[POSIT.scala 88:32]
  reg [31:0] _RAND_27;
  reg [1:0] exec_idx; // @[POSIT.scala 89:31]
  reg [31:0] _RAND_28;
  reg  dispatched; // @[POSIT.scala 90:33]
  reg [31:0] _RAND_29;
  reg  result_out_sign; // @[POSIT.scala 94:33]
  reg [31:0] _RAND_30;
  reg [8:0] result_out_exponent; // @[POSIT.scala 94:33]
  reg [31:0] _RAND_31;
  reg [27:0] result_out_fraction; // @[POSIT.scala 94:33]
  reg [31:0] _RAND_32;
  reg  result_out_isZero; // @[POSIT.scala 94:33]
  reg [31:0] _RAND_33;
  reg  result_out_isNaR; // @[POSIT.scala 94:33]
  reg [31:0] _RAND_34;
  reg  result_stickyBit; // @[POSIT.scala 95:39]
  reg [31:0] _RAND_35;
  reg [1:0] result_trailingBits; // @[POSIT.scala 96:42]
  reg [31:0] _RAND_36;
  reg  result_lt; // @[POSIT.scala 97:32]
  reg [31:0] _RAND_37;
  reg  result_eq; // @[POSIT.scala 98:32]
  reg [31:0] _RAND_38;
  reg  result_gt; // @[POSIT.scala 99:32]
  reg [31:0] _RAND_39;
  reg [1:0] result_idx; // @[POSIT.scala 100:33]
  reg [31:0] _RAND_40;
  wire  _T_44 = positCompare_io_validOut | positMulCore_io_validOut; // @[POSIT.scala 158:54]
  wire  _T_45 = _T_44 | positDivSqrtCore_io_validOut_div; // @[POSIT.scala 158:80]
  wire  _T_46 = _T_45 | positDivSqrtCore_io_validOut_sqrt; // @[POSIT.scala 159:58]
  wire  _T_47 = _T_46 | positFMACore_io_output_valid; // @[POSIT.scala 160:59]
  wire  new_result_valid = _T_47 | positAddCore_io_output_valid; // @[POSIT.scala 160:90]
  wire  _GEN_30 = exec_valid | dispatched; // @[POSIT.scala 126:31]
  wire  _T_19 = exec_inst == 3'h1; // @[POSIT.scala 133:64]
  wire  _T_20 = exec_valid & _T_19; // @[POSIT.scala 133:51]
  wire  _T_21 = ~dispatched; // @[POSIT.scala 133:91]
  wire  _T_25 = exec_inst == 3'h2; // @[POSIT.scala 137:60]
  wire  _T_26 = exec_valid & _T_25; // @[POSIT.scala 137:47]
  wire  _T_31 = exec_inst == 3'h3; // @[POSIT.scala 144:64]
  wire  _T_32 = exec_valid & _T_31; // @[POSIT.scala 144:51]
  wire  _T_36 = exec_inst == 3'h5; // @[POSIT.scala 150:64]
  wire  _T_37 = exec_valid & _T_36; // @[POSIT.scala 150:51]
  wire  _T_40 = exec_inst == 3'h4; // @[POSIT.scala 155:60]
  wire  _T_41 = exec_valid & _T_40; // @[POSIT.scala 155:47]
  wire  _T_49 = 3'h5 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_50_sign = _T_49 & positDivSqrtCore_io_out_sign; // @[Mux.scala 68:16]
  wire  _T_50_isZero = _T_49 & positDivSqrtCore_io_out_isZero; // @[Mux.scala 68:16]
  wire  _T_50_isNaR = _T_49 & positDivSqrtCore_io_out_isNaR; // @[Mux.scala 68:16]
  wire  _T_51 = 3'h4 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_53 = 3'h3 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_55 = 3'h1 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_58 = _T_49 & positDivSqrtCore_io_stickyBit; // @[Mux.scala 68:16]
  wire  _T_75 = ~reset; // @[POSIT.scala 233:31]
  wire  _T_110 = positGenerator_io_out != 32'h0; // @[common.scala 61:41]
  wire  _T_111 = ~_T_110; // @[common.scala 61:33]
  wire  _T_115 = positGenerator_io_out[30:0] != 31'h0; // @[common.scala 27:71]
  wire  _T_116 = ~_T_115; // @[common.scala 27:53]
  wire  _T_117 = positGenerator_io_out[31] & _T_116; // @[common.scala 27:51]
  wire  _GEN_44 = ~_T; // @[POSIT.scala 239:31]
  wire  _GEN_45 = _GEN_44 & _T_4; // @[POSIT.scala 239:31]
  wire  _GEN_46 = ~_T_4; // @[POSIT.scala 250:31]
  wire  _GEN_47 = _GEN_46 & new_result_valid; // @[POSIT.scala 250:31]
  wire  _GEN_48 = ~new_result_valid; // @[POSIT.scala 256:31]
  wire  _GEN_49 = _GEN_48 & exec_valid; // @[POSIT.scala 256:31]
  PositAddCore positAddCore ( // @[POSIT.scala 44:34]
    .clock(positAddCore_clock),
    .io_num1_sign(positAddCore_io_num1_sign),
    .io_num1_exponent(positAddCore_io_num1_exponent),
    .io_num1_fraction(positAddCore_io_num1_fraction),
    .io_num1_isZero(positAddCore_io_num1_isZero),
    .io_num1_isNaR(positAddCore_io_num1_isNaR),
    .io_num2_sign(positAddCore_io_num2_sign),
    .io_num2_exponent(positAddCore_io_num2_exponent),
    .io_num2_fraction(positAddCore_io_num2_fraction),
    .io_num2_isZero(positAddCore_io_num2_isZero),
    .io_num2_isNaR(positAddCore_io_num2_isNaR),
    .io_sub(positAddCore_io_sub),
    .io_input_valid(positAddCore_io_input_valid),
    .io_trailingBits(positAddCore_io_trailingBits),
    .io_stickyBit(positAddCore_io_stickyBit),
    .io_out_sign(positAddCore_io_out_sign),
    .io_out_exponent(positAddCore_io_out_exponent),
    .io_out_fraction(positAddCore_io_out_fraction),
    .io_out_isZero(positAddCore_io_out_isZero),
    .io_out_isNaR(positAddCore_io_out_isNaR),
    .io_output_valid(positAddCore_io_output_valid)
  );
  PositCompare positCompare ( // @[POSIT.scala 45:34]
    .io_num1(positCompare_io_num1),
    .io_num2(positCompare_io_num2),
    .io_lt(positCompare_io_lt),
    .io_eq(positCompare_io_eq),
    .io_gt(positCompare_io_gt),
    .io_validIn(positCompare_io_validIn),
    .io_validOut(positCompare_io_validOut)
  );
  PositFMACore positFMACore ( // @[POSIT.scala 46:34]
    .clock(positFMACore_clock),
    .io_num1_sign(positFMACore_io_num1_sign),
    .io_num1_exponent(positFMACore_io_num1_exponent),
    .io_num1_fraction(positFMACore_io_num1_fraction),
    .io_num1_isZero(positFMACore_io_num1_isZero),
    .io_num1_isNaR(positFMACore_io_num1_isNaR),
    .io_num2_sign(positFMACore_io_num2_sign),
    .io_num2_exponent(positFMACore_io_num2_exponent),
    .io_num2_fraction(positFMACore_io_num2_fraction),
    .io_num2_isZero(positFMACore_io_num2_isZero),
    .io_num2_isNaR(positFMACore_io_num2_isNaR),
    .io_num3_sign(positFMACore_io_num3_sign),
    .io_num3_exponent(positFMACore_io_num3_exponent),
    .io_num3_fraction(positFMACore_io_num3_fraction),
    .io_num3_isZero(positFMACore_io_num3_isZero),
    .io_num3_isNaR(positFMACore_io_num3_isNaR),
    .io_sub(positFMACore_io_sub),
    .io_negate(positFMACore_io_negate),
    .io_input_valid(positFMACore_io_input_valid),
    .io_trailingBits(positFMACore_io_trailingBits),
    .io_stickyBit(positFMACore_io_stickyBit),
    .io_out_sign(positFMACore_io_out_sign),
    .io_out_exponent(positFMACore_io_out_exponent),
    .io_out_fraction(positFMACore_io_out_fraction),
    .io_out_isZero(positFMACore_io_out_isZero),
    .io_out_isNaR(positFMACore_io_out_isNaR),
    .io_output_valid(positFMACore_io_output_valid)
  );
  PositDivSqrtCore positDivSqrtCore ( // @[POSIT.scala 47:38]
    .clock(positDivSqrtCore_clock),
    .reset(positDivSqrtCore_reset),
    .io_validIn(positDivSqrtCore_io_validIn),
    .io_sqrtOp(positDivSqrtCore_io_sqrtOp),
    .io_num1_sign(positDivSqrtCore_io_num1_sign),
    .io_num1_exponent(positDivSqrtCore_io_num1_exponent),
    .io_num1_fraction(positDivSqrtCore_io_num1_fraction),
    .io_num1_isZero(positDivSqrtCore_io_num1_isZero),
    .io_num1_isNaR(positDivSqrtCore_io_num1_isNaR),
    .io_num2_sign(positDivSqrtCore_io_num2_sign),
    .io_num2_exponent(positDivSqrtCore_io_num2_exponent),
    .io_num2_fraction(positDivSqrtCore_io_num2_fraction),
    .io_num2_isZero(positDivSqrtCore_io_num2_isZero),
    .io_num2_isNaR(positDivSqrtCore_io_num2_isNaR),
    .io_validOut_div(positDivSqrtCore_io_validOut_div),
    .io_validOut_sqrt(positDivSqrtCore_io_validOut_sqrt),
    .io_exceptions(positDivSqrtCore_io_exceptions),
    .io_trailingBits(positDivSqrtCore_io_trailingBits),
    .io_stickyBit(positDivSqrtCore_io_stickyBit),
    .io_out_sign(positDivSqrtCore_io_out_sign),
    .io_out_exponent(positDivSqrtCore_io_out_exponent),
    .io_out_fraction(positDivSqrtCore_io_out_fraction),
    .io_out_isZero(positDivSqrtCore_io_out_isZero),
    .io_out_isNaR(positDivSqrtCore_io_out_isNaR)
  );
  PositMulCore positMulCore ( // @[POSIT.scala 48:34]
    .io_num1_sign(positMulCore_io_num1_sign),
    .io_num1_exponent(positMulCore_io_num1_exponent),
    .io_num1_fraction(positMulCore_io_num1_fraction),
    .io_num1_isZero(positMulCore_io_num1_isZero),
    .io_num1_isNaR(positMulCore_io_num1_isNaR),
    .io_num2_sign(positMulCore_io_num2_sign),
    .io_num2_exponent(positMulCore_io_num2_exponent),
    .io_num2_fraction(positMulCore_io_num2_fraction),
    .io_num2_isZero(positMulCore_io_num2_isZero),
    .io_num2_isNaR(positMulCore_io_num2_isNaR),
    .io_trailingBits(positMulCore_io_trailingBits),
    .io_stickyBit(positMulCore_io_stickyBit),
    .io_out_sign(positMulCore_io_out_sign),
    .io_out_exponent(positMulCore_io_out_exponent),
    .io_out_fraction(positMulCore_io_out_fraction),
    .io_out_isZero(positMulCore_io_out_isZero),
    .io_out_isNaR(positMulCore_io_out_isNaR),
    .io_validIn(positMulCore_io_validIn),
    .io_validOut(positMulCore_io_validOut)
  );
  PositExtractor num1Extractor ( // @[POSIT.scala 74:35]
    .io_in(num1Extractor_io_in),
    .io_out_sign(num1Extractor_io_out_sign),
    .io_out_exponent(num1Extractor_io_out_exponent),
    .io_out_fraction(num1Extractor_io_out_fraction),
    .io_out_isZero(num1Extractor_io_out_isZero),
    .io_out_isNaR(num1Extractor_io_out_isNaR)
  );
  PositExtractor num2Extractor ( // @[POSIT.scala 75:35]
    .io_in(num2Extractor_io_in),
    .io_out_sign(num2Extractor_io_out_sign),
    .io_out_exponent(num2Extractor_io_out_exponent),
    .io_out_fraction(num2Extractor_io_out_fraction),
    .io_out_isZero(num2Extractor_io_out_isZero),
    .io_out_isNaR(num2Extractor_io_out_isNaR)
  );
  PositExtractor num3Extractor ( // @[POSIT.scala 76:35]
    .io_in(num3Extractor_io_in),
    .io_out_sign(num3Extractor_io_out_sign),
    .io_out_exponent(num3Extractor_io_out_exponent),
    .io_out_fraction(num3Extractor_io_out_fraction),
    .io_out_isZero(num3Extractor_io_out_isZero),
    .io_out_isNaR(num3Extractor_io_out_isNaR)
  );
  PositGenerator positGenerator ( // @[POSIT.scala 197:36]
    .io_in_sign(positGenerator_io_in_sign),
    .io_in_exponent(positGenerator_io_in_exponent),
    .io_in_fraction(positGenerator_io_in_fraction),
    .io_in_isZero(positGenerator_io_in_isZero),
    .io_in_isNaR(positGenerator_io_in_isNaR),
    .io_trailingBits(positGenerator_io_trailingBits),
    .io_stickyBit(positGenerator_io_stickyBit),
    .io_out(positGenerator_io_out)
  );
  PositGenerator PositGenerator ( // @[POSIT.scala 203:50]
    .io_in_sign(PositGenerator_io_in_sign),
    .io_in_exponent(PositGenerator_io_in_exponent),
    .io_in_fraction(PositGenerator_io_in_fraction),
    .io_in_isZero(PositGenerator_io_in_isZero),
    .io_in_isNaR(PositGenerator_io_in_isNaR),
    .io_trailingBits(PositGenerator_io_trailingBits),
    .io_stickyBit(PositGenerator_io_stickyBit),
    .io_out(PositGenerator_io_out)
  );
  PositGenerator PositGenerator_1 ( // @[POSIT.scala 204:47]
    .io_in_sign(PositGenerator_1_io_in_sign),
    .io_in_exponent(PositGenerator_1_io_in_exponent),
    .io_in_fraction(PositGenerator_1_io_in_fraction),
    .io_in_isZero(PositGenerator_1_io_in_isZero),
    .io_in_isNaR(PositGenerator_1_io_in_isNaR),
    .io_trailingBits(PositGenerator_1_io_trailingBits),
    .io_stickyBit(PositGenerator_1_io_stickyBit),
    .io_out(PositGenerator_1_io_out)
  );
  PositGenerator PositGenerator_2 ( // @[POSIT.scala 205:47]
    .io_in_sign(PositGenerator_2_io_in_sign),
    .io_in_exponent(PositGenerator_2_io_in_exponent),
    .io_in_fraction(PositGenerator_2_io_in_fraction),
    .io_in_isZero(PositGenerator_2_io_in_isZero),
    .io_in_isNaR(PositGenerator_2_io_in_isNaR),
    .io_trailingBits(PositGenerator_2_io_trailingBits),
    .io_stickyBit(PositGenerator_2_io_stickyBit),
    .io_out(PositGenerator_2_io_out)
  );
  PositGenerator PositGenerator_3 ( // @[POSIT.scala 206:51]
    .io_in_sign(PositGenerator_3_io_in_sign),
    .io_in_exponent(PositGenerator_3_io_in_exponent),
    .io_in_fraction(PositGenerator_3_io_in_fraction),
    .io_in_isZero(PositGenerator_3_io_in_isZero),
    .io_in_isNaR(PositGenerator_3_io_in_isNaR),
    .io_trailingBits(PositGenerator_3_io_trailingBits),
    .io_stickyBit(PositGenerator_3_io_stickyBit),
    .io_out(PositGenerator_3_io_out)
  );
  assign io_request_ready = ~init_valid; // @[POSIT.scala 102:26]
  assign io_result_valid = result_valid; // @[POSIT.scala 274:25]
  assign io_result_bits_isZero = result_out_isZero | _T_111; // @[POSIT.scala 265:31]
  assign io_result_bits_isNaR = result_out_isNaR | _T_117; // @[POSIT.scala 266:31]
  assign io_result_bits_out = positGenerator_io_out; // @[POSIT.scala 267:31]
  assign io_result_bits_lt = result_lt; // @[POSIT.scala 268:27]
  assign io_result_bits_eq = result_eq; // @[POSIT.scala 269:27]
  assign io_result_bits_gt = result_gt; // @[POSIT.scala 270:27]
  assign io_result_bits_exceptions = positDivSqrtCore_io_exceptions; // @[POSIT.scala 271:35]
  assign io_out_idx = result_idx; // @[POSIT.scala 272:20]
  assign positAddCore_clock = clock;
  assign positAddCore_io_num1_sign = exec_num1_sign; // @[POSIT.scala 130:30]
  assign positAddCore_io_num1_exponent = exec_num1_exponent; // @[POSIT.scala 130:30]
  assign positAddCore_io_num1_fraction = exec_num1_fraction; // @[POSIT.scala 130:30]
  assign positAddCore_io_num1_isZero = exec_num1_isZero; // @[POSIT.scala 130:30]
  assign positAddCore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 130:30]
  assign positAddCore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 131:30]
  assign positAddCore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 131:30]
  assign positAddCore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 131:30]
  assign positAddCore_io_num2_isZero = exec_num2_isZero; // @[POSIT.scala 131:30]
  assign positAddCore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 131:30]
  assign positAddCore_io_sub = exec_mode[0]; // @[POSIT.scala 132:29]
  assign positAddCore_io_input_valid = _T_20 & _T_21; // @[POSIT.scala 133:37]
  assign positCompare_io_num1 = comp_num1; // @[POSIT.scala 135:30]
  assign positCompare_io_num2 = comp_num2; // @[POSIT.scala 136:30]
  assign positCompare_io_validIn = _T_26 & _T_21; // @[POSIT.scala 137:33]
  assign positFMACore_clock = clock;
  assign positFMACore_io_num1_sign = exec_num1_sign; // @[POSIT.scala 139:30]
  assign positFMACore_io_num1_exponent = exec_num1_exponent; // @[POSIT.scala 139:30]
  assign positFMACore_io_num1_fraction = exec_num1_fraction; // @[POSIT.scala 139:30]
  assign positFMACore_io_num1_isZero = exec_num1_isZero; // @[POSIT.scala 139:30]
  assign positFMACore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 139:30]
  assign positFMACore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 140:30]
  assign positFMACore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 140:30]
  assign positFMACore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 140:30]
  assign positFMACore_io_num2_isZero = exec_num2_isZero; // @[POSIT.scala 140:30]
  assign positFMACore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 140:30]
  assign positFMACore_io_num3_sign = exec_num3_sign; // @[POSIT.scala 141:30]
  assign positFMACore_io_num3_exponent = exec_num3_exponent; // @[POSIT.scala 141:30]
  assign positFMACore_io_num3_fraction = exec_num3_fraction; // @[POSIT.scala 141:30]
  assign positFMACore_io_num3_isZero = exec_num3_isZero; // @[POSIT.scala 141:30]
  assign positFMACore_io_num3_isNaR = exec_num3_isNaR; // @[POSIT.scala 141:30]
  assign positFMACore_io_sub = exec_mode[0]; // @[POSIT.scala 142:29]
  assign positFMACore_io_negate = exec_mode[1]; // @[POSIT.scala 143:32]
  assign positFMACore_io_input_valid = _T_32 & _T_21; // @[POSIT.scala 144:37]
  assign positDivSqrtCore_clock = clock;
  assign positDivSqrtCore_reset = reset;
  assign positDivSqrtCore_io_validIn = _T_37 & _T_21; // @[POSIT.scala 150:37]
  assign positDivSqrtCore_io_sqrtOp = exec_mode[0]; // @[POSIT.scala 149:36]
  assign positDivSqrtCore_io_num1_sign = exec_num1_sign; // @[POSIT.scala 147:34]
  assign positDivSqrtCore_io_num1_exponent = exec_num1_exponent; // @[POSIT.scala 147:34]
  assign positDivSqrtCore_io_num1_fraction = exec_num1_fraction; // @[POSIT.scala 147:34]
  assign positDivSqrtCore_io_num1_isZero = exec_num1_isZero; // @[POSIT.scala 147:34]
  assign positDivSqrtCore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 147:34]
  assign positDivSqrtCore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 148:34]
  assign positDivSqrtCore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 148:34]
  assign positDivSqrtCore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 148:34]
  assign positDivSqrtCore_io_num2_isZero = exec_num2_isZero; // @[POSIT.scala 148:34]
  assign positDivSqrtCore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 148:34]
  assign positMulCore_io_num1_sign = exec_num1_sign; // @[POSIT.scala 153:30]
  assign positMulCore_io_num1_exponent = exec_num1_exponent; // @[POSIT.scala 153:30]
  assign positMulCore_io_num1_fraction = exec_num1_fraction; // @[POSIT.scala 153:30]
  assign positMulCore_io_num1_isZero = exec_num1_isZero; // @[POSIT.scala 153:30]
  assign positMulCore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 153:30]
  assign positMulCore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 154:30]
  assign positMulCore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 154:30]
  assign positMulCore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 154:30]
  assign positMulCore_io_num2_isZero = exec_num2_isZero; // @[POSIT.scala 154:30]
  assign positMulCore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 154:30]
  assign positMulCore_io_validIn = _T_41 & _T_21; // @[POSIT.scala 155:33]
  assign num1Extractor_io_in = init_num1; // @[POSIT.scala 77:29]
  assign num2Extractor_io_in = init_num2; // @[POSIT.scala 78:29]
  assign num3Extractor_io_in = init_num3; // @[POSIT.scala 79:29]
  assign positGenerator_io_in_sign = result_out_sign; // @[POSIT.scala 198:40]
  assign positGenerator_io_in_exponent = result_out_exponent; // @[POSIT.scala 198:40]
  assign positGenerator_io_in_fraction = result_out_fraction; // @[POSIT.scala 198:40]
  assign positGenerator_io_in_isZero = result_out_isZero; // @[POSIT.scala 198:40]
  assign positGenerator_io_in_isNaR = result_out_isNaR; // @[POSIT.scala 198:40]
  assign positGenerator_io_trailingBits = result_trailingBits; // @[POSIT.scala 199:40]
  assign positGenerator_io_stickyBit = result_stickyBit; // @[POSIT.scala 200:40]
  assign PositGenerator_io_in_sign = positAddCore_io_out_sign; // @[POSIT.scala 208:54]
  assign PositGenerator_io_in_exponent = positAddCore_io_out_exponent; // @[POSIT.scala 208:54]
  assign PositGenerator_io_in_fraction = positAddCore_io_out_fraction; // @[POSIT.scala 208:54]
  assign PositGenerator_io_in_isZero = positAddCore_io_out_isZero; // @[POSIT.scala 208:54]
  assign PositGenerator_io_in_isNaR = positAddCore_io_out_isNaR; // @[POSIT.scala 208:54]
  assign PositGenerator_io_trailingBits = positAddCore_io_trailingBits; // @[POSIT.scala 209:54]
  assign PositGenerator_io_stickyBit = positAddCore_io_stickyBit; // @[POSIT.scala 210:54]
  assign PositGenerator_1_io_in_sign = positFMACore_io_out_sign; // @[POSIT.scala 212:51]
  assign PositGenerator_1_io_in_exponent = positFMACore_io_out_exponent; // @[POSIT.scala 212:51]
  assign PositGenerator_1_io_in_fraction = positFMACore_io_out_fraction; // @[POSIT.scala 212:51]
  assign PositGenerator_1_io_in_isZero = positFMACore_io_out_isZero; // @[POSIT.scala 212:51]
  assign PositGenerator_1_io_in_isNaR = positFMACore_io_out_isNaR; // @[POSIT.scala 212:51]
  assign PositGenerator_1_io_trailingBits = positFMACore_io_trailingBits; // @[POSIT.scala 213:51]
  assign PositGenerator_1_io_stickyBit = positFMACore_io_stickyBit; // @[POSIT.scala 214:51]
  assign PositGenerator_2_io_in_sign = positMulCore_io_out_sign; // @[POSIT.scala 216:51]
  assign PositGenerator_2_io_in_exponent = positMulCore_io_out_exponent; // @[POSIT.scala 216:51]
  assign PositGenerator_2_io_in_fraction = positMulCore_io_out_fraction; // @[POSIT.scala 216:51]
  assign PositGenerator_2_io_in_isZero = positMulCore_io_out_isZero; // @[POSIT.scala 216:51]
  assign PositGenerator_2_io_in_isNaR = positMulCore_io_out_isNaR; // @[POSIT.scala 216:51]
  assign PositGenerator_2_io_trailingBits = positMulCore_io_trailingBits; // @[POSIT.scala 217:51]
  assign PositGenerator_2_io_stickyBit = positMulCore_io_stickyBit; // @[POSIT.scala 218:51]
  assign PositGenerator_3_io_in_sign = positDivSqrtCore_io_out_sign; // @[POSIT.scala 220:55]
  assign PositGenerator_3_io_in_exponent = positDivSqrtCore_io_out_exponent; // @[POSIT.scala 220:55]
  assign PositGenerator_3_io_in_fraction = positDivSqrtCore_io_out_fraction; // @[POSIT.scala 220:55]
  assign PositGenerator_3_io_in_isZero = positDivSqrtCore_io_out_isZero; // @[POSIT.scala 220:55]
  assign PositGenerator_3_io_in_isNaR = positDivSqrtCore_io_out_isNaR; // @[POSIT.scala 220:55]
  assign PositGenerator_3_io_trailingBits = positDivSqrtCore_io_trailingBits; // @[POSIT.scala 221:55]
  assign PositGenerator_3_io_stickyBit = positDivSqrtCore_io_stickyBit; // @[POSIT.scala 222:55]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  init_num1 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  init_num2 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  init_num3 = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  init_inst = _RAND_3[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  init_mode = _RAND_4[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  init_valid = _RAND_5[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  init_idx = _RAND_6[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  result_valid = _RAND_7[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  exec_valid = _RAND_8[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  exec_num1_sign = _RAND_9[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  exec_num1_exponent = _RAND_10[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  exec_num1_fraction = _RAND_11[27:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  exec_num1_isZero = _RAND_12[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  exec_num1_isNaR = _RAND_13[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  exec_num2_sign = _RAND_14[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  exec_num2_exponent = _RAND_15[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  exec_num2_fraction = _RAND_16[27:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  exec_num2_isZero = _RAND_17[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  exec_num2_isNaR = _RAND_18[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  exec_num3_sign = _RAND_19[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  exec_num3_exponent = _RAND_20[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  exec_num3_fraction = _RAND_21[27:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  exec_num3_isZero = _RAND_22[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {1{`RANDOM}};
  exec_num3_isNaR = _RAND_23[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  comp_num1 = _RAND_24[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  comp_num2 = _RAND_25[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{`RANDOM}};
  exec_inst = _RAND_26[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  exec_mode = _RAND_27[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{`RANDOM}};
  exec_idx = _RAND_28[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  dispatched = _RAND_29[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  result_out_sign = _RAND_30[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  result_out_exponent = _RAND_31[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{`RANDOM}};
  result_out_fraction = _RAND_32[27:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_33 = {1{`RANDOM}};
  result_out_isZero = _RAND_33[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{`RANDOM}};
  result_out_isNaR = _RAND_34[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_35 = {1{`RANDOM}};
  result_stickyBit = _RAND_35[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{`RANDOM}};
  result_trailingBits = _RAND_36[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_37 = {1{`RANDOM}};
  result_lt = _RAND_37[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_38 = {1{`RANDOM}};
  result_eq = _RAND_38[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_39 = {1{`RANDOM}};
  result_gt = _RAND_39[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_40 = {1{`RANDOM}};
  result_idx = _RAND_40[1:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      init_num1 <= 32'h0;
    end else if (_T) begin
      init_num1 <= io_request_bits_num1;
    end
    if (reset) begin
      init_num2 <= 32'h0;
    end else if (_T) begin
      init_num2 <= io_request_bits_num2;
    end
    if (reset) begin
      init_num3 <= 32'h0;
    end else if (_T) begin
      init_num3 <= io_request_bits_num3;
    end
    if (reset) begin
      init_inst <= 3'h0;
    end else if (_T) begin
      init_inst <= io_request_bits_inst;
    end
    if (reset) begin
      init_mode <= 2'h0;
    end else if (_T) begin
      init_mode <= io_request_bits_mode;
    end
    if (reset) begin
      init_valid <= 1'h0;
    end else if (_T) begin
      init_valid <= io_request_valid;
    end else if (_T_4) begin
      init_valid <= 1'h0;
    end
    if (reset) begin
      init_idx <= 2'h0;
    end else if (_T) begin
      init_idx <= io_in_idx;
    end
    if (reset) begin
      result_valid <= 1'h0;
    end else if (io_result_ready) begin
      result_valid <= new_result_valid;
    end
    if (reset) begin
      exec_valid <= 1'h0;
    end else if (_T_4) begin
      exec_valid <= init_valid;
    end else if (new_result_valid) begin
      exec_valid <= 1'h0;
    end
    if (reset) begin
      exec_num1_sign <= 1'h0;
    end else if (_T_4) begin
      exec_num1_sign <= num1Extractor_io_out_sign;
    end
    if (reset) begin
      exec_num1_exponent <= 9'sh0;
    end else if (_T_4) begin
      exec_num1_exponent <= num1Extractor_io_out_exponent;
    end
    if (reset) begin
      exec_num1_fraction <= 28'h0;
    end else if (_T_4) begin
      exec_num1_fraction <= num1Extractor_io_out_fraction;
    end
    if (reset) begin
      exec_num1_isZero <= 1'h0;
    end else if (_T_4) begin
      exec_num1_isZero <= num1Extractor_io_out_isZero;
    end
    if (reset) begin
      exec_num1_isNaR <= 1'h0;
    end else if (_T_4) begin
      exec_num1_isNaR <= num1Extractor_io_out_isNaR;
    end
    if (reset) begin
      exec_num2_sign <= 1'h0;
    end else if (_T_4) begin
      exec_num2_sign <= num2Extractor_io_out_sign;
    end
    if (reset) begin
      exec_num2_exponent <= 9'sh0;
    end else if (_T_4) begin
      exec_num2_exponent <= num2Extractor_io_out_exponent;
    end
    if (reset) begin
      exec_num2_fraction <= 28'h0;
    end else if (_T_4) begin
      exec_num2_fraction <= num2Extractor_io_out_fraction;
    end
    if (reset) begin
      exec_num2_isZero <= 1'h0;
    end else if (_T_4) begin
      exec_num2_isZero <= num2Extractor_io_out_isZero;
    end
    if (reset) begin
      exec_num2_isNaR <= 1'h0;
    end else if (_T_4) begin
      exec_num2_isNaR <= num2Extractor_io_out_isNaR;
    end
    if (reset) begin
      exec_num3_sign <= 1'h0;
    end else if (_T_4) begin
      exec_num3_sign <= num3Extractor_io_out_sign;
    end
    if (reset) begin
      exec_num3_exponent <= 9'sh0;
    end else if (_T_4) begin
      exec_num3_exponent <= num3Extractor_io_out_exponent;
    end
    if (reset) begin
      exec_num3_fraction <= 28'h0;
    end else if (_T_4) begin
      exec_num3_fraction <= num3Extractor_io_out_fraction;
    end
    if (reset) begin
      exec_num3_isZero <= 1'h0;
    end else if (_T_4) begin
      exec_num3_isZero <= num3Extractor_io_out_isZero;
    end
    if (reset) begin
      exec_num3_isNaR <= 1'h0;
    end else if (_T_4) begin
      exec_num3_isNaR <= num3Extractor_io_out_isNaR;
    end
    if (reset) begin
      comp_num1 <= 32'h0;
    end else if (_T_4) begin
      comp_num1 <= init_num1;
    end
    if (reset) begin
      comp_num2 <= 32'h0;
    end else if (_T_4) begin
      comp_num2 <= init_num2;
    end
    if (reset) begin
      exec_inst <= 3'h0;
    end else if (_T_4) begin
      exec_inst <= init_inst;
    end
    if (reset) begin
      exec_mode <= 2'h0;
    end else if (_T_4) begin
      exec_mode <= init_mode;
    end
    if (reset) begin
      exec_idx <= 2'h0;
    end else if (_T_4) begin
      exec_idx <= init_idx;
    end
    if (reset) begin
      dispatched <= 1'h0;
    end else if (new_result_valid) begin
      dispatched <= 1'h0;
    end else begin
      dispatched <= _GEN_30;
    end
    if (reset) begin
      result_out_sign <= 1'h0;
    end else if (io_result_ready) begin
      if (_T_55) begin
        result_out_sign <= positAddCore_io_out_sign;
      end else if (_T_53) begin
        result_out_sign <= positFMACore_io_out_sign;
      end else if (_T_51) begin
        result_out_sign <= positMulCore_io_out_sign;
      end else begin
        result_out_sign <= _T_50_sign;
      end
    end
    if (reset) begin
      result_out_exponent <= 9'sh0;
    end else if (io_result_ready) begin
      if (_T_55) begin
        result_out_exponent <= positAddCore_io_out_exponent;
      end else if (_T_53) begin
        result_out_exponent <= positFMACore_io_out_exponent;
      end else if (_T_51) begin
        result_out_exponent <= positMulCore_io_out_exponent;
      end else if (_T_49) begin
        result_out_exponent <= positDivSqrtCore_io_out_exponent;
      end else begin
        result_out_exponent <= 9'sh0;
      end
    end
    if (reset) begin
      result_out_fraction <= 28'h0;
    end else if (io_result_ready) begin
      if (_T_55) begin
        result_out_fraction <= positAddCore_io_out_fraction;
      end else if (_T_53) begin
        result_out_fraction <= positFMACore_io_out_fraction;
      end else if (_T_51) begin
        result_out_fraction <= positMulCore_io_out_fraction;
      end else if (_T_49) begin
        result_out_fraction <= positDivSqrtCore_io_out_fraction;
      end else begin
        result_out_fraction <= 28'h0;
      end
    end
    if (reset) begin
      result_out_isZero <= 1'h0;
    end else if (io_result_ready) begin
      if (_T_55) begin
        result_out_isZero <= positAddCore_io_out_isZero;
      end else if (_T_53) begin
        result_out_isZero <= positFMACore_io_out_isZero;
      end else if (_T_51) begin
        result_out_isZero <= positMulCore_io_out_isZero;
      end else begin
        result_out_isZero <= _T_50_isZero;
      end
    end
    if (reset) begin
      result_out_isNaR <= 1'h0;
    end else if (io_result_ready) begin
      if (_T_55) begin
        result_out_isNaR <= positAddCore_io_out_isNaR;
      end else if (_T_53) begin
        result_out_isNaR <= positFMACore_io_out_isNaR;
      end else if (_T_51) begin
        result_out_isNaR <= positMulCore_io_out_isNaR;
      end else begin
        result_out_isNaR <= _T_50_isNaR;
      end
    end
    if (reset) begin
      result_stickyBit <= 1'h0;
    end else if (io_result_ready) begin
      if (_T_55) begin
        result_stickyBit <= positAddCore_io_stickyBit;
      end else if (_T_53) begin
        result_stickyBit <= positFMACore_io_stickyBit;
      end else if (_T_51) begin
        result_stickyBit <= positMulCore_io_stickyBit;
      end else begin
        result_stickyBit <= _T_58;
      end
    end
    if (reset) begin
      result_trailingBits <= 2'h0;
    end else if (io_result_ready) begin
      if (_T_55) begin
        result_trailingBits <= positAddCore_io_trailingBits;
      end else if (_T_53) begin
        result_trailingBits <= positFMACore_io_trailingBits;
      end else if (_T_51) begin
        result_trailingBits <= positMulCore_io_trailingBits;
      end else if (_T_49) begin
        result_trailingBits <= positDivSqrtCore_io_trailingBits;
      end else begin
        result_trailingBits <= 2'h0;
      end
    end
    if (reset) begin
      result_lt <= 1'h0;
    end else if (io_result_ready) begin
      result_lt <= positCompare_io_lt;
    end
    if (reset) begin
      result_eq <= 1'h0;
    end else if (io_result_ready) begin
      result_eq <= positCompare_io_eq;
    end
    if (reset) begin
      result_gt <= 1'h0;
    end else if (io_result_ready) begin
      result_gt <= positCompare_io_gt;
    end
    if (reset) begin
      result_idx <= 2'h0;
    end else if (io_result_ready) begin
      result_idx <= exec_idx;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T & _T_75) begin
          $fwrite(32'h80000002,"Init:\n"); // @[POSIT.scala 233:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T & _T_75) begin
          $fwrite(32'h80000002,"\tinit_valid: %d\n",io_request_valid); // @[POSIT.scala 234:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T & _T_75) begin
          $fwrite(32'h80000002,"\tinit_inst: %d\n",io_request_bits_inst); // @[POSIT.scala 235:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T & _T_75) begin
          $fwrite(32'h80000002,"\tidx: %d\n",io_in_idx); // @[POSIT.scala 236:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_45 & _T_75) begin
          $fwrite(32'h80000002,"\tinit_valid: %d\n",1'h0); // @[POSIT.scala 239:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (new_result_valid & _T_75) begin
          $fwrite(32'h80000002,"new results!\n"); // @[POSIT.scala 242:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_4 & _T_75) begin
          $fwrite(32'h80000002,"Exec:\n"); // @[POSIT.scala 245:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_4 & _T_75) begin
          $fwrite(32'h80000002,"\t exec_valid: %d\n",init_valid); // @[POSIT.scala 246:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_4 & _T_75) begin
          $fwrite(32'h80000002,"\t exec_inst: %d\n",init_inst); // @[POSIT.scala 247:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_4 & _T_75) begin
          $fwrite(32'h80000002,"\t exec_idx: %d\n",init_idx); // @[POSIT.scala 248:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_47 & _T_75) begin
          $fwrite(32'h80000002,"\t exec_valid: %d\n",1'h0); // @[POSIT.scala 250:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (new_result_valid & _T_75) begin
          $fwrite(32'h80000002,"\tdispatched: %d\n",1'h0); // @[POSIT.scala 254:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_49 & _T_75) begin
          $fwrite(32'h80000002,"\tdispatched: %d\n",1'h1); // @[POSIT.scala 256:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_result_valid & _T_75) begin
          $fwrite(32'h80000002,"valid idx: %d\n",io_out_idx); // @[POSIT.scala 260:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
module DispatchArbiter(
  input  [3:0] io_validity,
  input  [1:0] io_priority,
  output [1:0] io_chosen,
  output       io_hasChosen
);
  wire  afterPriority_3 = io_validity[3]; // @[DispatchArbiter.scala 19:64]
  wire  _T_6 = 2'h2 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_2 = _T_6 & io_validity[2]; // @[DispatchArbiter.scala 19:28]
  wire  _T_9 = 2'h2 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_2 = _T_9 & io_validity[2]; // @[DispatchArbiter.scala 21:28]
  wire  _T_12 = 2'h1 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_1 = _T_12 & io_validity[1]; // @[DispatchArbiter.scala 19:28]
  wire  _T_15 = 2'h1 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_1 = _T_15 & io_validity[1]; // @[DispatchArbiter.scala 21:28]
  wire  _T_18 = 2'h0 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_0 = _T_18 & io_validity[0]; // @[DispatchArbiter.scala 19:28]
  wire  _T_21 = 2'h0 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_0 = _T_21 & io_validity[0]; // @[DispatchArbiter.scala 21:28]
  wire [1:0] _GEN_0 = afterPriority_2 ? 2'h2 : 2'h3; // @[DispatchArbiter.scala 30:29]
  wire [1:0] _GEN_1 = beforePriority_2 ? 2'h2 : 2'h3; // @[DispatchArbiter.scala 33:40]
  wire [1:0] _GEN_2 = afterPriority_1 ? 2'h1 : _GEN_0; // @[DispatchArbiter.scala 30:29]
  wire [1:0] _GEN_3 = beforePriority_1 ? 2'h1 : _GEN_1; // @[DispatchArbiter.scala 33:40]
  wire [1:0] afterPriorityChosen = afterPriority_0 ? 2'h0 : _GEN_2; // @[DispatchArbiter.scala 30:29]
  wire [1:0] beforePriorityChosen = beforePriority_0 ? 2'h0 : _GEN_3; // @[DispatchArbiter.scala 33:40]
  wire  _T_25 = afterPriority_0 | afterPriority_1; // @[DispatchArbiter.scala 37:54]
  wire  _T_26 = _T_25 | afterPriority_2; // @[DispatchArbiter.scala 37:54]
  wire  afterPriorityExist = _T_26 | afterPriority_3; // @[DispatchArbiter.scala 37:54]
  wire  _T_28 = beforePriority_0 | beforePriority_1; // @[DispatchArbiter.scala 38:56]
  wire  beforePriorityExist = _T_28 | beforePriority_2; // @[DispatchArbiter.scala 38:56]
  assign io_chosen = afterPriorityExist ? afterPriorityChosen : beforePriorityChosen; // @[DispatchArbiter.scala 41:19]
  assign io_hasChosen = afterPriorityExist | beforePriorityExist; // @[DispatchArbiter.scala 40:22]
endmodule
module DispatchArbiter_1(
  input  [11:0] io_validity,
  input  [3:0]  io_priority,
  output [3:0]  io_chosen,
  output        io_hasChosen
);
  wire  _T = 4'hb >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_11 = _T & io_validity[11]; // @[DispatchArbiter.scala 19:28]
  wire  _T_3 = 4'hb < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_11 = _T_3 & io_validity[11]; // @[DispatchArbiter.scala 21:28]
  wire  _T_6 = 4'ha >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_10 = _T_6 & io_validity[10]; // @[DispatchArbiter.scala 19:28]
  wire  _T_9 = 4'ha < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_10 = _T_9 & io_validity[10]; // @[DispatchArbiter.scala 21:28]
  wire  _T_12 = 4'h9 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_9 = _T_12 & io_validity[9]; // @[DispatchArbiter.scala 19:28]
  wire  _T_15 = 4'h9 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_9 = _T_15 & io_validity[9]; // @[DispatchArbiter.scala 21:28]
  wire  _T_18 = 4'h8 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_8 = _T_18 & io_validity[8]; // @[DispatchArbiter.scala 19:28]
  wire  _T_21 = 4'h8 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_8 = _T_21 & io_validity[8]; // @[DispatchArbiter.scala 21:28]
  wire  _T_24 = 4'h7 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_7 = _T_24 & io_validity[7]; // @[DispatchArbiter.scala 19:28]
  wire  _T_27 = 4'h7 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_7 = _T_27 & io_validity[7]; // @[DispatchArbiter.scala 21:28]
  wire  _T_30 = 4'h6 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_6 = _T_30 & io_validity[6]; // @[DispatchArbiter.scala 19:28]
  wire  _T_33 = 4'h6 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_6 = _T_33 & io_validity[6]; // @[DispatchArbiter.scala 21:28]
  wire  _T_36 = 4'h5 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_5 = _T_36 & io_validity[5]; // @[DispatchArbiter.scala 19:28]
  wire  _T_39 = 4'h5 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_5 = _T_39 & io_validity[5]; // @[DispatchArbiter.scala 21:28]
  wire  _T_42 = 4'h4 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_4 = _T_42 & io_validity[4]; // @[DispatchArbiter.scala 19:28]
  wire  _T_45 = 4'h4 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_4 = _T_45 & io_validity[4]; // @[DispatchArbiter.scala 21:28]
  wire  _T_48 = 4'h3 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_3 = _T_48 & io_validity[3]; // @[DispatchArbiter.scala 19:28]
  wire  _T_51 = 4'h3 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_3 = _T_51 & io_validity[3]; // @[DispatchArbiter.scala 21:28]
  wire  _T_54 = 4'h2 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_2 = _T_54 & io_validity[2]; // @[DispatchArbiter.scala 19:28]
  wire  _T_57 = 4'h2 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_2 = _T_57 & io_validity[2]; // @[DispatchArbiter.scala 21:28]
  wire  _T_60 = 4'h1 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_1 = _T_60 & io_validity[1]; // @[DispatchArbiter.scala 19:28]
  wire  _T_63 = 4'h1 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_1 = _T_63 & io_validity[1]; // @[DispatchArbiter.scala 21:28]
  wire  _T_66 = 4'h0 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_0 = _T_66 & io_validity[0]; // @[DispatchArbiter.scala 19:28]
  wire  _T_69 = 4'h0 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_0 = _T_69 & io_validity[0]; // @[DispatchArbiter.scala 21:28]
  wire [3:0] _GEN_0 = afterPriority_10 ? 4'ha : 4'hb; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_1 = beforePriority_10 ? 4'ha : 4'hb; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_2 = afterPriority_9 ? 4'h9 : _GEN_0; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_3 = beforePriority_9 ? 4'h9 : _GEN_1; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_4 = afterPriority_8 ? 4'h8 : _GEN_2; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_5 = beforePriority_8 ? 4'h8 : _GEN_3; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_6 = afterPriority_7 ? 4'h7 : _GEN_4; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_7 = beforePriority_7 ? 4'h7 : _GEN_5; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_8 = afterPriority_6 ? 4'h6 : _GEN_6; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_9 = beforePriority_6 ? 4'h6 : _GEN_7; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_10 = afterPriority_5 ? 4'h5 : _GEN_8; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_11 = beforePriority_5 ? 4'h5 : _GEN_9; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_12 = afterPriority_4 ? 4'h4 : _GEN_10; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_13 = beforePriority_4 ? 4'h4 : _GEN_11; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_14 = afterPriority_3 ? 4'h3 : _GEN_12; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_15 = beforePriority_3 ? 4'h3 : _GEN_13; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_16 = afterPriority_2 ? 4'h2 : _GEN_14; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_17 = beforePriority_2 ? 4'h2 : _GEN_15; // @[DispatchArbiter.scala 33:40]
  wire [3:0] _GEN_18 = afterPriority_1 ? 4'h1 : _GEN_16; // @[DispatchArbiter.scala 30:29]
  wire [3:0] _GEN_19 = beforePriority_1 ? 4'h1 : _GEN_17; // @[DispatchArbiter.scala 33:40]
  wire [3:0] afterPriorityChosen = afterPriority_0 ? 4'h0 : _GEN_18; // @[DispatchArbiter.scala 30:29]
  wire [3:0] beforePriorityChosen = beforePriority_0 ? 4'h0 : _GEN_19; // @[DispatchArbiter.scala 33:40]
  wire  _T_73 = afterPriority_0 | afterPriority_1; // @[DispatchArbiter.scala 37:54]
  wire  _T_74 = _T_73 | afterPriority_2; // @[DispatchArbiter.scala 37:54]
  wire  _T_75 = _T_74 | afterPriority_3; // @[DispatchArbiter.scala 37:54]
  wire  _T_76 = _T_75 | afterPriority_4; // @[DispatchArbiter.scala 37:54]
  wire  _T_77 = _T_76 | afterPriority_5; // @[DispatchArbiter.scala 37:54]
  wire  _T_78 = _T_77 | afterPriority_6; // @[DispatchArbiter.scala 37:54]
  wire  _T_79 = _T_78 | afterPriority_7; // @[DispatchArbiter.scala 37:54]
  wire  _T_80 = _T_79 | afterPriority_8; // @[DispatchArbiter.scala 37:54]
  wire  _T_81 = _T_80 | afterPriority_9; // @[DispatchArbiter.scala 37:54]
  wire  _T_82 = _T_81 | afterPriority_10; // @[DispatchArbiter.scala 37:54]
  wire  afterPriorityExist = _T_82 | afterPriority_11; // @[DispatchArbiter.scala 37:54]
  wire  _T_84 = beforePriority_0 | beforePriority_1; // @[DispatchArbiter.scala 38:56]
  wire  _T_85 = _T_84 | beforePriority_2; // @[DispatchArbiter.scala 38:56]
  wire  _T_86 = _T_85 | beforePriority_3; // @[DispatchArbiter.scala 38:56]
  wire  _T_87 = _T_86 | beforePriority_4; // @[DispatchArbiter.scala 38:56]
  wire  _T_88 = _T_87 | beforePriority_5; // @[DispatchArbiter.scala 38:56]
  wire  _T_89 = _T_88 | beforePriority_6; // @[DispatchArbiter.scala 38:56]
  wire  _T_90 = _T_89 | beforePriority_7; // @[DispatchArbiter.scala 38:56]
  wire  _T_91 = _T_90 | beforePriority_8; // @[DispatchArbiter.scala 38:56]
  wire  _T_92 = _T_91 | beforePriority_9; // @[DispatchArbiter.scala 38:56]
  wire  _T_93 = _T_92 | beforePriority_10; // @[DispatchArbiter.scala 38:56]
  wire  beforePriorityExist = _T_93 | beforePriority_11; // @[DispatchArbiter.scala 38:56]
  assign io_chosen = afterPriorityExist ? afterPriorityChosen : beforePriorityChosen; // @[DispatchArbiter.scala 41:19]
  assign io_hasChosen = afterPriorityExist | beforePriorityExist; // @[DispatchArbiter.scala 40:22]
endmodule
module POSIT_Locality(
  input          clock,
  input          reset,
  output         io_request_ready,
  input          io_request_valid,
  input  [31:0]  io_request_bits_operands_0_value,
  input  [1:0]   io_request_bits_operands_0_mode,
  input  [31:0]  io_request_bits_operands_1_value,
  input  [1:0]   io_request_bits_operands_1_mode,
  input  [31:0]  io_request_bits_operands_2_value,
  input  [1:0]   io_request_bits_operands_2_mode,
  input  [2:0]   io_request_bits_inst,
  input  [1:0]   io_request_bits_mode,
  input  [7:0]   io_request_bits_wr_addr,
  input          io_mem_write_ready,
  output         io_mem_write_valid,
  output         io_mem_write_bits_result_isZero,
  output         io_mem_write_bits_result_isNaR,
  output [31:0]  io_mem_write_bits_result_out,
  output         io_mem_write_bits_result_lt,
  output         io_mem_write_bits_result_eq,
  output         io_mem_write_bits_result_gt,
  output [4:0]   io_mem_write_bits_result_exceptions,
  output [7:0]   io_mem_write_bits_wr_addr,
  output         io_mem_read_req_valid,
  output [41:0]  io_mem_read_req_addr,
  output [15:0]  io_mem_read_req_tag,
  input  [511:0] io_mem_read_data,
  input          io_mem_read_resp_valid,
  input  [13:0]  io_mem_read_resp_tag
);
  wire  pe_clock; // @[POSIT_Locality.scala 12:24]
  wire  pe_reset; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_request_ready; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_request_valid; // @[POSIT_Locality.scala 12:24]
  wire [31:0] pe_io_request_bits_num1; // @[POSIT_Locality.scala 12:24]
  wire [31:0] pe_io_request_bits_num2; // @[POSIT_Locality.scala 12:24]
  wire [31:0] pe_io_request_bits_num3; // @[POSIT_Locality.scala 12:24]
  wire [2:0] pe_io_request_bits_inst; // @[POSIT_Locality.scala 12:24]
  wire [1:0] pe_io_request_bits_mode; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_result_ready; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_result_valid; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_result_bits_isZero; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_result_bits_isNaR; // @[POSIT_Locality.scala 12:24]
  wire [31:0] pe_io_result_bits_out; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_result_bits_lt; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_result_bits_eq; // @[POSIT_Locality.scala 12:24]
  wire  pe_io_result_bits_gt; // @[POSIT_Locality.scala 12:24]
  wire [4:0] pe_io_result_bits_exceptions; // @[POSIT_Locality.scala 12:24]
  wire [1:0] pe_io_in_idx; // @[POSIT_Locality.scala 12:24]
  wire [1:0] pe_io_out_idx; // @[POSIT_Locality.scala 12:24]
  wire [3:0] dispatchArb_io_validity; // @[POSIT_Locality.scala 59:33]
  wire [1:0] dispatchArb_io_priority; // @[POSIT_Locality.scala 59:33]
  wire [1:0] dispatchArb_io_chosen; // @[POSIT_Locality.scala 59:33]
  wire  dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 59:33]
  wire [11:0] fetchArb_io_validity; // @[POSIT_Locality.scala 172:30]
  wire [3:0] fetchArb_io_priority; // @[POSIT_Locality.scala 172:30]
  wire [3:0] fetchArb_io_chosen; // @[POSIT_Locality.scala 172:30]
  wire  fetchArb_io_hasChosen; // @[POSIT_Locality.scala 172:30]
  reg  rb_entries_0_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_0;
  reg  rb_entries_0_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_1;
  reg  rb_entries_0_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_2;
  reg  rb_entries_0_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_3;
  reg [7:0] rb_entries_0_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_4;
  reg [31:0] rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_5;
  reg [1:0] rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_6;
  reg [31:0] rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_7;
  reg [1:0] rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_8;
  reg [31:0] rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_9;
  reg [1:0] rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_10;
  reg [2:0] rb_entries_0_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_11;
  reg [1:0] rb_entries_0_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_12;
  reg  rb_entries_0_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_13;
  reg  rb_entries_0_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_14;
  reg [31:0] rb_entries_0_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_15;
  reg  rb_entries_0_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_16;
  reg  rb_entries_0_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_17;
  reg  rb_entries_0_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_18;
  reg [4:0] rb_entries_0_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_19;
  reg  rb_entries_1_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_20;
  reg  rb_entries_1_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_21;
  reg  rb_entries_1_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_22;
  reg  rb_entries_1_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_23;
  reg [7:0] rb_entries_1_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_24;
  reg [31:0] rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_25;
  reg [1:0] rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_26;
  reg [31:0] rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_27;
  reg [1:0] rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_28;
  reg [31:0] rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_29;
  reg [1:0] rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_30;
  reg [2:0] rb_entries_1_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_31;
  reg [1:0] rb_entries_1_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_32;
  reg  rb_entries_1_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_33;
  reg  rb_entries_1_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_34;
  reg [31:0] rb_entries_1_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_35;
  reg  rb_entries_1_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_36;
  reg  rb_entries_1_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_37;
  reg  rb_entries_1_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_38;
  reg [4:0] rb_entries_1_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_39;
  reg  rb_entries_2_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_40;
  reg  rb_entries_2_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_41;
  reg  rb_entries_2_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_42;
  reg  rb_entries_2_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_43;
  reg [7:0] rb_entries_2_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_44;
  reg [31:0] rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_45;
  reg [1:0] rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_46;
  reg [31:0] rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_47;
  reg [1:0] rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_48;
  reg [31:0] rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_49;
  reg [1:0] rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_50;
  reg [2:0] rb_entries_2_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_51;
  reg [1:0] rb_entries_2_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_52;
  reg  rb_entries_2_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_53;
  reg  rb_entries_2_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_54;
  reg [31:0] rb_entries_2_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_55;
  reg  rb_entries_2_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_56;
  reg  rb_entries_2_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_57;
  reg  rb_entries_2_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_58;
  reg [4:0] rb_entries_2_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_59;
  reg  rb_entries_3_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_60;
  reg  rb_entries_3_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_61;
  reg  rb_entries_3_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_62;
  reg  rb_entries_3_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_63;
  reg [7:0] rb_entries_3_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_64;
  reg [31:0] rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_65;
  reg [1:0] rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_66;
  reg [31:0] rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_67;
  reg [1:0] rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_68;
  reg [31:0] rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_69;
  reg [1:0] rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_70;
  reg [2:0] rb_entries_3_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_71;
  reg [1:0] rb_entries_3_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_72;
  reg  rb_entries_3_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_73;
  reg  rb_entries_3_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_74;
  reg [31:0] rb_entries_3_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_75;
  reg  rb_entries_3_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_76;
  reg  rb_entries_3_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_77;
  reg  rb_entries_3_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_78;
  reg [4:0] rb_entries_3_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_79;
  wire  _GEN_37 = 2'h1 == io_request_bits_wr_addr[1:0] ? rb_entries_1_valid : rb_entries_0_valid; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_39 = 2'h1 == io_request_bits_wr_addr[1:0] ? rb_entries_1_written : rb_entries_0_written; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_67 = 2'h2 == io_request_bits_wr_addr[1:0] ? rb_entries_2_valid : _GEN_37; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_69 = 2'h2 == io_request_bits_wr_addr[1:0] ? rb_entries_2_written : _GEN_39; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_97 = 2'h3 == io_request_bits_wr_addr[1:0] ? rb_entries_3_valid : _GEN_67; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_99 = 2'h3 == io_request_bits_wr_addr[1:0] ? rb_entries_3_written : _GEN_69; // @[POSIT_Locality.scala 21:80]
  wire  _T_3 = ~_GEN_97; // @[POSIT_Locality.scala 21:80]
  wire  _T_4 = _GEN_99 | _T_3; // @[POSIT_Locality.scala 21:77]
  wire  new_input_log = io_request_valid & _T_4; // @[POSIT_Locality.scala 21:43]
  wire  _T_11 = ~reset; // @[POSIT_Locality.scala 26:23]
  wire  _GEN_480 = 2'h0 == io_request_bits_wr_addr[1:0] ? 1'h0 : rb_entries_0_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_481 = 2'h1 == io_request_bits_wr_addr[1:0] ? 1'h0 : rb_entries_1_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_482 = 2'h2 == io_request_bits_wr_addr[1:0] ? 1'h0 : rb_entries_2_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_483 = 2'h3 == io_request_bits_wr_addr[1:0] ? 1'h0 : rb_entries_3_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_3970 = 2'h0 == io_request_bits_wr_addr[1:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_484 = _GEN_3970 | rb_entries_0_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_3971 = 2'h1 == io_request_bits_wr_addr[1:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_485 = _GEN_3971 | rb_entries_1_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_3972 = 2'h2 == io_request_bits_wr_addr[1:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_486 = _GEN_3972 | rb_entries_2_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_3973 = 2'h3 == io_request_bits_wr_addr[1:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_487 = _GEN_3973 | rb_entries_3_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_488 = 2'h0 == io_request_bits_wr_addr[1:0] ? 1'h0 : rb_entries_0_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_489 = 2'h1 == io_request_bits_wr_addr[1:0] ? 1'h0 : rb_entries_1_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_490 = 2'h2 == io_request_bits_wr_addr[1:0] ? 1'h0 : rb_entries_2_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_491 = 2'h3 == io_request_bits_wr_addr[1:0] ? 1'h0 : rb_entries_3_written; // @[POSIT_Locality.scala 29:47]
  wire [31:0] _GEN_504 = 2'h0 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_0_value : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_505 = 2'h1 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_0_value : rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_506 = 2'h2 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_0_value : rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_507 = 2'h3 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_0_value : rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [1:0] _GEN_508 = 2'h0 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_0_mode : rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_509 = 2'h1 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_0_mode : rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_510 = 2'h2 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_0_mode : rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_511 = 2'h3 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_0_mode : rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [31:0] _GEN_512 = 2'h0 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_1_value : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_513 = 2'h1 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_1_value : rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_514 = 2'h2 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_1_value : rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_515 = 2'h3 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_1_value : rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [1:0] _GEN_516 = 2'h0 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_1_mode : rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_517 = 2'h1 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_1_mode : rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_518 = 2'h2 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_1_mode : rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_519 = 2'h3 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_1_mode : rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [31:0] _GEN_520 = 2'h0 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_2_value : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_521 = 2'h1 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_2_value : rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_522 = 2'h2 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_2_value : rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_523 = 2'h3 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_2_value : rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [1:0] _GEN_524 = 2'h0 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_2_mode : rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_525 = 2'h1 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_2_mode : rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_526 = 2'h2 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_2_mode : rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_527 = 2'h3 == io_request_bits_wr_addr[1:0] ? io_request_bits_operands_2_mode : rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire  _GEN_556 = new_input_log ? _GEN_480 : rb_entries_0_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_557 = new_input_log ? _GEN_481 : rb_entries_1_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_558 = new_input_log ? _GEN_482 : rb_entries_2_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_559 = new_input_log ? _GEN_483 : rb_entries_3_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_564 = new_input_log ? _GEN_488 : rb_entries_0_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_565 = new_input_log ? _GEN_489 : rb_entries_1_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_566 = new_input_log ? _GEN_490 : rb_entries_2_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_567 = new_input_log ? _GEN_491 : rb_entries_3_written; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_580 = new_input_log ? _GEN_504 : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_581 = new_input_log ? _GEN_505 : rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_582 = new_input_log ? _GEN_506 : rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_583 = new_input_log ? _GEN_507 : rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_584 = new_input_log ? _GEN_508 : rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_585 = new_input_log ? _GEN_509 : rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_586 = new_input_log ? _GEN_510 : rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_587 = new_input_log ? _GEN_511 : rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_588 = new_input_log ? _GEN_512 : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_589 = new_input_log ? _GEN_513 : rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_590 = new_input_log ? _GEN_514 : rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_591 = new_input_log ? _GEN_515 : rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_592 = new_input_log ? _GEN_516 : rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_593 = new_input_log ? _GEN_517 : rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_594 = new_input_log ? _GEN_518 : rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_595 = new_input_log ? _GEN_519 : rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_596 = new_input_log ? _GEN_520 : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_597 = new_input_log ? _GEN_521 : rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_598 = new_input_log ? _GEN_522 : rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_599 = new_input_log ? _GEN_523 : rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_600 = new_input_log ? _GEN_524 : rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_601 = new_input_log ? _GEN_525 : rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_602 = new_input_log ? _GEN_526 : rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_603 = new_input_log ? _GEN_527 : rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_80;
  wire [1:0] _T_35 = value + 2'h1; // @[Counter.scala 39:22]
  wire  _GEN_670 = 2'h1 == value ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_700 = 2'h2 == value ? rb_entries_2_completed : _GEN_670; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_730 = 2'h3 == value ? rb_entries_3_completed : _GEN_700; // @[POSIT_Locality.scala 45:33]
  wire  _T_36 = io_mem_write_ready & _GEN_730; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_673 = 2'h1 == value ? rb_entries_1_written : rb_entries_0_written; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_703 = 2'h2 == value ? rb_entries_2_written : _GEN_673; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_733 = 2'h3 == value ? rb_entries_3_written : _GEN_703; // @[POSIT_Locality.scala 45:33]
  wire  _T_37 = ~_GEN_733; // @[POSIT_Locality.scala 45:72]
  wire  wbCountOn = _T_36 & _T_37; // @[POSIT_Locality.scala 45:68]
  wire [7:0] _GEN_674 = 2'h1 == value ? rb_entries_1_wr_addr : rb_entries_0_wr_addr; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_687 = 2'h1 == value ? rb_entries_1_result_isZero : rb_entries_0_result_isZero; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_688 = 2'h1 == value ? rb_entries_1_result_isNaR : rb_entries_0_result_isNaR; // @[POSIT_Locality.scala 45:33]
  wire [31:0] _GEN_689 = 2'h1 == value ? rb_entries_1_result_out : rb_entries_0_result_out; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_690 = 2'h1 == value ? rb_entries_1_result_lt : rb_entries_0_result_lt; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_691 = 2'h1 == value ? rb_entries_1_result_eq : rb_entries_0_result_eq; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_692 = 2'h1 == value ? rb_entries_1_result_gt : rb_entries_0_result_gt; // @[POSIT_Locality.scala 45:33]
  wire [4:0] _GEN_693 = 2'h1 == value ? rb_entries_1_result_exceptions : rb_entries_0_result_exceptions; // @[POSIT_Locality.scala 45:33]
  wire [7:0] _GEN_704 = 2'h2 == value ? rb_entries_2_wr_addr : _GEN_674; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_717 = 2'h2 == value ? rb_entries_2_result_isZero : _GEN_687; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_718 = 2'h2 == value ? rb_entries_2_result_isNaR : _GEN_688; // @[POSIT_Locality.scala 45:33]
  wire [31:0] _GEN_719 = 2'h2 == value ? rb_entries_2_result_out : _GEN_689; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_720 = 2'h2 == value ? rb_entries_2_result_lt : _GEN_690; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_721 = 2'h2 == value ? rb_entries_2_result_eq : _GEN_691; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_722 = 2'h2 == value ? rb_entries_2_result_gt : _GEN_692; // @[POSIT_Locality.scala 45:33]
  wire [4:0] _GEN_723 = 2'h2 == value ? rb_entries_2_result_exceptions : _GEN_693; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_3974 = 2'h0 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_754 = _GEN_3974 | _GEN_564; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_3975 = 2'h1 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_755 = _GEN_3975 | _GEN_565; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_3976 = 2'h2 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_756 = _GEN_3976 | _GEN_566; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_3977 = 2'h3 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_757 = _GEN_3977 | _GEN_567; // @[POSIT_Locality.scala 47:47]
  wire  singleOpValidVec_0 = rb_entries_0_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 68:52]
  wire  _T_42 = rb_entries_0_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_1 = singleOpValidVec_0 & _T_42; // @[POSIT_Locality.scala 70:96]
  wire  _T_44 = rb_entries_0_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_2 = singleOpValidVec_1 & _T_44; // @[POSIT_Locality.scala 70:96]
  wire  singleOpValidVec_3 = rb_entries_1_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 68:52]
  wire  _T_47 = rb_entries_1_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_4 = singleOpValidVec_3 & _T_47; // @[POSIT_Locality.scala 70:96]
  wire  _T_49 = rb_entries_1_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_5 = singleOpValidVec_4 & _T_49; // @[POSIT_Locality.scala 70:96]
  wire  singleOpValidVec_6 = rb_entries_2_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 68:52]
  wire  _T_52 = rb_entries_2_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_7 = singleOpValidVec_6 & _T_52; // @[POSIT_Locality.scala 70:96]
  wire  _T_54 = rb_entries_2_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_8 = singleOpValidVec_7 & _T_54; // @[POSIT_Locality.scala 70:96]
  wire  singleOpValidVec_9 = rb_entries_3_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 68:52]
  wire  _T_57 = rb_entries_3_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_10 = singleOpValidVec_9 & _T_57; // @[POSIT_Locality.scala 70:96]
  wire  _T_59 = rb_entries_3_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_11 = singleOpValidVec_10 & _T_59; // @[POSIT_Locality.scala 70:96]
  wire  _T_61 = singleOpValidVec_2 & rb_entries_0_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_62 = ~rb_entries_0_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_0 = _T_61 & _T_62; // @[POSIT_Locality.scala 76:82]
  wire  _T_64 = singleOpValidVec_5 & rb_entries_1_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_65 = ~rb_entries_1_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_1 = _T_64 & _T_65; // @[POSIT_Locality.scala 76:82]
  wire  _T_67 = singleOpValidVec_8 & rb_entries_2_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_68 = ~rb_entries_2_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_2 = _T_67 & _T_68; // @[POSIT_Locality.scala 76:82]
  wire  _T_70 = singleOpValidVec_11 & rb_entries_3_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_71 = ~rb_entries_3_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_3 = _T_70 & _T_71; // @[POSIT_Locality.scala 76:82]
  wire [1:0] _T_73 = {waitingForDispatchVec_1,waitingForDispatchVec_0}; // @[POSIT_Locality.scala 80:58]
  wire [1:0] _T_74 = {waitingForDispatchVec_3,waitingForDispatchVec_2}; // @[POSIT_Locality.scala 80:58]
  wire  _T_76 = io_request_bits_wr_addr == 8'h0; // @[POSIT_Locality.scala 85:32]
  wire  _T_77 = _T_76 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_78 = dispatchArb_io_chosen == 2'h0; // @[POSIT_Locality.scala 88:89]
  wire  _T_79 = _T_78 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_80 = _T_79 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_81 = rb_entries_0_dispatched | _T_80; // @[POSIT_Locality.scala 88:78]
  wire  _T_82 = io_request_bits_wr_addr == 8'h1; // @[POSIT_Locality.scala 85:32]
  wire  _T_83 = _T_82 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_84 = dispatchArb_io_chosen == 2'h1; // @[POSIT_Locality.scala 88:89]
  wire  _T_85 = _T_84 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_86 = _T_85 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_87 = rb_entries_1_dispatched | _T_86; // @[POSIT_Locality.scala 88:78]
  wire  _T_88 = io_request_bits_wr_addr == 8'h2; // @[POSIT_Locality.scala 85:32]
  wire  _T_89 = _T_88 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_90 = dispatchArb_io_chosen == 2'h2; // @[POSIT_Locality.scala 88:89]
  wire  _T_91 = _T_90 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_92 = _T_91 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_93 = rb_entries_2_dispatched | _T_92; // @[POSIT_Locality.scala 88:78]
  wire  _T_94 = io_request_bits_wr_addr == 8'h3; // @[POSIT_Locality.scala 85:32]
  wire  _T_95 = _T_94 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_96 = dispatchArb_io_chosen == 2'h3; // @[POSIT_Locality.scala 88:89]
  wire  _T_97 = _T_96 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_98 = _T_97 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_99 = rb_entries_3_dispatched | _T_98; // @[POSIT_Locality.scala 88:78]
  wire [31:0] _GEN_809 = 2'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_0_value : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_811 = 2'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_1_value : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_813 = 2'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_2_value : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_815 = 2'h1 == dispatchArb_io_chosen ? rb_entries_1_request_inst : rb_entries_0_request_inst; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_816 = 2'h1 == dispatchArb_io_chosen ? rb_entries_1_request_mode : rb_entries_0_request_mode; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_839 = 2'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_0_value : _GEN_809; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_841 = 2'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_1_value : _GEN_811; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_843 = 2'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_2_value : _GEN_813; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_845 = 2'h2 == dispatchArb_io_chosen ? rb_entries_2_request_inst : _GEN_815; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_846 = 2'h2 == dispatchArb_io_chosen ? rb_entries_2_request_mode : _GEN_816; // @[POSIT_Locality.scala 100:80]
  wire  _T_104 = pe_io_result_ready & pe_io_result_valid; // @[POSIT_Locality.scala 108:33]
  wire [1:0] result_idx = pe_io_out_idx; // @[POSIT_Locality.scala 106:30 POSIT_Locality.scala 107:20]
  wire [4:0] _rb_entries_result_idx_result_exceptions = pe_io_result_bits_exceptions; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_gt = pe_io_result_bits_gt; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_eq = pe_io_result_bits_eq; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_lt = pe_io_result_bits_lt; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire [31:0] _rb_entries_result_idx_result_out = pe_io_result_bits_out; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_isNaR = pe_io_result_bits_isNaR; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_isZero = pe_io_result_bits_isZero; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _GEN_3978 = 2'h0 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_916 = _GEN_3978 | _GEN_556; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_3979 = 2'h1 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_917 = _GEN_3979 | _GEN_557; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_3980 = 2'h2 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_918 = _GEN_3980 | _GEN_558; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_3981 = 2'h3 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_919 = _GEN_3981 | _GEN_559; // @[POSIT_Locality.scala 110:50]
  wire  _T_105 = rb_entries_0_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_988 = 2'h1 == rb_entries_0_request_operands_0_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1018 = 2'h2 == rb_entries_0_request_operands_0_value[1:0] ? rb_entries_2_completed : _GEN_988; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1048 = 2'h3 == rb_entries_0_request_operands_0_value[1:0] ? rb_entries_3_completed : _GEN_1018; // @[POSIT_Locality.scala 117:100]
  wire  _T_108 = rb_entries_0_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_1232 = 2'h1 == rb_entries_0_request_operands_1_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1262 = 2'h2 == rb_entries_0_request_operands_1_value[1:0] ? rb_entries_2_completed : _GEN_1232; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1292 = 2'h3 == rb_entries_0_request_operands_1_value[1:0] ? rb_entries_3_completed : _GEN_1262; // @[POSIT_Locality.scala 117:100]
  wire  _T_111 = rb_entries_0_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_1476 = 2'h1 == rb_entries_0_request_operands_2_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1506 = 2'h2 == rb_entries_0_request_operands_2_value[1:0] ? rb_entries_2_completed : _GEN_1476; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1536 = 2'h3 == rb_entries_0_request_operands_2_value[1:0] ? rb_entries_3_completed : _GEN_1506; // @[POSIT_Locality.scala 117:100]
  wire  _T_114 = rb_entries_1_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_1720 = 2'h1 == rb_entries_1_request_operands_0_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1750 = 2'h2 == rb_entries_1_request_operands_0_value[1:0] ? rb_entries_2_completed : _GEN_1720; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1780 = 2'h3 == rb_entries_1_request_operands_0_value[1:0] ? rb_entries_3_completed : _GEN_1750; // @[POSIT_Locality.scala 117:100]
  wire  _T_117 = rb_entries_1_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_1964 = 2'h1 == rb_entries_1_request_operands_1_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1994 = 2'h2 == rb_entries_1_request_operands_1_value[1:0] ? rb_entries_2_completed : _GEN_1964; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2024 = 2'h3 == rb_entries_1_request_operands_1_value[1:0] ? rb_entries_3_completed : _GEN_1994; // @[POSIT_Locality.scala 117:100]
  wire  _T_120 = rb_entries_1_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_2208 = 2'h1 == rb_entries_1_request_operands_2_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2238 = 2'h2 == rb_entries_1_request_operands_2_value[1:0] ? rb_entries_2_completed : _GEN_2208; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2268 = 2'h3 == rb_entries_1_request_operands_2_value[1:0] ? rb_entries_3_completed : _GEN_2238; // @[POSIT_Locality.scala 117:100]
  wire  _T_123 = rb_entries_2_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_2452 = 2'h1 == rb_entries_2_request_operands_0_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2482 = 2'h2 == rb_entries_2_request_operands_0_value[1:0] ? rb_entries_2_completed : _GEN_2452; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2512 = 2'h3 == rb_entries_2_request_operands_0_value[1:0] ? rb_entries_3_completed : _GEN_2482; // @[POSIT_Locality.scala 117:100]
  wire  _T_126 = rb_entries_2_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_2696 = 2'h1 == rb_entries_2_request_operands_1_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2726 = 2'h2 == rb_entries_2_request_operands_1_value[1:0] ? rb_entries_2_completed : _GEN_2696; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2756 = 2'h3 == rb_entries_2_request_operands_1_value[1:0] ? rb_entries_3_completed : _GEN_2726; // @[POSIT_Locality.scala 117:100]
  wire  _T_129 = rb_entries_2_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_2940 = 2'h1 == rb_entries_2_request_operands_2_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2970 = 2'h2 == rb_entries_2_request_operands_2_value[1:0] ? rb_entries_2_completed : _GEN_2940; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3000 = 2'h3 == rb_entries_2_request_operands_2_value[1:0] ? rb_entries_3_completed : _GEN_2970; // @[POSIT_Locality.scala 117:100]
  wire  _T_132 = rb_entries_3_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_3184 = 2'h1 == rb_entries_3_request_operands_0_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3214 = 2'h2 == rb_entries_3_request_operands_0_value[1:0] ? rb_entries_2_completed : _GEN_3184; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3244 = 2'h3 == rb_entries_3_request_operands_0_value[1:0] ? rb_entries_3_completed : _GEN_3214; // @[POSIT_Locality.scala 117:100]
  wire  _T_135 = rb_entries_3_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_3428 = 2'h1 == rb_entries_3_request_operands_1_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3458 = 2'h2 == rb_entries_3_request_operands_1_value[1:0] ? rb_entries_2_completed : _GEN_3428; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3488 = 2'h3 == rb_entries_3_request_operands_1_value[1:0] ? rb_entries_3_completed : _GEN_3458; // @[POSIT_Locality.scala 117:100]
  wire  _T_138 = rb_entries_3_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_3672 = 2'h1 == rb_entries_3_request_operands_2_value[1:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3702 = 2'h2 == rb_entries_3_request_operands_2_value[1:0] ? rb_entries_2_completed : _GEN_3672; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3732 = 2'h3 == rb_entries_3_request_operands_2_value[1:0] ? rb_entries_3_completed : _GEN_3702; // @[POSIT_Locality.scala 117:100]
  reg [1:0] reg_infetch_cacheline; // @[POSIT_Locality.scala 127:45]
  reg [31:0] _RAND_81;
  wire  _T_151 = 3'h7 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_152 = _T_151 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_153 = 3'h6 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_154 = _T_153 ? io_mem_read_data[417] : _T_152; // @[Mux.scala 68:16]
  wire  _T_155 = 3'h5 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_156 = _T_155 ? io_mem_read_data[353] : _T_154; // @[Mux.scala 68:16]
  wire  _T_157 = 3'h4 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_158 = _T_157 ? io_mem_read_data[289] : _T_156; // @[Mux.scala 68:16]
  wire  _T_159 = 3'h3 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_160 = _T_159 ? io_mem_read_data[225] : _T_158; // @[Mux.scala 68:16]
  wire  _T_161 = 3'h2 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_162 = _T_161 ? io_mem_read_data[161] : _T_160; // @[Mux.scala 68:16]
  wire  _T_163 = 3'h1 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_164 = _T_163 ? io_mem_read_data[97] : _T_162; // @[Mux.scala 68:16]
  wire  _T_165 = 3'h0 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_166 = _T_165 ? io_mem_read_data[33] : _T_164; // @[Mux.scala 68:16]
  wire  _T_177 = _T_151 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_179 = _T_153 ? io_mem_read_data[416] : _T_177; // @[Mux.scala 68:16]
  wire  _T_181 = _T_155 ? io_mem_read_data[352] : _T_179; // @[Mux.scala 68:16]
  wire  _T_183 = _T_157 ? io_mem_read_data[288] : _T_181; // @[Mux.scala 68:16]
  wire  _T_185 = _T_159 ? io_mem_read_data[224] : _T_183; // @[Mux.scala 68:16]
  wire  _T_187 = _T_161 ? io_mem_read_data[160] : _T_185; // @[Mux.scala 68:16]
  wire  _T_189 = _T_163 ? io_mem_read_data[96] : _T_187; // @[Mux.scala 68:16]
  wire  _T_191 = _T_165 ? io_mem_read_data[32] : _T_189; // @[Mux.scala 68:16]
  wire  _T_194 = rb_entries_0_request_operands_0_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_196 = _T_194 & _T_166; // @[POSIT_Locality.scala 138:49]
  wire  _T_198 = _T_191 == rb_entries_0_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_199 = _T_196 & _T_198; // @[POSIT_Locality.scala 139:49]
  wire  _T_237 = 3'h7 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_238 = _T_237 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_239 = 3'h6 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_240 = _T_239 ? io_mem_read_data[417] : _T_238; // @[Mux.scala 68:16]
  wire  _T_241 = 3'h5 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_242 = _T_241 ? io_mem_read_data[353] : _T_240; // @[Mux.scala 68:16]
  wire  _T_243 = 3'h4 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_244 = _T_243 ? io_mem_read_data[289] : _T_242; // @[Mux.scala 68:16]
  wire  _T_245 = 3'h3 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_246 = _T_245 ? io_mem_read_data[225] : _T_244; // @[Mux.scala 68:16]
  wire  _T_247 = 3'h2 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_248 = _T_247 ? io_mem_read_data[161] : _T_246; // @[Mux.scala 68:16]
  wire  _T_249 = 3'h1 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_250 = _T_249 ? io_mem_read_data[97] : _T_248; // @[Mux.scala 68:16]
  wire  _T_251 = 3'h0 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_252 = _T_251 ? io_mem_read_data[33] : _T_250; // @[Mux.scala 68:16]
  wire  _T_263 = _T_237 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_265 = _T_239 ? io_mem_read_data[416] : _T_263; // @[Mux.scala 68:16]
  wire  _T_267 = _T_241 ? io_mem_read_data[352] : _T_265; // @[Mux.scala 68:16]
  wire  _T_269 = _T_243 ? io_mem_read_data[288] : _T_267; // @[Mux.scala 68:16]
  wire  _T_271 = _T_245 ? io_mem_read_data[224] : _T_269; // @[Mux.scala 68:16]
  wire  _T_273 = _T_247 ? io_mem_read_data[160] : _T_271; // @[Mux.scala 68:16]
  wire  _T_275 = _T_249 ? io_mem_read_data[96] : _T_273; // @[Mux.scala 68:16]
  wire  _T_277 = _T_251 ? io_mem_read_data[32] : _T_275; // @[Mux.scala 68:16]
  wire  _T_280 = rb_entries_0_request_operands_1_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_282 = _T_280 & _T_252; // @[POSIT_Locality.scala 138:49]
  wire  _T_284 = _T_277 == rb_entries_0_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_285 = _T_282 & _T_284; // @[POSIT_Locality.scala 139:49]
  wire  _T_323 = 3'h7 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_324 = _T_323 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_325 = 3'h6 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_326 = _T_325 ? io_mem_read_data[417] : _T_324; // @[Mux.scala 68:16]
  wire  _T_327 = 3'h5 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_328 = _T_327 ? io_mem_read_data[353] : _T_326; // @[Mux.scala 68:16]
  wire  _T_329 = 3'h4 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_330 = _T_329 ? io_mem_read_data[289] : _T_328; // @[Mux.scala 68:16]
  wire  _T_331 = 3'h3 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_332 = _T_331 ? io_mem_read_data[225] : _T_330; // @[Mux.scala 68:16]
  wire  _T_333 = 3'h2 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_334 = _T_333 ? io_mem_read_data[161] : _T_332; // @[Mux.scala 68:16]
  wire  _T_335 = 3'h1 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_336 = _T_335 ? io_mem_read_data[97] : _T_334; // @[Mux.scala 68:16]
  wire  _T_337 = 3'h0 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_338 = _T_337 ? io_mem_read_data[33] : _T_336; // @[Mux.scala 68:16]
  wire  _T_349 = _T_323 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_351 = _T_325 ? io_mem_read_data[416] : _T_349; // @[Mux.scala 68:16]
  wire  _T_353 = _T_327 ? io_mem_read_data[352] : _T_351; // @[Mux.scala 68:16]
  wire  _T_355 = _T_329 ? io_mem_read_data[288] : _T_353; // @[Mux.scala 68:16]
  wire  _T_357 = _T_331 ? io_mem_read_data[224] : _T_355; // @[Mux.scala 68:16]
  wire  _T_359 = _T_333 ? io_mem_read_data[160] : _T_357; // @[Mux.scala 68:16]
  wire  _T_361 = _T_335 ? io_mem_read_data[96] : _T_359; // @[Mux.scala 68:16]
  wire  _T_363 = _T_337 ? io_mem_read_data[32] : _T_361; // @[Mux.scala 68:16]
  wire  _T_366 = rb_entries_0_request_operands_2_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_368 = _T_366 & _T_338; // @[POSIT_Locality.scala 138:49]
  wire  _T_370 = _T_363 == rb_entries_0_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_371 = _T_368 & _T_370; // @[POSIT_Locality.scala 139:49]
  wire  _T_409 = 3'h7 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_410 = _T_409 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_411 = 3'h6 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_412 = _T_411 ? io_mem_read_data[417] : _T_410; // @[Mux.scala 68:16]
  wire  _T_413 = 3'h5 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_414 = _T_413 ? io_mem_read_data[353] : _T_412; // @[Mux.scala 68:16]
  wire  _T_415 = 3'h4 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_416 = _T_415 ? io_mem_read_data[289] : _T_414; // @[Mux.scala 68:16]
  wire  _T_417 = 3'h3 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_418 = _T_417 ? io_mem_read_data[225] : _T_416; // @[Mux.scala 68:16]
  wire  _T_419 = 3'h2 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_420 = _T_419 ? io_mem_read_data[161] : _T_418; // @[Mux.scala 68:16]
  wire  _T_421 = 3'h1 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_422 = _T_421 ? io_mem_read_data[97] : _T_420; // @[Mux.scala 68:16]
  wire  _T_423 = 3'h0 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_424 = _T_423 ? io_mem_read_data[33] : _T_422; // @[Mux.scala 68:16]
  wire  _T_435 = _T_409 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_437 = _T_411 ? io_mem_read_data[416] : _T_435; // @[Mux.scala 68:16]
  wire  _T_439 = _T_413 ? io_mem_read_data[352] : _T_437; // @[Mux.scala 68:16]
  wire  _T_441 = _T_415 ? io_mem_read_data[288] : _T_439; // @[Mux.scala 68:16]
  wire  _T_443 = _T_417 ? io_mem_read_data[224] : _T_441; // @[Mux.scala 68:16]
  wire  _T_445 = _T_419 ? io_mem_read_data[160] : _T_443; // @[Mux.scala 68:16]
  wire  _T_447 = _T_421 ? io_mem_read_data[96] : _T_445; // @[Mux.scala 68:16]
  wire  _T_449 = _T_423 ? io_mem_read_data[32] : _T_447; // @[Mux.scala 68:16]
  wire  _T_452 = rb_entries_1_request_operands_0_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_454 = _T_452 & _T_424; // @[POSIT_Locality.scala 138:49]
  wire  _T_456 = _T_449 == rb_entries_1_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_457 = _T_454 & _T_456; // @[POSIT_Locality.scala 139:49]
  wire  _T_495 = 3'h7 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_496 = _T_495 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_497 = 3'h6 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_498 = _T_497 ? io_mem_read_data[417] : _T_496; // @[Mux.scala 68:16]
  wire  _T_499 = 3'h5 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_500 = _T_499 ? io_mem_read_data[353] : _T_498; // @[Mux.scala 68:16]
  wire  _T_501 = 3'h4 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_502 = _T_501 ? io_mem_read_data[289] : _T_500; // @[Mux.scala 68:16]
  wire  _T_503 = 3'h3 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_504 = _T_503 ? io_mem_read_data[225] : _T_502; // @[Mux.scala 68:16]
  wire  _T_505 = 3'h2 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_506 = _T_505 ? io_mem_read_data[161] : _T_504; // @[Mux.scala 68:16]
  wire  _T_507 = 3'h1 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_508 = _T_507 ? io_mem_read_data[97] : _T_506; // @[Mux.scala 68:16]
  wire  _T_509 = 3'h0 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_510 = _T_509 ? io_mem_read_data[33] : _T_508; // @[Mux.scala 68:16]
  wire  _T_521 = _T_495 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_523 = _T_497 ? io_mem_read_data[416] : _T_521; // @[Mux.scala 68:16]
  wire  _T_525 = _T_499 ? io_mem_read_data[352] : _T_523; // @[Mux.scala 68:16]
  wire  _T_527 = _T_501 ? io_mem_read_data[288] : _T_525; // @[Mux.scala 68:16]
  wire  _T_529 = _T_503 ? io_mem_read_data[224] : _T_527; // @[Mux.scala 68:16]
  wire  _T_531 = _T_505 ? io_mem_read_data[160] : _T_529; // @[Mux.scala 68:16]
  wire  _T_533 = _T_507 ? io_mem_read_data[96] : _T_531; // @[Mux.scala 68:16]
  wire  _T_535 = _T_509 ? io_mem_read_data[32] : _T_533; // @[Mux.scala 68:16]
  wire  _T_538 = rb_entries_1_request_operands_1_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_540 = _T_538 & _T_510; // @[POSIT_Locality.scala 138:49]
  wire  _T_542 = _T_535 == rb_entries_1_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_543 = _T_540 & _T_542; // @[POSIT_Locality.scala 139:49]
  wire  _T_581 = 3'h7 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_582 = _T_581 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_583 = 3'h6 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_584 = _T_583 ? io_mem_read_data[417] : _T_582; // @[Mux.scala 68:16]
  wire  _T_585 = 3'h5 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_586 = _T_585 ? io_mem_read_data[353] : _T_584; // @[Mux.scala 68:16]
  wire  _T_587 = 3'h4 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_588 = _T_587 ? io_mem_read_data[289] : _T_586; // @[Mux.scala 68:16]
  wire  _T_589 = 3'h3 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_590 = _T_589 ? io_mem_read_data[225] : _T_588; // @[Mux.scala 68:16]
  wire  _T_591 = 3'h2 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_592 = _T_591 ? io_mem_read_data[161] : _T_590; // @[Mux.scala 68:16]
  wire  _T_593 = 3'h1 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_594 = _T_593 ? io_mem_read_data[97] : _T_592; // @[Mux.scala 68:16]
  wire  _T_595 = 3'h0 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_596 = _T_595 ? io_mem_read_data[33] : _T_594; // @[Mux.scala 68:16]
  wire  _T_607 = _T_581 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_609 = _T_583 ? io_mem_read_data[416] : _T_607; // @[Mux.scala 68:16]
  wire  _T_611 = _T_585 ? io_mem_read_data[352] : _T_609; // @[Mux.scala 68:16]
  wire  _T_613 = _T_587 ? io_mem_read_data[288] : _T_611; // @[Mux.scala 68:16]
  wire  _T_615 = _T_589 ? io_mem_read_data[224] : _T_613; // @[Mux.scala 68:16]
  wire  _T_617 = _T_591 ? io_mem_read_data[160] : _T_615; // @[Mux.scala 68:16]
  wire  _T_619 = _T_593 ? io_mem_read_data[96] : _T_617; // @[Mux.scala 68:16]
  wire  _T_621 = _T_595 ? io_mem_read_data[32] : _T_619; // @[Mux.scala 68:16]
  wire  _T_624 = rb_entries_1_request_operands_2_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_626 = _T_624 & _T_596; // @[POSIT_Locality.scala 138:49]
  wire  _T_628 = _T_621 == rb_entries_1_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_629 = _T_626 & _T_628; // @[POSIT_Locality.scala 139:49]
  wire  _T_667 = 3'h7 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_668 = _T_667 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_669 = 3'h6 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_670 = _T_669 ? io_mem_read_data[417] : _T_668; // @[Mux.scala 68:16]
  wire  _T_671 = 3'h5 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_672 = _T_671 ? io_mem_read_data[353] : _T_670; // @[Mux.scala 68:16]
  wire  _T_673 = 3'h4 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_674 = _T_673 ? io_mem_read_data[289] : _T_672; // @[Mux.scala 68:16]
  wire  _T_675 = 3'h3 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_676 = _T_675 ? io_mem_read_data[225] : _T_674; // @[Mux.scala 68:16]
  wire  _T_677 = 3'h2 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_678 = _T_677 ? io_mem_read_data[161] : _T_676; // @[Mux.scala 68:16]
  wire  _T_679 = 3'h1 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_680 = _T_679 ? io_mem_read_data[97] : _T_678; // @[Mux.scala 68:16]
  wire  _T_681 = 3'h0 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_682 = _T_681 ? io_mem_read_data[33] : _T_680; // @[Mux.scala 68:16]
  wire  _T_693 = _T_667 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_695 = _T_669 ? io_mem_read_data[416] : _T_693; // @[Mux.scala 68:16]
  wire  _T_697 = _T_671 ? io_mem_read_data[352] : _T_695; // @[Mux.scala 68:16]
  wire  _T_699 = _T_673 ? io_mem_read_data[288] : _T_697; // @[Mux.scala 68:16]
  wire  _T_701 = _T_675 ? io_mem_read_data[224] : _T_699; // @[Mux.scala 68:16]
  wire  _T_703 = _T_677 ? io_mem_read_data[160] : _T_701; // @[Mux.scala 68:16]
  wire  _T_705 = _T_679 ? io_mem_read_data[96] : _T_703; // @[Mux.scala 68:16]
  wire  _T_707 = _T_681 ? io_mem_read_data[32] : _T_705; // @[Mux.scala 68:16]
  wire  _T_710 = rb_entries_2_request_operands_0_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_712 = _T_710 & _T_682; // @[POSIT_Locality.scala 138:49]
  wire  _T_714 = _T_707 == rb_entries_2_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_715 = _T_712 & _T_714; // @[POSIT_Locality.scala 139:49]
  wire  _T_753 = 3'h7 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_754 = _T_753 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_755 = 3'h6 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_756 = _T_755 ? io_mem_read_data[417] : _T_754; // @[Mux.scala 68:16]
  wire  _T_757 = 3'h5 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_758 = _T_757 ? io_mem_read_data[353] : _T_756; // @[Mux.scala 68:16]
  wire  _T_759 = 3'h4 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_760 = _T_759 ? io_mem_read_data[289] : _T_758; // @[Mux.scala 68:16]
  wire  _T_761 = 3'h3 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_762 = _T_761 ? io_mem_read_data[225] : _T_760; // @[Mux.scala 68:16]
  wire  _T_763 = 3'h2 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_764 = _T_763 ? io_mem_read_data[161] : _T_762; // @[Mux.scala 68:16]
  wire  _T_765 = 3'h1 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_766 = _T_765 ? io_mem_read_data[97] : _T_764; // @[Mux.scala 68:16]
  wire  _T_767 = 3'h0 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_768 = _T_767 ? io_mem_read_data[33] : _T_766; // @[Mux.scala 68:16]
  wire  _T_779 = _T_753 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_781 = _T_755 ? io_mem_read_data[416] : _T_779; // @[Mux.scala 68:16]
  wire  _T_783 = _T_757 ? io_mem_read_data[352] : _T_781; // @[Mux.scala 68:16]
  wire  _T_785 = _T_759 ? io_mem_read_data[288] : _T_783; // @[Mux.scala 68:16]
  wire  _T_787 = _T_761 ? io_mem_read_data[224] : _T_785; // @[Mux.scala 68:16]
  wire  _T_789 = _T_763 ? io_mem_read_data[160] : _T_787; // @[Mux.scala 68:16]
  wire  _T_791 = _T_765 ? io_mem_read_data[96] : _T_789; // @[Mux.scala 68:16]
  wire  _T_793 = _T_767 ? io_mem_read_data[32] : _T_791; // @[Mux.scala 68:16]
  wire  _T_796 = rb_entries_2_request_operands_1_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_798 = _T_796 & _T_768; // @[POSIT_Locality.scala 138:49]
  wire  _T_800 = _T_793 == rb_entries_2_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_801 = _T_798 & _T_800; // @[POSIT_Locality.scala 139:49]
  wire  _T_839 = 3'h7 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_840 = _T_839 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_841 = 3'h6 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_842 = _T_841 ? io_mem_read_data[417] : _T_840; // @[Mux.scala 68:16]
  wire  _T_843 = 3'h5 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_844 = _T_843 ? io_mem_read_data[353] : _T_842; // @[Mux.scala 68:16]
  wire  _T_845 = 3'h4 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_846 = _T_845 ? io_mem_read_data[289] : _T_844; // @[Mux.scala 68:16]
  wire  _T_847 = 3'h3 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_848 = _T_847 ? io_mem_read_data[225] : _T_846; // @[Mux.scala 68:16]
  wire  _T_849 = 3'h2 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_850 = _T_849 ? io_mem_read_data[161] : _T_848; // @[Mux.scala 68:16]
  wire  _T_851 = 3'h1 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_852 = _T_851 ? io_mem_read_data[97] : _T_850; // @[Mux.scala 68:16]
  wire  _T_853 = 3'h0 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_854 = _T_853 ? io_mem_read_data[33] : _T_852; // @[Mux.scala 68:16]
  wire  _T_865 = _T_839 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_867 = _T_841 ? io_mem_read_data[416] : _T_865; // @[Mux.scala 68:16]
  wire  _T_869 = _T_843 ? io_mem_read_data[352] : _T_867; // @[Mux.scala 68:16]
  wire  _T_871 = _T_845 ? io_mem_read_data[288] : _T_869; // @[Mux.scala 68:16]
  wire  _T_873 = _T_847 ? io_mem_read_data[224] : _T_871; // @[Mux.scala 68:16]
  wire  _T_875 = _T_849 ? io_mem_read_data[160] : _T_873; // @[Mux.scala 68:16]
  wire  _T_877 = _T_851 ? io_mem_read_data[96] : _T_875; // @[Mux.scala 68:16]
  wire  _T_879 = _T_853 ? io_mem_read_data[32] : _T_877; // @[Mux.scala 68:16]
  wire  _T_882 = rb_entries_2_request_operands_2_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_884 = _T_882 & _T_854; // @[POSIT_Locality.scala 138:49]
  wire  _T_886 = _T_879 == rb_entries_2_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_887 = _T_884 & _T_886; // @[POSIT_Locality.scala 139:49]
  wire  _T_925 = 3'h7 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_926 = _T_925 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_927 = 3'h6 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_928 = _T_927 ? io_mem_read_data[417] : _T_926; // @[Mux.scala 68:16]
  wire  _T_929 = 3'h5 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_930 = _T_929 ? io_mem_read_data[353] : _T_928; // @[Mux.scala 68:16]
  wire  _T_931 = 3'h4 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_932 = _T_931 ? io_mem_read_data[289] : _T_930; // @[Mux.scala 68:16]
  wire  _T_933 = 3'h3 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_934 = _T_933 ? io_mem_read_data[225] : _T_932; // @[Mux.scala 68:16]
  wire  _T_935 = 3'h2 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_936 = _T_935 ? io_mem_read_data[161] : _T_934; // @[Mux.scala 68:16]
  wire  _T_937 = 3'h1 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_938 = _T_937 ? io_mem_read_data[97] : _T_936; // @[Mux.scala 68:16]
  wire  _T_939 = 3'h0 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_940 = _T_939 ? io_mem_read_data[33] : _T_938; // @[Mux.scala 68:16]
  wire  _T_951 = _T_925 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_953 = _T_927 ? io_mem_read_data[416] : _T_951; // @[Mux.scala 68:16]
  wire  _T_955 = _T_929 ? io_mem_read_data[352] : _T_953; // @[Mux.scala 68:16]
  wire  _T_957 = _T_931 ? io_mem_read_data[288] : _T_955; // @[Mux.scala 68:16]
  wire  _T_959 = _T_933 ? io_mem_read_data[224] : _T_957; // @[Mux.scala 68:16]
  wire  _T_961 = _T_935 ? io_mem_read_data[160] : _T_959; // @[Mux.scala 68:16]
  wire  _T_963 = _T_937 ? io_mem_read_data[96] : _T_961; // @[Mux.scala 68:16]
  wire  _T_965 = _T_939 ? io_mem_read_data[32] : _T_963; // @[Mux.scala 68:16]
  wire  _T_968 = rb_entries_3_request_operands_0_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_970 = _T_968 & _T_940; // @[POSIT_Locality.scala 138:49]
  wire  _T_972 = _T_965 == rb_entries_3_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_973 = _T_970 & _T_972; // @[POSIT_Locality.scala 139:49]
  wire  _T_1011 = 3'h7 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1012 = _T_1011 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1013 = 3'h6 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1014 = _T_1013 ? io_mem_read_data[417] : _T_1012; // @[Mux.scala 68:16]
  wire  _T_1015 = 3'h5 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1016 = _T_1015 ? io_mem_read_data[353] : _T_1014; // @[Mux.scala 68:16]
  wire  _T_1017 = 3'h4 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1018 = _T_1017 ? io_mem_read_data[289] : _T_1016; // @[Mux.scala 68:16]
  wire  _T_1019 = 3'h3 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1020 = _T_1019 ? io_mem_read_data[225] : _T_1018; // @[Mux.scala 68:16]
  wire  _T_1021 = 3'h2 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1022 = _T_1021 ? io_mem_read_data[161] : _T_1020; // @[Mux.scala 68:16]
  wire  _T_1023 = 3'h1 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1024 = _T_1023 ? io_mem_read_data[97] : _T_1022; // @[Mux.scala 68:16]
  wire  _T_1025 = 3'h0 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1026 = _T_1025 ? io_mem_read_data[33] : _T_1024; // @[Mux.scala 68:16]
  wire  _T_1037 = _T_1011 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1039 = _T_1013 ? io_mem_read_data[416] : _T_1037; // @[Mux.scala 68:16]
  wire  _T_1041 = _T_1015 ? io_mem_read_data[352] : _T_1039; // @[Mux.scala 68:16]
  wire  _T_1043 = _T_1017 ? io_mem_read_data[288] : _T_1041; // @[Mux.scala 68:16]
  wire  _T_1045 = _T_1019 ? io_mem_read_data[224] : _T_1043; // @[Mux.scala 68:16]
  wire  _T_1047 = _T_1021 ? io_mem_read_data[160] : _T_1045; // @[Mux.scala 68:16]
  wire  _T_1049 = _T_1023 ? io_mem_read_data[96] : _T_1047; // @[Mux.scala 68:16]
  wire  _T_1051 = _T_1025 ? io_mem_read_data[32] : _T_1049; // @[Mux.scala 68:16]
  wire  _T_1054 = rb_entries_3_request_operands_1_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_1056 = _T_1054 & _T_1026; // @[POSIT_Locality.scala 138:49]
  wire  _T_1058 = _T_1051 == rb_entries_3_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1059 = _T_1056 & _T_1058; // @[POSIT_Locality.scala 139:49]
  wire  _T_1097 = 3'h7 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1098 = _T_1097 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1099 = 3'h6 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1100 = _T_1099 ? io_mem_read_data[417] : _T_1098; // @[Mux.scala 68:16]
  wire  _T_1101 = 3'h5 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1102 = _T_1101 ? io_mem_read_data[353] : _T_1100; // @[Mux.scala 68:16]
  wire  _T_1103 = 3'h4 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1104 = _T_1103 ? io_mem_read_data[289] : _T_1102; // @[Mux.scala 68:16]
  wire  _T_1105 = 3'h3 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1106 = _T_1105 ? io_mem_read_data[225] : _T_1104; // @[Mux.scala 68:16]
  wire  _T_1107 = 3'h2 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1108 = _T_1107 ? io_mem_read_data[161] : _T_1106; // @[Mux.scala 68:16]
  wire  _T_1109 = 3'h1 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1110 = _T_1109 ? io_mem_read_data[97] : _T_1108; // @[Mux.scala 68:16]
  wire  _T_1111 = 3'h0 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1112 = _T_1111 ? io_mem_read_data[33] : _T_1110; // @[Mux.scala 68:16]
  wire  _T_1123 = _T_1097 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1125 = _T_1099 ? io_mem_read_data[416] : _T_1123; // @[Mux.scala 68:16]
  wire  _T_1127 = _T_1101 ? io_mem_read_data[352] : _T_1125; // @[Mux.scala 68:16]
  wire  _T_1129 = _T_1103 ? io_mem_read_data[288] : _T_1127; // @[Mux.scala 68:16]
  wire  _T_1131 = _T_1105 ? io_mem_read_data[224] : _T_1129; // @[Mux.scala 68:16]
  wire  _T_1133 = _T_1107 ? io_mem_read_data[160] : _T_1131; // @[Mux.scala 68:16]
  wire  _T_1135 = _T_1109 ? io_mem_read_data[96] : _T_1133; // @[Mux.scala 68:16]
  wire  _T_1137 = _T_1111 ? io_mem_read_data[32] : _T_1135; // @[Mux.scala 68:16]
  wire  _T_1140 = rb_entries_3_request_operands_2_value[13:0] == io_mem_read_resp_tag; // @[POSIT_Locality.scala 137:50]
  wire  _T_1142 = _T_1140 & _T_1112; // @[POSIT_Locality.scala 138:49]
  wire  _T_1144 = _T_1137 == rb_entries_3_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1145 = _T_1142 & _T_1144; // @[POSIT_Locality.scala 139:49]
  wire  _T_1175 = rb_entries_0_valid & rb_entries_0_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _GEN_3982 = {{9'd0}, reg_infetch_cacheline}; // @[POSIT_Locality.scala 163:210]
  wire [10:0] _T_1177 = rb_entries_0_request_operands_0_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1178 = _T_1177 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_0 = _T_1175 & _T_1178; // @[POSIT_Locality.scala 163:146]
  wire  _T_1182 = rb_entries_0_valid & rb_entries_0_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1184 = rb_entries_0_request_operands_1_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1185 = _T_1184 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_1 = _T_1182 & _T_1185; // @[POSIT_Locality.scala 163:146]
  wire  _T_1189 = rb_entries_0_valid & rb_entries_0_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1191 = rb_entries_0_request_operands_2_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1192 = _T_1191 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_2 = _T_1189 & _T_1192; // @[POSIT_Locality.scala 163:146]
  wire  _T_1196 = rb_entries_1_valid & rb_entries_1_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1198 = rb_entries_1_request_operands_0_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1199 = _T_1198 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_3 = _T_1196 & _T_1199; // @[POSIT_Locality.scala 163:146]
  wire  _T_1203 = rb_entries_1_valid & rb_entries_1_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1205 = rb_entries_1_request_operands_1_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1206 = _T_1205 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_4 = _T_1203 & _T_1206; // @[POSIT_Locality.scala 163:146]
  wire  _T_1210 = rb_entries_1_valid & rb_entries_1_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1212 = rb_entries_1_request_operands_2_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1213 = _T_1212 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_5 = _T_1210 & _T_1213; // @[POSIT_Locality.scala 163:146]
  wire  _T_1217 = rb_entries_2_valid & rb_entries_2_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1219 = rb_entries_2_request_operands_0_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1220 = _T_1219 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_6 = _T_1217 & _T_1220; // @[POSIT_Locality.scala 163:146]
  wire  _T_1224 = rb_entries_2_valid & rb_entries_2_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1226 = rb_entries_2_request_operands_1_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1227 = _T_1226 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_7 = _T_1224 & _T_1227; // @[POSIT_Locality.scala 163:146]
  wire  _T_1231 = rb_entries_2_valid & rb_entries_2_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1233 = rb_entries_2_request_operands_2_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1234 = _T_1233 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_8 = _T_1231 & _T_1234; // @[POSIT_Locality.scala 163:146]
  wire  _T_1238 = rb_entries_3_valid & rb_entries_3_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1240 = rb_entries_3_request_operands_0_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1241 = _T_1240 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_9 = _T_1238 & _T_1241; // @[POSIT_Locality.scala 163:146]
  wire  _T_1245 = rb_entries_3_valid & rb_entries_3_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1247 = rb_entries_3_request_operands_1_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1248 = _T_1247 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_10 = _T_1245 & _T_1248; // @[POSIT_Locality.scala 163:146]
  wire  _T_1252 = rb_entries_3_valid & rb_entries_3_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_1254 = rb_entries_3_request_operands_2_value[13:3] & _GEN_3982; // @[POSIT_Locality.scala 163:210]
  wire  _T_1255 = _T_1254 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_11 = _T_1252 & _T_1255; // @[POSIT_Locality.scala 163:146]
  wire [5:0] _T_1261 = {waitingToBeFetched_5,waitingToBeFetched_4,waitingToBeFetched_3,waitingToBeFetched_2,waitingToBeFetched_1,waitingToBeFetched_0}; // @[POSIT_Locality.scala 173:52]
  wire [5:0] _T_1266 = {waitingToBeFetched_11,waitingToBeFetched_10,waitingToBeFetched_9,waitingToBeFetched_8,waitingToBeFetched_7,waitingToBeFetched_6}; // @[POSIT_Locality.scala 173:52]
  wire [47:0] fetchOffSet_0 = {{16'd0}, rb_entries_0_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] fetchOffSet_1 = {{16'd0}, rb_entries_0_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3953 = 4'h1 == fetchArb_io_chosen ? fetchOffSet_1 : fetchOffSet_0; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_2 = {{16'd0}, rb_entries_0_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3954 = 4'h2 == fetchArb_io_chosen ? fetchOffSet_2 : _GEN_3953; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_3 = {{16'd0}, rb_entries_1_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3955 = 4'h3 == fetchArb_io_chosen ? fetchOffSet_3 : _GEN_3954; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_4 = {{16'd0}, rb_entries_1_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3956 = 4'h4 == fetchArb_io_chosen ? fetchOffSet_4 : _GEN_3955; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_5 = {{16'd0}, rb_entries_1_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3957 = 4'h5 == fetchArb_io_chosen ? fetchOffSet_5 : _GEN_3956; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_6 = {{16'd0}, rb_entries_2_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3958 = 4'h6 == fetchArb_io_chosen ? fetchOffSet_6 : _GEN_3957; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_7 = {{16'd0}, rb_entries_2_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3959 = 4'h7 == fetchArb_io_chosen ? fetchOffSet_7 : _GEN_3958; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_8 = {{16'd0}, rb_entries_2_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3960 = 4'h8 == fetchArb_io_chosen ? fetchOffSet_8 : _GEN_3959; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_9 = {{16'd0}, rb_entries_3_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3961 = 4'h9 == fetchArb_io_chosen ? fetchOffSet_9 : _GEN_3960; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_10 = {{16'd0}, rb_entries_3_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3962 = 4'ha == fetchArb_io_chosen ? fetchOffSet_10 : _GEN_3961; // @[POSIT_Locality.scala 182:62]
  wire [47:0] fetchOffSet_11 = {{16'd0}, rb_entries_3_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_3963 = 4'hb == fetchArb_io_chosen ? fetchOffSet_11 : _GEN_3962; // @[POSIT_Locality.scala 182:62]
  wire [10:0] _T_1269 = _GEN_3963[13:3] & _GEN_3982; // @[POSIT_Locality.scala 182:82]
  wire  _T_1270 = _T_1269 != 11'h0; // @[POSIT_Locality.scala 182:107]
  wire  _T_1271 = 1'h1 ^ _T_1270; // @[POSIT_Locality.scala 184:49]
  wire  _T_1275 = _GEN_3963[13:11] != 3'h0; // @[OneHot.scala 32:14]
  wire [7:0] _GEN_3995 = {{5'd0}, _GEN_3963[13:11]}; // @[OneHot.scala 32:28]
  wire [7:0] _T_1276 = _GEN_3995 | _GEN_3963[10:3]; // @[OneHot.scala 32:28]
  wire  _T_1279 = _T_1276[7:4] != 4'h0; // @[OneHot.scala 32:14]
  wire [3:0] _T_1280 = _T_1276[7:4] | _T_1276[3:0]; // @[OneHot.scala 32:28]
  wire  _T_1283 = _T_1280[3:2] != 2'h0; // @[OneHot.scala 32:14]
  wire [1:0] _T_1284 = _T_1280[3:2] | _T_1280[1:0]; // @[OneHot.scala 32:28]
  wire [3:0] _T_1288 = {_T_1275,_T_1279,_T_1283,_T_1284[1]}; // @[Cat.scala 30:58]
  wire [3:0] _GEN_3965 = fetchArb_io_hasChosen ? _T_1288 : _T_1288; // @[POSIT_Locality.scala 181:36]
  wire [13:0] _GEN_3966 = fetchArb_io_hasChosen ? _GEN_3963[13:0] : 14'h0; // @[POSIT_Locality.scala 181:36]
  wire [10:0] _T_1317 = _GEN_3982 | io_mem_read_resp_tag[13:3]; // @[POSIT_Locality.scala 226:56]
  wire [10:0] _T_1319 = _T_1317 ^ io_mem_read_resp_tag[13:3]; // @[POSIT_Locality.scala 226:99]
  wire [10:0] _T_1321 = _GEN_3982 | io_mem_read_req_tag[13:3]; // @[POSIT_Locality.scala 227:53]
  wire [10:0] _T_1323 = _T_1319 | io_mem_read_req_tag[13:3]; // @[POSIT_Locality.scala 228:52]
  wire [10:0] _GEN_3967 = io_mem_read_req_valid ? _T_1323 : _T_1319; // @[POSIT_Locality.scala 230:52]
  wire [10:0] _GEN_3968 = io_mem_read_req_valid ? _T_1321 : {{9'd0}, reg_infetch_cacheline}; // @[POSIT_Locality.scala 236:52]
  wire [10:0] _GEN_3969 = io_mem_read_resp_valid ? _GEN_3967 : _GEN_3968; // @[POSIT_Locality.scala 229:45]
  wire  _T_1324 = io_mem_read_req_valid | io_mem_read_resp_valid; // @[POSIT_Locality.scala 242:44]
  wire  _T_1363 = io_request_valid | io_mem_write_valid; // @[POSIT_Locality.scala 266:39]
  wire  _T_1364 = _T_1363 | io_mem_read_req_valid; // @[POSIT_Locality.scala 266:61]
  wire  _T_1365 = _T_1364 | pe_io_result_valid; // @[POSIT_Locality.scala 266:86]
  wire  _GEN_4003 = io_mem_read_resp_valid & rb_entries_0_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4004 = _GEN_4003 & _T_199; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4005 = io_mem_read_resp_valid & rb_entries_0_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4006 = _GEN_4005 & _T_285; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4007 = io_mem_read_resp_valid & rb_entries_0_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4008 = _GEN_4007 & _T_371; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4009 = io_mem_read_resp_valid & rb_entries_1_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4010 = _GEN_4009 & _T_457; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4011 = io_mem_read_resp_valid & rb_entries_1_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4012 = _GEN_4011 & _T_543; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4013 = io_mem_read_resp_valid & rb_entries_1_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4014 = _GEN_4013 & _T_629; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4015 = io_mem_read_resp_valid & rb_entries_2_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4016 = _GEN_4015 & _T_715; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4017 = io_mem_read_resp_valid & rb_entries_2_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4018 = _GEN_4017 & _T_801; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4019 = io_mem_read_resp_valid & rb_entries_2_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4020 = _GEN_4019 & _T_887; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4021 = io_mem_read_resp_valid & rb_entries_3_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4022 = _GEN_4021 & _T_973; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4023 = io_mem_read_resp_valid & rb_entries_3_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4024 = _GEN_4023 & _T_1059; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4025 = io_mem_read_resp_valid & rb_entries_3_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_4026 = _GEN_4025 & _T_1145; // @[POSIT_Locality.scala 143:55]
  Posit pe ( // @[POSIT_Locality.scala 12:24]
    .clock(pe_clock),
    .reset(pe_reset),
    .io_request_ready(pe_io_request_ready),
    .io_request_valid(pe_io_request_valid),
    .io_request_bits_num1(pe_io_request_bits_num1),
    .io_request_bits_num2(pe_io_request_bits_num2),
    .io_request_bits_num3(pe_io_request_bits_num3),
    .io_request_bits_inst(pe_io_request_bits_inst),
    .io_request_bits_mode(pe_io_request_bits_mode),
    .io_result_ready(pe_io_result_ready),
    .io_result_valid(pe_io_result_valid),
    .io_result_bits_isZero(pe_io_result_bits_isZero),
    .io_result_bits_isNaR(pe_io_result_bits_isNaR),
    .io_result_bits_out(pe_io_result_bits_out),
    .io_result_bits_lt(pe_io_result_bits_lt),
    .io_result_bits_eq(pe_io_result_bits_eq),
    .io_result_bits_gt(pe_io_result_bits_gt),
    .io_result_bits_exceptions(pe_io_result_bits_exceptions),
    .io_in_idx(pe_io_in_idx),
    .io_out_idx(pe_io_out_idx)
  );
  DispatchArbiter dispatchArb ( // @[POSIT_Locality.scala 59:33]
    .io_validity(dispatchArb_io_validity),
    .io_priority(dispatchArb_io_priority),
    .io_chosen(dispatchArb_io_chosen),
    .io_hasChosen(dispatchArb_io_hasChosen)
  );
  DispatchArbiter_1 fetchArb ( // @[POSIT_Locality.scala 172:30]
    .io_validity(fetchArb_io_validity),
    .io_priority(fetchArb_io_priority),
    .io_chosen(fetchArb_io_chosen),
    .io_hasChosen(fetchArb_io_hasChosen)
  );
  assign io_request_ready = _GEN_99 | _T_3; // @[POSIT_Locality.scala 24:26]
  assign io_mem_write_valid = _GEN_730 & _T_37; // @[POSIT_Locality.scala 53:28]
  assign io_mem_write_bits_result_isZero = 2'h3 == value ? rb_entries_3_result_isZero : _GEN_717; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_isNaR = 2'h3 == value ? rb_entries_3_result_isNaR : _GEN_718; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_out = 2'h3 == value ? rb_entries_3_result_out : _GEN_719; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_lt = 2'h3 == value ? rb_entries_3_result_lt : _GEN_720; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_eq = 2'h3 == value ? rb_entries_3_result_eq : _GEN_721; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_gt = 2'h3 == value ? rb_entries_3_result_gt : _GEN_722; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_exceptions = 2'h3 == value ? rb_entries_3_result_exceptions : _GEN_723; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_wr_addr = 2'h3 == value ? rb_entries_3_wr_addr : _GEN_704; // @[POSIT_Locality.scala 54:35]
  assign io_mem_read_req_valid = fetchArb_io_hasChosen & _T_1271; // @[POSIT_Locality.scala 184:39 POSIT_Locality.scala 195:39]
  assign io_mem_read_req_addr = {{38'd0}, _GEN_3965}; // @[POSIT_Locality.scala 185:38 POSIT_Locality.scala 196:38]
  assign io_mem_read_req_tag = {{2'd0}, _GEN_3966}; // @[POSIT_Locality.scala 187:37 POSIT_Locality.scala 197:37]
  assign pe_clock = clock;
  assign pe_reset = reset;
  assign pe_io_request_valid = dispatchArb_io_hasChosen & pe_io_request_ready; // @[POSIT_Locality.scala 93:37 POSIT_Locality.scala 95:37]
  assign pe_io_request_bits_num1 = 2'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_0_value : _GEN_839; // @[POSIT_Locality.scala 100:33]
  assign pe_io_request_bits_num2 = 2'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_1_value : _GEN_841; // @[POSIT_Locality.scala 101:33]
  assign pe_io_request_bits_num3 = 2'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_2_value : _GEN_843; // @[POSIT_Locality.scala 102:33]
  assign pe_io_request_bits_inst = 2'h3 == dispatchArb_io_chosen ? rb_entries_3_request_inst : _GEN_845; // @[POSIT_Locality.scala 104:33]
  assign pe_io_request_bits_mode = 2'h3 == dispatchArb_io_chosen ? rb_entries_3_request_mode : _GEN_846; // @[POSIT_Locality.scala 103:33]
  assign pe_io_result_ready = io_mem_write_ready; // @[POSIT_Locality.scala 99:28]
  assign pe_io_in_idx = dispatchArb_io_chosen; // @[POSIT_Locality.scala 97:22]
  assign dispatchArb_io_validity = {_T_74,_T_73}; // @[POSIT_Locality.scala 80:33]
  assign dispatchArb_io_priority = {{1'd0}, wbCountOn}; // @[POSIT_Locality.scala 81:33]
  assign fetchArb_io_validity = {_T_1266,_T_1261}; // @[POSIT_Locality.scala 173:30]
  assign fetchArb_io_priority = {{3'd0}, wbCountOn}; // @[POSIT_Locality.scala 174:30]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rb_entries_0_completed = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  rb_entries_0_valid = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  rb_entries_0_dispatched = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  rb_entries_0_written = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  rb_entries_0_wr_addr = _RAND_4[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  rb_entries_0_request_operands_0_value = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  rb_entries_0_request_operands_0_mode = _RAND_6[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  rb_entries_0_request_operands_1_value = _RAND_7[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  rb_entries_0_request_operands_1_mode = _RAND_8[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  rb_entries_0_request_operands_2_value = _RAND_9[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  rb_entries_0_request_operands_2_mode = _RAND_10[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  rb_entries_0_request_inst = _RAND_11[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  rb_entries_0_request_mode = _RAND_12[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  rb_entries_0_result_isZero = _RAND_13[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  rb_entries_0_result_isNaR = _RAND_14[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  rb_entries_0_result_out = _RAND_15[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  rb_entries_0_result_lt = _RAND_16[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  rb_entries_0_result_eq = _RAND_17[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  rb_entries_0_result_gt = _RAND_18[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  rb_entries_0_result_exceptions = _RAND_19[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  rb_entries_1_completed = _RAND_20[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  rb_entries_1_valid = _RAND_21[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  rb_entries_1_dispatched = _RAND_22[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {1{`RANDOM}};
  rb_entries_1_written = _RAND_23[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  rb_entries_1_wr_addr = _RAND_24[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  rb_entries_1_request_operands_0_value = _RAND_25[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{`RANDOM}};
  rb_entries_1_request_operands_0_mode = _RAND_26[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  rb_entries_1_request_operands_1_value = _RAND_27[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{`RANDOM}};
  rb_entries_1_request_operands_1_mode = _RAND_28[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  rb_entries_1_request_operands_2_value = _RAND_29[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  rb_entries_1_request_operands_2_mode = _RAND_30[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  rb_entries_1_request_inst = _RAND_31[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{`RANDOM}};
  rb_entries_1_request_mode = _RAND_32[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_33 = {1{`RANDOM}};
  rb_entries_1_result_isZero = _RAND_33[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{`RANDOM}};
  rb_entries_1_result_isNaR = _RAND_34[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_35 = {1{`RANDOM}};
  rb_entries_1_result_out = _RAND_35[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{`RANDOM}};
  rb_entries_1_result_lt = _RAND_36[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_37 = {1{`RANDOM}};
  rb_entries_1_result_eq = _RAND_37[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_38 = {1{`RANDOM}};
  rb_entries_1_result_gt = _RAND_38[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_39 = {1{`RANDOM}};
  rb_entries_1_result_exceptions = _RAND_39[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_40 = {1{`RANDOM}};
  rb_entries_2_completed = _RAND_40[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_41 = {1{`RANDOM}};
  rb_entries_2_valid = _RAND_41[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_42 = {1{`RANDOM}};
  rb_entries_2_dispatched = _RAND_42[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_43 = {1{`RANDOM}};
  rb_entries_2_written = _RAND_43[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_44 = {1{`RANDOM}};
  rb_entries_2_wr_addr = _RAND_44[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_45 = {1{`RANDOM}};
  rb_entries_2_request_operands_0_value = _RAND_45[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_46 = {1{`RANDOM}};
  rb_entries_2_request_operands_0_mode = _RAND_46[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_47 = {1{`RANDOM}};
  rb_entries_2_request_operands_1_value = _RAND_47[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_48 = {1{`RANDOM}};
  rb_entries_2_request_operands_1_mode = _RAND_48[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_49 = {1{`RANDOM}};
  rb_entries_2_request_operands_2_value = _RAND_49[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_50 = {1{`RANDOM}};
  rb_entries_2_request_operands_2_mode = _RAND_50[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_51 = {1{`RANDOM}};
  rb_entries_2_request_inst = _RAND_51[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_52 = {1{`RANDOM}};
  rb_entries_2_request_mode = _RAND_52[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_53 = {1{`RANDOM}};
  rb_entries_2_result_isZero = _RAND_53[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_54 = {1{`RANDOM}};
  rb_entries_2_result_isNaR = _RAND_54[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_55 = {1{`RANDOM}};
  rb_entries_2_result_out = _RAND_55[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_56 = {1{`RANDOM}};
  rb_entries_2_result_lt = _RAND_56[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_57 = {1{`RANDOM}};
  rb_entries_2_result_eq = _RAND_57[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_58 = {1{`RANDOM}};
  rb_entries_2_result_gt = _RAND_58[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_59 = {1{`RANDOM}};
  rb_entries_2_result_exceptions = _RAND_59[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_60 = {1{`RANDOM}};
  rb_entries_3_completed = _RAND_60[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_61 = {1{`RANDOM}};
  rb_entries_3_valid = _RAND_61[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_62 = {1{`RANDOM}};
  rb_entries_3_dispatched = _RAND_62[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_63 = {1{`RANDOM}};
  rb_entries_3_written = _RAND_63[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_64 = {1{`RANDOM}};
  rb_entries_3_wr_addr = _RAND_64[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_65 = {1{`RANDOM}};
  rb_entries_3_request_operands_0_value = _RAND_65[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_66 = {1{`RANDOM}};
  rb_entries_3_request_operands_0_mode = _RAND_66[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_67 = {1{`RANDOM}};
  rb_entries_3_request_operands_1_value = _RAND_67[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_68 = {1{`RANDOM}};
  rb_entries_3_request_operands_1_mode = _RAND_68[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_69 = {1{`RANDOM}};
  rb_entries_3_request_operands_2_value = _RAND_69[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_70 = {1{`RANDOM}};
  rb_entries_3_request_operands_2_mode = _RAND_70[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_71 = {1{`RANDOM}};
  rb_entries_3_request_inst = _RAND_71[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_72 = {1{`RANDOM}};
  rb_entries_3_request_mode = _RAND_72[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_73 = {1{`RANDOM}};
  rb_entries_3_result_isZero = _RAND_73[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_74 = {1{`RANDOM}};
  rb_entries_3_result_isNaR = _RAND_74[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_75 = {1{`RANDOM}};
  rb_entries_3_result_out = _RAND_75[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_76 = {1{`RANDOM}};
  rb_entries_3_result_lt = _RAND_76[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_77 = {1{`RANDOM}};
  rb_entries_3_result_eq = _RAND_77[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_78 = {1{`RANDOM}};
  rb_entries_3_result_gt = _RAND_78[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_79 = {1{`RANDOM}};
  rb_entries_3_result_exceptions = _RAND_79[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_80 = {1{`RANDOM}};
  value = _RAND_80[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_81 = {1{`RANDOM}};
  reg_infetch_cacheline = _RAND_81[1:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      rb_entries_0_completed <= 1'h0;
    end else if (_T_104) begin
      rb_entries_0_completed <= _GEN_916;
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_0_valid <= _GEN_484;
    end
    if (reset) begin
      rb_entries_0_dispatched <= 1'h0;
    end else if (_T_77) begin
      rb_entries_0_dispatched <= 1'h0;
    end else begin
      rb_entries_0_dispatched <= _T_81;
    end
    if (reset) begin
      rb_entries_0_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_0_written <= _GEN_754;
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_0_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_0_mode[1]) begin
        if (_T_199) begin
          if (_T_165) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_163) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_161) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_159) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_157) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_155) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_153) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_151) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_0_request_operands_0_value <= 32'h0;
          end
        end else if (_T_105) begin
          if (_GEN_1048) begin
            if (2'h3 == rb_entries_0_request_operands_0_value[1:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_0_request_operands_0_value[1:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_0_request_operands_0_value[1:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_0_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h0 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_105) begin
        if (_GEN_1048) begin
          if (2'h3 == rb_entries_0_request_operands_0_value[1:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_0_request_operands_0_value[1:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_0_request_operands_0_value[1:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_0_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_105) begin
      if (_GEN_1048) begin
        if (2'h3 == rb_entries_0_request_operands_0_value[1:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_0_request_operands_0_value[1:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_0_request_operands_0_value[1:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_0_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_0_request_operands_0_value <= _GEN_580;
      end
    end else begin
      rb_entries_0_request_operands_0_value <= _GEN_580;
    end
    if (reset) begin
      rb_entries_0_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_0_mode[1]) begin
        if (_T_199) begin
          rb_entries_0_request_operands_0_mode <= 2'h0;
        end else if (_T_105) begin
          if (_GEN_1048) begin
            rb_entries_0_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h0 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_105) begin
        if (_GEN_1048) begin
          rb_entries_0_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_105) begin
      if (_GEN_1048) begin
        rb_entries_0_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_0_mode <= _GEN_584;
      end
    end else begin
      rb_entries_0_request_operands_0_mode <= _GEN_584;
    end
    if (reset) begin
      rb_entries_0_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_1_mode[1]) begin
        if (_T_285) begin
          if (_T_251) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_249) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_247) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_245) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_243) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_241) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_239) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_237) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_0_request_operands_1_value <= 32'h0;
          end
        end else if (_T_108) begin
          if (_GEN_1292) begin
            if (2'h3 == rb_entries_0_request_operands_1_value[1:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_0_request_operands_1_value[1:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_0_request_operands_1_value[1:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_0_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h0 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_108) begin
        if (_GEN_1292) begin
          if (2'h3 == rb_entries_0_request_operands_1_value[1:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_0_request_operands_1_value[1:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_0_request_operands_1_value[1:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_0_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_108) begin
      if (_GEN_1292) begin
        if (2'h3 == rb_entries_0_request_operands_1_value[1:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_0_request_operands_1_value[1:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_0_request_operands_1_value[1:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_0_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_0_request_operands_1_value <= _GEN_588;
      end
    end else begin
      rb_entries_0_request_operands_1_value <= _GEN_588;
    end
    if (reset) begin
      rb_entries_0_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_1_mode[1]) begin
        if (_T_285) begin
          rb_entries_0_request_operands_1_mode <= 2'h0;
        end else if (_T_108) begin
          if (_GEN_1292) begin
            rb_entries_0_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h0 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_108) begin
        if (_GEN_1292) begin
          rb_entries_0_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_108) begin
      if (_GEN_1292) begin
        rb_entries_0_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_1_mode <= _GEN_592;
      end
    end else begin
      rb_entries_0_request_operands_1_mode <= _GEN_592;
    end
    if (reset) begin
      rb_entries_0_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_2_mode[1]) begin
        if (_T_371) begin
          if (_T_337) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_335) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_333) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_331) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_329) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_327) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_325) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_323) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_0_request_operands_2_value <= 32'h0;
          end
        end else if (_T_111) begin
          if (_GEN_1536) begin
            if (2'h3 == rb_entries_0_request_operands_2_value[1:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_0_request_operands_2_value[1:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_0_request_operands_2_value[1:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_0_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h0 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_111) begin
        if (_GEN_1536) begin
          if (2'h3 == rb_entries_0_request_operands_2_value[1:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_0_request_operands_2_value[1:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_0_request_operands_2_value[1:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_0_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_111) begin
      if (_GEN_1536) begin
        if (2'h3 == rb_entries_0_request_operands_2_value[1:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_0_request_operands_2_value[1:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_0_request_operands_2_value[1:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_0_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_0_request_operands_2_value <= _GEN_596;
      end
    end else begin
      rb_entries_0_request_operands_2_value <= _GEN_596;
    end
    if (reset) begin
      rb_entries_0_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_2_mode[1]) begin
        if (_T_371) begin
          rb_entries_0_request_operands_2_mode <= 2'h0;
        end else if (_T_111) begin
          if (_GEN_1536) begin
            rb_entries_0_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h0 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_111) begin
        if (_GEN_1536) begin
          rb_entries_0_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h0 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_111) begin
      if (_GEN_1536) begin
        rb_entries_0_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_2_mode <= _GEN_600;
      end
    end else begin
      rb_entries_0_request_operands_2_mode <= _GEN_600;
    end
    if (reset) begin
      rb_entries_0_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_0_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_0_result_isZero <= 1'h0;
    end else if (_T_104) begin
      if (2'h0 == result_idx) begin
        rb_entries_0_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_isNaR <= 1'h0;
    end else if (_T_104) begin
      if (2'h0 == result_idx) begin
        rb_entries_0_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_out <= 32'h0;
    end else if (_T_104) begin
      if (2'h0 == result_idx) begin
        rb_entries_0_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_lt <= 1'h0;
    end else if (_T_104) begin
      if (2'h0 == result_idx) begin
        rb_entries_0_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_eq <= 1'h0;
    end else if (_T_104) begin
      if (2'h0 == result_idx) begin
        rb_entries_0_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_gt <= 1'h0;
    end else if (_T_104) begin
      if (2'h0 == result_idx) begin
        rb_entries_0_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_exceptions <= 5'h0;
    end else if (_T_104) begin
      if (2'h0 == result_idx) begin
        rb_entries_0_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (2'h0 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_0_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h0 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_0_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_1_completed <= 1'h0;
    end else if (_T_104) begin
      rb_entries_1_completed <= _GEN_917;
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_1_valid <= _GEN_485;
    end
    if (reset) begin
      rb_entries_1_dispatched <= 1'h0;
    end else if (_T_83) begin
      rb_entries_1_dispatched <= 1'h0;
    end else begin
      rb_entries_1_dispatched <= _T_87;
    end
    if (reset) begin
      rb_entries_1_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_1_written <= _GEN_755;
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_1_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_0_mode[1]) begin
        if (_T_457) begin
          if (_T_423) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_421) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_419) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_417) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_415) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_413) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_411) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_409) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_1_request_operands_0_value <= 32'h0;
          end
        end else if (_T_114) begin
          if (_GEN_1780) begin
            if (2'h3 == rb_entries_1_request_operands_0_value[1:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_1_request_operands_0_value[1:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_1_request_operands_0_value[1:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_1_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h1 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_114) begin
        if (_GEN_1780) begin
          if (2'h3 == rb_entries_1_request_operands_0_value[1:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_1_request_operands_0_value[1:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_1_request_operands_0_value[1:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_1_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_114) begin
      if (_GEN_1780) begin
        if (2'h3 == rb_entries_1_request_operands_0_value[1:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_1_request_operands_0_value[1:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_1_request_operands_0_value[1:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_1_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_1_request_operands_0_value <= _GEN_581;
      end
    end else begin
      rb_entries_1_request_operands_0_value <= _GEN_581;
    end
    if (reset) begin
      rb_entries_1_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_0_mode[1]) begin
        if (_T_457) begin
          rb_entries_1_request_operands_0_mode <= 2'h0;
        end else if (_T_114) begin
          if (_GEN_1780) begin
            rb_entries_1_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h1 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_114) begin
        if (_GEN_1780) begin
          rb_entries_1_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_114) begin
      if (_GEN_1780) begin
        rb_entries_1_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_0_mode <= _GEN_585;
      end
    end else begin
      rb_entries_1_request_operands_0_mode <= _GEN_585;
    end
    if (reset) begin
      rb_entries_1_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_1_mode[1]) begin
        if (_T_543) begin
          if (_T_509) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_507) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_505) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_503) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_501) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_499) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_497) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_495) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_1_request_operands_1_value <= 32'h0;
          end
        end else if (_T_117) begin
          if (_GEN_2024) begin
            if (2'h3 == rb_entries_1_request_operands_1_value[1:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_1_request_operands_1_value[1:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_1_request_operands_1_value[1:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_1_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h1 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_117) begin
        if (_GEN_2024) begin
          if (2'h3 == rb_entries_1_request_operands_1_value[1:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_1_request_operands_1_value[1:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_1_request_operands_1_value[1:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_1_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_117) begin
      if (_GEN_2024) begin
        if (2'h3 == rb_entries_1_request_operands_1_value[1:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_1_request_operands_1_value[1:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_1_request_operands_1_value[1:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_1_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_1_request_operands_1_value <= _GEN_589;
      end
    end else begin
      rb_entries_1_request_operands_1_value <= _GEN_589;
    end
    if (reset) begin
      rb_entries_1_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_1_mode[1]) begin
        if (_T_543) begin
          rb_entries_1_request_operands_1_mode <= 2'h0;
        end else if (_T_117) begin
          if (_GEN_2024) begin
            rb_entries_1_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h1 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_117) begin
        if (_GEN_2024) begin
          rb_entries_1_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_117) begin
      if (_GEN_2024) begin
        rb_entries_1_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_1_mode <= _GEN_593;
      end
    end else begin
      rb_entries_1_request_operands_1_mode <= _GEN_593;
    end
    if (reset) begin
      rb_entries_1_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_2_mode[1]) begin
        if (_T_629) begin
          if (_T_595) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_593) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_591) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_589) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_587) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_585) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_583) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_581) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_1_request_operands_2_value <= 32'h0;
          end
        end else if (_T_120) begin
          if (_GEN_2268) begin
            if (2'h3 == rb_entries_1_request_operands_2_value[1:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_1_request_operands_2_value[1:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_1_request_operands_2_value[1:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_1_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h1 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_120) begin
        if (_GEN_2268) begin
          if (2'h3 == rb_entries_1_request_operands_2_value[1:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_1_request_operands_2_value[1:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_1_request_operands_2_value[1:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_1_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_120) begin
      if (_GEN_2268) begin
        if (2'h3 == rb_entries_1_request_operands_2_value[1:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_1_request_operands_2_value[1:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_1_request_operands_2_value[1:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_1_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_1_request_operands_2_value <= _GEN_597;
      end
    end else begin
      rb_entries_1_request_operands_2_value <= _GEN_597;
    end
    if (reset) begin
      rb_entries_1_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_2_mode[1]) begin
        if (_T_629) begin
          rb_entries_1_request_operands_2_mode <= 2'h0;
        end else if (_T_120) begin
          if (_GEN_2268) begin
            rb_entries_1_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h1 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_120) begin
        if (_GEN_2268) begin
          rb_entries_1_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h1 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_120) begin
      if (_GEN_2268) begin
        rb_entries_1_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_2_mode <= _GEN_601;
      end
    end else begin
      rb_entries_1_request_operands_2_mode <= _GEN_601;
    end
    if (reset) begin
      rb_entries_1_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_1_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_1_result_isZero <= 1'h0;
    end else if (_T_104) begin
      if (2'h1 == result_idx) begin
        rb_entries_1_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_isNaR <= 1'h0;
    end else if (_T_104) begin
      if (2'h1 == result_idx) begin
        rb_entries_1_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_out <= 32'h0;
    end else if (_T_104) begin
      if (2'h1 == result_idx) begin
        rb_entries_1_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_lt <= 1'h0;
    end else if (_T_104) begin
      if (2'h1 == result_idx) begin
        rb_entries_1_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_eq <= 1'h0;
    end else if (_T_104) begin
      if (2'h1 == result_idx) begin
        rb_entries_1_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_gt <= 1'h0;
    end else if (_T_104) begin
      if (2'h1 == result_idx) begin
        rb_entries_1_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_exceptions <= 5'h0;
    end else if (_T_104) begin
      if (2'h1 == result_idx) begin
        rb_entries_1_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (2'h1 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_1_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h1 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_1_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_2_completed <= 1'h0;
    end else if (_T_104) begin
      rb_entries_2_completed <= _GEN_918;
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_2_valid <= _GEN_486;
    end
    if (reset) begin
      rb_entries_2_dispatched <= 1'h0;
    end else if (_T_89) begin
      rb_entries_2_dispatched <= 1'h0;
    end else begin
      rb_entries_2_dispatched <= _T_93;
    end
    if (reset) begin
      rb_entries_2_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_2_written <= _GEN_756;
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_2_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_0_mode[1]) begin
        if (_T_715) begin
          if (_T_681) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_679) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_677) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_675) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_673) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_671) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_669) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_667) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_2_request_operands_0_value <= 32'h0;
          end
        end else if (_T_123) begin
          if (_GEN_2512) begin
            if (2'h3 == rb_entries_2_request_operands_0_value[1:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_2_request_operands_0_value[1:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_2_request_operands_0_value[1:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_2_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h2 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_123) begin
        if (_GEN_2512) begin
          if (2'h3 == rb_entries_2_request_operands_0_value[1:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_2_request_operands_0_value[1:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_2_request_operands_0_value[1:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_2_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_123) begin
      if (_GEN_2512) begin
        if (2'h3 == rb_entries_2_request_operands_0_value[1:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_2_request_operands_0_value[1:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_2_request_operands_0_value[1:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_2_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_2_request_operands_0_value <= _GEN_582;
      end
    end else begin
      rb_entries_2_request_operands_0_value <= _GEN_582;
    end
    if (reset) begin
      rb_entries_2_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_0_mode[1]) begin
        if (_T_715) begin
          rb_entries_2_request_operands_0_mode <= 2'h0;
        end else if (_T_123) begin
          if (_GEN_2512) begin
            rb_entries_2_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h2 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_123) begin
        if (_GEN_2512) begin
          rb_entries_2_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_123) begin
      if (_GEN_2512) begin
        rb_entries_2_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_0_mode <= _GEN_586;
      end
    end else begin
      rb_entries_2_request_operands_0_mode <= _GEN_586;
    end
    if (reset) begin
      rb_entries_2_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_1_mode[1]) begin
        if (_T_801) begin
          if (_T_767) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_765) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_763) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_761) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_759) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_757) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_755) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_753) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_2_request_operands_1_value <= 32'h0;
          end
        end else if (_T_126) begin
          if (_GEN_2756) begin
            if (2'h3 == rb_entries_2_request_operands_1_value[1:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_2_request_operands_1_value[1:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_2_request_operands_1_value[1:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_2_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h2 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_126) begin
        if (_GEN_2756) begin
          if (2'h3 == rb_entries_2_request_operands_1_value[1:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_2_request_operands_1_value[1:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_2_request_operands_1_value[1:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_2_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_126) begin
      if (_GEN_2756) begin
        if (2'h3 == rb_entries_2_request_operands_1_value[1:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_2_request_operands_1_value[1:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_2_request_operands_1_value[1:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_2_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_2_request_operands_1_value <= _GEN_590;
      end
    end else begin
      rb_entries_2_request_operands_1_value <= _GEN_590;
    end
    if (reset) begin
      rb_entries_2_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_1_mode[1]) begin
        if (_T_801) begin
          rb_entries_2_request_operands_1_mode <= 2'h0;
        end else if (_T_126) begin
          if (_GEN_2756) begin
            rb_entries_2_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h2 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_126) begin
        if (_GEN_2756) begin
          rb_entries_2_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_126) begin
      if (_GEN_2756) begin
        rb_entries_2_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_1_mode <= _GEN_594;
      end
    end else begin
      rb_entries_2_request_operands_1_mode <= _GEN_594;
    end
    if (reset) begin
      rb_entries_2_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_2_mode[1]) begin
        if (_T_887) begin
          if (_T_853) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_851) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_849) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_847) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_845) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_843) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_841) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_839) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_2_request_operands_2_value <= 32'h0;
          end
        end else if (_T_129) begin
          if (_GEN_3000) begin
            if (2'h3 == rb_entries_2_request_operands_2_value[1:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_2_request_operands_2_value[1:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_2_request_operands_2_value[1:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_2_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h2 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_129) begin
        if (_GEN_3000) begin
          if (2'h3 == rb_entries_2_request_operands_2_value[1:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_2_request_operands_2_value[1:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_2_request_operands_2_value[1:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_2_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_129) begin
      if (_GEN_3000) begin
        if (2'h3 == rb_entries_2_request_operands_2_value[1:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_2_request_operands_2_value[1:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_2_request_operands_2_value[1:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_2_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_2_request_operands_2_value <= _GEN_598;
      end
    end else begin
      rb_entries_2_request_operands_2_value <= _GEN_598;
    end
    if (reset) begin
      rb_entries_2_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_2_mode[1]) begin
        if (_T_887) begin
          rb_entries_2_request_operands_2_mode <= 2'h0;
        end else if (_T_129) begin
          if (_GEN_3000) begin
            rb_entries_2_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h2 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_129) begin
        if (_GEN_3000) begin
          rb_entries_2_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h2 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_129) begin
      if (_GEN_3000) begin
        rb_entries_2_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_2_mode <= _GEN_602;
      end
    end else begin
      rb_entries_2_request_operands_2_mode <= _GEN_602;
    end
    if (reset) begin
      rb_entries_2_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_2_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_2_result_isZero <= 1'h0;
    end else if (_T_104) begin
      if (2'h2 == result_idx) begin
        rb_entries_2_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_isNaR <= 1'h0;
    end else if (_T_104) begin
      if (2'h2 == result_idx) begin
        rb_entries_2_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_out <= 32'h0;
    end else if (_T_104) begin
      if (2'h2 == result_idx) begin
        rb_entries_2_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_lt <= 1'h0;
    end else if (_T_104) begin
      if (2'h2 == result_idx) begin
        rb_entries_2_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_eq <= 1'h0;
    end else if (_T_104) begin
      if (2'h2 == result_idx) begin
        rb_entries_2_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_gt <= 1'h0;
    end else if (_T_104) begin
      if (2'h2 == result_idx) begin
        rb_entries_2_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_exceptions <= 5'h0;
    end else if (_T_104) begin
      if (2'h2 == result_idx) begin
        rb_entries_2_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (2'h2 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_2_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h2 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_2_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_3_completed <= 1'h0;
    end else if (_T_104) begin
      rb_entries_3_completed <= _GEN_919;
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_3_valid <= _GEN_487;
    end
    if (reset) begin
      rb_entries_3_dispatched <= 1'h0;
    end else if (_T_95) begin
      rb_entries_3_dispatched <= 1'h0;
    end else begin
      rb_entries_3_dispatched <= _T_99;
    end
    if (reset) begin
      rb_entries_3_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_3_written <= _GEN_757;
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_3_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_0_mode[1]) begin
        if (_T_973) begin
          if (_T_939) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_937) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_935) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_933) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_931) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_929) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_927) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_925) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_3_request_operands_0_value <= 32'h0;
          end
        end else if (_T_132) begin
          if (_GEN_3244) begin
            if (2'h3 == rb_entries_3_request_operands_0_value[1:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_3_request_operands_0_value[1:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_3_request_operands_0_value[1:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_3_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h3 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_132) begin
        if (_GEN_3244) begin
          if (2'h3 == rb_entries_3_request_operands_0_value[1:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_3_request_operands_0_value[1:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_3_request_operands_0_value[1:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_3_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_132) begin
      if (_GEN_3244) begin
        if (2'h3 == rb_entries_3_request_operands_0_value[1:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_3_request_operands_0_value[1:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_3_request_operands_0_value[1:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_3_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_3_request_operands_0_value <= _GEN_583;
      end
    end else begin
      rb_entries_3_request_operands_0_value <= _GEN_583;
    end
    if (reset) begin
      rb_entries_3_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_0_mode[1]) begin
        if (_T_973) begin
          rb_entries_3_request_operands_0_mode <= 2'h0;
        end else if (_T_132) begin
          if (_GEN_3244) begin
            rb_entries_3_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h3 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_132) begin
        if (_GEN_3244) begin
          rb_entries_3_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_132) begin
      if (_GEN_3244) begin
        rb_entries_3_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_0_mode <= _GEN_587;
      end
    end else begin
      rb_entries_3_request_operands_0_mode <= _GEN_587;
    end
    if (reset) begin
      rb_entries_3_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_1_mode[1]) begin
        if (_T_1059) begin
          if (_T_1025) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_1023) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_1021) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_1019) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_1017) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_1015) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_1013) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_1011) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_3_request_operands_1_value <= 32'h0;
          end
        end else if (_T_135) begin
          if (_GEN_3488) begin
            if (2'h3 == rb_entries_3_request_operands_1_value[1:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_3_request_operands_1_value[1:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_3_request_operands_1_value[1:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_3_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h3 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_135) begin
        if (_GEN_3488) begin
          if (2'h3 == rb_entries_3_request_operands_1_value[1:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_3_request_operands_1_value[1:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_3_request_operands_1_value[1:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_3_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_135) begin
      if (_GEN_3488) begin
        if (2'h3 == rb_entries_3_request_operands_1_value[1:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_3_request_operands_1_value[1:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_3_request_operands_1_value[1:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_3_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_3_request_operands_1_value <= _GEN_591;
      end
    end else begin
      rb_entries_3_request_operands_1_value <= _GEN_591;
    end
    if (reset) begin
      rb_entries_3_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_1_mode[1]) begin
        if (_T_1059) begin
          rb_entries_3_request_operands_1_mode <= 2'h0;
        end else if (_T_135) begin
          if (_GEN_3488) begin
            rb_entries_3_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h3 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_135) begin
        if (_GEN_3488) begin
          rb_entries_3_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_135) begin
      if (_GEN_3488) begin
        rb_entries_3_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_1_mode <= _GEN_595;
      end
    end else begin
      rb_entries_3_request_operands_1_mode <= _GEN_595;
    end
    if (reset) begin
      rb_entries_3_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_2_mode[1]) begin
        if (_T_1145) begin
          if (_T_1111) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_1109) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_1107) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_1105) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_1103) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_1101) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_1099) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_1097) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_3_request_operands_2_value <= 32'h0;
          end
        end else if (_T_138) begin
          if (_GEN_3732) begin
            if (2'h3 == rb_entries_3_request_operands_2_value[1:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_3_result_out;
            end else if (2'h2 == rb_entries_3_request_operands_2_value[1:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_2_result_out;
            end else if (2'h1 == rb_entries_3_request_operands_2_value[1:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_3_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (2'h3 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_138) begin
        if (_GEN_3732) begin
          if (2'h3 == rb_entries_3_request_operands_2_value[1:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_3_result_out;
          end else if (2'h2 == rb_entries_3_request_operands_2_value[1:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_2_result_out;
          end else if (2'h1 == rb_entries_3_request_operands_2_value[1:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_3_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_138) begin
      if (_GEN_3732) begin
        if (2'h3 == rb_entries_3_request_operands_2_value[1:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_3_result_out;
        end else if (2'h2 == rb_entries_3_request_operands_2_value[1:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_2_result_out;
        end else if (2'h1 == rb_entries_3_request_operands_2_value[1:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_3_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_3_request_operands_2_value <= _GEN_599;
      end
    end else begin
      rb_entries_3_request_operands_2_value <= _GEN_599;
    end
    if (reset) begin
      rb_entries_3_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_2_mode[1]) begin
        if (_T_1145) begin
          rb_entries_3_request_operands_2_mode <= 2'h0;
        end else if (_T_138) begin
          if (_GEN_3732) begin
            rb_entries_3_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (2'h3 == io_request_bits_wr_addr[1:0]) begin
              rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_138) begin
        if (_GEN_3732) begin
          rb_entries_3_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (2'h3 == io_request_bits_wr_addr[1:0]) begin
            rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_138) begin
      if (_GEN_3732) begin
        rb_entries_3_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_2_mode <= _GEN_603;
      end
    end else begin
      rb_entries_3_request_operands_2_mode <= _GEN_603;
    end
    if (reset) begin
      rb_entries_3_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_3_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_3_result_isZero <= 1'h0;
    end else if (_T_104) begin
      if (2'h3 == result_idx) begin
        rb_entries_3_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_isNaR <= 1'h0;
    end else if (_T_104) begin
      if (2'h3 == result_idx) begin
        rb_entries_3_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_out <= 32'h0;
    end else if (_T_104) begin
      if (2'h3 == result_idx) begin
        rb_entries_3_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_lt <= 1'h0;
    end else if (_T_104) begin
      if (2'h3 == result_idx) begin
        rb_entries_3_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_eq <= 1'h0;
    end else if (_T_104) begin
      if (2'h3 == result_idx) begin
        rb_entries_3_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_gt <= 1'h0;
    end else if (_T_104) begin
      if (2'h3 == result_idx) begin
        rb_entries_3_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_exceptions <= 5'h0;
    end else if (_T_104) begin
      if (2'h3 == result_idx) begin
        rb_entries_3_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (2'h3 == io_request_bits_wr_addr[1:0]) begin
          rb_entries_3_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (2'h3 == io_request_bits_wr_addr[1:0]) begin
        rb_entries_3_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      value <= 2'h0;
    end else if (wbCountOn) begin
      value <= _T_35;
    end
    if (reset) begin
      reg_infetch_cacheline <= 2'h0;
    end else begin
      reg_infetch_cacheline <= _GEN_3969[1:0];
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (new_input_log & _T_11) begin
          $fwrite(32'h80000002,"written new entry\n"); // @[POSIT_Locality.scala 26:23]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (new_input_log & _T_11) begin
          $fwrite(32'h80000002,"op%d: mode: %d value: %d\n",1'h0,io_request_bits_operands_0_mode,io_request_bits_operands_0_value); // @[POSIT_Locality.scala 34:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (new_input_log & _T_11) begin
          $fwrite(32'h80000002,"op%d: mode: %d value: %d\n",1'h1,io_request_bits_operands_1_mode,io_request_bits_operands_1_value); // @[POSIT_Locality.scala 34:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (new_input_log & _T_11) begin
          $fwrite(32'h80000002,"op%d: mode: %d value: %d\n",2'h2,io_request_bits_operands_2_mode,io_request_bits_operands_2_value); // @[POSIT_Locality.scala 34:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4004 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h0,8'h0); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4006 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h0,8'h1); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4008 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h0,8'h2); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4010 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h1,8'h0); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4012 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h1,8'h1); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4014 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h1,8'h2); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4016 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h2,8'h0); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4018 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h2,8'h1); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4020 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h2,8'h2); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4022 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h3,8'h0); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4024 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h3,8'h1); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_4026 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h3,8'h2); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (fetchArb_io_hasChosen & _T_11) begin
          $fwrite(32'h80000002,"chosen: %d\n",fetchArb_io_chosen); // @[POSIT_Locality.scala 188:23]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (fetchArb_io_hasChosen & _T_11) begin
          $fwrite(32'h80000002,"fetchoffset: %b, subfield: %b\n",_GEN_3963,_GEN_3963[13:3]); // @[POSIT_Locality.scala 189:23]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (fetchArb_io_hasChosen & _T_11) begin
          $fwrite(32'h80000002,"io.mem_read.req_addr: %b\n",io_mem_read_req_addr); // @[POSIT_Locality.scala 190:23]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (fetchArb_io_hasChosen & _T_11) begin
          $fwrite(32'h80000002,"filter: %b\n",_T_1270); // @[POSIT_Locality.scala 191:23]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1324 & _T_11) begin
          $fwrite(32'h80000002,"\t-mem_read:\n"); // @[POSIT_Locality.scala 243:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1324 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-req_valid: %b\n",io_mem_read_req_valid); // @[POSIT_Locality.scala 244:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1324 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-req_addr: %x\n",io_mem_read_req_addr); // @[POSIT_Locality.scala 245:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1324 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-resp_valid: %b\n",io_mem_read_resp_valid); // @[POSIT_Locality.scala 246:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1324 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-data: %x\n",io_mem_read_data); // @[POSIT_Locality.scala 247:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1324 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-resp_tag: %x\n",io_mem_read_resp_tag); // @[POSIT_Locality.scala 248:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t-mem_write:\n"); // @[POSIT_Locality.scala 251:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t-valid: %b\n",io_mem_write_valid); // @[POSIT_Locality.scala 252:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t-ready: %b\n",io_mem_write_ready); // @[POSIT_Locality.scala 253:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t-bits:\n"); // @[POSIT_Locality.scala 254:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-wr_addr: %x\n",io_mem_write_bits_wr_addr); // @[POSIT_Locality.scala 255:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-result: \n"); // @[POSIT_Locality.scala 256:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-isZero: %b\n",io_mem_write_bits_result_isZero); // @[POSIT_Locality.scala 257:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-isNaR: %b\n",io_mem_write_bits_result_isNaR); // @[POSIT_Locality.scala 258:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-lt: %b\n",io_mem_write_bits_result_lt); // @[POSIT_Locality.scala 259:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-eq: %b\n",io_mem_write_bits_result_eq); // @[POSIT_Locality.scala 260:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-gt: %b\n",io_mem_write_bits_result_gt); // @[POSIT_Locality.scala 261:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-exceptions: %x\n",io_mem_write_bits_result_exceptions); // @[POSIT_Locality.scala 262:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mem_write_valid & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-out: %b\n",io_mem_write_bits_result_out); // @[POSIT_Locality.scala 263:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"top level io:\n"); // @[POSIT_Locality.scala 267:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t-request:\n"); // @[POSIT_Locality.scala 268:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-valid: %b\n",io_request_valid); // @[POSIT_Locality.scala 269:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-ready: %b\n",io_request_ready); // @[POSIT_Locality.scala 270:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-bits:\n"); // @[POSIT_Locality.scala 271:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-inst: %x\n",io_request_bits_inst); // @[POSIT_Locality.scala 272:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-mode: %x\n",io_request_bits_mode); // @[POSIT_Locality.scala 273:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-wr_addr: %x\n",io_request_bits_wr_addr); // @[POSIT_Locality.scala 274:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-operand0:\n"); // @[POSIT_Locality.scala 276:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-value: %x\n",io_request_bits_operands_0_value); // @[POSIT_Locality.scala 277:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-mode: %x\n",io_request_bits_operands_0_mode); // @[POSIT_Locality.scala 278:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-operand1:\n"); // @[POSIT_Locality.scala 276:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-value: %x\n",io_request_bits_operands_1_value); // @[POSIT_Locality.scala 277:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-mode: %x\n",io_request_bits_operands_1_mode); // @[POSIT_Locality.scala 278:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-operand2:\n"); // @[POSIT_Locality.scala 276:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-value: %x\n",io_request_bits_operands_2_value); // @[POSIT_Locality.scala 277:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-mode: %x\n",io_request_bits_operands_2_mode); // @[POSIT_Locality.scala 278:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t-fetchArb:\n"); // @[POSIT_Locality.scala 281:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-validity:%b\n",fetchArb_io_validity); // @[POSIT_Locality.scala 282:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-priority:%x\n",fetchArb_io_priority); // @[POSIT_Locality.scala 283:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-chosen:%x\n",fetchArb_io_chosen); // @[POSIT_Locality.scala 284:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-hasChosen:%b\n",fetchArb_io_hasChosen); // @[POSIT_Locality.scala 285:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t-dispatchArb\n"); // @[POSIT_Locality.scala 287:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-validity:%b\n",dispatchArb_io_validity); // @[POSIT_Locality.scala 288:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-priority:%x\n",dispatchArb_io_priority); // @[POSIT_Locality.scala 289:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-chosen:%x\n",dispatchArb_io_chosen); // @[POSIT_Locality.scala 290:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-hasChosen:%b\n",dispatchArb_io_hasChosen); // @[POSIT_Locality.scala 291:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"rb data: \n"); // @[POSIT_Locality.scala 293:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"idx | completed | valid | dispatched | writtern | wr_addr| inst | mode | num0 | mode0 | infetch0 | num1 | mode1 | infetch1 | num2 | mode2 | infetch2 | isZero | isNar | out | lt | eq | gt | exceptions\n"); // @[POSIT_Locality.scala 294:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",1'h0,rb_entries_0_completed,rb_entries_0_valid,rb_entries_0_dispatched,rb_entries_0_written,rb_entries_0_wr_addr,rb_entries_0_request_inst,rb_entries_0_request_mode,rb_entries_0_request_operands_0_value,rb_entries_0_request_operands_0_mode,1'h0,rb_entries_0_request_operands_1_value,rb_entries_0_request_operands_1_mode,1'h0,rb_entries_0_request_operands_2_value,rb_entries_0_request_operands_2_mode,1'h0,rb_entries_0_result_isZero,rb_entries_0_result_isNaR,rb_entries_0_result_out,rb_entries_0_result_lt,rb_entries_0_result_eq,rb_entries_0_result_gt,rb_entries_0_result_exceptions); // @[POSIT_Locality.scala 301:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",1'h1,rb_entries_1_completed,rb_entries_1_valid,rb_entries_1_dispatched,rb_entries_1_written,rb_entries_1_wr_addr,rb_entries_1_request_inst,rb_entries_1_request_mode,rb_entries_1_request_operands_0_value,rb_entries_1_request_operands_0_mode,1'h0,rb_entries_1_request_operands_1_value,rb_entries_1_request_operands_1_mode,1'h0,rb_entries_1_request_operands_2_value,rb_entries_1_request_operands_2_mode,1'h0,rb_entries_1_result_isZero,rb_entries_1_result_isNaR,rb_entries_1_result_out,rb_entries_1_result_lt,rb_entries_1_result_eq,rb_entries_1_result_gt,rb_entries_1_result_exceptions); // @[POSIT_Locality.scala 301:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",2'h2,rb_entries_2_completed,rb_entries_2_valid,rb_entries_2_dispatched,rb_entries_2_written,rb_entries_2_wr_addr,rb_entries_2_request_inst,rb_entries_2_request_mode,rb_entries_2_request_operands_0_value,rb_entries_2_request_operands_0_mode,1'h0,rb_entries_2_request_operands_1_value,rb_entries_2_request_operands_1_mode,1'h0,rb_entries_2_request_operands_2_value,rb_entries_2_request_operands_2_mode,1'h0,rb_entries_2_result_isZero,rb_entries_2_result_isNaR,rb_entries_2_result_out,rb_entries_2_result_lt,rb_entries_2_result_eq,rb_entries_2_result_gt,rb_entries_2_result_exceptions); // @[POSIT_Locality.scala 301:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",2'h3,rb_entries_3_completed,rb_entries_3_valid,rb_entries_3_dispatched,rb_entries_3_written,rb_entries_3_wr_addr,rb_entries_3_request_inst,rb_entries_3_request_mode,rb_entries_3_request_operands_0_value,rb_entries_3_request_operands_0_mode,1'h0,rb_entries_3_request_operands_1_value,rb_entries_3_request_operands_1_mode,1'h0,rb_entries_3_request_operands_2_value,rb_entries_3_request_operands_2_mode,1'h0,rb_entries_3_result_isZero,rb_entries_3_result_isNaR,rb_entries_3_result_out,rb_entries_3_result_lt,rb_entries_3_result_eq,rb_entries_3_result_gt,rb_entries_3_result_exceptions); // @[POSIT_Locality.scala 301:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"reg_infetch_cacheline:%b\n",reg_infetch_cacheline); // @[POSIT_Locality.scala 307:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"pe: \n"); // @[POSIT_Locality.scala 309:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"request: valid | ready | num 1 | num2 | num3 | inst | mode\n"); // @[POSIT_Locality.scala 313:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t %b | %b | %b | %b | %b | %x | %x\n",pe_io_request_valid,pe_io_request_ready,pe_io_request_bits_num1,pe_io_request_bits_num2,pe_io_request_bits_num3,pe_io_request_bits_inst,pe_io_request_bits_mode); // @[POSIT_Locality.scala 314:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"result: valid | ready | isZero | isNar | out | lt | eq | gt | exceptions\n"); // @[POSIT_Locality.scala 315:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1365 & _T_11) begin
          $fwrite(32'h80000002,"\t %b | %b | %b | %b | %x | %b | %b | %b | %x\n",pe_io_result_valid,pe_io_result_ready,pe_io_result_bits_isZero,pe_io_result_bits_isNaR,pe_io_result_bits_out,pe_io_result_bits_lt,pe_io_result_bits_eq,pe_io_result_bits_gt,pe_io_result_bits_exceptions); // @[POSIT_Locality.scala 317:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
