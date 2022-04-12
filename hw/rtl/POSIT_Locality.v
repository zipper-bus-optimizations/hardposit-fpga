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
  input  [2:0]  io_in_idx,
  output [2:0]  io_out_idx
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
  reg [2:0] init_idx; // @[POSIT.scala 58:31]
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
  reg [2:0] exec_idx; // @[POSIT.scala 89:31]
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
  reg [2:0] result_idx; // @[POSIT.scala 100:33]
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
  init_idx = _RAND_6[2:0];
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
  exec_idx = _RAND_28[2:0];
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
  result_idx = _RAND_40[2:0];
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
      init_idx <= 3'h0;
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
      exec_idx <= 3'h0;
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
      result_idx <= 3'h0;
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
  input  [7:0] io_validity,
  input  [2:0] io_priority,
  output [2:0] io_chosen,
  output       io_hasChosen
);
  wire  afterPriority_7 = io_validity[7]; // @[DispatchArbiter.scala 19:64]
  wire  _T_6 = 3'h6 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_6 = _T_6 & io_validity[6]; // @[DispatchArbiter.scala 19:28]
  wire  _T_9 = 3'h6 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_6 = _T_9 & io_validity[6]; // @[DispatchArbiter.scala 21:28]
  wire  _T_12 = 3'h5 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_5 = _T_12 & io_validity[5]; // @[DispatchArbiter.scala 19:28]
  wire  _T_15 = 3'h5 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_5 = _T_15 & io_validity[5]; // @[DispatchArbiter.scala 21:28]
  wire  _T_18 = 3'h4 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_4 = _T_18 & io_validity[4]; // @[DispatchArbiter.scala 19:28]
  wire  _T_21 = 3'h4 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_4 = _T_21 & io_validity[4]; // @[DispatchArbiter.scala 21:28]
  wire  _T_24 = 3'h3 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_3 = _T_24 & io_validity[3]; // @[DispatchArbiter.scala 19:28]
  wire  _T_27 = 3'h3 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_3 = _T_27 & io_validity[3]; // @[DispatchArbiter.scala 21:28]
  wire  _T_30 = 3'h2 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_2 = _T_30 & io_validity[2]; // @[DispatchArbiter.scala 19:28]
  wire  _T_33 = 3'h2 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_2 = _T_33 & io_validity[2]; // @[DispatchArbiter.scala 21:28]
  wire  _T_36 = 3'h1 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_1 = _T_36 & io_validity[1]; // @[DispatchArbiter.scala 19:28]
  wire  _T_39 = 3'h1 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_1 = _T_39 & io_validity[1]; // @[DispatchArbiter.scala 21:28]
  wire  _T_42 = 3'h0 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_0 = _T_42 & io_validity[0]; // @[DispatchArbiter.scala 19:28]
  wire  _T_45 = 3'h0 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_0 = _T_45 & io_validity[0]; // @[DispatchArbiter.scala 21:28]
  wire [2:0] _GEN_0 = afterPriority_6 ? 3'h6 : 3'h7; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_1 = beforePriority_6 ? 3'h6 : 3'h7; // @[DispatchArbiter.scala 33:40]
  wire [2:0] _GEN_2 = afterPriority_5 ? 3'h5 : _GEN_0; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_3 = beforePriority_5 ? 3'h5 : _GEN_1; // @[DispatchArbiter.scala 33:40]
  wire [2:0] _GEN_4 = afterPriority_4 ? 3'h4 : _GEN_2; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_5 = beforePriority_4 ? 3'h4 : _GEN_3; // @[DispatchArbiter.scala 33:40]
  wire [2:0] _GEN_6 = afterPriority_3 ? 3'h3 : _GEN_4; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_7 = beforePriority_3 ? 3'h3 : _GEN_5; // @[DispatchArbiter.scala 33:40]
  wire [2:0] _GEN_8 = afterPriority_2 ? 3'h2 : _GEN_6; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_9 = beforePriority_2 ? 3'h2 : _GEN_7; // @[DispatchArbiter.scala 33:40]
  wire [2:0] _GEN_10 = afterPriority_1 ? 3'h1 : _GEN_8; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_11 = beforePriority_1 ? 3'h1 : _GEN_9; // @[DispatchArbiter.scala 33:40]
  wire [2:0] afterPriorityChosen = afterPriority_0 ? 3'h0 : _GEN_10; // @[DispatchArbiter.scala 30:29]
  wire [2:0] beforePriorityChosen = beforePriority_0 ? 3'h0 : _GEN_11; // @[DispatchArbiter.scala 33:40]
  wire  _T_49 = afterPriority_0 | afterPriority_1; // @[DispatchArbiter.scala 37:54]
  wire  _T_50 = _T_49 | afterPriority_2; // @[DispatchArbiter.scala 37:54]
  wire  _T_51 = _T_50 | afterPriority_3; // @[DispatchArbiter.scala 37:54]
  wire  _T_52 = _T_51 | afterPriority_4; // @[DispatchArbiter.scala 37:54]
  wire  _T_53 = _T_52 | afterPriority_5; // @[DispatchArbiter.scala 37:54]
  wire  _T_54 = _T_53 | afterPriority_6; // @[DispatchArbiter.scala 37:54]
  wire  afterPriorityExist = _T_54 | afterPriority_7; // @[DispatchArbiter.scala 37:54]
  wire  _T_56 = beforePriority_0 | beforePriority_1; // @[DispatchArbiter.scala 38:56]
  wire  _T_57 = _T_56 | beforePriority_2; // @[DispatchArbiter.scala 38:56]
  wire  _T_58 = _T_57 | beforePriority_3; // @[DispatchArbiter.scala 38:56]
  wire  _T_59 = _T_58 | beforePriority_4; // @[DispatchArbiter.scala 38:56]
  wire  _T_60 = _T_59 | beforePriority_5; // @[DispatchArbiter.scala 38:56]
  wire  beforePriorityExist = _T_60 | beforePriority_6; // @[DispatchArbiter.scala 38:56]
  assign io_chosen = afterPriorityExist ? afterPriorityChosen : beforePriorityChosen; // @[DispatchArbiter.scala 41:19]
  assign io_hasChosen = afterPriorityExist | beforePriorityExist; // @[DispatchArbiter.scala 40:22]
endmodule
module DispatchArbiter_1(
  input  [23:0] io_validity,
  input  [4:0]  io_priority,
  output [4:0]  io_chosen,
  output        io_hasChosen
);
  wire  _T = 5'h17 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_23 = _T & io_validity[23]; // @[DispatchArbiter.scala 19:28]
  wire  _T_3 = 5'h17 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_23 = _T_3 & io_validity[23]; // @[DispatchArbiter.scala 21:28]
  wire  _T_6 = 5'h16 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_22 = _T_6 & io_validity[22]; // @[DispatchArbiter.scala 19:28]
  wire  _T_9 = 5'h16 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_22 = _T_9 & io_validity[22]; // @[DispatchArbiter.scala 21:28]
  wire  _T_12 = 5'h15 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_21 = _T_12 & io_validity[21]; // @[DispatchArbiter.scala 19:28]
  wire  _T_15 = 5'h15 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_21 = _T_15 & io_validity[21]; // @[DispatchArbiter.scala 21:28]
  wire  _T_18 = 5'h14 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_20 = _T_18 & io_validity[20]; // @[DispatchArbiter.scala 19:28]
  wire  _T_21 = 5'h14 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_20 = _T_21 & io_validity[20]; // @[DispatchArbiter.scala 21:28]
  wire  _T_24 = 5'h13 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_19 = _T_24 & io_validity[19]; // @[DispatchArbiter.scala 19:28]
  wire  _T_27 = 5'h13 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_19 = _T_27 & io_validity[19]; // @[DispatchArbiter.scala 21:28]
  wire  _T_30 = 5'h12 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_18 = _T_30 & io_validity[18]; // @[DispatchArbiter.scala 19:28]
  wire  _T_33 = 5'h12 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_18 = _T_33 & io_validity[18]; // @[DispatchArbiter.scala 21:28]
  wire  _T_36 = 5'h11 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_17 = _T_36 & io_validity[17]; // @[DispatchArbiter.scala 19:28]
  wire  _T_39 = 5'h11 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_17 = _T_39 & io_validity[17]; // @[DispatchArbiter.scala 21:28]
  wire  _T_42 = 5'h10 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_16 = _T_42 & io_validity[16]; // @[DispatchArbiter.scala 19:28]
  wire  _T_45 = 5'h10 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_16 = _T_45 & io_validity[16]; // @[DispatchArbiter.scala 21:28]
  wire  _T_48 = 5'hf >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_15 = _T_48 & io_validity[15]; // @[DispatchArbiter.scala 19:28]
  wire  _T_51 = 5'hf < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_15 = _T_51 & io_validity[15]; // @[DispatchArbiter.scala 21:28]
  wire  _T_54 = 5'he >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_14 = _T_54 & io_validity[14]; // @[DispatchArbiter.scala 19:28]
  wire  _T_57 = 5'he < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_14 = _T_57 & io_validity[14]; // @[DispatchArbiter.scala 21:28]
  wire  _T_60 = 5'hd >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_13 = _T_60 & io_validity[13]; // @[DispatchArbiter.scala 19:28]
  wire  _T_63 = 5'hd < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_13 = _T_63 & io_validity[13]; // @[DispatchArbiter.scala 21:28]
  wire  _T_66 = 5'hc >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_12 = _T_66 & io_validity[12]; // @[DispatchArbiter.scala 19:28]
  wire  _T_69 = 5'hc < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_12 = _T_69 & io_validity[12]; // @[DispatchArbiter.scala 21:28]
  wire  _T_72 = 5'hb >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_11 = _T_72 & io_validity[11]; // @[DispatchArbiter.scala 19:28]
  wire  _T_75 = 5'hb < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_11 = _T_75 & io_validity[11]; // @[DispatchArbiter.scala 21:28]
  wire  _T_78 = 5'ha >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_10 = _T_78 & io_validity[10]; // @[DispatchArbiter.scala 19:28]
  wire  _T_81 = 5'ha < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_10 = _T_81 & io_validity[10]; // @[DispatchArbiter.scala 21:28]
  wire  _T_84 = 5'h9 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_9 = _T_84 & io_validity[9]; // @[DispatchArbiter.scala 19:28]
  wire  _T_87 = 5'h9 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_9 = _T_87 & io_validity[9]; // @[DispatchArbiter.scala 21:28]
  wire  _T_90 = 5'h8 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_8 = _T_90 & io_validity[8]; // @[DispatchArbiter.scala 19:28]
  wire  _T_93 = 5'h8 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_8 = _T_93 & io_validity[8]; // @[DispatchArbiter.scala 21:28]
  wire  _T_96 = 5'h7 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_7 = _T_96 & io_validity[7]; // @[DispatchArbiter.scala 19:28]
  wire  _T_99 = 5'h7 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_7 = _T_99 & io_validity[7]; // @[DispatchArbiter.scala 21:28]
  wire  _T_102 = 5'h6 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_6 = _T_102 & io_validity[6]; // @[DispatchArbiter.scala 19:28]
  wire  _T_105 = 5'h6 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_6 = _T_105 & io_validity[6]; // @[DispatchArbiter.scala 21:28]
  wire  _T_108 = 5'h5 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_5 = _T_108 & io_validity[5]; // @[DispatchArbiter.scala 19:28]
  wire  _T_111 = 5'h5 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_5 = _T_111 & io_validity[5]; // @[DispatchArbiter.scala 21:28]
  wire  _T_114 = 5'h4 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_4 = _T_114 & io_validity[4]; // @[DispatchArbiter.scala 19:28]
  wire  _T_117 = 5'h4 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_4 = _T_117 & io_validity[4]; // @[DispatchArbiter.scala 21:28]
  wire  _T_120 = 5'h3 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_3 = _T_120 & io_validity[3]; // @[DispatchArbiter.scala 19:28]
  wire  _T_123 = 5'h3 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_3 = _T_123 & io_validity[3]; // @[DispatchArbiter.scala 21:28]
  wire  _T_126 = 5'h2 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_2 = _T_126 & io_validity[2]; // @[DispatchArbiter.scala 19:28]
  wire  _T_129 = 5'h2 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_2 = _T_129 & io_validity[2]; // @[DispatchArbiter.scala 21:28]
  wire  _T_132 = 5'h1 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_1 = _T_132 & io_validity[1]; // @[DispatchArbiter.scala 19:28]
  wire  _T_135 = 5'h1 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_1 = _T_135 & io_validity[1]; // @[DispatchArbiter.scala 21:28]
  wire  _T_138 = 5'h0 >= io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_0 = _T_138 & io_validity[0]; // @[DispatchArbiter.scala 19:28]
  wire  _T_141 = 5'h0 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_0 = _T_141 & io_validity[0]; // @[DispatchArbiter.scala 21:28]
  wire [4:0] _GEN_0 = afterPriority_22 ? 5'h16 : 5'h17; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_1 = beforePriority_22 ? 5'h16 : 5'h17; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_2 = afterPriority_21 ? 5'h15 : _GEN_0; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_3 = beforePriority_21 ? 5'h15 : _GEN_1; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_4 = afterPriority_20 ? 5'h14 : _GEN_2; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_5 = beforePriority_20 ? 5'h14 : _GEN_3; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_6 = afterPriority_19 ? 5'h13 : _GEN_4; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_7 = beforePriority_19 ? 5'h13 : _GEN_5; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_8 = afterPriority_18 ? 5'h12 : _GEN_6; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_9 = beforePriority_18 ? 5'h12 : _GEN_7; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_10 = afterPriority_17 ? 5'h11 : _GEN_8; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_11 = beforePriority_17 ? 5'h11 : _GEN_9; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_12 = afterPriority_16 ? 5'h10 : _GEN_10; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_13 = beforePriority_16 ? 5'h10 : _GEN_11; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_14 = afterPriority_15 ? 5'hf : _GEN_12; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_15 = beforePriority_15 ? 5'hf : _GEN_13; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_16 = afterPriority_14 ? 5'he : _GEN_14; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_17 = beforePriority_14 ? 5'he : _GEN_15; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_18 = afterPriority_13 ? 5'hd : _GEN_16; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_19 = beforePriority_13 ? 5'hd : _GEN_17; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_20 = afterPriority_12 ? 5'hc : _GEN_18; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_21 = beforePriority_12 ? 5'hc : _GEN_19; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_22 = afterPriority_11 ? 5'hb : _GEN_20; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_23 = beforePriority_11 ? 5'hb : _GEN_21; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_24 = afterPriority_10 ? 5'ha : _GEN_22; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_25 = beforePriority_10 ? 5'ha : _GEN_23; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_26 = afterPriority_9 ? 5'h9 : _GEN_24; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_27 = beforePriority_9 ? 5'h9 : _GEN_25; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_28 = afterPriority_8 ? 5'h8 : _GEN_26; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_29 = beforePriority_8 ? 5'h8 : _GEN_27; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_30 = afterPriority_7 ? 5'h7 : _GEN_28; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_31 = beforePriority_7 ? 5'h7 : _GEN_29; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_32 = afterPriority_6 ? 5'h6 : _GEN_30; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_33 = beforePriority_6 ? 5'h6 : _GEN_31; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_34 = afterPriority_5 ? 5'h5 : _GEN_32; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_35 = beforePriority_5 ? 5'h5 : _GEN_33; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_36 = afterPriority_4 ? 5'h4 : _GEN_34; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_37 = beforePriority_4 ? 5'h4 : _GEN_35; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_38 = afterPriority_3 ? 5'h3 : _GEN_36; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_39 = beforePriority_3 ? 5'h3 : _GEN_37; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_40 = afterPriority_2 ? 5'h2 : _GEN_38; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_41 = beforePriority_2 ? 5'h2 : _GEN_39; // @[DispatchArbiter.scala 33:40]
  wire [4:0] _GEN_42 = afterPriority_1 ? 5'h1 : _GEN_40; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_43 = beforePriority_1 ? 5'h1 : _GEN_41; // @[DispatchArbiter.scala 33:40]
  wire [4:0] afterPriorityChosen = afterPriority_0 ? 5'h0 : _GEN_42; // @[DispatchArbiter.scala 30:29]
  wire [4:0] beforePriorityChosen = beforePriority_0 ? 5'h0 : _GEN_43; // @[DispatchArbiter.scala 33:40]
  wire  _T_145 = afterPriority_0 | afterPriority_1; // @[DispatchArbiter.scala 37:54]
  wire  _T_146 = _T_145 | afterPriority_2; // @[DispatchArbiter.scala 37:54]
  wire  _T_147 = _T_146 | afterPriority_3; // @[DispatchArbiter.scala 37:54]
  wire  _T_148 = _T_147 | afterPriority_4; // @[DispatchArbiter.scala 37:54]
  wire  _T_149 = _T_148 | afterPriority_5; // @[DispatchArbiter.scala 37:54]
  wire  _T_150 = _T_149 | afterPriority_6; // @[DispatchArbiter.scala 37:54]
  wire  _T_151 = _T_150 | afterPriority_7; // @[DispatchArbiter.scala 37:54]
  wire  _T_152 = _T_151 | afterPriority_8; // @[DispatchArbiter.scala 37:54]
  wire  _T_153 = _T_152 | afterPriority_9; // @[DispatchArbiter.scala 37:54]
  wire  _T_154 = _T_153 | afterPriority_10; // @[DispatchArbiter.scala 37:54]
  wire  _T_155 = _T_154 | afterPriority_11; // @[DispatchArbiter.scala 37:54]
  wire  _T_156 = _T_155 | afterPriority_12; // @[DispatchArbiter.scala 37:54]
  wire  _T_157 = _T_156 | afterPriority_13; // @[DispatchArbiter.scala 37:54]
  wire  _T_158 = _T_157 | afterPriority_14; // @[DispatchArbiter.scala 37:54]
  wire  _T_159 = _T_158 | afterPriority_15; // @[DispatchArbiter.scala 37:54]
  wire  _T_160 = _T_159 | afterPriority_16; // @[DispatchArbiter.scala 37:54]
  wire  _T_161 = _T_160 | afterPriority_17; // @[DispatchArbiter.scala 37:54]
  wire  _T_162 = _T_161 | afterPriority_18; // @[DispatchArbiter.scala 37:54]
  wire  _T_163 = _T_162 | afterPriority_19; // @[DispatchArbiter.scala 37:54]
  wire  _T_164 = _T_163 | afterPriority_20; // @[DispatchArbiter.scala 37:54]
  wire  _T_165 = _T_164 | afterPriority_21; // @[DispatchArbiter.scala 37:54]
  wire  _T_166 = _T_165 | afterPriority_22; // @[DispatchArbiter.scala 37:54]
  wire  afterPriorityExist = _T_166 | afterPriority_23; // @[DispatchArbiter.scala 37:54]
  wire  _T_168 = beforePriority_0 | beforePriority_1; // @[DispatchArbiter.scala 38:56]
  wire  _T_169 = _T_168 | beforePriority_2; // @[DispatchArbiter.scala 38:56]
  wire  _T_170 = _T_169 | beforePriority_3; // @[DispatchArbiter.scala 38:56]
  wire  _T_171 = _T_170 | beforePriority_4; // @[DispatchArbiter.scala 38:56]
  wire  _T_172 = _T_171 | beforePriority_5; // @[DispatchArbiter.scala 38:56]
  wire  _T_173 = _T_172 | beforePriority_6; // @[DispatchArbiter.scala 38:56]
  wire  _T_174 = _T_173 | beforePriority_7; // @[DispatchArbiter.scala 38:56]
  wire  _T_175 = _T_174 | beforePriority_8; // @[DispatchArbiter.scala 38:56]
  wire  _T_176 = _T_175 | beforePriority_9; // @[DispatchArbiter.scala 38:56]
  wire  _T_177 = _T_176 | beforePriority_10; // @[DispatchArbiter.scala 38:56]
  wire  _T_178 = _T_177 | beforePriority_11; // @[DispatchArbiter.scala 38:56]
  wire  _T_179 = _T_178 | beforePriority_12; // @[DispatchArbiter.scala 38:56]
  wire  _T_180 = _T_179 | beforePriority_13; // @[DispatchArbiter.scala 38:56]
  wire  _T_181 = _T_180 | beforePriority_14; // @[DispatchArbiter.scala 38:56]
  wire  _T_182 = _T_181 | beforePriority_15; // @[DispatchArbiter.scala 38:56]
  wire  _T_183 = _T_182 | beforePriority_16; // @[DispatchArbiter.scala 38:56]
  wire  _T_184 = _T_183 | beforePriority_17; // @[DispatchArbiter.scala 38:56]
  wire  _T_185 = _T_184 | beforePriority_18; // @[DispatchArbiter.scala 38:56]
  wire  _T_186 = _T_185 | beforePriority_19; // @[DispatchArbiter.scala 38:56]
  wire  _T_187 = _T_186 | beforePriority_20; // @[DispatchArbiter.scala 38:56]
  wire  _T_188 = _T_187 | beforePriority_21; // @[DispatchArbiter.scala 38:56]
  wire  _T_189 = _T_188 | beforePriority_22; // @[DispatchArbiter.scala 38:56]
  wire  beforePriorityExist = _T_189 | beforePriority_23; // @[DispatchArbiter.scala 38:56]
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
  input  [7:0]   io_mem_read_resp_tag
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
  wire [2:0] pe_io_in_idx; // @[POSIT_Locality.scala 12:24]
  wire [2:0] pe_io_out_idx; // @[POSIT_Locality.scala 12:24]
  wire [7:0] dispatchArb_io_validity; // @[POSIT_Locality.scala 59:33]
  wire [2:0] dispatchArb_io_priority; // @[POSIT_Locality.scala 59:33]
  wire [2:0] dispatchArb_io_chosen; // @[POSIT_Locality.scala 59:33]
  wire  dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 59:33]
  wire [23:0] fetchArb_io_validity; // @[POSIT_Locality.scala 172:30]
  wire [4:0] fetchArb_io_priority; // @[POSIT_Locality.scala 172:30]
  wire [4:0] fetchArb_io_chosen; // @[POSIT_Locality.scala 172:30]
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
  reg  rb_entries_0_request_inFetch_0; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_13;
  reg  rb_entries_0_request_inFetch_1; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_14;
  reg  rb_entries_0_request_inFetch_2; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_15;
  reg  rb_entries_0_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_16;
  reg  rb_entries_0_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_17;
  reg [31:0] rb_entries_0_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_18;
  reg  rb_entries_0_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_19;
  reg  rb_entries_0_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_20;
  reg  rb_entries_0_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_21;
  reg [4:0] rb_entries_0_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_22;
  reg  rb_entries_1_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_23;
  reg  rb_entries_1_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_24;
  reg  rb_entries_1_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_25;
  reg  rb_entries_1_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_26;
  reg [7:0] rb_entries_1_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_27;
  reg [31:0] rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_28;
  reg [1:0] rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_29;
  reg [31:0] rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_30;
  reg [1:0] rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_31;
  reg [31:0] rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_32;
  reg [1:0] rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_33;
  reg [2:0] rb_entries_1_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_34;
  reg [1:0] rb_entries_1_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_35;
  reg  rb_entries_1_request_inFetch_0; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_36;
  reg  rb_entries_1_request_inFetch_1; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_37;
  reg  rb_entries_1_request_inFetch_2; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_38;
  reg  rb_entries_1_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_39;
  reg  rb_entries_1_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_40;
  reg [31:0] rb_entries_1_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_41;
  reg  rb_entries_1_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_42;
  reg  rb_entries_1_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_43;
  reg  rb_entries_1_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_44;
  reg [4:0] rb_entries_1_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_45;
  reg  rb_entries_2_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_46;
  reg  rb_entries_2_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_47;
  reg  rb_entries_2_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_48;
  reg  rb_entries_2_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_49;
  reg [7:0] rb_entries_2_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_50;
  reg [31:0] rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_51;
  reg [1:0] rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_52;
  reg [31:0] rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_53;
  reg [1:0] rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_54;
  reg [31:0] rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_55;
  reg [1:0] rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_56;
  reg [2:0] rb_entries_2_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_57;
  reg [1:0] rb_entries_2_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_58;
  reg  rb_entries_2_request_inFetch_0; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_59;
  reg  rb_entries_2_request_inFetch_1; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_60;
  reg  rb_entries_2_request_inFetch_2; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_61;
  reg  rb_entries_2_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_62;
  reg  rb_entries_2_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_63;
  reg [31:0] rb_entries_2_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_64;
  reg  rb_entries_2_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_65;
  reg  rb_entries_2_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_66;
  reg  rb_entries_2_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_67;
  reg [4:0] rb_entries_2_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_68;
  reg  rb_entries_3_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_69;
  reg  rb_entries_3_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_70;
  reg  rb_entries_3_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_71;
  reg  rb_entries_3_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_72;
  reg [7:0] rb_entries_3_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_73;
  reg [31:0] rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_74;
  reg [1:0] rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_75;
  reg [31:0] rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_76;
  reg [1:0] rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_77;
  reg [31:0] rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_78;
  reg [1:0] rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_79;
  reg [2:0] rb_entries_3_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_80;
  reg [1:0] rb_entries_3_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_81;
  reg  rb_entries_3_request_inFetch_0; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_82;
  reg  rb_entries_3_request_inFetch_1; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_83;
  reg  rb_entries_3_request_inFetch_2; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_84;
  reg  rb_entries_3_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_85;
  reg  rb_entries_3_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_86;
  reg [31:0] rb_entries_3_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_87;
  reg  rb_entries_3_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_88;
  reg  rb_entries_3_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_89;
  reg  rb_entries_3_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_90;
  reg [4:0] rb_entries_3_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_91;
  reg  rb_entries_4_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_92;
  reg  rb_entries_4_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_93;
  reg  rb_entries_4_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_94;
  reg  rb_entries_4_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_95;
  reg [7:0] rb_entries_4_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_96;
  reg [31:0] rb_entries_4_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_97;
  reg [1:0] rb_entries_4_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_98;
  reg [31:0] rb_entries_4_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_99;
  reg [1:0] rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_100;
  reg [31:0] rb_entries_4_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_101;
  reg [1:0] rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_102;
  reg [2:0] rb_entries_4_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_103;
  reg [1:0] rb_entries_4_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_104;
  reg  rb_entries_4_request_inFetch_0; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_105;
  reg  rb_entries_4_request_inFetch_1; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_106;
  reg  rb_entries_4_request_inFetch_2; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_107;
  reg  rb_entries_4_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_108;
  reg  rb_entries_4_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_109;
  reg [31:0] rb_entries_4_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_110;
  reg  rb_entries_4_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_111;
  reg  rb_entries_4_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_112;
  reg  rb_entries_4_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_113;
  reg [4:0] rb_entries_4_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_114;
  reg  rb_entries_5_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_115;
  reg  rb_entries_5_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_116;
  reg  rb_entries_5_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_117;
  reg  rb_entries_5_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_118;
  reg [7:0] rb_entries_5_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_119;
  reg [31:0] rb_entries_5_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_120;
  reg [1:0] rb_entries_5_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_121;
  reg [31:0] rb_entries_5_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_122;
  reg [1:0] rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_123;
  reg [31:0] rb_entries_5_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_124;
  reg [1:0] rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_125;
  reg [2:0] rb_entries_5_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_126;
  reg [1:0] rb_entries_5_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_127;
  reg  rb_entries_5_request_inFetch_0; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_128;
  reg  rb_entries_5_request_inFetch_1; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_129;
  reg  rb_entries_5_request_inFetch_2; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_130;
  reg  rb_entries_5_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_131;
  reg  rb_entries_5_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_132;
  reg [31:0] rb_entries_5_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_133;
  reg  rb_entries_5_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_134;
  reg  rb_entries_5_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_135;
  reg  rb_entries_5_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_136;
  reg [4:0] rb_entries_5_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_137;
  reg  rb_entries_6_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_138;
  reg  rb_entries_6_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_139;
  reg  rb_entries_6_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_140;
  reg  rb_entries_6_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_141;
  reg [7:0] rb_entries_6_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_142;
  reg [31:0] rb_entries_6_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_143;
  reg [1:0] rb_entries_6_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_144;
  reg [31:0] rb_entries_6_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_145;
  reg [1:0] rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_146;
  reg [31:0] rb_entries_6_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_147;
  reg [1:0] rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_148;
  reg [2:0] rb_entries_6_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_149;
  reg [1:0] rb_entries_6_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_150;
  reg  rb_entries_6_request_inFetch_0; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_151;
  reg  rb_entries_6_request_inFetch_1; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_152;
  reg  rb_entries_6_request_inFetch_2; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_153;
  reg  rb_entries_6_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_154;
  reg  rb_entries_6_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_155;
  reg [31:0] rb_entries_6_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_156;
  reg  rb_entries_6_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_157;
  reg  rb_entries_6_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_158;
  reg  rb_entries_6_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_159;
  reg [4:0] rb_entries_6_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_160;
  reg  rb_entries_7_completed; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_161;
  reg  rb_entries_7_valid; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_162;
  reg  rb_entries_7_dispatched; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_163;
  reg  rb_entries_7_written; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_164;
  reg [7:0] rb_entries_7_wr_addr; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_165;
  reg [31:0] rb_entries_7_request_operands_0_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_166;
  reg [1:0] rb_entries_7_request_operands_0_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_167;
  reg [31:0] rb_entries_7_request_operands_1_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_168;
  reg [1:0] rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_169;
  reg [31:0] rb_entries_7_request_operands_2_value; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_170;
  reg [1:0] rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_171;
  reg [2:0] rb_entries_7_request_inst; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_172;
  reg [1:0] rb_entries_7_request_mode; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_173;
  reg  rb_entries_7_request_inFetch_0; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_174;
  reg  rb_entries_7_request_inFetch_1; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_175;
  reg  rb_entries_7_request_inFetch_2; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_176;
  reg  rb_entries_7_result_isZero; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_177;
  reg  rb_entries_7_result_isNaR; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_178;
  reg [31:0] rb_entries_7_result_out; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_179;
  reg  rb_entries_7_result_lt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_180;
  reg  rb_entries_7_result_eq; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_181;
  reg  rb_entries_7_result_gt; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_182;
  reg [4:0] rb_entries_7_result_exceptions; // @[POSIT_Locality.scala 16:25]
  reg [31:0] _RAND_183;
  wire  _GEN_37 = 3'h1 == io_request_bits_wr_addr[2:0] ? rb_entries_1_valid : rb_entries_0_valid; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_39 = 3'h1 == io_request_bits_wr_addr[2:0] ? rb_entries_1_written : rb_entries_0_written; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_67 = 3'h2 == io_request_bits_wr_addr[2:0] ? rb_entries_2_valid : _GEN_37; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_69 = 3'h2 == io_request_bits_wr_addr[2:0] ? rb_entries_2_written : _GEN_39; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_97 = 3'h3 == io_request_bits_wr_addr[2:0] ? rb_entries_3_valid : _GEN_67; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_99 = 3'h3 == io_request_bits_wr_addr[2:0] ? rb_entries_3_written : _GEN_69; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_127 = 3'h4 == io_request_bits_wr_addr[2:0] ? rb_entries_4_valid : _GEN_97; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_129 = 3'h4 == io_request_bits_wr_addr[2:0] ? rb_entries_4_written : _GEN_99; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_157 = 3'h5 == io_request_bits_wr_addr[2:0] ? rb_entries_5_valid : _GEN_127; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_159 = 3'h5 == io_request_bits_wr_addr[2:0] ? rb_entries_5_written : _GEN_129; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_187 = 3'h6 == io_request_bits_wr_addr[2:0] ? rb_entries_6_valid : _GEN_157; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_189 = 3'h6 == io_request_bits_wr_addr[2:0] ? rb_entries_6_written : _GEN_159; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_217 = 3'h7 == io_request_bits_wr_addr[2:0] ? rb_entries_7_valid : _GEN_187; // @[POSIT_Locality.scala 21:80]
  wire  _GEN_219 = 3'h7 == io_request_bits_wr_addr[2:0] ? rb_entries_7_written : _GEN_189; // @[POSIT_Locality.scala 21:80]
  wire  _T_3 = ~_GEN_217; // @[POSIT_Locality.scala 21:80]
  wire  _T_4 = _GEN_219 | _T_3; // @[POSIT_Locality.scala 21:77]
  wire  new_input_log = io_request_valid & _T_4; // @[POSIT_Locality.scala 21:43]
  wire  _T_11 = ~reset; // @[POSIT_Locality.scala 26:23]
  wire  _GEN_960 = 3'h0 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_0_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_961 = 3'h1 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_1_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_962 = 3'h2 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_2_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_963 = 3'h3 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_3_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_964 = 3'h4 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_4_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_965 = 3'h5 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_5_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_966 = 3'h6 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_6_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_967 = 3'h7 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_7_completed; // @[POSIT_Locality.scala 27:49]
  wire  _GEN_13738 = 3'h0 == io_request_bits_wr_addr[2:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_968 = _GEN_13738 | rb_entries_0_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_13739 = 3'h1 == io_request_bits_wr_addr[2:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_969 = _GEN_13739 | rb_entries_1_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_13740 = 3'h2 == io_request_bits_wr_addr[2:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_970 = _GEN_13740 | rb_entries_2_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_13741 = 3'h3 == io_request_bits_wr_addr[2:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_971 = _GEN_13741 | rb_entries_3_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_13742 = 3'h4 == io_request_bits_wr_addr[2:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_972 = _GEN_13742 | rb_entries_4_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_13743 = 3'h5 == io_request_bits_wr_addr[2:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_973 = _GEN_13743 | rb_entries_5_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_13744 = 3'h6 == io_request_bits_wr_addr[2:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_974 = _GEN_13744 | rb_entries_6_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_13745 = 3'h7 == io_request_bits_wr_addr[2:0]; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_975 = _GEN_13745 | rb_entries_7_valid; // @[POSIT_Locality.scala 28:45]
  wire  _GEN_976 = 3'h0 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_0_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_977 = 3'h1 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_1_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_978 = 3'h2 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_2_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_979 = 3'h3 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_3_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_980 = 3'h4 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_4_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_981 = 3'h5 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_5_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_982 = 3'h6 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_6_written; // @[POSIT_Locality.scala 29:47]
  wire  _GEN_983 = 3'h7 == io_request_bits_wr_addr[2:0] ? 1'h0 : rb_entries_7_written; // @[POSIT_Locality.scala 29:47]
  wire [31:0] _GEN_1008 = 3'h0 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_value : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1009 = 3'h1 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_value : rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1010 = 3'h2 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_value : rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1011 = 3'h3 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_value : rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1012 = 3'h4 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_value : rb_entries_4_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1013 = 3'h5 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_value : rb_entries_5_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1014 = 3'h6 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_value : rb_entries_6_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1015 = 3'h7 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_value : rb_entries_7_request_operands_0_value; // @[POSIT_Locality.scala 35:73]
  wire [1:0] _GEN_1016 = 3'h0 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_mode : rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1017 = 3'h1 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_mode : rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1018 = 3'h2 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_mode : rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1019 = 3'h3 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_mode : rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1020 = 3'h4 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_mode : rb_entries_4_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1021 = 3'h5 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_mode : rb_entries_5_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1022 = 3'h6 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_mode : rb_entries_6_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1023 = 3'h7 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_0_mode : rb_entries_7_request_operands_0_mode; // @[POSIT_Locality.scala 36:72]
  wire [31:0] _GEN_1024 = 3'h0 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_value : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1025 = 3'h1 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_value : rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1026 = 3'h2 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_value : rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1027 = 3'h3 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_value : rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1028 = 3'h4 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_value : rb_entries_4_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1029 = 3'h5 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_value : rb_entries_5_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1030 = 3'h6 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_value : rb_entries_6_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1031 = 3'h7 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_value : rb_entries_7_request_operands_1_value; // @[POSIT_Locality.scala 35:73]
  wire [1:0] _GEN_1032 = 3'h0 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_mode : rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1033 = 3'h1 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_mode : rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1034 = 3'h2 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_mode : rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1035 = 3'h3 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_mode : rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1036 = 3'h4 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_mode : rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1037 = 3'h5 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_mode : rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1038 = 3'h6 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_mode : rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1039 = 3'h7 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_1_mode : rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 36:72]
  wire [31:0] _GEN_1040 = 3'h0 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_value : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1041 = 3'h1 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_value : rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1042 = 3'h2 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_value : rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1043 = 3'h3 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_value : rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1044 = 3'h4 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_value : rb_entries_4_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1045 = 3'h5 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_value : rb_entries_5_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1046 = 3'h6 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_value : rb_entries_6_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [31:0] _GEN_1047 = 3'h7 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_value : rb_entries_7_request_operands_2_value; // @[POSIT_Locality.scala 35:73]
  wire [1:0] _GEN_1048 = 3'h0 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_mode : rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1049 = 3'h1 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_mode : rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1050 = 3'h2 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_mode : rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1051 = 3'h3 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_mode : rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1052 = 3'h4 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_mode : rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1053 = 3'h5 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_mode : rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1054 = 3'h6 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_mode : rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire [1:0] _GEN_1055 = 3'h7 == io_request_bits_wr_addr[2:0] ? io_request_bits_operands_2_mode : rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 36:72]
  wire  _GEN_1112 = new_input_log ? _GEN_960 : rb_entries_0_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1113 = new_input_log ? _GEN_961 : rb_entries_1_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1114 = new_input_log ? _GEN_962 : rb_entries_2_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1115 = new_input_log ? _GEN_963 : rb_entries_3_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1116 = new_input_log ? _GEN_964 : rb_entries_4_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1117 = new_input_log ? _GEN_965 : rb_entries_5_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1118 = new_input_log ? _GEN_966 : rb_entries_6_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1119 = new_input_log ? _GEN_967 : rb_entries_7_completed; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1128 = new_input_log ? _GEN_976 : rb_entries_0_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1129 = new_input_log ? _GEN_977 : rb_entries_1_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1130 = new_input_log ? _GEN_978 : rb_entries_2_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1131 = new_input_log ? _GEN_979 : rb_entries_3_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1132 = new_input_log ? _GEN_980 : rb_entries_4_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1133 = new_input_log ? _GEN_981 : rb_entries_5_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1134 = new_input_log ? _GEN_982 : rb_entries_6_written; // @[POSIT_Locality.scala 25:28]
  wire  _GEN_1135 = new_input_log ? _GEN_983 : rb_entries_7_written; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1160 = new_input_log ? _GEN_1008 : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1161 = new_input_log ? _GEN_1009 : rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1162 = new_input_log ? _GEN_1010 : rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1163 = new_input_log ? _GEN_1011 : rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1164 = new_input_log ? _GEN_1012 : rb_entries_4_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1165 = new_input_log ? _GEN_1013 : rb_entries_5_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1166 = new_input_log ? _GEN_1014 : rb_entries_6_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1167 = new_input_log ? _GEN_1015 : rb_entries_7_request_operands_0_value; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1168 = new_input_log ? _GEN_1016 : rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1169 = new_input_log ? _GEN_1017 : rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1170 = new_input_log ? _GEN_1018 : rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1171 = new_input_log ? _GEN_1019 : rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1172 = new_input_log ? _GEN_1020 : rb_entries_4_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1173 = new_input_log ? _GEN_1021 : rb_entries_5_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1174 = new_input_log ? _GEN_1022 : rb_entries_6_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1175 = new_input_log ? _GEN_1023 : rb_entries_7_request_operands_0_mode; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1176 = new_input_log ? _GEN_1024 : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1177 = new_input_log ? _GEN_1025 : rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1178 = new_input_log ? _GEN_1026 : rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1179 = new_input_log ? _GEN_1027 : rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1180 = new_input_log ? _GEN_1028 : rb_entries_4_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1181 = new_input_log ? _GEN_1029 : rb_entries_5_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1182 = new_input_log ? _GEN_1030 : rb_entries_6_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1183 = new_input_log ? _GEN_1031 : rb_entries_7_request_operands_1_value; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1184 = new_input_log ? _GEN_1032 : rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1185 = new_input_log ? _GEN_1033 : rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1186 = new_input_log ? _GEN_1034 : rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1187 = new_input_log ? _GEN_1035 : rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1188 = new_input_log ? _GEN_1036 : rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1189 = new_input_log ? _GEN_1037 : rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1190 = new_input_log ? _GEN_1038 : rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1191 = new_input_log ? _GEN_1039 : rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1192 = new_input_log ? _GEN_1040 : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1193 = new_input_log ? _GEN_1041 : rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1194 = new_input_log ? _GEN_1042 : rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1195 = new_input_log ? _GEN_1043 : rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1196 = new_input_log ? _GEN_1044 : rb_entries_4_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1197 = new_input_log ? _GEN_1045 : rb_entries_5_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1198 = new_input_log ? _GEN_1046 : rb_entries_6_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [31:0] _GEN_1199 = new_input_log ? _GEN_1047 : rb_entries_7_request_operands_2_value; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1200 = new_input_log ? _GEN_1048 : rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1201 = new_input_log ? _GEN_1049 : rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1202 = new_input_log ? _GEN_1050 : rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1203 = new_input_log ? _GEN_1051 : rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1204 = new_input_log ? _GEN_1052 : rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1205 = new_input_log ? _GEN_1053 : rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1206 = new_input_log ? _GEN_1054 : rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  wire [1:0] _GEN_1207 = new_input_log ? _GEN_1055 : rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 25:28]
  reg [2:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_184;
  wire [2:0] _T_35 = value + 3'h1; // @[Counter.scala 39:22]
  wire  _GEN_1302 = 3'h1 == value ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1332 = 3'h2 == value ? rb_entries_2_completed : _GEN_1302; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1362 = 3'h3 == value ? rb_entries_3_completed : _GEN_1332; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1392 = 3'h4 == value ? rb_entries_4_completed : _GEN_1362; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1422 = 3'h5 == value ? rb_entries_5_completed : _GEN_1392; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1452 = 3'h6 == value ? rb_entries_6_completed : _GEN_1422; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1482 = 3'h7 == value ? rb_entries_7_completed : _GEN_1452; // @[POSIT_Locality.scala 45:33]
  wire  _T_36 = io_mem_write_ready & _GEN_1482; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1305 = 3'h1 == value ? rb_entries_1_written : rb_entries_0_written; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1335 = 3'h2 == value ? rb_entries_2_written : _GEN_1305; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1365 = 3'h3 == value ? rb_entries_3_written : _GEN_1335; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1395 = 3'h4 == value ? rb_entries_4_written : _GEN_1365; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1425 = 3'h5 == value ? rb_entries_5_written : _GEN_1395; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1455 = 3'h6 == value ? rb_entries_6_written : _GEN_1425; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1485 = 3'h7 == value ? rb_entries_7_written : _GEN_1455; // @[POSIT_Locality.scala 45:33]
  wire  _T_37 = ~_GEN_1485; // @[POSIT_Locality.scala 45:72]
  wire  wbCountOn = _T_36 & _T_37; // @[POSIT_Locality.scala 45:68]
  wire [7:0] _GEN_1306 = 3'h1 == value ? rb_entries_1_wr_addr : rb_entries_0_wr_addr; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1319 = 3'h1 == value ? rb_entries_1_result_isZero : rb_entries_0_result_isZero; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1320 = 3'h1 == value ? rb_entries_1_result_isNaR : rb_entries_0_result_isNaR; // @[POSIT_Locality.scala 45:33]
  wire [31:0] _GEN_1321 = 3'h1 == value ? rb_entries_1_result_out : rb_entries_0_result_out; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1322 = 3'h1 == value ? rb_entries_1_result_lt : rb_entries_0_result_lt; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1323 = 3'h1 == value ? rb_entries_1_result_eq : rb_entries_0_result_eq; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1324 = 3'h1 == value ? rb_entries_1_result_gt : rb_entries_0_result_gt; // @[POSIT_Locality.scala 45:33]
  wire [4:0] _GEN_1325 = 3'h1 == value ? rb_entries_1_result_exceptions : rb_entries_0_result_exceptions; // @[POSIT_Locality.scala 45:33]
  wire [7:0] _GEN_1336 = 3'h2 == value ? rb_entries_2_wr_addr : _GEN_1306; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1349 = 3'h2 == value ? rb_entries_2_result_isZero : _GEN_1319; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1350 = 3'h2 == value ? rb_entries_2_result_isNaR : _GEN_1320; // @[POSIT_Locality.scala 45:33]
  wire [31:0] _GEN_1351 = 3'h2 == value ? rb_entries_2_result_out : _GEN_1321; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1352 = 3'h2 == value ? rb_entries_2_result_lt : _GEN_1322; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1353 = 3'h2 == value ? rb_entries_2_result_eq : _GEN_1323; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1354 = 3'h2 == value ? rb_entries_2_result_gt : _GEN_1324; // @[POSIT_Locality.scala 45:33]
  wire [4:0] _GEN_1355 = 3'h2 == value ? rb_entries_2_result_exceptions : _GEN_1325; // @[POSIT_Locality.scala 45:33]
  wire [7:0] _GEN_1366 = 3'h3 == value ? rb_entries_3_wr_addr : _GEN_1336; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1379 = 3'h3 == value ? rb_entries_3_result_isZero : _GEN_1349; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1380 = 3'h3 == value ? rb_entries_3_result_isNaR : _GEN_1350; // @[POSIT_Locality.scala 45:33]
  wire [31:0] _GEN_1381 = 3'h3 == value ? rb_entries_3_result_out : _GEN_1351; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1382 = 3'h3 == value ? rb_entries_3_result_lt : _GEN_1352; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1383 = 3'h3 == value ? rb_entries_3_result_eq : _GEN_1353; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1384 = 3'h3 == value ? rb_entries_3_result_gt : _GEN_1354; // @[POSIT_Locality.scala 45:33]
  wire [4:0] _GEN_1385 = 3'h3 == value ? rb_entries_3_result_exceptions : _GEN_1355; // @[POSIT_Locality.scala 45:33]
  wire [7:0] _GEN_1396 = 3'h4 == value ? rb_entries_4_wr_addr : _GEN_1366; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1409 = 3'h4 == value ? rb_entries_4_result_isZero : _GEN_1379; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1410 = 3'h4 == value ? rb_entries_4_result_isNaR : _GEN_1380; // @[POSIT_Locality.scala 45:33]
  wire [31:0] _GEN_1411 = 3'h4 == value ? rb_entries_4_result_out : _GEN_1381; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1412 = 3'h4 == value ? rb_entries_4_result_lt : _GEN_1382; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1413 = 3'h4 == value ? rb_entries_4_result_eq : _GEN_1383; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1414 = 3'h4 == value ? rb_entries_4_result_gt : _GEN_1384; // @[POSIT_Locality.scala 45:33]
  wire [4:0] _GEN_1415 = 3'h4 == value ? rb_entries_4_result_exceptions : _GEN_1385; // @[POSIT_Locality.scala 45:33]
  wire [7:0] _GEN_1426 = 3'h5 == value ? rb_entries_5_wr_addr : _GEN_1396; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1439 = 3'h5 == value ? rb_entries_5_result_isZero : _GEN_1409; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1440 = 3'h5 == value ? rb_entries_5_result_isNaR : _GEN_1410; // @[POSIT_Locality.scala 45:33]
  wire [31:0] _GEN_1441 = 3'h5 == value ? rb_entries_5_result_out : _GEN_1411; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1442 = 3'h5 == value ? rb_entries_5_result_lt : _GEN_1412; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1443 = 3'h5 == value ? rb_entries_5_result_eq : _GEN_1413; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1444 = 3'h5 == value ? rb_entries_5_result_gt : _GEN_1414; // @[POSIT_Locality.scala 45:33]
  wire [4:0] _GEN_1445 = 3'h5 == value ? rb_entries_5_result_exceptions : _GEN_1415; // @[POSIT_Locality.scala 45:33]
  wire [7:0] _GEN_1456 = 3'h6 == value ? rb_entries_6_wr_addr : _GEN_1426; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1469 = 3'h6 == value ? rb_entries_6_result_isZero : _GEN_1439; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1470 = 3'h6 == value ? rb_entries_6_result_isNaR : _GEN_1440; // @[POSIT_Locality.scala 45:33]
  wire [31:0] _GEN_1471 = 3'h6 == value ? rb_entries_6_result_out : _GEN_1441; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1472 = 3'h6 == value ? rb_entries_6_result_lt : _GEN_1442; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1473 = 3'h6 == value ? rb_entries_6_result_eq : _GEN_1443; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_1474 = 3'h6 == value ? rb_entries_6_result_gt : _GEN_1444; // @[POSIT_Locality.scala 45:33]
  wire [4:0] _GEN_1475 = 3'h6 == value ? rb_entries_6_result_exceptions : _GEN_1445; // @[POSIT_Locality.scala 45:33]
  wire  _GEN_13746 = 3'h0 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_1506 = _GEN_13746 | _GEN_1128; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_13747 = 3'h1 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_1507 = _GEN_13747 | _GEN_1129; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_13748 = 3'h2 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_1508 = _GEN_13748 | _GEN_1130; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_13749 = 3'h3 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_1509 = _GEN_13749 | _GEN_1131; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_13750 = 3'h4 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_1510 = _GEN_13750 | _GEN_1132; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_13751 = 3'h5 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_1511 = _GEN_13751 | _GEN_1133; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_13752 = 3'h6 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_1512 = _GEN_13752 | _GEN_1134; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_13753 = 3'h7 == value; // @[POSIT_Locality.scala 47:47]
  wire  _GEN_1513 = _GEN_13753 | _GEN_1135; // @[POSIT_Locality.scala 47:47]
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
  wire  singleOpValidVec_12 = rb_entries_4_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 68:52]
  wire  _T_62 = rb_entries_4_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_13 = singleOpValidVec_12 & _T_62; // @[POSIT_Locality.scala 70:96]
  wire  _T_64 = rb_entries_4_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_14 = singleOpValidVec_13 & _T_64; // @[POSIT_Locality.scala 70:96]
  wire  singleOpValidVec_15 = rb_entries_5_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 68:52]
  wire  _T_67 = rb_entries_5_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_16 = singleOpValidVec_15 & _T_67; // @[POSIT_Locality.scala 70:96]
  wire  _T_69 = rb_entries_5_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_17 = singleOpValidVec_16 & _T_69; // @[POSIT_Locality.scala 70:96]
  wire  singleOpValidVec_18 = rb_entries_6_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 68:52]
  wire  _T_72 = rb_entries_6_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_19 = singleOpValidVec_18 & _T_72; // @[POSIT_Locality.scala 70:96]
  wire  _T_74 = rb_entries_6_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_20 = singleOpValidVec_19 & _T_74; // @[POSIT_Locality.scala 70:96]
  wire  singleOpValidVec_21 = rb_entries_7_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 68:52]
  wire  _T_77 = rb_entries_7_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_22 = singleOpValidVec_21 & _T_77; // @[POSIT_Locality.scala 70:96]
  wire  _T_79 = rb_entries_7_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 70:139]
  wire  singleOpValidVec_23 = singleOpValidVec_22 & _T_79; // @[POSIT_Locality.scala 70:96]
  wire  _T_81 = singleOpValidVec_2 & rb_entries_0_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_82 = ~rb_entries_0_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_0 = _T_81 & _T_82; // @[POSIT_Locality.scala 76:82]
  wire  _T_84 = singleOpValidVec_5 & rb_entries_1_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_85 = ~rb_entries_1_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_1 = _T_84 & _T_85; // @[POSIT_Locality.scala 76:82]
  wire  _T_87 = singleOpValidVec_8 & rb_entries_2_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_88 = ~rb_entries_2_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_2 = _T_87 & _T_88; // @[POSIT_Locality.scala 76:82]
  wire  _T_90 = singleOpValidVec_11 & rb_entries_3_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_91 = ~rb_entries_3_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_3 = _T_90 & _T_91; // @[POSIT_Locality.scala 76:82]
  wire  _T_93 = singleOpValidVec_14 & rb_entries_4_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_94 = ~rb_entries_4_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_4 = _T_93 & _T_94; // @[POSIT_Locality.scala 76:82]
  wire  _T_96 = singleOpValidVec_17 & rb_entries_5_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_97 = ~rb_entries_5_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_5 = _T_96 & _T_97; // @[POSIT_Locality.scala 76:82]
  wire  _T_99 = singleOpValidVec_20 & rb_entries_6_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_100 = ~rb_entries_6_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_6 = _T_99 & _T_100; // @[POSIT_Locality.scala 76:82]
  wire  _T_102 = singleOpValidVec_23 & rb_entries_7_valid; // @[POSIT_Locality.scala 76:60]
  wire  _T_103 = ~rb_entries_7_dispatched; // @[POSIT_Locality.scala 76:85]
  wire  waitingForDispatchVec_7 = _T_102 & _T_103; // @[POSIT_Locality.scala 76:82]
  wire [3:0] _T_107 = {waitingForDispatchVec_3,waitingForDispatchVec_2,waitingForDispatchVec_1,waitingForDispatchVec_0}; // @[POSIT_Locality.scala 80:58]
  wire [3:0] _T_110 = {waitingForDispatchVec_7,waitingForDispatchVec_6,waitingForDispatchVec_5,waitingForDispatchVec_4}; // @[POSIT_Locality.scala 80:58]
  wire  _T_112 = io_request_bits_wr_addr == 8'h0; // @[POSIT_Locality.scala 85:32]
  wire  _T_113 = _T_112 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_114 = dispatchArb_io_chosen == 3'h0; // @[POSIT_Locality.scala 88:89]
  wire  _T_115 = _T_114 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_116 = _T_115 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_117 = rb_entries_0_dispatched | _T_116; // @[POSIT_Locality.scala 88:78]
  wire  _T_118 = io_request_bits_wr_addr == 8'h1; // @[POSIT_Locality.scala 85:32]
  wire  _T_119 = _T_118 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_120 = dispatchArb_io_chosen == 3'h1; // @[POSIT_Locality.scala 88:89]
  wire  _T_121 = _T_120 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_122 = _T_121 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_123 = rb_entries_1_dispatched | _T_122; // @[POSIT_Locality.scala 88:78]
  wire  _T_124 = io_request_bits_wr_addr == 8'h2; // @[POSIT_Locality.scala 85:32]
  wire  _T_125 = _T_124 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_126 = dispatchArb_io_chosen == 3'h2; // @[POSIT_Locality.scala 88:89]
  wire  _T_127 = _T_126 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_128 = _T_127 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_129 = rb_entries_2_dispatched | _T_128; // @[POSIT_Locality.scala 88:78]
  wire  _T_130 = io_request_bits_wr_addr == 8'h3; // @[POSIT_Locality.scala 85:32]
  wire  _T_131 = _T_130 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_132 = dispatchArb_io_chosen == 3'h3; // @[POSIT_Locality.scala 88:89]
  wire  _T_133 = _T_132 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_134 = _T_133 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_135 = rb_entries_3_dispatched | _T_134; // @[POSIT_Locality.scala 88:78]
  wire  _T_136 = io_request_bits_wr_addr == 8'h4; // @[POSIT_Locality.scala 85:32]
  wire  _T_137 = _T_136 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_138 = dispatchArb_io_chosen == 3'h4; // @[POSIT_Locality.scala 88:89]
  wire  _T_139 = _T_138 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_140 = _T_139 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_141 = rb_entries_4_dispatched | _T_140; // @[POSIT_Locality.scala 88:78]
  wire  _T_142 = io_request_bits_wr_addr == 8'h5; // @[POSIT_Locality.scala 85:32]
  wire  _T_143 = _T_142 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_144 = dispatchArb_io_chosen == 3'h5; // @[POSIT_Locality.scala 88:89]
  wire  _T_145 = _T_144 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_146 = _T_145 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_147 = rb_entries_5_dispatched | _T_146; // @[POSIT_Locality.scala 88:78]
  wire  _T_148 = io_request_bits_wr_addr == 8'h6; // @[POSIT_Locality.scala 85:32]
  wire  _T_149 = _T_148 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_150 = dispatchArb_io_chosen == 3'h6; // @[POSIT_Locality.scala 88:89]
  wire  _T_151 = _T_150 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_152 = _T_151 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_153 = rb_entries_6_dispatched | _T_152; // @[POSIT_Locality.scala 88:78]
  wire  _T_154 = io_request_bits_wr_addr == 8'h7; // @[POSIT_Locality.scala 85:32]
  wire  _T_155 = _T_154 & new_input_log; // @[POSIT_Locality.scala 85:40]
  wire  _T_156 = dispatchArb_io_chosen == 3'h7; // @[POSIT_Locality.scala 88:89]
  wire  _T_157 = _T_156 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 88:102]
  wire  _T_158 = _T_157 & pe_io_request_ready; // @[POSIT_Locality.scala 88:130]
  wire  _T_159 = rb_entries_7_dispatched | _T_158; // @[POSIT_Locality.scala 88:78]
  wire [31:0] _GEN_1573 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_0_value : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1575 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_1_value : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1577 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_2_value : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1579 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_inst : rb_entries_0_request_inst; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1580 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_mode : rb_entries_0_request_mode; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1603 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_0_value : _GEN_1573; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1605 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_1_value : _GEN_1575; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1607 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_2_value : _GEN_1577; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1609 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_inst : _GEN_1579; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1610 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_mode : _GEN_1580; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1633 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_0_value : _GEN_1603; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1635 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_1_value : _GEN_1605; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1637 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_2_value : _GEN_1607; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1639 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_inst : _GEN_1609; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1640 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_mode : _GEN_1610; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1663 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_0_value : _GEN_1633; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1665 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_1_value : _GEN_1635; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1667 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_2_value : _GEN_1637; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1669 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_inst : _GEN_1639; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1670 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_mode : _GEN_1640; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1693 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_0_value : _GEN_1663; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1695 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_1_value : _GEN_1665; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1697 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_2_value : _GEN_1667; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1699 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_inst : _GEN_1669; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1700 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_mode : _GEN_1670; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1723 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_0_value : _GEN_1693; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1725 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_1_value : _GEN_1695; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1727 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_2_value : _GEN_1697; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1729 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_inst : _GEN_1699; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1730 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_mode : _GEN_1700; // @[POSIT_Locality.scala 100:80]
  wire  _T_164 = pe_io_result_ready & pe_io_result_valid; // @[POSIT_Locality.scala 108:33]
  wire [2:0] result_idx = pe_io_out_idx; // @[POSIT_Locality.scala 106:30 POSIT_Locality.scala 107:20]
  wire [4:0] _rb_entries_result_idx_result_exceptions = pe_io_result_bits_exceptions; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_gt = pe_io_result_bits_gt; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_eq = pe_io_result_bits_eq; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_lt = pe_io_result_bits_lt; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire [31:0] _rb_entries_result_idx_result_out = pe_io_result_bits_out; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_isNaR = pe_io_result_bits_isNaR; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _rb_entries_result_idx_result_isZero = pe_io_result_bits_isZero; // @[POSIT_Locality.scala 109:47 POSIT_Locality.scala 109:47]
  wire  _GEN_13754 = 3'h0 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_1828 = _GEN_13754 | _GEN_1112; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_13755 = 3'h1 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_1829 = _GEN_13755 | _GEN_1113; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_13756 = 3'h2 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_1830 = _GEN_13756 | _GEN_1114; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_13757 = 3'h3 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_1831 = _GEN_13757 | _GEN_1115; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_13758 = 3'h4 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_1832 = _GEN_13758 | _GEN_1116; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_13759 = 3'h5 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_1833 = _GEN_13759 | _GEN_1117; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_13760 = 3'h6 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_1834 = _GEN_13760 | _GEN_1118; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_13761 = 3'h7 == result_idx; // @[POSIT_Locality.scala 110:50]
  wire  _GEN_1835 = _GEN_13761 | _GEN_1119; // @[POSIT_Locality.scala 110:50]
  wire  _T_165 = rb_entries_0_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_1936 = 3'h1 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1966 = 3'h2 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_1936; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_1996 = 3'h3 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_1966; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2026 = 3'h4 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_1996; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2056 = 3'h5 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_2026; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2086 = 3'h6 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_2056; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2116 = 3'h7 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_2086; // @[POSIT_Locality.scala 117:100]
  wire  _T_168 = rb_entries_0_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_2420 = 3'h1 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2450 = 3'h2 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_2420; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2480 = 3'h3 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_2450; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2510 = 3'h4 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_2480; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2540 = 3'h5 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_2510; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2570 = 3'h6 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_2540; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2600 = 3'h7 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_2570; // @[POSIT_Locality.scala 117:100]
  wire  _T_171 = rb_entries_0_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_2904 = 3'h1 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2934 = 3'h2 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_2904; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2964 = 3'h3 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_2934; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_2994 = 3'h4 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_2964; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3024 = 3'h5 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_2994; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3054 = 3'h6 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_3024; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3084 = 3'h7 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_3054; // @[POSIT_Locality.scala 117:100]
  wire  _T_174 = rb_entries_1_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_3388 = 3'h1 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3418 = 3'h2 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_3388; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3448 = 3'h3 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_3418; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3478 = 3'h4 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_3448; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3508 = 3'h5 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_3478; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3538 = 3'h6 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_3508; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3568 = 3'h7 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_3538; // @[POSIT_Locality.scala 117:100]
  wire  _T_177 = rb_entries_1_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_3872 = 3'h1 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3902 = 3'h2 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_3872; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3932 = 3'h3 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_3902; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3962 = 3'h4 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_3932; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_3992 = 3'h5 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_3962; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4022 = 3'h6 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_3992; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4052 = 3'h7 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_4022; // @[POSIT_Locality.scala 117:100]
  wire  _T_180 = rb_entries_1_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_4356 = 3'h1 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4386 = 3'h2 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_4356; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4416 = 3'h3 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_4386; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4446 = 3'h4 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_4416; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4476 = 3'h5 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_4446; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4506 = 3'h6 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_4476; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4536 = 3'h7 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_4506; // @[POSIT_Locality.scala 117:100]
  wire  _T_183 = rb_entries_2_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_4840 = 3'h1 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4870 = 3'h2 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_4840; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4900 = 3'h3 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_4870; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4930 = 3'h4 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_4900; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4960 = 3'h5 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_4930; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_4990 = 3'h6 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_4960; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5020 = 3'h7 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_4990; // @[POSIT_Locality.scala 117:100]
  wire  _T_186 = rb_entries_2_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_5324 = 3'h1 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5354 = 3'h2 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_5324; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5384 = 3'h3 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_5354; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5414 = 3'h4 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_5384; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5444 = 3'h5 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_5414; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5474 = 3'h6 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_5444; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5504 = 3'h7 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_5474; // @[POSIT_Locality.scala 117:100]
  wire  _T_189 = rb_entries_2_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_5808 = 3'h1 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5838 = 3'h2 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_5808; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5868 = 3'h3 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_5838; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5898 = 3'h4 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_5868; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5928 = 3'h5 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_5898; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5958 = 3'h6 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_5928; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_5988 = 3'h7 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_5958; // @[POSIT_Locality.scala 117:100]
  wire  _T_192 = rb_entries_3_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_6292 = 3'h1 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6322 = 3'h2 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_6292; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6352 = 3'h3 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_6322; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6382 = 3'h4 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_6352; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6412 = 3'h5 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_6382; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6442 = 3'h6 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_6412; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6472 = 3'h7 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_6442; // @[POSIT_Locality.scala 117:100]
  wire  _T_195 = rb_entries_3_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_6776 = 3'h1 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6806 = 3'h2 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_6776; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6836 = 3'h3 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_6806; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6866 = 3'h4 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_6836; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6896 = 3'h5 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_6866; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6926 = 3'h6 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_6896; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_6956 = 3'h7 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_6926; // @[POSIT_Locality.scala 117:100]
  wire  _T_198 = rb_entries_3_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_7260 = 3'h1 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7290 = 3'h2 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_7260; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7320 = 3'h3 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_7290; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7350 = 3'h4 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_7320; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7380 = 3'h5 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_7350; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7410 = 3'h6 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_7380; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7440 = 3'h7 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_7410; // @[POSIT_Locality.scala 117:100]
  wire  _T_201 = rb_entries_4_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_7744 = 3'h1 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7774 = 3'h2 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_7744; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7804 = 3'h3 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_7774; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7834 = 3'h4 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_7804; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7864 = 3'h5 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_7834; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7894 = 3'h6 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_7864; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_7924 = 3'h7 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_7894; // @[POSIT_Locality.scala 117:100]
  wire  _T_204 = rb_entries_4_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_8228 = 3'h1 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8258 = 3'h2 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_8228; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8288 = 3'h3 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_8258; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8318 = 3'h4 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_8288; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8348 = 3'h5 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_8318; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8378 = 3'h6 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_8348; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8408 = 3'h7 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_8378; // @[POSIT_Locality.scala 117:100]
  wire  _T_207 = rb_entries_4_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_8712 = 3'h1 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8742 = 3'h2 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_8712; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8772 = 3'h3 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_8742; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8802 = 3'h4 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_8772; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8832 = 3'h5 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_8802; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8862 = 3'h6 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_8832; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_8892 = 3'h7 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_8862; // @[POSIT_Locality.scala 117:100]
  wire  _T_210 = rb_entries_5_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_9196 = 3'h1 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9226 = 3'h2 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_9196; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9256 = 3'h3 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_9226; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9286 = 3'h4 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_9256; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9316 = 3'h5 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_9286; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9346 = 3'h6 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_9316; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9376 = 3'h7 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_9346; // @[POSIT_Locality.scala 117:100]
  wire  _T_213 = rb_entries_5_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_9680 = 3'h1 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9710 = 3'h2 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_9680; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9740 = 3'h3 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_9710; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9770 = 3'h4 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_9740; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9800 = 3'h5 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_9770; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9830 = 3'h6 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_9800; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_9860 = 3'h7 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_9830; // @[POSIT_Locality.scala 117:100]
  wire  _T_216 = rb_entries_5_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_10164 = 3'h1 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10194 = 3'h2 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_10164; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10224 = 3'h3 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_10194; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10254 = 3'h4 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_10224; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10284 = 3'h5 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_10254; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10314 = 3'h6 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_10284; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10344 = 3'h7 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_10314; // @[POSIT_Locality.scala 117:100]
  wire  _T_219 = rb_entries_6_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_10648 = 3'h1 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10678 = 3'h2 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_10648; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10708 = 3'h3 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_10678; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10738 = 3'h4 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_10708; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10768 = 3'h5 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_10738; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10798 = 3'h6 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_10768; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_10828 = 3'h7 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_10798; // @[POSIT_Locality.scala 117:100]
  wire  _T_222 = rb_entries_6_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_11132 = 3'h1 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11162 = 3'h2 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_11132; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11192 = 3'h3 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_11162; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11222 = 3'h4 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_11192; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11252 = 3'h5 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_11222; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11282 = 3'h6 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_11252; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11312 = 3'h7 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_11282; // @[POSIT_Locality.scala 117:100]
  wire  _T_225 = rb_entries_6_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_11616 = 3'h1 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11646 = 3'h2 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_11616; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11676 = 3'h3 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_11646; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11706 = 3'h4 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_11676; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11736 = 3'h5 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_11706; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11766 = 3'h6 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_11736; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_11796 = 3'h7 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_11766; // @[POSIT_Locality.scala 117:100]
  wire  _T_228 = rb_entries_7_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_12100 = 3'h1 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12130 = 3'h2 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_12100; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12160 = 3'h3 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_12130; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12190 = 3'h4 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_12160; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12220 = 3'h5 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_12190; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12250 = 3'h6 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_12220; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12280 = 3'h7 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_12250; // @[POSIT_Locality.scala 117:100]
  wire  _T_231 = rb_entries_7_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_12584 = 3'h1 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12614 = 3'h2 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_12584; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12644 = 3'h3 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_12614; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12674 = 3'h4 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_12644; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12704 = 3'h5 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_12674; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12734 = 3'h6 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_12704; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_12764 = 3'h7 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_12734; // @[POSIT_Locality.scala 117:100]
  wire  _T_234 = rb_entries_7_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 116:69]
  wire  _GEN_13068 = 3'h1 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_13098 = 3'h2 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_13068; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_13128 = 3'h3 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_13098; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_13158 = 3'h4 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_13128; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_13188 = 3'h5 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_13158; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_13218 = 3'h6 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_13188; // @[POSIT_Locality.scala 117:100]
  wire  _GEN_13248 = 3'h7 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_13218; // @[POSIT_Locality.scala 117:100]
  reg [7:0] reg_infetch_cacheline; // @[POSIT_Locality.scala 127:45]
  reg [31:0] _RAND_185;
  wire  _T_247 = 3'h7 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_248 = _T_247 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_249 = 3'h6 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_250 = _T_249 ? io_mem_read_data[417] : _T_248; // @[Mux.scala 68:16]
  wire  _T_251 = 3'h5 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_252 = _T_251 ? io_mem_read_data[353] : _T_250; // @[Mux.scala 68:16]
  wire  _T_253 = 3'h4 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_254 = _T_253 ? io_mem_read_data[289] : _T_252; // @[Mux.scala 68:16]
  wire  _T_255 = 3'h3 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_256 = _T_255 ? io_mem_read_data[225] : _T_254; // @[Mux.scala 68:16]
  wire  _T_257 = 3'h2 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_258 = _T_257 ? io_mem_read_data[161] : _T_256; // @[Mux.scala 68:16]
  wire  _T_259 = 3'h1 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_260 = _T_259 ? io_mem_read_data[97] : _T_258; // @[Mux.scala 68:16]
  wire  _T_261 = 3'h0 == rb_entries_0_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_262 = _T_261 ? io_mem_read_data[33] : _T_260; // @[Mux.scala 68:16]
  wire  _T_273 = _T_247 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_275 = _T_249 ? io_mem_read_data[416] : _T_273; // @[Mux.scala 68:16]
  wire  _T_277 = _T_251 ? io_mem_read_data[352] : _T_275; // @[Mux.scala 68:16]
  wire  _T_279 = _T_253 ? io_mem_read_data[288] : _T_277; // @[Mux.scala 68:16]
  wire  _T_281 = _T_255 ? io_mem_read_data[224] : _T_279; // @[Mux.scala 68:16]
  wire  _T_283 = _T_257 ? io_mem_read_data[160] : _T_281; // @[Mux.scala 68:16]
  wire  _T_285 = _T_259 ? io_mem_read_data[96] : _T_283; // @[Mux.scala 68:16]
  wire  _T_287 = _T_261 ? io_mem_read_data[32] : _T_285; // @[Mux.scala 68:16]
  wire [10:0] _GEN_13762 = {{3'd0}, io_mem_read_resp_tag}; // @[POSIT_Locality.scala 137:50]
  wire  _T_290 = rb_entries_0_request_operands_0_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_292 = _T_290 & _T_262; // @[POSIT_Locality.scala 138:49]
  wire  _T_294 = _T_287 == rb_entries_0_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_295 = _T_292 & _T_294; // @[POSIT_Locality.scala 139:49]
  wire  _T_333 = 3'h7 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_334 = _T_333 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_335 = 3'h6 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_336 = _T_335 ? io_mem_read_data[417] : _T_334; // @[Mux.scala 68:16]
  wire  _T_337 = 3'h5 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_338 = _T_337 ? io_mem_read_data[353] : _T_336; // @[Mux.scala 68:16]
  wire  _T_339 = 3'h4 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_340 = _T_339 ? io_mem_read_data[289] : _T_338; // @[Mux.scala 68:16]
  wire  _T_341 = 3'h3 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_342 = _T_341 ? io_mem_read_data[225] : _T_340; // @[Mux.scala 68:16]
  wire  _T_343 = 3'h2 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_344 = _T_343 ? io_mem_read_data[161] : _T_342; // @[Mux.scala 68:16]
  wire  _T_345 = 3'h1 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_346 = _T_345 ? io_mem_read_data[97] : _T_344; // @[Mux.scala 68:16]
  wire  _T_347 = 3'h0 == rb_entries_0_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_348 = _T_347 ? io_mem_read_data[33] : _T_346; // @[Mux.scala 68:16]
  wire  _T_359 = _T_333 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_361 = _T_335 ? io_mem_read_data[416] : _T_359; // @[Mux.scala 68:16]
  wire  _T_363 = _T_337 ? io_mem_read_data[352] : _T_361; // @[Mux.scala 68:16]
  wire  _T_365 = _T_339 ? io_mem_read_data[288] : _T_363; // @[Mux.scala 68:16]
  wire  _T_367 = _T_341 ? io_mem_read_data[224] : _T_365; // @[Mux.scala 68:16]
  wire  _T_369 = _T_343 ? io_mem_read_data[160] : _T_367; // @[Mux.scala 68:16]
  wire  _T_371 = _T_345 ? io_mem_read_data[96] : _T_369; // @[Mux.scala 68:16]
  wire  _T_373 = _T_347 ? io_mem_read_data[32] : _T_371; // @[Mux.scala 68:16]
  wire  _T_376 = rb_entries_0_request_operands_1_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_378 = _T_376 & _T_348; // @[POSIT_Locality.scala 138:49]
  wire  _T_380 = _T_373 == rb_entries_0_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_381 = _T_378 & _T_380; // @[POSIT_Locality.scala 139:49]
  wire  _T_419 = 3'h7 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_420 = _T_419 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_421 = 3'h6 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_422 = _T_421 ? io_mem_read_data[417] : _T_420; // @[Mux.scala 68:16]
  wire  _T_423 = 3'h5 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_424 = _T_423 ? io_mem_read_data[353] : _T_422; // @[Mux.scala 68:16]
  wire  _T_425 = 3'h4 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_426 = _T_425 ? io_mem_read_data[289] : _T_424; // @[Mux.scala 68:16]
  wire  _T_427 = 3'h3 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_428 = _T_427 ? io_mem_read_data[225] : _T_426; // @[Mux.scala 68:16]
  wire  _T_429 = 3'h2 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_430 = _T_429 ? io_mem_read_data[161] : _T_428; // @[Mux.scala 68:16]
  wire  _T_431 = 3'h1 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_432 = _T_431 ? io_mem_read_data[97] : _T_430; // @[Mux.scala 68:16]
  wire  _T_433 = 3'h0 == rb_entries_0_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_434 = _T_433 ? io_mem_read_data[33] : _T_432; // @[Mux.scala 68:16]
  wire  _T_445 = _T_419 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_447 = _T_421 ? io_mem_read_data[416] : _T_445; // @[Mux.scala 68:16]
  wire  _T_449 = _T_423 ? io_mem_read_data[352] : _T_447; // @[Mux.scala 68:16]
  wire  _T_451 = _T_425 ? io_mem_read_data[288] : _T_449; // @[Mux.scala 68:16]
  wire  _T_453 = _T_427 ? io_mem_read_data[224] : _T_451; // @[Mux.scala 68:16]
  wire  _T_455 = _T_429 ? io_mem_read_data[160] : _T_453; // @[Mux.scala 68:16]
  wire  _T_457 = _T_431 ? io_mem_read_data[96] : _T_455; // @[Mux.scala 68:16]
  wire  _T_459 = _T_433 ? io_mem_read_data[32] : _T_457; // @[Mux.scala 68:16]
  wire  _T_462 = rb_entries_0_request_operands_2_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_464 = _T_462 & _T_434; // @[POSIT_Locality.scala 138:49]
  wire  _T_466 = _T_459 == rb_entries_0_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_467 = _T_464 & _T_466; // @[POSIT_Locality.scala 139:49]
  wire  _T_505 = 3'h7 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_506 = _T_505 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_507 = 3'h6 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_508 = _T_507 ? io_mem_read_data[417] : _T_506; // @[Mux.scala 68:16]
  wire  _T_509 = 3'h5 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_510 = _T_509 ? io_mem_read_data[353] : _T_508; // @[Mux.scala 68:16]
  wire  _T_511 = 3'h4 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_512 = _T_511 ? io_mem_read_data[289] : _T_510; // @[Mux.scala 68:16]
  wire  _T_513 = 3'h3 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_514 = _T_513 ? io_mem_read_data[225] : _T_512; // @[Mux.scala 68:16]
  wire  _T_515 = 3'h2 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_516 = _T_515 ? io_mem_read_data[161] : _T_514; // @[Mux.scala 68:16]
  wire  _T_517 = 3'h1 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_518 = _T_517 ? io_mem_read_data[97] : _T_516; // @[Mux.scala 68:16]
  wire  _T_519 = 3'h0 == rb_entries_1_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_520 = _T_519 ? io_mem_read_data[33] : _T_518; // @[Mux.scala 68:16]
  wire  _T_531 = _T_505 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_533 = _T_507 ? io_mem_read_data[416] : _T_531; // @[Mux.scala 68:16]
  wire  _T_535 = _T_509 ? io_mem_read_data[352] : _T_533; // @[Mux.scala 68:16]
  wire  _T_537 = _T_511 ? io_mem_read_data[288] : _T_535; // @[Mux.scala 68:16]
  wire  _T_539 = _T_513 ? io_mem_read_data[224] : _T_537; // @[Mux.scala 68:16]
  wire  _T_541 = _T_515 ? io_mem_read_data[160] : _T_539; // @[Mux.scala 68:16]
  wire  _T_543 = _T_517 ? io_mem_read_data[96] : _T_541; // @[Mux.scala 68:16]
  wire  _T_545 = _T_519 ? io_mem_read_data[32] : _T_543; // @[Mux.scala 68:16]
  wire  _T_548 = rb_entries_1_request_operands_0_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_550 = _T_548 & _T_520; // @[POSIT_Locality.scala 138:49]
  wire  _T_552 = _T_545 == rb_entries_1_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_553 = _T_550 & _T_552; // @[POSIT_Locality.scala 139:49]
  wire  _T_591 = 3'h7 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_592 = _T_591 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_593 = 3'h6 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_594 = _T_593 ? io_mem_read_data[417] : _T_592; // @[Mux.scala 68:16]
  wire  _T_595 = 3'h5 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_596 = _T_595 ? io_mem_read_data[353] : _T_594; // @[Mux.scala 68:16]
  wire  _T_597 = 3'h4 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_598 = _T_597 ? io_mem_read_data[289] : _T_596; // @[Mux.scala 68:16]
  wire  _T_599 = 3'h3 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_600 = _T_599 ? io_mem_read_data[225] : _T_598; // @[Mux.scala 68:16]
  wire  _T_601 = 3'h2 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_602 = _T_601 ? io_mem_read_data[161] : _T_600; // @[Mux.scala 68:16]
  wire  _T_603 = 3'h1 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_604 = _T_603 ? io_mem_read_data[97] : _T_602; // @[Mux.scala 68:16]
  wire  _T_605 = 3'h0 == rb_entries_1_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_606 = _T_605 ? io_mem_read_data[33] : _T_604; // @[Mux.scala 68:16]
  wire  _T_617 = _T_591 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_619 = _T_593 ? io_mem_read_data[416] : _T_617; // @[Mux.scala 68:16]
  wire  _T_621 = _T_595 ? io_mem_read_data[352] : _T_619; // @[Mux.scala 68:16]
  wire  _T_623 = _T_597 ? io_mem_read_data[288] : _T_621; // @[Mux.scala 68:16]
  wire  _T_625 = _T_599 ? io_mem_read_data[224] : _T_623; // @[Mux.scala 68:16]
  wire  _T_627 = _T_601 ? io_mem_read_data[160] : _T_625; // @[Mux.scala 68:16]
  wire  _T_629 = _T_603 ? io_mem_read_data[96] : _T_627; // @[Mux.scala 68:16]
  wire  _T_631 = _T_605 ? io_mem_read_data[32] : _T_629; // @[Mux.scala 68:16]
  wire  _T_634 = rb_entries_1_request_operands_1_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_636 = _T_634 & _T_606; // @[POSIT_Locality.scala 138:49]
  wire  _T_638 = _T_631 == rb_entries_1_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_639 = _T_636 & _T_638; // @[POSIT_Locality.scala 139:49]
  wire  _T_677 = 3'h7 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_678 = _T_677 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_679 = 3'h6 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_680 = _T_679 ? io_mem_read_data[417] : _T_678; // @[Mux.scala 68:16]
  wire  _T_681 = 3'h5 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_682 = _T_681 ? io_mem_read_data[353] : _T_680; // @[Mux.scala 68:16]
  wire  _T_683 = 3'h4 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_684 = _T_683 ? io_mem_read_data[289] : _T_682; // @[Mux.scala 68:16]
  wire  _T_685 = 3'h3 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_686 = _T_685 ? io_mem_read_data[225] : _T_684; // @[Mux.scala 68:16]
  wire  _T_687 = 3'h2 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_688 = _T_687 ? io_mem_read_data[161] : _T_686; // @[Mux.scala 68:16]
  wire  _T_689 = 3'h1 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_690 = _T_689 ? io_mem_read_data[97] : _T_688; // @[Mux.scala 68:16]
  wire  _T_691 = 3'h0 == rb_entries_1_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_692 = _T_691 ? io_mem_read_data[33] : _T_690; // @[Mux.scala 68:16]
  wire  _T_703 = _T_677 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_705 = _T_679 ? io_mem_read_data[416] : _T_703; // @[Mux.scala 68:16]
  wire  _T_707 = _T_681 ? io_mem_read_data[352] : _T_705; // @[Mux.scala 68:16]
  wire  _T_709 = _T_683 ? io_mem_read_data[288] : _T_707; // @[Mux.scala 68:16]
  wire  _T_711 = _T_685 ? io_mem_read_data[224] : _T_709; // @[Mux.scala 68:16]
  wire  _T_713 = _T_687 ? io_mem_read_data[160] : _T_711; // @[Mux.scala 68:16]
  wire  _T_715 = _T_689 ? io_mem_read_data[96] : _T_713; // @[Mux.scala 68:16]
  wire  _T_717 = _T_691 ? io_mem_read_data[32] : _T_715; // @[Mux.scala 68:16]
  wire  _T_720 = rb_entries_1_request_operands_2_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_722 = _T_720 & _T_692; // @[POSIT_Locality.scala 138:49]
  wire  _T_724 = _T_717 == rb_entries_1_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_725 = _T_722 & _T_724; // @[POSIT_Locality.scala 139:49]
  wire  _T_763 = 3'h7 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_764 = _T_763 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_765 = 3'h6 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_766 = _T_765 ? io_mem_read_data[417] : _T_764; // @[Mux.scala 68:16]
  wire  _T_767 = 3'h5 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_768 = _T_767 ? io_mem_read_data[353] : _T_766; // @[Mux.scala 68:16]
  wire  _T_769 = 3'h4 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_770 = _T_769 ? io_mem_read_data[289] : _T_768; // @[Mux.scala 68:16]
  wire  _T_771 = 3'h3 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_772 = _T_771 ? io_mem_read_data[225] : _T_770; // @[Mux.scala 68:16]
  wire  _T_773 = 3'h2 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_774 = _T_773 ? io_mem_read_data[161] : _T_772; // @[Mux.scala 68:16]
  wire  _T_775 = 3'h1 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_776 = _T_775 ? io_mem_read_data[97] : _T_774; // @[Mux.scala 68:16]
  wire  _T_777 = 3'h0 == rb_entries_2_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_778 = _T_777 ? io_mem_read_data[33] : _T_776; // @[Mux.scala 68:16]
  wire  _T_789 = _T_763 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_791 = _T_765 ? io_mem_read_data[416] : _T_789; // @[Mux.scala 68:16]
  wire  _T_793 = _T_767 ? io_mem_read_data[352] : _T_791; // @[Mux.scala 68:16]
  wire  _T_795 = _T_769 ? io_mem_read_data[288] : _T_793; // @[Mux.scala 68:16]
  wire  _T_797 = _T_771 ? io_mem_read_data[224] : _T_795; // @[Mux.scala 68:16]
  wire  _T_799 = _T_773 ? io_mem_read_data[160] : _T_797; // @[Mux.scala 68:16]
  wire  _T_801 = _T_775 ? io_mem_read_data[96] : _T_799; // @[Mux.scala 68:16]
  wire  _T_803 = _T_777 ? io_mem_read_data[32] : _T_801; // @[Mux.scala 68:16]
  wire  _T_806 = rb_entries_2_request_operands_0_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_808 = _T_806 & _T_778; // @[POSIT_Locality.scala 138:49]
  wire  _T_810 = _T_803 == rb_entries_2_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_811 = _T_808 & _T_810; // @[POSIT_Locality.scala 139:49]
  wire  _T_849 = 3'h7 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_850 = _T_849 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_851 = 3'h6 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_852 = _T_851 ? io_mem_read_data[417] : _T_850; // @[Mux.scala 68:16]
  wire  _T_853 = 3'h5 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_854 = _T_853 ? io_mem_read_data[353] : _T_852; // @[Mux.scala 68:16]
  wire  _T_855 = 3'h4 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_856 = _T_855 ? io_mem_read_data[289] : _T_854; // @[Mux.scala 68:16]
  wire  _T_857 = 3'h3 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_858 = _T_857 ? io_mem_read_data[225] : _T_856; // @[Mux.scala 68:16]
  wire  _T_859 = 3'h2 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_860 = _T_859 ? io_mem_read_data[161] : _T_858; // @[Mux.scala 68:16]
  wire  _T_861 = 3'h1 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_862 = _T_861 ? io_mem_read_data[97] : _T_860; // @[Mux.scala 68:16]
  wire  _T_863 = 3'h0 == rb_entries_2_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_864 = _T_863 ? io_mem_read_data[33] : _T_862; // @[Mux.scala 68:16]
  wire  _T_875 = _T_849 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_877 = _T_851 ? io_mem_read_data[416] : _T_875; // @[Mux.scala 68:16]
  wire  _T_879 = _T_853 ? io_mem_read_data[352] : _T_877; // @[Mux.scala 68:16]
  wire  _T_881 = _T_855 ? io_mem_read_data[288] : _T_879; // @[Mux.scala 68:16]
  wire  _T_883 = _T_857 ? io_mem_read_data[224] : _T_881; // @[Mux.scala 68:16]
  wire  _T_885 = _T_859 ? io_mem_read_data[160] : _T_883; // @[Mux.scala 68:16]
  wire  _T_887 = _T_861 ? io_mem_read_data[96] : _T_885; // @[Mux.scala 68:16]
  wire  _T_889 = _T_863 ? io_mem_read_data[32] : _T_887; // @[Mux.scala 68:16]
  wire  _T_892 = rb_entries_2_request_operands_1_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_894 = _T_892 & _T_864; // @[POSIT_Locality.scala 138:49]
  wire  _T_896 = _T_889 == rb_entries_2_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_897 = _T_894 & _T_896; // @[POSIT_Locality.scala 139:49]
  wire  _T_935 = 3'h7 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_936 = _T_935 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_937 = 3'h6 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_938 = _T_937 ? io_mem_read_data[417] : _T_936; // @[Mux.scala 68:16]
  wire  _T_939 = 3'h5 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_940 = _T_939 ? io_mem_read_data[353] : _T_938; // @[Mux.scala 68:16]
  wire  _T_941 = 3'h4 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_942 = _T_941 ? io_mem_read_data[289] : _T_940; // @[Mux.scala 68:16]
  wire  _T_943 = 3'h3 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_944 = _T_943 ? io_mem_read_data[225] : _T_942; // @[Mux.scala 68:16]
  wire  _T_945 = 3'h2 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_946 = _T_945 ? io_mem_read_data[161] : _T_944; // @[Mux.scala 68:16]
  wire  _T_947 = 3'h1 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_948 = _T_947 ? io_mem_read_data[97] : _T_946; // @[Mux.scala 68:16]
  wire  _T_949 = 3'h0 == rb_entries_2_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_950 = _T_949 ? io_mem_read_data[33] : _T_948; // @[Mux.scala 68:16]
  wire  _T_961 = _T_935 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_963 = _T_937 ? io_mem_read_data[416] : _T_961; // @[Mux.scala 68:16]
  wire  _T_965 = _T_939 ? io_mem_read_data[352] : _T_963; // @[Mux.scala 68:16]
  wire  _T_967 = _T_941 ? io_mem_read_data[288] : _T_965; // @[Mux.scala 68:16]
  wire  _T_969 = _T_943 ? io_mem_read_data[224] : _T_967; // @[Mux.scala 68:16]
  wire  _T_971 = _T_945 ? io_mem_read_data[160] : _T_969; // @[Mux.scala 68:16]
  wire  _T_973 = _T_947 ? io_mem_read_data[96] : _T_971; // @[Mux.scala 68:16]
  wire  _T_975 = _T_949 ? io_mem_read_data[32] : _T_973; // @[Mux.scala 68:16]
  wire  _T_978 = rb_entries_2_request_operands_2_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_980 = _T_978 & _T_950; // @[POSIT_Locality.scala 138:49]
  wire  _T_982 = _T_975 == rb_entries_2_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_983 = _T_980 & _T_982; // @[POSIT_Locality.scala 139:49]
  wire  _T_1021 = 3'h7 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1022 = _T_1021 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1023 = 3'h6 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1024 = _T_1023 ? io_mem_read_data[417] : _T_1022; // @[Mux.scala 68:16]
  wire  _T_1025 = 3'h5 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1026 = _T_1025 ? io_mem_read_data[353] : _T_1024; // @[Mux.scala 68:16]
  wire  _T_1027 = 3'h4 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1028 = _T_1027 ? io_mem_read_data[289] : _T_1026; // @[Mux.scala 68:16]
  wire  _T_1029 = 3'h3 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1030 = _T_1029 ? io_mem_read_data[225] : _T_1028; // @[Mux.scala 68:16]
  wire  _T_1031 = 3'h2 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1032 = _T_1031 ? io_mem_read_data[161] : _T_1030; // @[Mux.scala 68:16]
  wire  _T_1033 = 3'h1 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1034 = _T_1033 ? io_mem_read_data[97] : _T_1032; // @[Mux.scala 68:16]
  wire  _T_1035 = 3'h0 == rb_entries_3_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1036 = _T_1035 ? io_mem_read_data[33] : _T_1034; // @[Mux.scala 68:16]
  wire  _T_1047 = _T_1021 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1049 = _T_1023 ? io_mem_read_data[416] : _T_1047; // @[Mux.scala 68:16]
  wire  _T_1051 = _T_1025 ? io_mem_read_data[352] : _T_1049; // @[Mux.scala 68:16]
  wire  _T_1053 = _T_1027 ? io_mem_read_data[288] : _T_1051; // @[Mux.scala 68:16]
  wire  _T_1055 = _T_1029 ? io_mem_read_data[224] : _T_1053; // @[Mux.scala 68:16]
  wire  _T_1057 = _T_1031 ? io_mem_read_data[160] : _T_1055; // @[Mux.scala 68:16]
  wire  _T_1059 = _T_1033 ? io_mem_read_data[96] : _T_1057; // @[Mux.scala 68:16]
  wire  _T_1061 = _T_1035 ? io_mem_read_data[32] : _T_1059; // @[Mux.scala 68:16]
  wire  _T_1064 = rb_entries_3_request_operands_0_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1066 = _T_1064 & _T_1036; // @[POSIT_Locality.scala 138:49]
  wire  _T_1068 = _T_1061 == rb_entries_3_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1069 = _T_1066 & _T_1068; // @[POSIT_Locality.scala 139:49]
  wire  _T_1107 = 3'h7 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1108 = _T_1107 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1109 = 3'h6 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1110 = _T_1109 ? io_mem_read_data[417] : _T_1108; // @[Mux.scala 68:16]
  wire  _T_1111 = 3'h5 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1112 = _T_1111 ? io_mem_read_data[353] : _T_1110; // @[Mux.scala 68:16]
  wire  _T_1113 = 3'h4 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1114 = _T_1113 ? io_mem_read_data[289] : _T_1112; // @[Mux.scala 68:16]
  wire  _T_1115 = 3'h3 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1116 = _T_1115 ? io_mem_read_data[225] : _T_1114; // @[Mux.scala 68:16]
  wire  _T_1117 = 3'h2 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1118 = _T_1117 ? io_mem_read_data[161] : _T_1116; // @[Mux.scala 68:16]
  wire  _T_1119 = 3'h1 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1120 = _T_1119 ? io_mem_read_data[97] : _T_1118; // @[Mux.scala 68:16]
  wire  _T_1121 = 3'h0 == rb_entries_3_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1122 = _T_1121 ? io_mem_read_data[33] : _T_1120; // @[Mux.scala 68:16]
  wire  _T_1133 = _T_1107 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1135 = _T_1109 ? io_mem_read_data[416] : _T_1133; // @[Mux.scala 68:16]
  wire  _T_1137 = _T_1111 ? io_mem_read_data[352] : _T_1135; // @[Mux.scala 68:16]
  wire  _T_1139 = _T_1113 ? io_mem_read_data[288] : _T_1137; // @[Mux.scala 68:16]
  wire  _T_1141 = _T_1115 ? io_mem_read_data[224] : _T_1139; // @[Mux.scala 68:16]
  wire  _T_1143 = _T_1117 ? io_mem_read_data[160] : _T_1141; // @[Mux.scala 68:16]
  wire  _T_1145 = _T_1119 ? io_mem_read_data[96] : _T_1143; // @[Mux.scala 68:16]
  wire  _T_1147 = _T_1121 ? io_mem_read_data[32] : _T_1145; // @[Mux.scala 68:16]
  wire  _T_1150 = rb_entries_3_request_operands_1_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1152 = _T_1150 & _T_1122; // @[POSIT_Locality.scala 138:49]
  wire  _T_1154 = _T_1147 == rb_entries_3_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1155 = _T_1152 & _T_1154; // @[POSIT_Locality.scala 139:49]
  wire  _T_1193 = 3'h7 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1194 = _T_1193 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1195 = 3'h6 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1196 = _T_1195 ? io_mem_read_data[417] : _T_1194; // @[Mux.scala 68:16]
  wire  _T_1197 = 3'h5 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1198 = _T_1197 ? io_mem_read_data[353] : _T_1196; // @[Mux.scala 68:16]
  wire  _T_1199 = 3'h4 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1200 = _T_1199 ? io_mem_read_data[289] : _T_1198; // @[Mux.scala 68:16]
  wire  _T_1201 = 3'h3 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1202 = _T_1201 ? io_mem_read_data[225] : _T_1200; // @[Mux.scala 68:16]
  wire  _T_1203 = 3'h2 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1204 = _T_1203 ? io_mem_read_data[161] : _T_1202; // @[Mux.scala 68:16]
  wire  _T_1205 = 3'h1 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1206 = _T_1205 ? io_mem_read_data[97] : _T_1204; // @[Mux.scala 68:16]
  wire  _T_1207 = 3'h0 == rb_entries_3_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1208 = _T_1207 ? io_mem_read_data[33] : _T_1206; // @[Mux.scala 68:16]
  wire  _T_1219 = _T_1193 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1221 = _T_1195 ? io_mem_read_data[416] : _T_1219; // @[Mux.scala 68:16]
  wire  _T_1223 = _T_1197 ? io_mem_read_data[352] : _T_1221; // @[Mux.scala 68:16]
  wire  _T_1225 = _T_1199 ? io_mem_read_data[288] : _T_1223; // @[Mux.scala 68:16]
  wire  _T_1227 = _T_1201 ? io_mem_read_data[224] : _T_1225; // @[Mux.scala 68:16]
  wire  _T_1229 = _T_1203 ? io_mem_read_data[160] : _T_1227; // @[Mux.scala 68:16]
  wire  _T_1231 = _T_1205 ? io_mem_read_data[96] : _T_1229; // @[Mux.scala 68:16]
  wire  _T_1233 = _T_1207 ? io_mem_read_data[32] : _T_1231; // @[Mux.scala 68:16]
  wire  _T_1236 = rb_entries_3_request_operands_2_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1238 = _T_1236 & _T_1208; // @[POSIT_Locality.scala 138:49]
  wire  _T_1240 = _T_1233 == rb_entries_3_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1241 = _T_1238 & _T_1240; // @[POSIT_Locality.scala 139:49]
  wire  _T_1279 = 3'h7 == rb_entries_4_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1280 = _T_1279 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1281 = 3'h6 == rb_entries_4_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1282 = _T_1281 ? io_mem_read_data[417] : _T_1280; // @[Mux.scala 68:16]
  wire  _T_1283 = 3'h5 == rb_entries_4_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1284 = _T_1283 ? io_mem_read_data[353] : _T_1282; // @[Mux.scala 68:16]
  wire  _T_1285 = 3'h4 == rb_entries_4_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1286 = _T_1285 ? io_mem_read_data[289] : _T_1284; // @[Mux.scala 68:16]
  wire  _T_1287 = 3'h3 == rb_entries_4_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1288 = _T_1287 ? io_mem_read_data[225] : _T_1286; // @[Mux.scala 68:16]
  wire  _T_1289 = 3'h2 == rb_entries_4_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1290 = _T_1289 ? io_mem_read_data[161] : _T_1288; // @[Mux.scala 68:16]
  wire  _T_1291 = 3'h1 == rb_entries_4_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1292 = _T_1291 ? io_mem_read_data[97] : _T_1290; // @[Mux.scala 68:16]
  wire  _T_1293 = 3'h0 == rb_entries_4_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1294 = _T_1293 ? io_mem_read_data[33] : _T_1292; // @[Mux.scala 68:16]
  wire  _T_1305 = _T_1279 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1307 = _T_1281 ? io_mem_read_data[416] : _T_1305; // @[Mux.scala 68:16]
  wire  _T_1309 = _T_1283 ? io_mem_read_data[352] : _T_1307; // @[Mux.scala 68:16]
  wire  _T_1311 = _T_1285 ? io_mem_read_data[288] : _T_1309; // @[Mux.scala 68:16]
  wire  _T_1313 = _T_1287 ? io_mem_read_data[224] : _T_1311; // @[Mux.scala 68:16]
  wire  _T_1315 = _T_1289 ? io_mem_read_data[160] : _T_1313; // @[Mux.scala 68:16]
  wire  _T_1317 = _T_1291 ? io_mem_read_data[96] : _T_1315; // @[Mux.scala 68:16]
  wire  _T_1319 = _T_1293 ? io_mem_read_data[32] : _T_1317; // @[Mux.scala 68:16]
  wire  _T_1322 = rb_entries_4_request_operands_0_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1324 = _T_1322 & _T_1294; // @[POSIT_Locality.scala 138:49]
  wire  _T_1326 = _T_1319 == rb_entries_4_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1327 = _T_1324 & _T_1326; // @[POSIT_Locality.scala 139:49]
  wire  _T_1365 = 3'h7 == rb_entries_4_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1366 = _T_1365 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1367 = 3'h6 == rb_entries_4_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1368 = _T_1367 ? io_mem_read_data[417] : _T_1366; // @[Mux.scala 68:16]
  wire  _T_1369 = 3'h5 == rb_entries_4_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1370 = _T_1369 ? io_mem_read_data[353] : _T_1368; // @[Mux.scala 68:16]
  wire  _T_1371 = 3'h4 == rb_entries_4_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1372 = _T_1371 ? io_mem_read_data[289] : _T_1370; // @[Mux.scala 68:16]
  wire  _T_1373 = 3'h3 == rb_entries_4_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1374 = _T_1373 ? io_mem_read_data[225] : _T_1372; // @[Mux.scala 68:16]
  wire  _T_1375 = 3'h2 == rb_entries_4_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1376 = _T_1375 ? io_mem_read_data[161] : _T_1374; // @[Mux.scala 68:16]
  wire  _T_1377 = 3'h1 == rb_entries_4_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1378 = _T_1377 ? io_mem_read_data[97] : _T_1376; // @[Mux.scala 68:16]
  wire  _T_1379 = 3'h0 == rb_entries_4_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1380 = _T_1379 ? io_mem_read_data[33] : _T_1378; // @[Mux.scala 68:16]
  wire  _T_1391 = _T_1365 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1393 = _T_1367 ? io_mem_read_data[416] : _T_1391; // @[Mux.scala 68:16]
  wire  _T_1395 = _T_1369 ? io_mem_read_data[352] : _T_1393; // @[Mux.scala 68:16]
  wire  _T_1397 = _T_1371 ? io_mem_read_data[288] : _T_1395; // @[Mux.scala 68:16]
  wire  _T_1399 = _T_1373 ? io_mem_read_data[224] : _T_1397; // @[Mux.scala 68:16]
  wire  _T_1401 = _T_1375 ? io_mem_read_data[160] : _T_1399; // @[Mux.scala 68:16]
  wire  _T_1403 = _T_1377 ? io_mem_read_data[96] : _T_1401; // @[Mux.scala 68:16]
  wire  _T_1405 = _T_1379 ? io_mem_read_data[32] : _T_1403; // @[Mux.scala 68:16]
  wire  _T_1408 = rb_entries_4_request_operands_1_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1410 = _T_1408 & _T_1380; // @[POSIT_Locality.scala 138:49]
  wire  _T_1412 = _T_1405 == rb_entries_4_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1413 = _T_1410 & _T_1412; // @[POSIT_Locality.scala 139:49]
  wire  _T_1451 = 3'h7 == rb_entries_4_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1452 = _T_1451 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1453 = 3'h6 == rb_entries_4_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1454 = _T_1453 ? io_mem_read_data[417] : _T_1452; // @[Mux.scala 68:16]
  wire  _T_1455 = 3'h5 == rb_entries_4_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1456 = _T_1455 ? io_mem_read_data[353] : _T_1454; // @[Mux.scala 68:16]
  wire  _T_1457 = 3'h4 == rb_entries_4_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1458 = _T_1457 ? io_mem_read_data[289] : _T_1456; // @[Mux.scala 68:16]
  wire  _T_1459 = 3'h3 == rb_entries_4_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1460 = _T_1459 ? io_mem_read_data[225] : _T_1458; // @[Mux.scala 68:16]
  wire  _T_1461 = 3'h2 == rb_entries_4_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1462 = _T_1461 ? io_mem_read_data[161] : _T_1460; // @[Mux.scala 68:16]
  wire  _T_1463 = 3'h1 == rb_entries_4_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1464 = _T_1463 ? io_mem_read_data[97] : _T_1462; // @[Mux.scala 68:16]
  wire  _T_1465 = 3'h0 == rb_entries_4_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1466 = _T_1465 ? io_mem_read_data[33] : _T_1464; // @[Mux.scala 68:16]
  wire  _T_1477 = _T_1451 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1479 = _T_1453 ? io_mem_read_data[416] : _T_1477; // @[Mux.scala 68:16]
  wire  _T_1481 = _T_1455 ? io_mem_read_data[352] : _T_1479; // @[Mux.scala 68:16]
  wire  _T_1483 = _T_1457 ? io_mem_read_data[288] : _T_1481; // @[Mux.scala 68:16]
  wire  _T_1485 = _T_1459 ? io_mem_read_data[224] : _T_1483; // @[Mux.scala 68:16]
  wire  _T_1487 = _T_1461 ? io_mem_read_data[160] : _T_1485; // @[Mux.scala 68:16]
  wire  _T_1489 = _T_1463 ? io_mem_read_data[96] : _T_1487; // @[Mux.scala 68:16]
  wire  _T_1491 = _T_1465 ? io_mem_read_data[32] : _T_1489; // @[Mux.scala 68:16]
  wire  _T_1494 = rb_entries_4_request_operands_2_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1496 = _T_1494 & _T_1466; // @[POSIT_Locality.scala 138:49]
  wire  _T_1498 = _T_1491 == rb_entries_4_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1499 = _T_1496 & _T_1498; // @[POSIT_Locality.scala 139:49]
  wire  _T_1537 = 3'h7 == rb_entries_5_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1538 = _T_1537 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1539 = 3'h6 == rb_entries_5_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1540 = _T_1539 ? io_mem_read_data[417] : _T_1538; // @[Mux.scala 68:16]
  wire  _T_1541 = 3'h5 == rb_entries_5_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1542 = _T_1541 ? io_mem_read_data[353] : _T_1540; // @[Mux.scala 68:16]
  wire  _T_1543 = 3'h4 == rb_entries_5_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1544 = _T_1543 ? io_mem_read_data[289] : _T_1542; // @[Mux.scala 68:16]
  wire  _T_1545 = 3'h3 == rb_entries_5_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1546 = _T_1545 ? io_mem_read_data[225] : _T_1544; // @[Mux.scala 68:16]
  wire  _T_1547 = 3'h2 == rb_entries_5_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1548 = _T_1547 ? io_mem_read_data[161] : _T_1546; // @[Mux.scala 68:16]
  wire  _T_1549 = 3'h1 == rb_entries_5_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1550 = _T_1549 ? io_mem_read_data[97] : _T_1548; // @[Mux.scala 68:16]
  wire  _T_1551 = 3'h0 == rb_entries_5_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1552 = _T_1551 ? io_mem_read_data[33] : _T_1550; // @[Mux.scala 68:16]
  wire  _T_1563 = _T_1537 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1565 = _T_1539 ? io_mem_read_data[416] : _T_1563; // @[Mux.scala 68:16]
  wire  _T_1567 = _T_1541 ? io_mem_read_data[352] : _T_1565; // @[Mux.scala 68:16]
  wire  _T_1569 = _T_1543 ? io_mem_read_data[288] : _T_1567; // @[Mux.scala 68:16]
  wire  _T_1571 = _T_1545 ? io_mem_read_data[224] : _T_1569; // @[Mux.scala 68:16]
  wire  _T_1573 = _T_1547 ? io_mem_read_data[160] : _T_1571; // @[Mux.scala 68:16]
  wire  _T_1575 = _T_1549 ? io_mem_read_data[96] : _T_1573; // @[Mux.scala 68:16]
  wire  _T_1577 = _T_1551 ? io_mem_read_data[32] : _T_1575; // @[Mux.scala 68:16]
  wire  _T_1580 = rb_entries_5_request_operands_0_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1582 = _T_1580 & _T_1552; // @[POSIT_Locality.scala 138:49]
  wire  _T_1584 = _T_1577 == rb_entries_5_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1585 = _T_1582 & _T_1584; // @[POSIT_Locality.scala 139:49]
  wire  _T_1623 = 3'h7 == rb_entries_5_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1624 = _T_1623 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1625 = 3'h6 == rb_entries_5_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1626 = _T_1625 ? io_mem_read_data[417] : _T_1624; // @[Mux.scala 68:16]
  wire  _T_1627 = 3'h5 == rb_entries_5_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1628 = _T_1627 ? io_mem_read_data[353] : _T_1626; // @[Mux.scala 68:16]
  wire  _T_1629 = 3'h4 == rb_entries_5_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1630 = _T_1629 ? io_mem_read_data[289] : _T_1628; // @[Mux.scala 68:16]
  wire  _T_1631 = 3'h3 == rb_entries_5_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1632 = _T_1631 ? io_mem_read_data[225] : _T_1630; // @[Mux.scala 68:16]
  wire  _T_1633 = 3'h2 == rb_entries_5_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1634 = _T_1633 ? io_mem_read_data[161] : _T_1632; // @[Mux.scala 68:16]
  wire  _T_1635 = 3'h1 == rb_entries_5_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1636 = _T_1635 ? io_mem_read_data[97] : _T_1634; // @[Mux.scala 68:16]
  wire  _T_1637 = 3'h0 == rb_entries_5_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1638 = _T_1637 ? io_mem_read_data[33] : _T_1636; // @[Mux.scala 68:16]
  wire  _T_1649 = _T_1623 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1651 = _T_1625 ? io_mem_read_data[416] : _T_1649; // @[Mux.scala 68:16]
  wire  _T_1653 = _T_1627 ? io_mem_read_data[352] : _T_1651; // @[Mux.scala 68:16]
  wire  _T_1655 = _T_1629 ? io_mem_read_data[288] : _T_1653; // @[Mux.scala 68:16]
  wire  _T_1657 = _T_1631 ? io_mem_read_data[224] : _T_1655; // @[Mux.scala 68:16]
  wire  _T_1659 = _T_1633 ? io_mem_read_data[160] : _T_1657; // @[Mux.scala 68:16]
  wire  _T_1661 = _T_1635 ? io_mem_read_data[96] : _T_1659; // @[Mux.scala 68:16]
  wire  _T_1663 = _T_1637 ? io_mem_read_data[32] : _T_1661; // @[Mux.scala 68:16]
  wire  _T_1666 = rb_entries_5_request_operands_1_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1668 = _T_1666 & _T_1638; // @[POSIT_Locality.scala 138:49]
  wire  _T_1670 = _T_1663 == rb_entries_5_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1671 = _T_1668 & _T_1670; // @[POSIT_Locality.scala 139:49]
  wire  _T_1709 = 3'h7 == rb_entries_5_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1710 = _T_1709 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1711 = 3'h6 == rb_entries_5_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1712 = _T_1711 ? io_mem_read_data[417] : _T_1710; // @[Mux.scala 68:16]
  wire  _T_1713 = 3'h5 == rb_entries_5_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1714 = _T_1713 ? io_mem_read_data[353] : _T_1712; // @[Mux.scala 68:16]
  wire  _T_1715 = 3'h4 == rb_entries_5_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1716 = _T_1715 ? io_mem_read_data[289] : _T_1714; // @[Mux.scala 68:16]
  wire  _T_1717 = 3'h3 == rb_entries_5_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1718 = _T_1717 ? io_mem_read_data[225] : _T_1716; // @[Mux.scala 68:16]
  wire  _T_1719 = 3'h2 == rb_entries_5_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1720 = _T_1719 ? io_mem_read_data[161] : _T_1718; // @[Mux.scala 68:16]
  wire  _T_1721 = 3'h1 == rb_entries_5_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1722 = _T_1721 ? io_mem_read_data[97] : _T_1720; // @[Mux.scala 68:16]
  wire  _T_1723 = 3'h0 == rb_entries_5_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1724 = _T_1723 ? io_mem_read_data[33] : _T_1722; // @[Mux.scala 68:16]
  wire  _T_1735 = _T_1709 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1737 = _T_1711 ? io_mem_read_data[416] : _T_1735; // @[Mux.scala 68:16]
  wire  _T_1739 = _T_1713 ? io_mem_read_data[352] : _T_1737; // @[Mux.scala 68:16]
  wire  _T_1741 = _T_1715 ? io_mem_read_data[288] : _T_1739; // @[Mux.scala 68:16]
  wire  _T_1743 = _T_1717 ? io_mem_read_data[224] : _T_1741; // @[Mux.scala 68:16]
  wire  _T_1745 = _T_1719 ? io_mem_read_data[160] : _T_1743; // @[Mux.scala 68:16]
  wire  _T_1747 = _T_1721 ? io_mem_read_data[96] : _T_1745; // @[Mux.scala 68:16]
  wire  _T_1749 = _T_1723 ? io_mem_read_data[32] : _T_1747; // @[Mux.scala 68:16]
  wire  _T_1752 = rb_entries_5_request_operands_2_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1754 = _T_1752 & _T_1724; // @[POSIT_Locality.scala 138:49]
  wire  _T_1756 = _T_1749 == rb_entries_5_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1757 = _T_1754 & _T_1756; // @[POSIT_Locality.scala 139:49]
  wire  _T_1795 = 3'h7 == rb_entries_6_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1796 = _T_1795 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1797 = 3'h6 == rb_entries_6_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1798 = _T_1797 ? io_mem_read_data[417] : _T_1796; // @[Mux.scala 68:16]
  wire  _T_1799 = 3'h5 == rb_entries_6_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1800 = _T_1799 ? io_mem_read_data[353] : _T_1798; // @[Mux.scala 68:16]
  wire  _T_1801 = 3'h4 == rb_entries_6_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1802 = _T_1801 ? io_mem_read_data[289] : _T_1800; // @[Mux.scala 68:16]
  wire  _T_1803 = 3'h3 == rb_entries_6_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1804 = _T_1803 ? io_mem_read_data[225] : _T_1802; // @[Mux.scala 68:16]
  wire  _T_1805 = 3'h2 == rb_entries_6_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1806 = _T_1805 ? io_mem_read_data[161] : _T_1804; // @[Mux.scala 68:16]
  wire  _T_1807 = 3'h1 == rb_entries_6_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1808 = _T_1807 ? io_mem_read_data[97] : _T_1806; // @[Mux.scala 68:16]
  wire  _T_1809 = 3'h0 == rb_entries_6_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1810 = _T_1809 ? io_mem_read_data[33] : _T_1808; // @[Mux.scala 68:16]
  wire  _T_1821 = _T_1795 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1823 = _T_1797 ? io_mem_read_data[416] : _T_1821; // @[Mux.scala 68:16]
  wire  _T_1825 = _T_1799 ? io_mem_read_data[352] : _T_1823; // @[Mux.scala 68:16]
  wire  _T_1827 = _T_1801 ? io_mem_read_data[288] : _T_1825; // @[Mux.scala 68:16]
  wire  _T_1829 = _T_1803 ? io_mem_read_data[224] : _T_1827; // @[Mux.scala 68:16]
  wire  _T_1831 = _T_1805 ? io_mem_read_data[160] : _T_1829; // @[Mux.scala 68:16]
  wire  _T_1833 = _T_1807 ? io_mem_read_data[96] : _T_1831; // @[Mux.scala 68:16]
  wire  _T_1835 = _T_1809 ? io_mem_read_data[32] : _T_1833; // @[Mux.scala 68:16]
  wire  _T_1838 = rb_entries_6_request_operands_0_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1840 = _T_1838 & _T_1810; // @[POSIT_Locality.scala 138:49]
  wire  _T_1842 = _T_1835 == rb_entries_6_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1843 = _T_1840 & _T_1842; // @[POSIT_Locality.scala 139:49]
  wire  _T_1881 = 3'h7 == rb_entries_6_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1882 = _T_1881 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1883 = 3'h6 == rb_entries_6_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1884 = _T_1883 ? io_mem_read_data[417] : _T_1882; // @[Mux.scala 68:16]
  wire  _T_1885 = 3'h5 == rb_entries_6_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1886 = _T_1885 ? io_mem_read_data[353] : _T_1884; // @[Mux.scala 68:16]
  wire  _T_1887 = 3'h4 == rb_entries_6_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1888 = _T_1887 ? io_mem_read_data[289] : _T_1886; // @[Mux.scala 68:16]
  wire  _T_1889 = 3'h3 == rb_entries_6_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1890 = _T_1889 ? io_mem_read_data[225] : _T_1888; // @[Mux.scala 68:16]
  wire  _T_1891 = 3'h2 == rb_entries_6_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1892 = _T_1891 ? io_mem_read_data[161] : _T_1890; // @[Mux.scala 68:16]
  wire  _T_1893 = 3'h1 == rb_entries_6_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1894 = _T_1893 ? io_mem_read_data[97] : _T_1892; // @[Mux.scala 68:16]
  wire  _T_1895 = 3'h0 == rb_entries_6_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1896 = _T_1895 ? io_mem_read_data[33] : _T_1894; // @[Mux.scala 68:16]
  wire  _T_1907 = _T_1881 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1909 = _T_1883 ? io_mem_read_data[416] : _T_1907; // @[Mux.scala 68:16]
  wire  _T_1911 = _T_1885 ? io_mem_read_data[352] : _T_1909; // @[Mux.scala 68:16]
  wire  _T_1913 = _T_1887 ? io_mem_read_data[288] : _T_1911; // @[Mux.scala 68:16]
  wire  _T_1915 = _T_1889 ? io_mem_read_data[224] : _T_1913; // @[Mux.scala 68:16]
  wire  _T_1917 = _T_1891 ? io_mem_read_data[160] : _T_1915; // @[Mux.scala 68:16]
  wire  _T_1919 = _T_1893 ? io_mem_read_data[96] : _T_1917; // @[Mux.scala 68:16]
  wire  _T_1921 = _T_1895 ? io_mem_read_data[32] : _T_1919; // @[Mux.scala 68:16]
  wire  _T_1924 = rb_entries_6_request_operands_1_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_1926 = _T_1924 & _T_1896; // @[POSIT_Locality.scala 138:49]
  wire  _T_1928 = _T_1921 == rb_entries_6_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_1929 = _T_1926 & _T_1928; // @[POSIT_Locality.scala 139:49]
  wire  _T_1967 = 3'h7 == rb_entries_6_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1968 = _T_1967 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_1969 = 3'h6 == rb_entries_6_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1970 = _T_1969 ? io_mem_read_data[417] : _T_1968; // @[Mux.scala 68:16]
  wire  _T_1971 = 3'h5 == rb_entries_6_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1972 = _T_1971 ? io_mem_read_data[353] : _T_1970; // @[Mux.scala 68:16]
  wire  _T_1973 = 3'h4 == rb_entries_6_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1974 = _T_1973 ? io_mem_read_data[289] : _T_1972; // @[Mux.scala 68:16]
  wire  _T_1975 = 3'h3 == rb_entries_6_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1976 = _T_1975 ? io_mem_read_data[225] : _T_1974; // @[Mux.scala 68:16]
  wire  _T_1977 = 3'h2 == rb_entries_6_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1978 = _T_1977 ? io_mem_read_data[161] : _T_1976; // @[Mux.scala 68:16]
  wire  _T_1979 = 3'h1 == rb_entries_6_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1980 = _T_1979 ? io_mem_read_data[97] : _T_1978; // @[Mux.scala 68:16]
  wire  _T_1981 = 3'h0 == rb_entries_6_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_1982 = _T_1981 ? io_mem_read_data[33] : _T_1980; // @[Mux.scala 68:16]
  wire  _T_1993 = _T_1967 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_1995 = _T_1969 ? io_mem_read_data[416] : _T_1993; // @[Mux.scala 68:16]
  wire  _T_1997 = _T_1971 ? io_mem_read_data[352] : _T_1995; // @[Mux.scala 68:16]
  wire  _T_1999 = _T_1973 ? io_mem_read_data[288] : _T_1997; // @[Mux.scala 68:16]
  wire  _T_2001 = _T_1975 ? io_mem_read_data[224] : _T_1999; // @[Mux.scala 68:16]
  wire  _T_2003 = _T_1977 ? io_mem_read_data[160] : _T_2001; // @[Mux.scala 68:16]
  wire  _T_2005 = _T_1979 ? io_mem_read_data[96] : _T_2003; // @[Mux.scala 68:16]
  wire  _T_2007 = _T_1981 ? io_mem_read_data[32] : _T_2005; // @[Mux.scala 68:16]
  wire  _T_2010 = rb_entries_6_request_operands_2_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_2012 = _T_2010 & _T_1982; // @[POSIT_Locality.scala 138:49]
  wire  _T_2014 = _T_2007 == rb_entries_6_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_2015 = _T_2012 & _T_2014; // @[POSIT_Locality.scala 139:49]
  wire  _T_2053 = 3'h7 == rb_entries_7_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2054 = _T_2053 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_2055 = 3'h6 == rb_entries_7_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2056 = _T_2055 ? io_mem_read_data[417] : _T_2054; // @[Mux.scala 68:16]
  wire  _T_2057 = 3'h5 == rb_entries_7_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2058 = _T_2057 ? io_mem_read_data[353] : _T_2056; // @[Mux.scala 68:16]
  wire  _T_2059 = 3'h4 == rb_entries_7_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2060 = _T_2059 ? io_mem_read_data[289] : _T_2058; // @[Mux.scala 68:16]
  wire  _T_2061 = 3'h3 == rb_entries_7_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2062 = _T_2061 ? io_mem_read_data[225] : _T_2060; // @[Mux.scala 68:16]
  wire  _T_2063 = 3'h2 == rb_entries_7_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2064 = _T_2063 ? io_mem_read_data[161] : _T_2062; // @[Mux.scala 68:16]
  wire  _T_2065 = 3'h1 == rb_entries_7_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2066 = _T_2065 ? io_mem_read_data[97] : _T_2064; // @[Mux.scala 68:16]
  wire  _T_2067 = 3'h0 == rb_entries_7_request_operands_0_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2068 = _T_2067 ? io_mem_read_data[33] : _T_2066; // @[Mux.scala 68:16]
  wire  _T_2079 = _T_2053 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_2081 = _T_2055 ? io_mem_read_data[416] : _T_2079; // @[Mux.scala 68:16]
  wire  _T_2083 = _T_2057 ? io_mem_read_data[352] : _T_2081; // @[Mux.scala 68:16]
  wire  _T_2085 = _T_2059 ? io_mem_read_data[288] : _T_2083; // @[Mux.scala 68:16]
  wire  _T_2087 = _T_2061 ? io_mem_read_data[224] : _T_2085; // @[Mux.scala 68:16]
  wire  _T_2089 = _T_2063 ? io_mem_read_data[160] : _T_2087; // @[Mux.scala 68:16]
  wire  _T_2091 = _T_2065 ? io_mem_read_data[96] : _T_2089; // @[Mux.scala 68:16]
  wire  _T_2093 = _T_2067 ? io_mem_read_data[32] : _T_2091; // @[Mux.scala 68:16]
  wire  _T_2096 = rb_entries_7_request_operands_0_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_2098 = _T_2096 & _T_2068; // @[POSIT_Locality.scala 138:49]
  wire  _T_2100 = _T_2093 == rb_entries_7_request_operands_0_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_2101 = _T_2098 & _T_2100; // @[POSIT_Locality.scala 139:49]
  wire  _T_2139 = 3'h7 == rb_entries_7_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2140 = _T_2139 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_2141 = 3'h6 == rb_entries_7_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2142 = _T_2141 ? io_mem_read_data[417] : _T_2140; // @[Mux.scala 68:16]
  wire  _T_2143 = 3'h5 == rb_entries_7_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2144 = _T_2143 ? io_mem_read_data[353] : _T_2142; // @[Mux.scala 68:16]
  wire  _T_2145 = 3'h4 == rb_entries_7_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2146 = _T_2145 ? io_mem_read_data[289] : _T_2144; // @[Mux.scala 68:16]
  wire  _T_2147 = 3'h3 == rb_entries_7_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2148 = _T_2147 ? io_mem_read_data[225] : _T_2146; // @[Mux.scala 68:16]
  wire  _T_2149 = 3'h2 == rb_entries_7_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2150 = _T_2149 ? io_mem_read_data[161] : _T_2148; // @[Mux.scala 68:16]
  wire  _T_2151 = 3'h1 == rb_entries_7_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2152 = _T_2151 ? io_mem_read_data[97] : _T_2150; // @[Mux.scala 68:16]
  wire  _T_2153 = 3'h0 == rb_entries_7_request_operands_1_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2154 = _T_2153 ? io_mem_read_data[33] : _T_2152; // @[Mux.scala 68:16]
  wire  _T_2165 = _T_2139 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_2167 = _T_2141 ? io_mem_read_data[416] : _T_2165; // @[Mux.scala 68:16]
  wire  _T_2169 = _T_2143 ? io_mem_read_data[352] : _T_2167; // @[Mux.scala 68:16]
  wire  _T_2171 = _T_2145 ? io_mem_read_data[288] : _T_2169; // @[Mux.scala 68:16]
  wire  _T_2173 = _T_2147 ? io_mem_read_data[224] : _T_2171; // @[Mux.scala 68:16]
  wire  _T_2175 = _T_2149 ? io_mem_read_data[160] : _T_2173; // @[Mux.scala 68:16]
  wire  _T_2177 = _T_2151 ? io_mem_read_data[96] : _T_2175; // @[Mux.scala 68:16]
  wire  _T_2179 = _T_2153 ? io_mem_read_data[32] : _T_2177; // @[Mux.scala 68:16]
  wire  _T_2182 = rb_entries_7_request_operands_1_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_2184 = _T_2182 & _T_2154; // @[POSIT_Locality.scala 138:49]
  wire  _T_2186 = _T_2179 == rb_entries_7_request_operands_1_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_2187 = _T_2184 & _T_2186; // @[POSIT_Locality.scala 139:49]
  wire  _T_2225 = 3'h7 == rb_entries_7_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2226 = _T_2225 & io_mem_read_data[481]; // @[Mux.scala 68:16]
  wire  _T_2227 = 3'h6 == rb_entries_7_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2228 = _T_2227 ? io_mem_read_data[417] : _T_2226; // @[Mux.scala 68:16]
  wire  _T_2229 = 3'h5 == rb_entries_7_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2230 = _T_2229 ? io_mem_read_data[353] : _T_2228; // @[Mux.scala 68:16]
  wire  _T_2231 = 3'h4 == rb_entries_7_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2232 = _T_2231 ? io_mem_read_data[289] : _T_2230; // @[Mux.scala 68:16]
  wire  _T_2233 = 3'h3 == rb_entries_7_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2234 = _T_2233 ? io_mem_read_data[225] : _T_2232; // @[Mux.scala 68:16]
  wire  _T_2235 = 3'h2 == rb_entries_7_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2236 = _T_2235 ? io_mem_read_data[161] : _T_2234; // @[Mux.scala 68:16]
  wire  _T_2237 = 3'h1 == rb_entries_7_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2238 = _T_2237 ? io_mem_read_data[97] : _T_2236; // @[Mux.scala 68:16]
  wire  _T_2239 = 3'h0 == rb_entries_7_request_operands_2_value[2:0]; // @[Mux.scala 68:19]
  wire  _T_2240 = _T_2239 ? io_mem_read_data[33] : _T_2238; // @[Mux.scala 68:16]
  wire  _T_2251 = _T_2225 & io_mem_read_data[480]; // @[Mux.scala 68:16]
  wire  _T_2253 = _T_2227 ? io_mem_read_data[416] : _T_2251; // @[Mux.scala 68:16]
  wire  _T_2255 = _T_2229 ? io_mem_read_data[352] : _T_2253; // @[Mux.scala 68:16]
  wire  _T_2257 = _T_2231 ? io_mem_read_data[288] : _T_2255; // @[Mux.scala 68:16]
  wire  _T_2259 = _T_2233 ? io_mem_read_data[224] : _T_2257; // @[Mux.scala 68:16]
  wire  _T_2261 = _T_2235 ? io_mem_read_data[160] : _T_2259; // @[Mux.scala 68:16]
  wire  _T_2263 = _T_2237 ? io_mem_read_data[96] : _T_2261; // @[Mux.scala 68:16]
  wire  _T_2265 = _T_2239 ? io_mem_read_data[32] : _T_2263; // @[Mux.scala 68:16]
  wire  _T_2268 = rb_entries_7_request_operands_2_value[13:3] == _GEN_13762; // @[POSIT_Locality.scala 137:50]
  wire  _T_2270 = _T_2268 & _T_2240; // @[POSIT_Locality.scala 138:49]
  wire  _T_2272 = _T_2265 == rb_entries_7_request_operands_2_mode[0]; // @[POSIT_Locality.scala 139:59]
  wire  _T_2273 = _T_2270 & _T_2272; // @[POSIT_Locality.scala 139:49]
  wire  _T_2303 = rb_entries_0_valid & rb_entries_0_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _GEN_13786 = {{3'd0}, reg_infetch_cacheline}; // @[POSIT_Locality.scala 163:210]
  wire [10:0] _T_2305 = rb_entries_0_request_operands_0_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2306 = _T_2305 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_0 = _T_2303 & _T_2306; // @[POSIT_Locality.scala 163:146]
  wire  _T_2313 = rb_entries_0_valid & rb_entries_0_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2315 = rb_entries_0_request_operands_1_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2316 = _T_2315 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_1 = _T_2313 & _T_2316; // @[POSIT_Locality.scala 163:146]
  wire  _T_2323 = rb_entries_0_valid & rb_entries_0_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2325 = rb_entries_0_request_operands_2_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2326 = _T_2325 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_2 = _T_2323 & _T_2326; // @[POSIT_Locality.scala 163:146]
  wire  _T_2333 = rb_entries_1_valid & rb_entries_1_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2335 = rb_entries_1_request_operands_0_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2336 = _T_2335 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_3 = _T_2333 & _T_2336; // @[POSIT_Locality.scala 163:146]
  wire  _T_2343 = rb_entries_1_valid & rb_entries_1_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2345 = rb_entries_1_request_operands_1_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2346 = _T_2345 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_4 = _T_2343 & _T_2346; // @[POSIT_Locality.scala 163:146]
  wire  _T_2353 = rb_entries_1_valid & rb_entries_1_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2355 = rb_entries_1_request_operands_2_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2356 = _T_2355 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_5 = _T_2353 & _T_2356; // @[POSIT_Locality.scala 163:146]
  wire  _T_2363 = rb_entries_2_valid & rb_entries_2_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2365 = rb_entries_2_request_operands_0_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2366 = _T_2365 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_6 = _T_2363 & _T_2366; // @[POSIT_Locality.scala 163:146]
  wire  _T_2373 = rb_entries_2_valid & rb_entries_2_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2375 = rb_entries_2_request_operands_1_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2376 = _T_2375 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_7 = _T_2373 & _T_2376; // @[POSIT_Locality.scala 163:146]
  wire  _T_2383 = rb_entries_2_valid & rb_entries_2_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2385 = rb_entries_2_request_operands_2_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2386 = _T_2385 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_8 = _T_2383 & _T_2386; // @[POSIT_Locality.scala 163:146]
  wire  _T_2393 = rb_entries_3_valid & rb_entries_3_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2395 = rb_entries_3_request_operands_0_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2396 = _T_2395 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_9 = _T_2393 & _T_2396; // @[POSIT_Locality.scala 163:146]
  wire  _T_2403 = rb_entries_3_valid & rb_entries_3_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2405 = rb_entries_3_request_operands_1_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2406 = _T_2405 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_10 = _T_2403 & _T_2406; // @[POSIT_Locality.scala 163:146]
  wire  _T_2413 = rb_entries_3_valid & rb_entries_3_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2415 = rb_entries_3_request_operands_2_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2416 = _T_2415 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_11 = _T_2413 & _T_2416; // @[POSIT_Locality.scala 163:146]
  wire  _T_2423 = rb_entries_4_valid & rb_entries_4_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2425 = rb_entries_4_request_operands_0_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2426 = _T_2425 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_12 = _T_2423 & _T_2426; // @[POSIT_Locality.scala 163:146]
  wire  _T_2433 = rb_entries_4_valid & rb_entries_4_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2435 = rb_entries_4_request_operands_1_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2436 = _T_2435 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_13 = _T_2433 & _T_2436; // @[POSIT_Locality.scala 163:146]
  wire  _T_2443 = rb_entries_4_valid & rb_entries_4_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2445 = rb_entries_4_request_operands_2_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2446 = _T_2445 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_14 = _T_2443 & _T_2446; // @[POSIT_Locality.scala 163:146]
  wire  _T_2453 = rb_entries_5_valid & rb_entries_5_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2455 = rb_entries_5_request_operands_0_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2456 = _T_2455 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_15 = _T_2453 & _T_2456; // @[POSIT_Locality.scala 163:146]
  wire  _T_2463 = rb_entries_5_valid & rb_entries_5_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2465 = rb_entries_5_request_operands_1_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2466 = _T_2465 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_16 = _T_2463 & _T_2466; // @[POSIT_Locality.scala 163:146]
  wire  _T_2473 = rb_entries_5_valid & rb_entries_5_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2475 = rb_entries_5_request_operands_2_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2476 = _T_2475 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_17 = _T_2473 & _T_2476; // @[POSIT_Locality.scala 163:146]
  wire  _T_2483 = rb_entries_6_valid & rb_entries_6_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2485 = rb_entries_6_request_operands_0_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2486 = _T_2485 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_18 = _T_2483 & _T_2486; // @[POSIT_Locality.scala 163:146]
  wire  _T_2493 = rb_entries_6_valid & rb_entries_6_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2495 = rb_entries_6_request_operands_1_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2496 = _T_2495 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_19 = _T_2493 & _T_2496; // @[POSIT_Locality.scala 163:146]
  wire  _T_2503 = rb_entries_6_valid & rb_entries_6_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2505 = rb_entries_6_request_operands_2_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2506 = _T_2505 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_20 = _T_2503 & _T_2506; // @[POSIT_Locality.scala 163:146]
  wire  _T_2513 = rb_entries_7_valid & rb_entries_7_request_operands_0_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2515 = rb_entries_7_request_operands_0_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2516 = _T_2515 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_21 = _T_2513 & _T_2516; // @[POSIT_Locality.scala 163:146]
  wire  _T_2523 = rb_entries_7_valid & rb_entries_7_request_operands_1_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2525 = rb_entries_7_request_operands_1_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2526 = _T_2525 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_22 = _T_2523 & _T_2526; // @[POSIT_Locality.scala 163:146]
  wire  _T_2533 = rb_entries_7_valid & rb_entries_7_request_operands_2_mode[1]; // @[POSIT_Locality.scala 163:91]
  wire [10:0] _T_2535 = rb_entries_7_request_operands_2_value[13:3] & _GEN_13786; // @[POSIT_Locality.scala 163:210]
  wire  _T_2536 = _T_2535 == 11'h0; // @[POSIT_Locality.scala 163:236]
  wire  waitingToBeFetched_23 = _T_2533 & _T_2536; // @[POSIT_Locality.scala 163:146]
  wire [5:0] _T_2545 = {waitingToBeFetched_5,waitingToBeFetched_4,waitingToBeFetched_3,waitingToBeFetched_2,waitingToBeFetched_1,waitingToBeFetched_0}; // @[POSIT_Locality.scala 173:52]
  wire [11:0] _T_2551 = {waitingToBeFetched_11,waitingToBeFetched_10,waitingToBeFetched_9,waitingToBeFetched_8,waitingToBeFetched_7,waitingToBeFetched_6,_T_2545}; // @[POSIT_Locality.scala 173:52]
  wire [5:0] _T_2556 = {waitingToBeFetched_17,waitingToBeFetched_16,waitingToBeFetched_15,waitingToBeFetched_14,waitingToBeFetched_13,waitingToBeFetched_12}; // @[POSIT_Locality.scala 173:52]
  wire [11:0] _T_2562 = {waitingToBeFetched_23,waitingToBeFetched_22,waitingToBeFetched_21,waitingToBeFetched_20,waitingToBeFetched_19,waitingToBeFetched_18,_T_2556}; // @[POSIT_Locality.scala 173:52]
  wire [23:0] _T_2563 = {waitingToBeFetched_23,waitingToBeFetched_22,waitingToBeFetched_21,waitingToBeFetched_20,waitingToBeFetched_19,waitingToBeFetched_18,_T_2556,_T_2551}; // @[POSIT_Locality.scala 173:52]
  wire [47:0] fetchOffSet_0 = {{16'd0}, rb_entries_0_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] fetchOffSet_1 = {{16'd0}, rb_entries_0_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13661 = 5'h1 == fetchArb_io_chosen ? fetchOffSet_1 : fetchOffSet_0; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_2 = {{16'd0}, rb_entries_0_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13662 = 5'h2 == fetchArb_io_chosen ? fetchOffSet_2 : _GEN_13661; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_3 = {{16'd0}, rb_entries_1_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13663 = 5'h3 == fetchArb_io_chosen ? fetchOffSet_3 : _GEN_13662; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_4 = {{16'd0}, rb_entries_1_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13664 = 5'h4 == fetchArb_io_chosen ? fetchOffSet_4 : _GEN_13663; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_5 = {{16'd0}, rb_entries_1_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13665 = 5'h5 == fetchArb_io_chosen ? fetchOffSet_5 : _GEN_13664; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_6 = {{16'd0}, rb_entries_2_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13666 = 5'h6 == fetchArb_io_chosen ? fetchOffSet_6 : _GEN_13665; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_7 = {{16'd0}, rb_entries_2_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13667 = 5'h7 == fetchArb_io_chosen ? fetchOffSet_7 : _GEN_13666; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_8 = {{16'd0}, rb_entries_2_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13668 = 5'h8 == fetchArb_io_chosen ? fetchOffSet_8 : _GEN_13667; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_9 = {{16'd0}, rb_entries_3_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13669 = 5'h9 == fetchArb_io_chosen ? fetchOffSet_9 : _GEN_13668; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_10 = {{16'd0}, rb_entries_3_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13670 = 5'ha == fetchArb_io_chosen ? fetchOffSet_10 : _GEN_13669; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_11 = {{16'd0}, rb_entries_3_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13671 = 5'hb == fetchArb_io_chosen ? fetchOffSet_11 : _GEN_13670; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_12 = {{16'd0}, rb_entries_4_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13672 = 5'hc == fetchArb_io_chosen ? fetchOffSet_12 : _GEN_13671; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_13 = {{16'd0}, rb_entries_4_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13673 = 5'hd == fetchArb_io_chosen ? fetchOffSet_13 : _GEN_13672; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_14 = {{16'd0}, rb_entries_4_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13674 = 5'he == fetchArb_io_chosen ? fetchOffSet_14 : _GEN_13673; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_15 = {{16'd0}, rb_entries_5_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13675 = 5'hf == fetchArb_io_chosen ? fetchOffSet_15 : _GEN_13674; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_16 = {{16'd0}, rb_entries_5_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13676 = 5'h10 == fetchArb_io_chosen ? fetchOffSet_16 : _GEN_13675; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_17 = {{16'd0}, rb_entries_5_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13677 = 5'h11 == fetchArb_io_chosen ? fetchOffSet_17 : _GEN_13676; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_18 = {{16'd0}, rb_entries_6_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13678 = 5'h12 == fetchArb_io_chosen ? fetchOffSet_18 : _GEN_13677; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_19 = {{16'd0}, rb_entries_6_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13679 = 5'h13 == fetchArb_io_chosen ? fetchOffSet_19 : _GEN_13678; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_20 = {{16'd0}, rb_entries_6_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13680 = 5'h14 == fetchArb_io_chosen ? fetchOffSet_20 : _GEN_13679; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_21 = {{16'd0}, rb_entries_7_request_operands_0_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13681 = 5'h15 == fetchArb_io_chosen ? fetchOffSet_21 : _GEN_13680; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_22 = {{16'd0}, rb_entries_7_request_operands_1_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13682 = 5'h16 == fetchArb_io_chosen ? fetchOffSet_22 : _GEN_13681; // @[POSIT_Locality.scala 182:75]
  wire [47:0] fetchOffSet_23 = {{16'd0}, rb_entries_7_request_operands_2_value}; // @[POSIT_Locality.scala 157:31 POSIT_Locality.scala 168:53]
  wire [47:0] _GEN_13683 = 5'h17 == fetchArb_io_chosen ? fetchOffSet_23 : _GEN_13682; // @[POSIT_Locality.scala 182:75]
  wire [10:0] _T_2565 = _GEN_13683[13:3] & _GEN_13786; // @[POSIT_Locality.scala 182:95]
  wire  _T_2566 = _T_2565 != 11'h0; // @[POSIT_Locality.scala 182:120]
  wire [5:0] _T_2571 = {rb_entries_1_request_inFetch_2,rb_entries_1_request_inFetch_1,rb_entries_1_request_inFetch_0,rb_entries_0_request_inFetch_2,rb_entries_0_request_inFetch_1,rb_entries_0_request_inFetch_0}; // @[POSIT_Locality.scala 183:42]
  wire [11:0] _T_2577 = {rb_entries_3_request_inFetch_2,rb_entries_3_request_inFetch_1,rb_entries_3_request_inFetch_0,rb_entries_2_request_inFetch_2,rb_entries_2_request_inFetch_1,rb_entries_2_request_inFetch_0,_T_2571}; // @[POSIT_Locality.scala 183:42]
  wire [5:0] _T_2582 = {rb_entries_5_request_inFetch_2,rb_entries_5_request_inFetch_1,rb_entries_5_request_inFetch_0,rb_entries_4_request_inFetch_2,rb_entries_4_request_inFetch_1,rb_entries_4_request_inFetch_0}; // @[POSIT_Locality.scala 183:42]
  wire [23:0] _T_2589 = {rb_entries_7_request_inFetch_2,rb_entries_7_request_inFetch_1,rb_entries_7_request_inFetch_0,rb_entries_6_request_inFetch_2,rb_entries_6_request_inFetch_1,rb_entries_6_request_inFetch_0,_T_2582,_T_2577}; // @[POSIT_Locality.scala 183:42]
  wire [31:0] _T_2590 = 32'h1 << fetchArb_io_chosen; // @[OneHot.scala 58:35]
  wire [23:0] _T_2592 = _T_2566 ? _T_2590[23:0] : 24'h0; // @[POSIT_Locality.scala 183:54]
  wire [23:0] _T_2593 = _T_2589 ^ _T_2592; // @[POSIT_Locality.scala 183:49]
  wire  _T_2618 = 1'h1 ^ _T_2566; // @[POSIT_Locality.scala 184:49]
  wire  _T_2622 = _GEN_13683[13:11] != 3'h0; // @[OneHot.scala 32:14]
  wire [7:0] _GEN_13835 = {{5'd0}, _GEN_13683[13:11]}; // @[OneHot.scala 32:28]
  wire [7:0] _T_2623 = _GEN_13835 | _GEN_13683[10:3]; // @[OneHot.scala 32:28]
  wire  _T_2626 = _T_2623[7:4] != 4'h0; // @[OneHot.scala 32:14]
  wire [3:0] _T_2627 = _T_2623[7:4] | _T_2623[3:0]; // @[OneHot.scala 32:28]
  wire  _T_2630 = _T_2627[3:2] != 2'h0; // @[OneHot.scala 32:14]
  wire [1:0] _T_2631 = _T_2627[3:2] | _T_2627[1:0]; // @[OneHot.scala 32:28]
  wire [3:0] _T_2635 = {_T_2622,_T_2626,_T_2630,_T_2631[1]}; // @[Cat.scala 30:58]
  wire  inFetch_2 = fetchArb_io_hasChosen ? _T_2593[2] : rb_entries_0_request_inFetch_2; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_1 = fetchArb_io_hasChosen ? _T_2593[1] : rb_entries_0_request_inFetch_1; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_0 = fetchArb_io_hasChosen ? _T_2593[0] : rb_entries_0_request_inFetch_0; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_5 = fetchArb_io_hasChosen ? _T_2593[5] : rb_entries_1_request_inFetch_2; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_4 = fetchArb_io_hasChosen ? _T_2593[4] : rb_entries_1_request_inFetch_1; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_3 = fetchArb_io_hasChosen ? _T_2593[3] : rb_entries_1_request_inFetch_0; // @[POSIT_Locality.scala 181:36]
  wire [5:0] _T_2650 = {inFetch_5,inFetch_4,inFetch_3,inFetch_2,inFetch_1,inFetch_0}; // @[POSIT_Locality.scala 192:49]
  wire  inFetch_8 = fetchArb_io_hasChosen ? _T_2593[8] : rb_entries_2_request_inFetch_2; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_7 = fetchArb_io_hasChosen ? _T_2593[7] : rb_entries_2_request_inFetch_1; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_6 = fetchArb_io_hasChosen ? _T_2593[6] : rb_entries_2_request_inFetch_0; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_11 = fetchArb_io_hasChosen ? _T_2593[11] : rb_entries_3_request_inFetch_2; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_10 = fetchArb_io_hasChosen ? _T_2593[10] : rb_entries_3_request_inFetch_1; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_9 = fetchArb_io_hasChosen ? _T_2593[9] : rb_entries_3_request_inFetch_0; // @[POSIT_Locality.scala 181:36]
  wire [11:0] _T_2656 = {inFetch_11,inFetch_10,inFetch_9,inFetch_8,inFetch_7,inFetch_6,_T_2650}; // @[POSIT_Locality.scala 192:49]
  wire  inFetch_14 = fetchArb_io_hasChosen ? _T_2593[14] : rb_entries_4_request_inFetch_2; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_13 = fetchArb_io_hasChosen ? _T_2593[13] : rb_entries_4_request_inFetch_1; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_12 = fetchArb_io_hasChosen ? _T_2593[12] : rb_entries_4_request_inFetch_0; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_17 = fetchArb_io_hasChosen ? _T_2593[17] : rb_entries_5_request_inFetch_2; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_16 = fetchArb_io_hasChosen ? _T_2593[16] : rb_entries_5_request_inFetch_1; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_15 = fetchArb_io_hasChosen ? _T_2593[15] : rb_entries_5_request_inFetch_0; // @[POSIT_Locality.scala 181:36]
  wire [5:0] _T_2661 = {inFetch_17,inFetch_16,inFetch_15,inFetch_14,inFetch_13,inFetch_12}; // @[POSIT_Locality.scala 192:49]
  wire  inFetch_20 = fetchArb_io_hasChosen ? _T_2593[20] : rb_entries_6_request_inFetch_2; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_19 = fetchArb_io_hasChosen ? _T_2593[19] : rb_entries_6_request_inFetch_1; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_18 = fetchArb_io_hasChosen ? _T_2593[18] : rb_entries_6_request_inFetch_0; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_23 = fetchArb_io_hasChosen ? _T_2593[23] : rb_entries_7_request_inFetch_2; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_22 = fetchArb_io_hasChosen ? _T_2593[22] : rb_entries_7_request_inFetch_1; // @[POSIT_Locality.scala 181:36]
  wire  inFetch_21 = fetchArb_io_hasChosen ? _T_2593[21] : rb_entries_7_request_inFetch_0; // @[POSIT_Locality.scala 181:36]
  wire [23:0] _T_2668 = {inFetch_23,inFetch_22,inFetch_21,inFetch_20,inFetch_19,inFetch_18,_T_2661,_T_2656}; // @[POSIT_Locality.scala 192:49]
  wire [3:0] _GEN_13709 = fetchArb_io_hasChosen ? _T_2635 : _T_2635; // @[POSIT_Locality.scala 181:36]
  wire [10:0] _GEN_13710 = fetchArb_io_hasChosen ? _GEN_13683[13:3] : 11'h0; // @[POSIT_Locality.scala 181:36]
  wire [7:0] _T_2704 = reg_infetch_cacheline | io_mem_read_resp_tag; // @[POSIT_Locality.scala 209:56]
  wire [7:0] _T_2705 = _T_2704 ^ io_mem_read_resp_tag; // @[POSIT_Locality.scala 209:80]
  wire [15:0] _GEN_13837 = {{8'd0}, reg_infetch_cacheline}; // @[POSIT_Locality.scala 210:53]
  wire [15:0] _T_2706 = _GEN_13837 | io_mem_read_req_tag; // @[POSIT_Locality.scala 210:53]
  wire [15:0] _GEN_13838 = {{8'd0}, _T_2705}; // @[POSIT_Locality.scala 211:52]
  wire [15:0] _T_2707 = _GEN_13838 | io_mem_read_req_tag; // @[POSIT_Locality.scala 211:52]
  wire [15:0] _GEN_13735 = io_mem_read_req_valid ? _T_2707 : {{8'd0}, _T_2705}; // @[POSIT_Locality.scala 213:52]
  wire [15:0] _GEN_13736 = io_mem_read_req_valid ? _T_2706 : {{8'd0}, reg_infetch_cacheline}; // @[POSIT_Locality.scala 219:52]
  wire [15:0] _GEN_13737 = io_mem_read_resp_valid ? _GEN_13735 : _GEN_13736; // @[POSIT_Locality.scala 212:45]
  wire  _T_2708 = io_mem_read_req_valid | io_mem_read_resp_valid; // @[POSIT_Locality.scala 225:44]
  wire  _T_2747 = io_request_valid | io_mem_write_valid; // @[POSIT_Locality.scala 249:39]
  wire  _T_2748 = _T_2747 | io_mem_read_req_valid; // @[POSIT_Locality.scala 249:61]
  wire  _T_2749 = _T_2748 | pe_io_result_valid; // @[POSIT_Locality.scala 249:86]
  wire [5:0] _T_2851 = {_T_2356,_T_2346,_T_2336,_T_2326,_T_2316,_T_2306}; // @[POSIT_Locality.scala 289:118]
  wire [11:0] _T_2857 = {_T_2416,_T_2406,_T_2396,_T_2386,_T_2376,_T_2366,_T_2851}; // @[POSIT_Locality.scala 289:118]
  wire [5:0] _T_2862 = {_T_2476,_T_2466,_T_2456,_T_2446,_T_2436,_T_2426}; // @[POSIT_Locality.scala 289:118]
  wire [23:0] _T_2869 = {_T_2536,_T_2526,_T_2516,_T_2506,_T_2496,_T_2486,_T_2862,_T_2857}; // @[POSIT_Locality.scala 289:118]
  wire  _GEN_13843 = io_mem_read_resp_valid & rb_entries_0_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13844 = _GEN_13843 & _T_295; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13845 = io_mem_read_resp_valid & rb_entries_0_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13846 = _GEN_13845 & _T_381; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13847 = io_mem_read_resp_valid & rb_entries_0_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13848 = _GEN_13847 & _T_467; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13849 = io_mem_read_resp_valid & rb_entries_1_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13850 = _GEN_13849 & _T_553; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13851 = io_mem_read_resp_valid & rb_entries_1_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13852 = _GEN_13851 & _T_639; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13853 = io_mem_read_resp_valid & rb_entries_1_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13854 = _GEN_13853 & _T_725; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13855 = io_mem_read_resp_valid & rb_entries_2_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13856 = _GEN_13855 & _T_811; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13857 = io_mem_read_resp_valid & rb_entries_2_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13858 = _GEN_13857 & _T_897; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13859 = io_mem_read_resp_valid & rb_entries_2_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13860 = _GEN_13859 & _T_983; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13861 = io_mem_read_resp_valid & rb_entries_3_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13862 = _GEN_13861 & _T_1069; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13863 = io_mem_read_resp_valid & rb_entries_3_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13864 = _GEN_13863 & _T_1155; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13865 = io_mem_read_resp_valid & rb_entries_3_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13866 = _GEN_13865 & _T_1241; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13867 = io_mem_read_resp_valid & rb_entries_4_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13868 = _GEN_13867 & _T_1327; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13869 = io_mem_read_resp_valid & rb_entries_4_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13870 = _GEN_13869 & _T_1413; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13871 = io_mem_read_resp_valid & rb_entries_4_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13872 = _GEN_13871 & _T_1499; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13873 = io_mem_read_resp_valid & rb_entries_5_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13874 = _GEN_13873 & _T_1585; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13875 = io_mem_read_resp_valid & rb_entries_5_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13876 = _GEN_13875 & _T_1671; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13877 = io_mem_read_resp_valid & rb_entries_5_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13878 = _GEN_13877 & _T_1757; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13879 = io_mem_read_resp_valid & rb_entries_6_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13880 = _GEN_13879 & _T_1843; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13881 = io_mem_read_resp_valid & rb_entries_6_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13882 = _GEN_13881 & _T_1929; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13883 = io_mem_read_resp_valid & rb_entries_6_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13884 = _GEN_13883 & _T_2015; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13885 = io_mem_read_resp_valid & rb_entries_7_request_operands_0_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13886 = _GEN_13885 & _T_2101; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13887 = io_mem_read_resp_valid & rb_entries_7_request_operands_1_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13888 = _GEN_13887 & _T_2187; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13889 = io_mem_read_resp_valid & rb_entries_7_request_operands_2_mode[1]; // @[POSIT_Locality.scala 143:55]
  wire  _GEN_13890 = _GEN_13889 & _T_2273; // @[POSIT_Locality.scala 143:55]
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
  assign io_request_ready = _GEN_219 | _T_3; // @[POSIT_Locality.scala 24:26]
  assign io_mem_write_valid = _GEN_1482 & _T_37; // @[POSIT_Locality.scala 53:28]
  assign io_mem_write_bits_result_isZero = 3'h7 == value ? rb_entries_7_result_isZero : _GEN_1469; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_isNaR = 3'h7 == value ? rb_entries_7_result_isNaR : _GEN_1470; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_out = 3'h7 == value ? rb_entries_7_result_out : _GEN_1471; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_lt = 3'h7 == value ? rb_entries_7_result_lt : _GEN_1472; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_eq = 3'h7 == value ? rb_entries_7_result_eq : _GEN_1473; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_gt = 3'h7 == value ? rb_entries_7_result_gt : _GEN_1474; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_result_exceptions = 3'h7 == value ? rb_entries_7_result_exceptions : _GEN_1475; // @[POSIT_Locality.scala 55:34]
  assign io_mem_write_bits_wr_addr = 3'h7 == value ? rb_entries_7_wr_addr : _GEN_1456; // @[POSIT_Locality.scala 54:35]
  assign io_mem_read_req_valid = fetchArb_io_hasChosen & _T_2618; // @[POSIT_Locality.scala 184:39 POSIT_Locality.scala 195:39]
  assign io_mem_read_req_addr = {{38'd0}, _GEN_13709}; // @[POSIT_Locality.scala 185:38 POSIT_Locality.scala 196:38]
  assign io_mem_read_req_tag = {{5'd0}, _GEN_13710}; // @[POSIT_Locality.scala 187:37 POSIT_Locality.scala 197:37]
  assign pe_clock = clock;
  assign pe_reset = reset;
  assign pe_io_request_valid = dispatchArb_io_hasChosen & pe_io_request_ready; // @[POSIT_Locality.scala 93:37 POSIT_Locality.scala 95:37]
  assign pe_io_request_bits_num1 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_0_value : _GEN_1723; // @[POSIT_Locality.scala 100:33]
  assign pe_io_request_bits_num2 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_1_value : _GEN_1725; // @[POSIT_Locality.scala 101:33]
  assign pe_io_request_bits_num3 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_2_value : _GEN_1727; // @[POSIT_Locality.scala 102:33]
  assign pe_io_request_bits_inst = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_inst : _GEN_1729; // @[POSIT_Locality.scala 104:33]
  assign pe_io_request_bits_mode = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_mode : _GEN_1730; // @[POSIT_Locality.scala 103:33]
  assign pe_io_result_ready = io_mem_write_ready; // @[POSIT_Locality.scala 99:28]
  assign pe_io_in_idx = dispatchArb_io_chosen; // @[POSIT_Locality.scala 97:22]
  assign dispatchArb_io_validity = {_T_110,_T_107}; // @[POSIT_Locality.scala 80:33]
  assign dispatchArb_io_priority = {{2'd0}, wbCountOn}; // @[POSIT_Locality.scala 81:33]
  assign fetchArb_io_validity = {_T_2562,_T_2551}; // @[POSIT_Locality.scala 173:30]
  assign fetchArb_io_priority = {{4'd0}, wbCountOn}; // @[POSIT_Locality.scala 174:30]
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
  rb_entries_0_request_inFetch_0 = _RAND_13[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  rb_entries_0_request_inFetch_1 = _RAND_14[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  rb_entries_0_request_inFetch_2 = _RAND_15[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  rb_entries_0_result_isZero = _RAND_16[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  rb_entries_0_result_isNaR = _RAND_17[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  rb_entries_0_result_out = _RAND_18[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  rb_entries_0_result_lt = _RAND_19[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  rb_entries_0_result_eq = _RAND_20[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  rb_entries_0_result_gt = _RAND_21[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  rb_entries_0_result_exceptions = _RAND_22[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {1{`RANDOM}};
  rb_entries_1_completed = _RAND_23[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  rb_entries_1_valid = _RAND_24[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  rb_entries_1_dispatched = _RAND_25[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{`RANDOM}};
  rb_entries_1_written = _RAND_26[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  rb_entries_1_wr_addr = _RAND_27[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{`RANDOM}};
  rb_entries_1_request_operands_0_value = _RAND_28[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  rb_entries_1_request_operands_0_mode = _RAND_29[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  rb_entries_1_request_operands_1_value = _RAND_30[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  rb_entries_1_request_operands_1_mode = _RAND_31[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{`RANDOM}};
  rb_entries_1_request_operands_2_value = _RAND_32[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_33 = {1{`RANDOM}};
  rb_entries_1_request_operands_2_mode = _RAND_33[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{`RANDOM}};
  rb_entries_1_request_inst = _RAND_34[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_35 = {1{`RANDOM}};
  rb_entries_1_request_mode = _RAND_35[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{`RANDOM}};
  rb_entries_1_request_inFetch_0 = _RAND_36[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_37 = {1{`RANDOM}};
  rb_entries_1_request_inFetch_1 = _RAND_37[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_38 = {1{`RANDOM}};
  rb_entries_1_request_inFetch_2 = _RAND_38[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_39 = {1{`RANDOM}};
  rb_entries_1_result_isZero = _RAND_39[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_40 = {1{`RANDOM}};
  rb_entries_1_result_isNaR = _RAND_40[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_41 = {1{`RANDOM}};
  rb_entries_1_result_out = _RAND_41[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_42 = {1{`RANDOM}};
  rb_entries_1_result_lt = _RAND_42[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_43 = {1{`RANDOM}};
  rb_entries_1_result_eq = _RAND_43[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_44 = {1{`RANDOM}};
  rb_entries_1_result_gt = _RAND_44[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_45 = {1{`RANDOM}};
  rb_entries_1_result_exceptions = _RAND_45[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_46 = {1{`RANDOM}};
  rb_entries_2_completed = _RAND_46[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_47 = {1{`RANDOM}};
  rb_entries_2_valid = _RAND_47[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_48 = {1{`RANDOM}};
  rb_entries_2_dispatched = _RAND_48[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_49 = {1{`RANDOM}};
  rb_entries_2_written = _RAND_49[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_50 = {1{`RANDOM}};
  rb_entries_2_wr_addr = _RAND_50[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_51 = {1{`RANDOM}};
  rb_entries_2_request_operands_0_value = _RAND_51[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_52 = {1{`RANDOM}};
  rb_entries_2_request_operands_0_mode = _RAND_52[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_53 = {1{`RANDOM}};
  rb_entries_2_request_operands_1_value = _RAND_53[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_54 = {1{`RANDOM}};
  rb_entries_2_request_operands_1_mode = _RAND_54[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_55 = {1{`RANDOM}};
  rb_entries_2_request_operands_2_value = _RAND_55[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_56 = {1{`RANDOM}};
  rb_entries_2_request_operands_2_mode = _RAND_56[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_57 = {1{`RANDOM}};
  rb_entries_2_request_inst = _RAND_57[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_58 = {1{`RANDOM}};
  rb_entries_2_request_mode = _RAND_58[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_59 = {1{`RANDOM}};
  rb_entries_2_request_inFetch_0 = _RAND_59[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_60 = {1{`RANDOM}};
  rb_entries_2_request_inFetch_1 = _RAND_60[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_61 = {1{`RANDOM}};
  rb_entries_2_request_inFetch_2 = _RAND_61[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_62 = {1{`RANDOM}};
  rb_entries_2_result_isZero = _RAND_62[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_63 = {1{`RANDOM}};
  rb_entries_2_result_isNaR = _RAND_63[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_64 = {1{`RANDOM}};
  rb_entries_2_result_out = _RAND_64[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_65 = {1{`RANDOM}};
  rb_entries_2_result_lt = _RAND_65[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_66 = {1{`RANDOM}};
  rb_entries_2_result_eq = _RAND_66[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_67 = {1{`RANDOM}};
  rb_entries_2_result_gt = _RAND_67[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_68 = {1{`RANDOM}};
  rb_entries_2_result_exceptions = _RAND_68[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_69 = {1{`RANDOM}};
  rb_entries_3_completed = _RAND_69[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_70 = {1{`RANDOM}};
  rb_entries_3_valid = _RAND_70[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_71 = {1{`RANDOM}};
  rb_entries_3_dispatched = _RAND_71[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_72 = {1{`RANDOM}};
  rb_entries_3_written = _RAND_72[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_73 = {1{`RANDOM}};
  rb_entries_3_wr_addr = _RAND_73[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_74 = {1{`RANDOM}};
  rb_entries_3_request_operands_0_value = _RAND_74[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_75 = {1{`RANDOM}};
  rb_entries_3_request_operands_0_mode = _RAND_75[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_76 = {1{`RANDOM}};
  rb_entries_3_request_operands_1_value = _RAND_76[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_77 = {1{`RANDOM}};
  rb_entries_3_request_operands_1_mode = _RAND_77[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_78 = {1{`RANDOM}};
  rb_entries_3_request_operands_2_value = _RAND_78[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_79 = {1{`RANDOM}};
  rb_entries_3_request_operands_2_mode = _RAND_79[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_80 = {1{`RANDOM}};
  rb_entries_3_request_inst = _RAND_80[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_81 = {1{`RANDOM}};
  rb_entries_3_request_mode = _RAND_81[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_82 = {1{`RANDOM}};
  rb_entries_3_request_inFetch_0 = _RAND_82[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_83 = {1{`RANDOM}};
  rb_entries_3_request_inFetch_1 = _RAND_83[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_84 = {1{`RANDOM}};
  rb_entries_3_request_inFetch_2 = _RAND_84[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_85 = {1{`RANDOM}};
  rb_entries_3_result_isZero = _RAND_85[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_86 = {1{`RANDOM}};
  rb_entries_3_result_isNaR = _RAND_86[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_87 = {1{`RANDOM}};
  rb_entries_3_result_out = _RAND_87[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_88 = {1{`RANDOM}};
  rb_entries_3_result_lt = _RAND_88[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_89 = {1{`RANDOM}};
  rb_entries_3_result_eq = _RAND_89[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_90 = {1{`RANDOM}};
  rb_entries_3_result_gt = _RAND_90[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_91 = {1{`RANDOM}};
  rb_entries_3_result_exceptions = _RAND_91[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_92 = {1{`RANDOM}};
  rb_entries_4_completed = _RAND_92[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_93 = {1{`RANDOM}};
  rb_entries_4_valid = _RAND_93[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_94 = {1{`RANDOM}};
  rb_entries_4_dispatched = _RAND_94[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_95 = {1{`RANDOM}};
  rb_entries_4_written = _RAND_95[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_96 = {1{`RANDOM}};
  rb_entries_4_wr_addr = _RAND_96[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_97 = {1{`RANDOM}};
  rb_entries_4_request_operands_0_value = _RAND_97[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_98 = {1{`RANDOM}};
  rb_entries_4_request_operands_0_mode = _RAND_98[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_99 = {1{`RANDOM}};
  rb_entries_4_request_operands_1_value = _RAND_99[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_100 = {1{`RANDOM}};
  rb_entries_4_request_operands_1_mode = _RAND_100[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_101 = {1{`RANDOM}};
  rb_entries_4_request_operands_2_value = _RAND_101[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_102 = {1{`RANDOM}};
  rb_entries_4_request_operands_2_mode = _RAND_102[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_103 = {1{`RANDOM}};
  rb_entries_4_request_inst = _RAND_103[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_104 = {1{`RANDOM}};
  rb_entries_4_request_mode = _RAND_104[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_105 = {1{`RANDOM}};
  rb_entries_4_request_inFetch_0 = _RAND_105[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_106 = {1{`RANDOM}};
  rb_entries_4_request_inFetch_1 = _RAND_106[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_107 = {1{`RANDOM}};
  rb_entries_4_request_inFetch_2 = _RAND_107[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_108 = {1{`RANDOM}};
  rb_entries_4_result_isZero = _RAND_108[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_109 = {1{`RANDOM}};
  rb_entries_4_result_isNaR = _RAND_109[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_110 = {1{`RANDOM}};
  rb_entries_4_result_out = _RAND_110[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_111 = {1{`RANDOM}};
  rb_entries_4_result_lt = _RAND_111[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_112 = {1{`RANDOM}};
  rb_entries_4_result_eq = _RAND_112[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_113 = {1{`RANDOM}};
  rb_entries_4_result_gt = _RAND_113[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_114 = {1{`RANDOM}};
  rb_entries_4_result_exceptions = _RAND_114[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_115 = {1{`RANDOM}};
  rb_entries_5_completed = _RAND_115[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_116 = {1{`RANDOM}};
  rb_entries_5_valid = _RAND_116[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_117 = {1{`RANDOM}};
  rb_entries_5_dispatched = _RAND_117[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_118 = {1{`RANDOM}};
  rb_entries_5_written = _RAND_118[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_119 = {1{`RANDOM}};
  rb_entries_5_wr_addr = _RAND_119[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_120 = {1{`RANDOM}};
  rb_entries_5_request_operands_0_value = _RAND_120[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_121 = {1{`RANDOM}};
  rb_entries_5_request_operands_0_mode = _RAND_121[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_122 = {1{`RANDOM}};
  rb_entries_5_request_operands_1_value = _RAND_122[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_123 = {1{`RANDOM}};
  rb_entries_5_request_operands_1_mode = _RAND_123[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_124 = {1{`RANDOM}};
  rb_entries_5_request_operands_2_value = _RAND_124[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_125 = {1{`RANDOM}};
  rb_entries_5_request_operands_2_mode = _RAND_125[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_126 = {1{`RANDOM}};
  rb_entries_5_request_inst = _RAND_126[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_127 = {1{`RANDOM}};
  rb_entries_5_request_mode = _RAND_127[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_128 = {1{`RANDOM}};
  rb_entries_5_request_inFetch_0 = _RAND_128[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_129 = {1{`RANDOM}};
  rb_entries_5_request_inFetch_1 = _RAND_129[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_130 = {1{`RANDOM}};
  rb_entries_5_request_inFetch_2 = _RAND_130[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_131 = {1{`RANDOM}};
  rb_entries_5_result_isZero = _RAND_131[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_132 = {1{`RANDOM}};
  rb_entries_5_result_isNaR = _RAND_132[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_133 = {1{`RANDOM}};
  rb_entries_5_result_out = _RAND_133[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_134 = {1{`RANDOM}};
  rb_entries_5_result_lt = _RAND_134[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_135 = {1{`RANDOM}};
  rb_entries_5_result_eq = _RAND_135[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_136 = {1{`RANDOM}};
  rb_entries_5_result_gt = _RAND_136[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_137 = {1{`RANDOM}};
  rb_entries_5_result_exceptions = _RAND_137[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_138 = {1{`RANDOM}};
  rb_entries_6_completed = _RAND_138[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_139 = {1{`RANDOM}};
  rb_entries_6_valid = _RAND_139[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_140 = {1{`RANDOM}};
  rb_entries_6_dispatched = _RAND_140[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_141 = {1{`RANDOM}};
  rb_entries_6_written = _RAND_141[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_142 = {1{`RANDOM}};
  rb_entries_6_wr_addr = _RAND_142[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_143 = {1{`RANDOM}};
  rb_entries_6_request_operands_0_value = _RAND_143[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_144 = {1{`RANDOM}};
  rb_entries_6_request_operands_0_mode = _RAND_144[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_145 = {1{`RANDOM}};
  rb_entries_6_request_operands_1_value = _RAND_145[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_146 = {1{`RANDOM}};
  rb_entries_6_request_operands_1_mode = _RAND_146[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_147 = {1{`RANDOM}};
  rb_entries_6_request_operands_2_value = _RAND_147[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_148 = {1{`RANDOM}};
  rb_entries_6_request_operands_2_mode = _RAND_148[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_149 = {1{`RANDOM}};
  rb_entries_6_request_inst = _RAND_149[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_150 = {1{`RANDOM}};
  rb_entries_6_request_mode = _RAND_150[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_151 = {1{`RANDOM}};
  rb_entries_6_request_inFetch_0 = _RAND_151[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_152 = {1{`RANDOM}};
  rb_entries_6_request_inFetch_1 = _RAND_152[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_153 = {1{`RANDOM}};
  rb_entries_6_request_inFetch_2 = _RAND_153[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_154 = {1{`RANDOM}};
  rb_entries_6_result_isZero = _RAND_154[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_155 = {1{`RANDOM}};
  rb_entries_6_result_isNaR = _RAND_155[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_156 = {1{`RANDOM}};
  rb_entries_6_result_out = _RAND_156[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_157 = {1{`RANDOM}};
  rb_entries_6_result_lt = _RAND_157[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_158 = {1{`RANDOM}};
  rb_entries_6_result_eq = _RAND_158[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_159 = {1{`RANDOM}};
  rb_entries_6_result_gt = _RAND_159[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_160 = {1{`RANDOM}};
  rb_entries_6_result_exceptions = _RAND_160[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_161 = {1{`RANDOM}};
  rb_entries_7_completed = _RAND_161[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_162 = {1{`RANDOM}};
  rb_entries_7_valid = _RAND_162[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_163 = {1{`RANDOM}};
  rb_entries_7_dispatched = _RAND_163[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_164 = {1{`RANDOM}};
  rb_entries_7_written = _RAND_164[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_165 = {1{`RANDOM}};
  rb_entries_7_wr_addr = _RAND_165[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_166 = {1{`RANDOM}};
  rb_entries_7_request_operands_0_value = _RAND_166[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_167 = {1{`RANDOM}};
  rb_entries_7_request_operands_0_mode = _RAND_167[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_168 = {1{`RANDOM}};
  rb_entries_7_request_operands_1_value = _RAND_168[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_169 = {1{`RANDOM}};
  rb_entries_7_request_operands_1_mode = _RAND_169[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_170 = {1{`RANDOM}};
  rb_entries_7_request_operands_2_value = _RAND_170[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_171 = {1{`RANDOM}};
  rb_entries_7_request_operands_2_mode = _RAND_171[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_172 = {1{`RANDOM}};
  rb_entries_7_request_inst = _RAND_172[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_173 = {1{`RANDOM}};
  rb_entries_7_request_mode = _RAND_173[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_174 = {1{`RANDOM}};
  rb_entries_7_request_inFetch_0 = _RAND_174[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_175 = {1{`RANDOM}};
  rb_entries_7_request_inFetch_1 = _RAND_175[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_176 = {1{`RANDOM}};
  rb_entries_7_request_inFetch_2 = _RAND_176[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_177 = {1{`RANDOM}};
  rb_entries_7_result_isZero = _RAND_177[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_178 = {1{`RANDOM}};
  rb_entries_7_result_isNaR = _RAND_178[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_179 = {1{`RANDOM}};
  rb_entries_7_result_out = _RAND_179[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_180 = {1{`RANDOM}};
  rb_entries_7_result_lt = _RAND_180[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_181 = {1{`RANDOM}};
  rb_entries_7_result_eq = _RAND_181[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_182 = {1{`RANDOM}};
  rb_entries_7_result_gt = _RAND_182[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_183 = {1{`RANDOM}};
  rb_entries_7_result_exceptions = _RAND_183[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_184 = {1{`RANDOM}};
  value = _RAND_184[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_185 = {1{`RANDOM}};
  reg_infetch_cacheline = _RAND_185[7:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      rb_entries_0_completed <= 1'h0;
    end else if (_T_164) begin
      rb_entries_0_completed <= _GEN_1828;
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_0_valid <= _GEN_968;
    end
    if (reset) begin
      rb_entries_0_dispatched <= 1'h0;
    end else if (_T_113) begin
      rb_entries_0_dispatched <= 1'h0;
    end else begin
      rb_entries_0_dispatched <= _T_117;
    end
    if (reset) begin
      rb_entries_0_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_0_written <= _GEN_1506;
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_0_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_0_mode[1]) begin
        if (_T_295) begin
          if (_T_261) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_259) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_257) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_255) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_253) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_251) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_249) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_247) begin
            rb_entries_0_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_0_request_operands_0_value <= 32'h0;
          end
        end else if (_T_165) begin
          if (_GEN_2116) begin
            if (3'h7 == rb_entries_0_request_operands_0_value[2:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_0_request_operands_0_value[2:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_0_request_operands_0_value[2:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_0_request_operands_0_value[2:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_0_request_operands_0_value[2:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_0_request_operands_0_value[2:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_0_request_operands_0_value[2:0]) begin
              rb_entries_0_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_0_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h0 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_165) begin
        if (_GEN_2116) begin
          if (3'h7 == rb_entries_0_request_operands_0_value[2:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_0_request_operands_0_value[2:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_0_request_operands_0_value[2:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_0_request_operands_0_value[2:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_0_request_operands_0_value[2:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_0_request_operands_0_value[2:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_0_request_operands_0_value[2:0]) begin
            rb_entries_0_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_0_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_165) begin
      if (_GEN_2116) begin
        if (3'h7 == rb_entries_0_request_operands_0_value[2:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_0_request_operands_0_value[2:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_0_request_operands_0_value[2:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_0_request_operands_0_value[2:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_0_request_operands_0_value[2:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_0_request_operands_0_value[2:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_0_request_operands_0_value[2:0]) begin
          rb_entries_0_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_0_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_0_request_operands_0_value <= _GEN_1160;
      end
    end else begin
      rb_entries_0_request_operands_0_value <= _GEN_1160;
    end
    if (reset) begin
      rb_entries_0_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_0_mode[1]) begin
        if (_T_295) begin
          rb_entries_0_request_operands_0_mode <= 2'h0;
        end else if (_T_165) begin
          if (_GEN_2116) begin
            rb_entries_0_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h0 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_165) begin
        if (_GEN_2116) begin
          rb_entries_0_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_165) begin
      if (_GEN_2116) begin
        rb_entries_0_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_0_mode <= _GEN_1168;
      end
    end else begin
      rb_entries_0_request_operands_0_mode <= _GEN_1168;
    end
    if (reset) begin
      rb_entries_0_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_1_mode[1]) begin
        if (_T_381) begin
          if (_T_347) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_345) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_343) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_341) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_339) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_337) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_335) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_333) begin
            rb_entries_0_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_0_request_operands_1_value <= 32'h0;
          end
        end else if (_T_168) begin
          if (_GEN_2600) begin
            if (3'h7 == rb_entries_0_request_operands_1_value[2:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_0_request_operands_1_value[2:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_0_request_operands_1_value[2:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_0_request_operands_1_value[2:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_0_request_operands_1_value[2:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_0_request_operands_1_value[2:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_0_request_operands_1_value[2:0]) begin
              rb_entries_0_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_0_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h0 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_168) begin
        if (_GEN_2600) begin
          if (3'h7 == rb_entries_0_request_operands_1_value[2:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_0_request_operands_1_value[2:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_0_request_operands_1_value[2:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_0_request_operands_1_value[2:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_0_request_operands_1_value[2:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_0_request_operands_1_value[2:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_0_request_operands_1_value[2:0]) begin
            rb_entries_0_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_0_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_168) begin
      if (_GEN_2600) begin
        if (3'h7 == rb_entries_0_request_operands_1_value[2:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_0_request_operands_1_value[2:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_0_request_operands_1_value[2:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_0_request_operands_1_value[2:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_0_request_operands_1_value[2:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_0_request_operands_1_value[2:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_0_request_operands_1_value[2:0]) begin
          rb_entries_0_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_0_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_0_request_operands_1_value <= _GEN_1176;
      end
    end else begin
      rb_entries_0_request_operands_1_value <= _GEN_1176;
    end
    if (reset) begin
      rb_entries_0_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_1_mode[1]) begin
        if (_T_381) begin
          rb_entries_0_request_operands_1_mode <= 2'h0;
        end else if (_T_168) begin
          if (_GEN_2600) begin
            rb_entries_0_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h0 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_168) begin
        if (_GEN_2600) begin
          rb_entries_0_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_168) begin
      if (_GEN_2600) begin
        rb_entries_0_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_1_mode <= _GEN_1184;
      end
    end else begin
      rb_entries_0_request_operands_1_mode <= _GEN_1184;
    end
    if (reset) begin
      rb_entries_0_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_2_mode[1]) begin
        if (_T_467) begin
          if (_T_433) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_431) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_429) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_427) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_425) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_423) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_421) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_419) begin
            rb_entries_0_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_0_request_operands_2_value <= 32'h0;
          end
        end else if (_T_171) begin
          if (_GEN_3084) begin
            if (3'h7 == rb_entries_0_request_operands_2_value[2:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_0_request_operands_2_value[2:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_0_request_operands_2_value[2:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_0_request_operands_2_value[2:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_0_request_operands_2_value[2:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_0_request_operands_2_value[2:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_0_request_operands_2_value[2:0]) begin
              rb_entries_0_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_0_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h0 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_171) begin
        if (_GEN_3084) begin
          if (3'h7 == rb_entries_0_request_operands_2_value[2:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_0_request_operands_2_value[2:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_0_request_operands_2_value[2:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_0_request_operands_2_value[2:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_0_request_operands_2_value[2:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_0_request_operands_2_value[2:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_0_request_operands_2_value[2:0]) begin
            rb_entries_0_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_0_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_171) begin
      if (_GEN_3084) begin
        if (3'h7 == rb_entries_0_request_operands_2_value[2:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_0_request_operands_2_value[2:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_0_request_operands_2_value[2:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_0_request_operands_2_value[2:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_0_request_operands_2_value[2:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_0_request_operands_2_value[2:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_0_request_operands_2_value[2:0]) begin
          rb_entries_0_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_0_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_0_request_operands_2_value <= _GEN_1192;
      end
    end else begin
      rb_entries_0_request_operands_2_value <= _GEN_1192;
    end
    if (reset) begin
      rb_entries_0_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_0_request_operands_2_mode[1]) begin
        if (_T_467) begin
          rb_entries_0_request_operands_2_mode <= 2'h0;
        end else if (_T_171) begin
          if (_GEN_3084) begin
            rb_entries_0_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h0 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_171) begin
        if (_GEN_3084) begin
          rb_entries_0_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h0 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_171) begin
      if (_GEN_3084) begin
        rb_entries_0_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_2_mode <= _GEN_1200;
      end
    end else begin
      rb_entries_0_request_operands_2_mode <= _GEN_1200;
    end
    if (reset) begin
      rb_entries_0_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_0_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_0_request_inFetch_0 <= 1'h0;
    end else if (_T_113) begin
      rb_entries_0_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_0 <= _T_2593[0];
    end
    if (reset) begin
      rb_entries_0_request_inFetch_1 <= 1'h0;
    end else if (_T_113) begin
      rb_entries_0_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_1 <= _T_2593[1];
    end
    if (reset) begin
      rb_entries_0_request_inFetch_2 <= 1'h0;
    end else if (_T_113) begin
      rb_entries_0_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_2 <= _T_2593[2];
    end
    if (reset) begin
      rb_entries_0_result_isZero <= 1'h0;
    end else if (_T_164) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_isNaR <= 1'h0;
    end else if (_T_164) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_out <= 32'h0;
    end else if (_T_164) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_lt <= 1'h0;
    end else if (_T_164) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_eq <= 1'h0;
    end else if (_T_164) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_gt <= 1'h0;
    end else if (_T_164) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_exceptions <= 5'h0;
    end else if (_T_164) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h0 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_0_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_0_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_1_completed <= 1'h0;
    end else if (_T_164) begin
      rb_entries_1_completed <= _GEN_1829;
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_1_valid <= _GEN_969;
    end
    if (reset) begin
      rb_entries_1_dispatched <= 1'h0;
    end else if (_T_119) begin
      rb_entries_1_dispatched <= 1'h0;
    end else begin
      rb_entries_1_dispatched <= _T_123;
    end
    if (reset) begin
      rb_entries_1_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_1_written <= _GEN_1507;
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_1_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_0_mode[1]) begin
        if (_T_553) begin
          if (_T_519) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_517) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_515) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_513) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_511) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_509) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_507) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_505) begin
            rb_entries_1_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_1_request_operands_0_value <= 32'h0;
          end
        end else if (_T_174) begin
          if (_GEN_3568) begin
            if (3'h7 == rb_entries_1_request_operands_0_value[2:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_1_request_operands_0_value[2:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_1_request_operands_0_value[2:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_1_request_operands_0_value[2:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_1_request_operands_0_value[2:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_1_request_operands_0_value[2:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_1_request_operands_0_value[2:0]) begin
              rb_entries_1_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_1_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h1 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_174) begin
        if (_GEN_3568) begin
          if (3'h7 == rb_entries_1_request_operands_0_value[2:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_1_request_operands_0_value[2:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_1_request_operands_0_value[2:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_1_request_operands_0_value[2:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_1_request_operands_0_value[2:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_1_request_operands_0_value[2:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_1_request_operands_0_value[2:0]) begin
            rb_entries_1_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_1_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_174) begin
      if (_GEN_3568) begin
        if (3'h7 == rb_entries_1_request_operands_0_value[2:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_1_request_operands_0_value[2:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_1_request_operands_0_value[2:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_1_request_operands_0_value[2:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_1_request_operands_0_value[2:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_1_request_operands_0_value[2:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_1_request_operands_0_value[2:0]) begin
          rb_entries_1_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_1_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_1_request_operands_0_value <= _GEN_1161;
      end
    end else begin
      rb_entries_1_request_operands_0_value <= _GEN_1161;
    end
    if (reset) begin
      rb_entries_1_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_0_mode[1]) begin
        if (_T_553) begin
          rb_entries_1_request_operands_0_mode <= 2'h0;
        end else if (_T_174) begin
          if (_GEN_3568) begin
            rb_entries_1_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h1 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_174) begin
        if (_GEN_3568) begin
          rb_entries_1_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_174) begin
      if (_GEN_3568) begin
        rb_entries_1_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_0_mode <= _GEN_1169;
      end
    end else begin
      rb_entries_1_request_operands_0_mode <= _GEN_1169;
    end
    if (reset) begin
      rb_entries_1_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_1_mode[1]) begin
        if (_T_639) begin
          if (_T_605) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_603) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_601) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_599) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_597) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_595) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_593) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_591) begin
            rb_entries_1_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_1_request_operands_1_value <= 32'h0;
          end
        end else if (_T_177) begin
          if (_GEN_4052) begin
            if (3'h7 == rb_entries_1_request_operands_1_value[2:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_1_request_operands_1_value[2:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_1_request_operands_1_value[2:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_1_request_operands_1_value[2:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_1_request_operands_1_value[2:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_1_request_operands_1_value[2:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_1_request_operands_1_value[2:0]) begin
              rb_entries_1_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_1_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h1 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_177) begin
        if (_GEN_4052) begin
          if (3'h7 == rb_entries_1_request_operands_1_value[2:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_1_request_operands_1_value[2:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_1_request_operands_1_value[2:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_1_request_operands_1_value[2:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_1_request_operands_1_value[2:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_1_request_operands_1_value[2:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_1_request_operands_1_value[2:0]) begin
            rb_entries_1_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_1_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_177) begin
      if (_GEN_4052) begin
        if (3'h7 == rb_entries_1_request_operands_1_value[2:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_1_request_operands_1_value[2:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_1_request_operands_1_value[2:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_1_request_operands_1_value[2:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_1_request_operands_1_value[2:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_1_request_operands_1_value[2:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_1_request_operands_1_value[2:0]) begin
          rb_entries_1_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_1_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_1_request_operands_1_value <= _GEN_1177;
      end
    end else begin
      rb_entries_1_request_operands_1_value <= _GEN_1177;
    end
    if (reset) begin
      rb_entries_1_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_1_mode[1]) begin
        if (_T_639) begin
          rb_entries_1_request_operands_1_mode <= 2'h0;
        end else if (_T_177) begin
          if (_GEN_4052) begin
            rb_entries_1_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h1 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_177) begin
        if (_GEN_4052) begin
          rb_entries_1_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_177) begin
      if (_GEN_4052) begin
        rb_entries_1_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_1_mode <= _GEN_1185;
      end
    end else begin
      rb_entries_1_request_operands_1_mode <= _GEN_1185;
    end
    if (reset) begin
      rb_entries_1_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_2_mode[1]) begin
        if (_T_725) begin
          if (_T_691) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_689) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_687) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_685) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_683) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_681) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_679) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_677) begin
            rb_entries_1_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_1_request_operands_2_value <= 32'h0;
          end
        end else if (_T_180) begin
          if (_GEN_4536) begin
            if (3'h7 == rb_entries_1_request_operands_2_value[2:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_1_request_operands_2_value[2:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_1_request_operands_2_value[2:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_1_request_operands_2_value[2:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_1_request_operands_2_value[2:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_1_request_operands_2_value[2:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_1_request_operands_2_value[2:0]) begin
              rb_entries_1_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_1_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h1 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_180) begin
        if (_GEN_4536) begin
          if (3'h7 == rb_entries_1_request_operands_2_value[2:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_1_request_operands_2_value[2:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_1_request_operands_2_value[2:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_1_request_operands_2_value[2:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_1_request_operands_2_value[2:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_1_request_operands_2_value[2:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_1_request_operands_2_value[2:0]) begin
            rb_entries_1_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_1_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_180) begin
      if (_GEN_4536) begin
        if (3'h7 == rb_entries_1_request_operands_2_value[2:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_1_request_operands_2_value[2:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_1_request_operands_2_value[2:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_1_request_operands_2_value[2:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_1_request_operands_2_value[2:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_1_request_operands_2_value[2:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_1_request_operands_2_value[2:0]) begin
          rb_entries_1_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_1_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_1_request_operands_2_value <= _GEN_1193;
      end
    end else begin
      rb_entries_1_request_operands_2_value <= _GEN_1193;
    end
    if (reset) begin
      rb_entries_1_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_1_request_operands_2_mode[1]) begin
        if (_T_725) begin
          rb_entries_1_request_operands_2_mode <= 2'h0;
        end else if (_T_180) begin
          if (_GEN_4536) begin
            rb_entries_1_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h1 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_180) begin
        if (_GEN_4536) begin
          rb_entries_1_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h1 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_180) begin
      if (_GEN_4536) begin
        rb_entries_1_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_2_mode <= _GEN_1201;
      end
    end else begin
      rb_entries_1_request_operands_2_mode <= _GEN_1201;
    end
    if (reset) begin
      rb_entries_1_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_1_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_1_request_inFetch_0 <= 1'h0;
    end else if (_T_119) begin
      rb_entries_1_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_0 <= _T_2593[3];
    end
    if (reset) begin
      rb_entries_1_request_inFetch_1 <= 1'h0;
    end else if (_T_119) begin
      rb_entries_1_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_1 <= _T_2593[4];
    end
    if (reset) begin
      rb_entries_1_request_inFetch_2 <= 1'h0;
    end else if (_T_119) begin
      rb_entries_1_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_2 <= _T_2593[5];
    end
    if (reset) begin
      rb_entries_1_result_isZero <= 1'h0;
    end else if (_T_164) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_isNaR <= 1'h0;
    end else if (_T_164) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_out <= 32'h0;
    end else if (_T_164) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_lt <= 1'h0;
    end else if (_T_164) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_eq <= 1'h0;
    end else if (_T_164) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_gt <= 1'h0;
    end else if (_T_164) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_exceptions <= 5'h0;
    end else if (_T_164) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h1 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_1_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_1_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_2_completed <= 1'h0;
    end else if (_T_164) begin
      rb_entries_2_completed <= _GEN_1830;
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_2_valid <= _GEN_970;
    end
    if (reset) begin
      rb_entries_2_dispatched <= 1'h0;
    end else if (_T_125) begin
      rb_entries_2_dispatched <= 1'h0;
    end else begin
      rb_entries_2_dispatched <= _T_129;
    end
    if (reset) begin
      rb_entries_2_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_2_written <= _GEN_1508;
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_2_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_0_mode[1]) begin
        if (_T_811) begin
          if (_T_777) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_775) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_773) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_771) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_769) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_767) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_765) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_763) begin
            rb_entries_2_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_2_request_operands_0_value <= 32'h0;
          end
        end else if (_T_183) begin
          if (_GEN_5020) begin
            if (3'h7 == rb_entries_2_request_operands_0_value[2:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_2_request_operands_0_value[2:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_2_request_operands_0_value[2:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_2_request_operands_0_value[2:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_2_request_operands_0_value[2:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_2_request_operands_0_value[2:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_2_request_operands_0_value[2:0]) begin
              rb_entries_2_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_2_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h2 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_183) begin
        if (_GEN_5020) begin
          if (3'h7 == rb_entries_2_request_operands_0_value[2:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_2_request_operands_0_value[2:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_2_request_operands_0_value[2:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_2_request_operands_0_value[2:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_2_request_operands_0_value[2:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_2_request_operands_0_value[2:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_2_request_operands_0_value[2:0]) begin
            rb_entries_2_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_2_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_183) begin
      if (_GEN_5020) begin
        if (3'h7 == rb_entries_2_request_operands_0_value[2:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_2_request_operands_0_value[2:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_2_request_operands_0_value[2:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_2_request_operands_0_value[2:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_2_request_operands_0_value[2:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_2_request_operands_0_value[2:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_2_request_operands_0_value[2:0]) begin
          rb_entries_2_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_2_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_2_request_operands_0_value <= _GEN_1162;
      end
    end else begin
      rb_entries_2_request_operands_0_value <= _GEN_1162;
    end
    if (reset) begin
      rb_entries_2_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_0_mode[1]) begin
        if (_T_811) begin
          rb_entries_2_request_operands_0_mode <= 2'h0;
        end else if (_T_183) begin
          if (_GEN_5020) begin
            rb_entries_2_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h2 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_183) begin
        if (_GEN_5020) begin
          rb_entries_2_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_183) begin
      if (_GEN_5020) begin
        rb_entries_2_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_0_mode <= _GEN_1170;
      end
    end else begin
      rb_entries_2_request_operands_0_mode <= _GEN_1170;
    end
    if (reset) begin
      rb_entries_2_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_1_mode[1]) begin
        if (_T_897) begin
          if (_T_863) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_861) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_859) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_857) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_855) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_853) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_851) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_849) begin
            rb_entries_2_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_2_request_operands_1_value <= 32'h0;
          end
        end else if (_T_186) begin
          if (_GEN_5504) begin
            if (3'h7 == rb_entries_2_request_operands_1_value[2:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_2_request_operands_1_value[2:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_2_request_operands_1_value[2:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_2_request_operands_1_value[2:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_2_request_operands_1_value[2:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_2_request_operands_1_value[2:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_2_request_operands_1_value[2:0]) begin
              rb_entries_2_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_2_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h2 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_186) begin
        if (_GEN_5504) begin
          if (3'h7 == rb_entries_2_request_operands_1_value[2:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_2_request_operands_1_value[2:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_2_request_operands_1_value[2:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_2_request_operands_1_value[2:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_2_request_operands_1_value[2:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_2_request_operands_1_value[2:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_2_request_operands_1_value[2:0]) begin
            rb_entries_2_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_2_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_186) begin
      if (_GEN_5504) begin
        if (3'h7 == rb_entries_2_request_operands_1_value[2:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_2_request_operands_1_value[2:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_2_request_operands_1_value[2:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_2_request_operands_1_value[2:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_2_request_operands_1_value[2:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_2_request_operands_1_value[2:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_2_request_operands_1_value[2:0]) begin
          rb_entries_2_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_2_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_2_request_operands_1_value <= _GEN_1178;
      end
    end else begin
      rb_entries_2_request_operands_1_value <= _GEN_1178;
    end
    if (reset) begin
      rb_entries_2_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_1_mode[1]) begin
        if (_T_897) begin
          rb_entries_2_request_operands_1_mode <= 2'h0;
        end else if (_T_186) begin
          if (_GEN_5504) begin
            rb_entries_2_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h2 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_186) begin
        if (_GEN_5504) begin
          rb_entries_2_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_186) begin
      if (_GEN_5504) begin
        rb_entries_2_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_1_mode <= _GEN_1186;
      end
    end else begin
      rb_entries_2_request_operands_1_mode <= _GEN_1186;
    end
    if (reset) begin
      rb_entries_2_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_2_mode[1]) begin
        if (_T_983) begin
          if (_T_949) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_947) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_945) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_943) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_941) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_939) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_937) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_935) begin
            rb_entries_2_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_2_request_operands_2_value <= 32'h0;
          end
        end else if (_T_189) begin
          if (_GEN_5988) begin
            if (3'h7 == rb_entries_2_request_operands_2_value[2:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_2_request_operands_2_value[2:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_2_request_operands_2_value[2:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_2_request_operands_2_value[2:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_2_request_operands_2_value[2:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_2_request_operands_2_value[2:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_2_request_operands_2_value[2:0]) begin
              rb_entries_2_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_2_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h2 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_189) begin
        if (_GEN_5988) begin
          if (3'h7 == rb_entries_2_request_operands_2_value[2:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_2_request_operands_2_value[2:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_2_request_operands_2_value[2:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_2_request_operands_2_value[2:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_2_request_operands_2_value[2:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_2_request_operands_2_value[2:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_2_request_operands_2_value[2:0]) begin
            rb_entries_2_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_2_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_189) begin
      if (_GEN_5988) begin
        if (3'h7 == rb_entries_2_request_operands_2_value[2:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_2_request_operands_2_value[2:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_2_request_operands_2_value[2:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_2_request_operands_2_value[2:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_2_request_operands_2_value[2:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_2_request_operands_2_value[2:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_2_request_operands_2_value[2:0]) begin
          rb_entries_2_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_2_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_2_request_operands_2_value <= _GEN_1194;
      end
    end else begin
      rb_entries_2_request_operands_2_value <= _GEN_1194;
    end
    if (reset) begin
      rb_entries_2_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_2_request_operands_2_mode[1]) begin
        if (_T_983) begin
          rb_entries_2_request_operands_2_mode <= 2'h0;
        end else if (_T_189) begin
          if (_GEN_5988) begin
            rb_entries_2_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h2 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_189) begin
        if (_GEN_5988) begin
          rb_entries_2_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h2 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_189) begin
      if (_GEN_5988) begin
        rb_entries_2_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_2_mode <= _GEN_1202;
      end
    end else begin
      rb_entries_2_request_operands_2_mode <= _GEN_1202;
    end
    if (reset) begin
      rb_entries_2_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_2_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_2_request_inFetch_0 <= 1'h0;
    end else if (_T_125) begin
      rb_entries_2_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_0 <= _T_2593[6];
    end
    if (reset) begin
      rb_entries_2_request_inFetch_1 <= 1'h0;
    end else if (_T_125) begin
      rb_entries_2_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_1 <= _T_2593[7];
    end
    if (reset) begin
      rb_entries_2_request_inFetch_2 <= 1'h0;
    end else if (_T_125) begin
      rb_entries_2_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_2 <= _T_2593[8];
    end
    if (reset) begin
      rb_entries_2_result_isZero <= 1'h0;
    end else if (_T_164) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_isNaR <= 1'h0;
    end else if (_T_164) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_out <= 32'h0;
    end else if (_T_164) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_lt <= 1'h0;
    end else if (_T_164) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_eq <= 1'h0;
    end else if (_T_164) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_gt <= 1'h0;
    end else if (_T_164) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_exceptions <= 5'h0;
    end else if (_T_164) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h2 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_2_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_2_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_3_completed <= 1'h0;
    end else if (_T_164) begin
      rb_entries_3_completed <= _GEN_1831;
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_3_valid <= _GEN_971;
    end
    if (reset) begin
      rb_entries_3_dispatched <= 1'h0;
    end else if (_T_131) begin
      rb_entries_3_dispatched <= 1'h0;
    end else begin
      rb_entries_3_dispatched <= _T_135;
    end
    if (reset) begin
      rb_entries_3_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_3_written <= _GEN_1509;
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_3_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_0_mode[1]) begin
        if (_T_1069) begin
          if (_T_1035) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_1033) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_1031) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_1029) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_1027) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_1025) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_1023) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_1021) begin
            rb_entries_3_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_3_request_operands_0_value <= 32'h0;
          end
        end else if (_T_192) begin
          if (_GEN_6472) begin
            if (3'h7 == rb_entries_3_request_operands_0_value[2:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_3_request_operands_0_value[2:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_3_request_operands_0_value[2:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_3_request_operands_0_value[2:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_3_request_operands_0_value[2:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_3_request_operands_0_value[2:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_3_request_operands_0_value[2:0]) begin
              rb_entries_3_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_3_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h3 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_192) begin
        if (_GEN_6472) begin
          if (3'h7 == rb_entries_3_request_operands_0_value[2:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_3_request_operands_0_value[2:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_3_request_operands_0_value[2:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_3_request_operands_0_value[2:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_3_request_operands_0_value[2:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_3_request_operands_0_value[2:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_3_request_operands_0_value[2:0]) begin
            rb_entries_3_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_3_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_192) begin
      if (_GEN_6472) begin
        if (3'h7 == rb_entries_3_request_operands_0_value[2:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_3_request_operands_0_value[2:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_3_request_operands_0_value[2:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_3_request_operands_0_value[2:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_3_request_operands_0_value[2:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_3_request_operands_0_value[2:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_3_request_operands_0_value[2:0]) begin
          rb_entries_3_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_3_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_3_request_operands_0_value <= _GEN_1163;
      end
    end else begin
      rb_entries_3_request_operands_0_value <= _GEN_1163;
    end
    if (reset) begin
      rb_entries_3_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_0_mode[1]) begin
        if (_T_1069) begin
          rb_entries_3_request_operands_0_mode <= 2'h0;
        end else if (_T_192) begin
          if (_GEN_6472) begin
            rb_entries_3_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h3 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_192) begin
        if (_GEN_6472) begin
          rb_entries_3_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_192) begin
      if (_GEN_6472) begin
        rb_entries_3_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_0_mode <= _GEN_1171;
      end
    end else begin
      rb_entries_3_request_operands_0_mode <= _GEN_1171;
    end
    if (reset) begin
      rb_entries_3_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_1_mode[1]) begin
        if (_T_1155) begin
          if (_T_1121) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_1119) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_1117) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_1115) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_1113) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_1111) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_1109) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_1107) begin
            rb_entries_3_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_3_request_operands_1_value <= 32'h0;
          end
        end else if (_T_195) begin
          if (_GEN_6956) begin
            if (3'h7 == rb_entries_3_request_operands_1_value[2:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_3_request_operands_1_value[2:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_3_request_operands_1_value[2:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_3_request_operands_1_value[2:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_3_request_operands_1_value[2:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_3_request_operands_1_value[2:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_3_request_operands_1_value[2:0]) begin
              rb_entries_3_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_3_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h3 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_195) begin
        if (_GEN_6956) begin
          if (3'h7 == rb_entries_3_request_operands_1_value[2:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_3_request_operands_1_value[2:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_3_request_operands_1_value[2:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_3_request_operands_1_value[2:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_3_request_operands_1_value[2:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_3_request_operands_1_value[2:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_3_request_operands_1_value[2:0]) begin
            rb_entries_3_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_3_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_195) begin
      if (_GEN_6956) begin
        if (3'h7 == rb_entries_3_request_operands_1_value[2:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_3_request_operands_1_value[2:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_3_request_operands_1_value[2:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_3_request_operands_1_value[2:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_3_request_operands_1_value[2:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_3_request_operands_1_value[2:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_3_request_operands_1_value[2:0]) begin
          rb_entries_3_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_3_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_3_request_operands_1_value <= _GEN_1179;
      end
    end else begin
      rb_entries_3_request_operands_1_value <= _GEN_1179;
    end
    if (reset) begin
      rb_entries_3_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_1_mode[1]) begin
        if (_T_1155) begin
          rb_entries_3_request_operands_1_mode <= 2'h0;
        end else if (_T_195) begin
          if (_GEN_6956) begin
            rb_entries_3_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h3 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_195) begin
        if (_GEN_6956) begin
          rb_entries_3_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_195) begin
      if (_GEN_6956) begin
        rb_entries_3_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_1_mode <= _GEN_1187;
      end
    end else begin
      rb_entries_3_request_operands_1_mode <= _GEN_1187;
    end
    if (reset) begin
      rb_entries_3_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_2_mode[1]) begin
        if (_T_1241) begin
          if (_T_1207) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_1205) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_1203) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_1201) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_1199) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_1197) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_1195) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_1193) begin
            rb_entries_3_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_3_request_operands_2_value <= 32'h0;
          end
        end else if (_T_198) begin
          if (_GEN_7440) begin
            if (3'h7 == rb_entries_3_request_operands_2_value[2:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_3_request_operands_2_value[2:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_3_request_operands_2_value[2:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_3_request_operands_2_value[2:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_3_request_operands_2_value[2:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_3_request_operands_2_value[2:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_3_request_operands_2_value[2:0]) begin
              rb_entries_3_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_3_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h3 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_198) begin
        if (_GEN_7440) begin
          if (3'h7 == rb_entries_3_request_operands_2_value[2:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_3_request_operands_2_value[2:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_3_request_operands_2_value[2:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_3_request_operands_2_value[2:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_3_request_operands_2_value[2:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_3_request_operands_2_value[2:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_3_request_operands_2_value[2:0]) begin
            rb_entries_3_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_3_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_198) begin
      if (_GEN_7440) begin
        if (3'h7 == rb_entries_3_request_operands_2_value[2:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_3_request_operands_2_value[2:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_3_request_operands_2_value[2:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_3_request_operands_2_value[2:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_3_request_operands_2_value[2:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_3_request_operands_2_value[2:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_3_request_operands_2_value[2:0]) begin
          rb_entries_3_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_3_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_3_request_operands_2_value <= _GEN_1195;
      end
    end else begin
      rb_entries_3_request_operands_2_value <= _GEN_1195;
    end
    if (reset) begin
      rb_entries_3_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_3_request_operands_2_mode[1]) begin
        if (_T_1241) begin
          rb_entries_3_request_operands_2_mode <= 2'h0;
        end else if (_T_198) begin
          if (_GEN_7440) begin
            rb_entries_3_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h3 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_198) begin
        if (_GEN_7440) begin
          rb_entries_3_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h3 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_198) begin
      if (_GEN_7440) begin
        rb_entries_3_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_2_mode <= _GEN_1203;
      end
    end else begin
      rb_entries_3_request_operands_2_mode <= _GEN_1203;
    end
    if (reset) begin
      rb_entries_3_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_3_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_3_request_inFetch_0 <= 1'h0;
    end else if (_T_131) begin
      rb_entries_3_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_0 <= _T_2593[9];
    end
    if (reset) begin
      rb_entries_3_request_inFetch_1 <= 1'h0;
    end else if (_T_131) begin
      rb_entries_3_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_1 <= _T_2593[10];
    end
    if (reset) begin
      rb_entries_3_request_inFetch_2 <= 1'h0;
    end else if (_T_131) begin
      rb_entries_3_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_2 <= _T_2593[11];
    end
    if (reset) begin
      rb_entries_3_result_isZero <= 1'h0;
    end else if (_T_164) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_isNaR <= 1'h0;
    end else if (_T_164) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_out <= 32'h0;
    end else if (_T_164) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_lt <= 1'h0;
    end else if (_T_164) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_eq <= 1'h0;
    end else if (_T_164) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_gt <= 1'h0;
    end else if (_T_164) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_exceptions <= 5'h0;
    end else if (_T_164) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h3 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_3_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_3_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_4_completed <= 1'h0;
    end else if (_T_164) begin
      rb_entries_4_completed <= _GEN_1832;
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_4_valid <= _GEN_972;
    end
    if (reset) begin
      rb_entries_4_dispatched <= 1'h0;
    end else if (_T_137) begin
      rb_entries_4_dispatched <= 1'h0;
    end else begin
      rb_entries_4_dispatched <= _T_141;
    end
    if (reset) begin
      rb_entries_4_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_4_written <= _GEN_1510;
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_4_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_4_request_operands_0_mode[1]) begin
        if (_T_1327) begin
          if (_T_1293) begin
            rb_entries_4_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_1291) begin
            rb_entries_4_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_1289) begin
            rb_entries_4_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_1287) begin
            rb_entries_4_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_1285) begin
            rb_entries_4_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_1283) begin
            rb_entries_4_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_1281) begin
            rb_entries_4_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_1279) begin
            rb_entries_4_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_4_request_operands_0_value <= 32'h0;
          end
        end else if (_T_201) begin
          if (_GEN_7924) begin
            if (3'h7 == rb_entries_4_request_operands_0_value[2:0]) begin
              rb_entries_4_request_operands_0_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_4_request_operands_0_value[2:0]) begin
              rb_entries_4_request_operands_0_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_4_request_operands_0_value[2:0]) begin
              rb_entries_4_request_operands_0_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_4_request_operands_0_value[2:0]) begin
              rb_entries_4_request_operands_0_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_4_request_operands_0_value[2:0]) begin
              rb_entries_4_request_operands_0_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_4_request_operands_0_value[2:0]) begin
              rb_entries_4_request_operands_0_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_4_request_operands_0_value[2:0]) begin
              rb_entries_4_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_4_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h4 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_4_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_201) begin
        if (_GEN_7924) begin
          if (3'h7 == rb_entries_4_request_operands_0_value[2:0]) begin
            rb_entries_4_request_operands_0_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_4_request_operands_0_value[2:0]) begin
            rb_entries_4_request_operands_0_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_4_request_operands_0_value[2:0]) begin
            rb_entries_4_request_operands_0_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_4_request_operands_0_value[2:0]) begin
            rb_entries_4_request_operands_0_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_4_request_operands_0_value[2:0]) begin
            rb_entries_4_request_operands_0_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_4_request_operands_0_value[2:0]) begin
            rb_entries_4_request_operands_0_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_4_request_operands_0_value[2:0]) begin
            rb_entries_4_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_4_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_201) begin
      if (_GEN_7924) begin
        if (3'h7 == rb_entries_4_request_operands_0_value[2:0]) begin
          rb_entries_4_request_operands_0_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_4_request_operands_0_value[2:0]) begin
          rb_entries_4_request_operands_0_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_4_request_operands_0_value[2:0]) begin
          rb_entries_4_request_operands_0_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_4_request_operands_0_value[2:0]) begin
          rb_entries_4_request_operands_0_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_4_request_operands_0_value[2:0]) begin
          rb_entries_4_request_operands_0_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_4_request_operands_0_value[2:0]) begin
          rb_entries_4_request_operands_0_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_4_request_operands_0_value[2:0]) begin
          rb_entries_4_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_4_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_4_request_operands_0_value <= _GEN_1164;
      end
    end else begin
      rb_entries_4_request_operands_0_value <= _GEN_1164;
    end
    if (reset) begin
      rb_entries_4_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_4_request_operands_0_mode[1]) begin
        if (_T_1327) begin
          rb_entries_4_request_operands_0_mode <= 2'h0;
        end else if (_T_201) begin
          if (_GEN_7924) begin
            rb_entries_4_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h4 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_4_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_201) begin
        if (_GEN_7924) begin
          rb_entries_4_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_201) begin
      if (_GEN_7924) begin
        rb_entries_4_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_0_mode <= _GEN_1172;
      end
    end else begin
      rb_entries_4_request_operands_0_mode <= _GEN_1172;
    end
    if (reset) begin
      rb_entries_4_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_4_request_operands_1_mode[1]) begin
        if (_T_1413) begin
          if (_T_1379) begin
            rb_entries_4_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_1377) begin
            rb_entries_4_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_1375) begin
            rb_entries_4_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_1373) begin
            rb_entries_4_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_1371) begin
            rb_entries_4_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_1369) begin
            rb_entries_4_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_1367) begin
            rb_entries_4_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_1365) begin
            rb_entries_4_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_4_request_operands_1_value <= 32'h0;
          end
        end else if (_T_204) begin
          if (_GEN_8408) begin
            if (3'h7 == rb_entries_4_request_operands_1_value[2:0]) begin
              rb_entries_4_request_operands_1_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_4_request_operands_1_value[2:0]) begin
              rb_entries_4_request_operands_1_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_4_request_operands_1_value[2:0]) begin
              rb_entries_4_request_operands_1_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_4_request_operands_1_value[2:0]) begin
              rb_entries_4_request_operands_1_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_4_request_operands_1_value[2:0]) begin
              rb_entries_4_request_operands_1_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_4_request_operands_1_value[2:0]) begin
              rb_entries_4_request_operands_1_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_4_request_operands_1_value[2:0]) begin
              rb_entries_4_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_4_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h4 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_4_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_204) begin
        if (_GEN_8408) begin
          if (3'h7 == rb_entries_4_request_operands_1_value[2:0]) begin
            rb_entries_4_request_operands_1_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_4_request_operands_1_value[2:0]) begin
            rb_entries_4_request_operands_1_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_4_request_operands_1_value[2:0]) begin
            rb_entries_4_request_operands_1_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_4_request_operands_1_value[2:0]) begin
            rb_entries_4_request_operands_1_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_4_request_operands_1_value[2:0]) begin
            rb_entries_4_request_operands_1_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_4_request_operands_1_value[2:0]) begin
            rb_entries_4_request_operands_1_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_4_request_operands_1_value[2:0]) begin
            rb_entries_4_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_4_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_204) begin
      if (_GEN_8408) begin
        if (3'h7 == rb_entries_4_request_operands_1_value[2:0]) begin
          rb_entries_4_request_operands_1_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_4_request_operands_1_value[2:0]) begin
          rb_entries_4_request_operands_1_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_4_request_operands_1_value[2:0]) begin
          rb_entries_4_request_operands_1_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_4_request_operands_1_value[2:0]) begin
          rb_entries_4_request_operands_1_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_4_request_operands_1_value[2:0]) begin
          rb_entries_4_request_operands_1_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_4_request_operands_1_value[2:0]) begin
          rb_entries_4_request_operands_1_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_4_request_operands_1_value[2:0]) begin
          rb_entries_4_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_4_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_4_request_operands_1_value <= _GEN_1180;
      end
    end else begin
      rb_entries_4_request_operands_1_value <= _GEN_1180;
    end
    if (reset) begin
      rb_entries_4_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_4_request_operands_1_mode[1]) begin
        if (_T_1413) begin
          rb_entries_4_request_operands_1_mode <= 2'h0;
        end else if (_T_204) begin
          if (_GEN_8408) begin
            rb_entries_4_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h4 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_4_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_204) begin
        if (_GEN_8408) begin
          rb_entries_4_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_204) begin
      if (_GEN_8408) begin
        rb_entries_4_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_1_mode <= _GEN_1188;
      end
    end else begin
      rb_entries_4_request_operands_1_mode <= _GEN_1188;
    end
    if (reset) begin
      rb_entries_4_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_4_request_operands_2_mode[1]) begin
        if (_T_1499) begin
          if (_T_1465) begin
            rb_entries_4_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_1463) begin
            rb_entries_4_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_1461) begin
            rb_entries_4_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_1459) begin
            rb_entries_4_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_1457) begin
            rb_entries_4_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_1455) begin
            rb_entries_4_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_1453) begin
            rb_entries_4_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_1451) begin
            rb_entries_4_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_4_request_operands_2_value <= 32'h0;
          end
        end else if (_T_207) begin
          if (_GEN_8892) begin
            if (3'h7 == rb_entries_4_request_operands_2_value[2:0]) begin
              rb_entries_4_request_operands_2_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_4_request_operands_2_value[2:0]) begin
              rb_entries_4_request_operands_2_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_4_request_operands_2_value[2:0]) begin
              rb_entries_4_request_operands_2_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_4_request_operands_2_value[2:0]) begin
              rb_entries_4_request_operands_2_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_4_request_operands_2_value[2:0]) begin
              rb_entries_4_request_operands_2_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_4_request_operands_2_value[2:0]) begin
              rb_entries_4_request_operands_2_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_4_request_operands_2_value[2:0]) begin
              rb_entries_4_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_4_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h4 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_4_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_207) begin
        if (_GEN_8892) begin
          if (3'h7 == rb_entries_4_request_operands_2_value[2:0]) begin
            rb_entries_4_request_operands_2_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_4_request_operands_2_value[2:0]) begin
            rb_entries_4_request_operands_2_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_4_request_operands_2_value[2:0]) begin
            rb_entries_4_request_operands_2_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_4_request_operands_2_value[2:0]) begin
            rb_entries_4_request_operands_2_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_4_request_operands_2_value[2:0]) begin
            rb_entries_4_request_operands_2_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_4_request_operands_2_value[2:0]) begin
            rb_entries_4_request_operands_2_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_4_request_operands_2_value[2:0]) begin
            rb_entries_4_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_4_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_207) begin
      if (_GEN_8892) begin
        if (3'h7 == rb_entries_4_request_operands_2_value[2:0]) begin
          rb_entries_4_request_operands_2_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_4_request_operands_2_value[2:0]) begin
          rb_entries_4_request_operands_2_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_4_request_operands_2_value[2:0]) begin
          rb_entries_4_request_operands_2_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_4_request_operands_2_value[2:0]) begin
          rb_entries_4_request_operands_2_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_4_request_operands_2_value[2:0]) begin
          rb_entries_4_request_operands_2_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_4_request_operands_2_value[2:0]) begin
          rb_entries_4_request_operands_2_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_4_request_operands_2_value[2:0]) begin
          rb_entries_4_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_4_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_4_request_operands_2_value <= _GEN_1196;
      end
    end else begin
      rb_entries_4_request_operands_2_value <= _GEN_1196;
    end
    if (reset) begin
      rb_entries_4_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_4_request_operands_2_mode[1]) begin
        if (_T_1499) begin
          rb_entries_4_request_operands_2_mode <= 2'h0;
        end else if (_T_207) begin
          if (_GEN_8892) begin
            rb_entries_4_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h4 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_4_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_207) begin
        if (_GEN_8892) begin
          rb_entries_4_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h4 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_4_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_207) begin
      if (_GEN_8892) begin
        rb_entries_4_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_2_mode <= _GEN_1204;
      end
    end else begin
      rb_entries_4_request_operands_2_mode <= _GEN_1204;
    end
    if (reset) begin
      rb_entries_4_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_4_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_4_request_inFetch_0 <= 1'h0;
    end else if (_T_137) begin
      rb_entries_4_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_0 <= _T_2593[12];
    end
    if (reset) begin
      rb_entries_4_request_inFetch_1 <= 1'h0;
    end else if (_T_137) begin
      rb_entries_4_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_1 <= _T_2593[13];
    end
    if (reset) begin
      rb_entries_4_request_inFetch_2 <= 1'h0;
    end else if (_T_137) begin
      rb_entries_4_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_2 <= _T_2593[14];
    end
    if (reset) begin
      rb_entries_4_result_isZero <= 1'h0;
    end else if (_T_164) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_isNaR <= 1'h0;
    end else if (_T_164) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_out <= 32'h0;
    end else if (_T_164) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_lt <= 1'h0;
    end else if (_T_164) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_eq <= 1'h0;
    end else if (_T_164) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_gt <= 1'h0;
    end else if (_T_164) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_exceptions <= 5'h0;
    end else if (_T_164) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h4 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_4_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_4_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_5_completed <= 1'h0;
    end else if (_T_164) begin
      rb_entries_5_completed <= _GEN_1833;
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_5_valid <= _GEN_973;
    end
    if (reset) begin
      rb_entries_5_dispatched <= 1'h0;
    end else if (_T_143) begin
      rb_entries_5_dispatched <= 1'h0;
    end else begin
      rb_entries_5_dispatched <= _T_147;
    end
    if (reset) begin
      rb_entries_5_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_5_written <= _GEN_1511;
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_5_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_5_request_operands_0_mode[1]) begin
        if (_T_1585) begin
          if (_T_1551) begin
            rb_entries_5_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_1549) begin
            rb_entries_5_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_1547) begin
            rb_entries_5_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_1545) begin
            rb_entries_5_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_1543) begin
            rb_entries_5_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_1541) begin
            rb_entries_5_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_1539) begin
            rb_entries_5_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_1537) begin
            rb_entries_5_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_5_request_operands_0_value <= 32'h0;
          end
        end else if (_T_210) begin
          if (_GEN_9376) begin
            if (3'h7 == rb_entries_5_request_operands_0_value[2:0]) begin
              rb_entries_5_request_operands_0_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_5_request_operands_0_value[2:0]) begin
              rb_entries_5_request_operands_0_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_5_request_operands_0_value[2:0]) begin
              rb_entries_5_request_operands_0_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_5_request_operands_0_value[2:0]) begin
              rb_entries_5_request_operands_0_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_5_request_operands_0_value[2:0]) begin
              rb_entries_5_request_operands_0_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_5_request_operands_0_value[2:0]) begin
              rb_entries_5_request_operands_0_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_5_request_operands_0_value[2:0]) begin
              rb_entries_5_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_5_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h5 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_5_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_210) begin
        if (_GEN_9376) begin
          if (3'h7 == rb_entries_5_request_operands_0_value[2:0]) begin
            rb_entries_5_request_operands_0_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_5_request_operands_0_value[2:0]) begin
            rb_entries_5_request_operands_0_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_5_request_operands_0_value[2:0]) begin
            rb_entries_5_request_operands_0_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_5_request_operands_0_value[2:0]) begin
            rb_entries_5_request_operands_0_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_5_request_operands_0_value[2:0]) begin
            rb_entries_5_request_operands_0_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_5_request_operands_0_value[2:0]) begin
            rb_entries_5_request_operands_0_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_5_request_operands_0_value[2:0]) begin
            rb_entries_5_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_5_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_210) begin
      if (_GEN_9376) begin
        if (3'h7 == rb_entries_5_request_operands_0_value[2:0]) begin
          rb_entries_5_request_operands_0_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_5_request_operands_0_value[2:0]) begin
          rb_entries_5_request_operands_0_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_5_request_operands_0_value[2:0]) begin
          rb_entries_5_request_operands_0_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_5_request_operands_0_value[2:0]) begin
          rb_entries_5_request_operands_0_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_5_request_operands_0_value[2:0]) begin
          rb_entries_5_request_operands_0_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_5_request_operands_0_value[2:0]) begin
          rb_entries_5_request_operands_0_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_5_request_operands_0_value[2:0]) begin
          rb_entries_5_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_5_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_5_request_operands_0_value <= _GEN_1165;
      end
    end else begin
      rb_entries_5_request_operands_0_value <= _GEN_1165;
    end
    if (reset) begin
      rb_entries_5_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_5_request_operands_0_mode[1]) begin
        if (_T_1585) begin
          rb_entries_5_request_operands_0_mode <= 2'h0;
        end else if (_T_210) begin
          if (_GEN_9376) begin
            rb_entries_5_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h5 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_5_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_210) begin
        if (_GEN_9376) begin
          rb_entries_5_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_210) begin
      if (_GEN_9376) begin
        rb_entries_5_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_0_mode <= _GEN_1173;
      end
    end else begin
      rb_entries_5_request_operands_0_mode <= _GEN_1173;
    end
    if (reset) begin
      rb_entries_5_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_5_request_operands_1_mode[1]) begin
        if (_T_1671) begin
          if (_T_1637) begin
            rb_entries_5_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_1635) begin
            rb_entries_5_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_1633) begin
            rb_entries_5_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_1631) begin
            rb_entries_5_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_1629) begin
            rb_entries_5_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_1627) begin
            rb_entries_5_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_1625) begin
            rb_entries_5_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_1623) begin
            rb_entries_5_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_5_request_operands_1_value <= 32'h0;
          end
        end else if (_T_213) begin
          if (_GEN_9860) begin
            if (3'h7 == rb_entries_5_request_operands_1_value[2:0]) begin
              rb_entries_5_request_operands_1_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_5_request_operands_1_value[2:0]) begin
              rb_entries_5_request_operands_1_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_5_request_operands_1_value[2:0]) begin
              rb_entries_5_request_operands_1_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_5_request_operands_1_value[2:0]) begin
              rb_entries_5_request_operands_1_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_5_request_operands_1_value[2:0]) begin
              rb_entries_5_request_operands_1_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_5_request_operands_1_value[2:0]) begin
              rb_entries_5_request_operands_1_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_5_request_operands_1_value[2:0]) begin
              rb_entries_5_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_5_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h5 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_5_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_213) begin
        if (_GEN_9860) begin
          if (3'h7 == rb_entries_5_request_operands_1_value[2:0]) begin
            rb_entries_5_request_operands_1_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_5_request_operands_1_value[2:0]) begin
            rb_entries_5_request_operands_1_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_5_request_operands_1_value[2:0]) begin
            rb_entries_5_request_operands_1_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_5_request_operands_1_value[2:0]) begin
            rb_entries_5_request_operands_1_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_5_request_operands_1_value[2:0]) begin
            rb_entries_5_request_operands_1_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_5_request_operands_1_value[2:0]) begin
            rb_entries_5_request_operands_1_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_5_request_operands_1_value[2:0]) begin
            rb_entries_5_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_5_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_213) begin
      if (_GEN_9860) begin
        if (3'h7 == rb_entries_5_request_operands_1_value[2:0]) begin
          rb_entries_5_request_operands_1_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_5_request_operands_1_value[2:0]) begin
          rb_entries_5_request_operands_1_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_5_request_operands_1_value[2:0]) begin
          rb_entries_5_request_operands_1_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_5_request_operands_1_value[2:0]) begin
          rb_entries_5_request_operands_1_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_5_request_operands_1_value[2:0]) begin
          rb_entries_5_request_operands_1_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_5_request_operands_1_value[2:0]) begin
          rb_entries_5_request_operands_1_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_5_request_operands_1_value[2:0]) begin
          rb_entries_5_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_5_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_5_request_operands_1_value <= _GEN_1181;
      end
    end else begin
      rb_entries_5_request_operands_1_value <= _GEN_1181;
    end
    if (reset) begin
      rb_entries_5_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_5_request_operands_1_mode[1]) begin
        if (_T_1671) begin
          rb_entries_5_request_operands_1_mode <= 2'h0;
        end else if (_T_213) begin
          if (_GEN_9860) begin
            rb_entries_5_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h5 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_5_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_213) begin
        if (_GEN_9860) begin
          rb_entries_5_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_213) begin
      if (_GEN_9860) begin
        rb_entries_5_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_1_mode <= _GEN_1189;
      end
    end else begin
      rb_entries_5_request_operands_1_mode <= _GEN_1189;
    end
    if (reset) begin
      rb_entries_5_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_5_request_operands_2_mode[1]) begin
        if (_T_1757) begin
          if (_T_1723) begin
            rb_entries_5_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_1721) begin
            rb_entries_5_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_1719) begin
            rb_entries_5_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_1717) begin
            rb_entries_5_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_1715) begin
            rb_entries_5_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_1713) begin
            rb_entries_5_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_1711) begin
            rb_entries_5_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_1709) begin
            rb_entries_5_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_5_request_operands_2_value <= 32'h0;
          end
        end else if (_T_216) begin
          if (_GEN_10344) begin
            if (3'h7 == rb_entries_5_request_operands_2_value[2:0]) begin
              rb_entries_5_request_operands_2_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_5_request_operands_2_value[2:0]) begin
              rb_entries_5_request_operands_2_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_5_request_operands_2_value[2:0]) begin
              rb_entries_5_request_operands_2_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_5_request_operands_2_value[2:0]) begin
              rb_entries_5_request_operands_2_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_5_request_operands_2_value[2:0]) begin
              rb_entries_5_request_operands_2_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_5_request_operands_2_value[2:0]) begin
              rb_entries_5_request_operands_2_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_5_request_operands_2_value[2:0]) begin
              rb_entries_5_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_5_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h5 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_5_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_216) begin
        if (_GEN_10344) begin
          if (3'h7 == rb_entries_5_request_operands_2_value[2:0]) begin
            rb_entries_5_request_operands_2_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_5_request_operands_2_value[2:0]) begin
            rb_entries_5_request_operands_2_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_5_request_operands_2_value[2:0]) begin
            rb_entries_5_request_operands_2_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_5_request_operands_2_value[2:0]) begin
            rb_entries_5_request_operands_2_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_5_request_operands_2_value[2:0]) begin
            rb_entries_5_request_operands_2_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_5_request_operands_2_value[2:0]) begin
            rb_entries_5_request_operands_2_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_5_request_operands_2_value[2:0]) begin
            rb_entries_5_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_5_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_216) begin
      if (_GEN_10344) begin
        if (3'h7 == rb_entries_5_request_operands_2_value[2:0]) begin
          rb_entries_5_request_operands_2_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_5_request_operands_2_value[2:0]) begin
          rb_entries_5_request_operands_2_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_5_request_operands_2_value[2:0]) begin
          rb_entries_5_request_operands_2_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_5_request_operands_2_value[2:0]) begin
          rb_entries_5_request_operands_2_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_5_request_operands_2_value[2:0]) begin
          rb_entries_5_request_operands_2_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_5_request_operands_2_value[2:0]) begin
          rb_entries_5_request_operands_2_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_5_request_operands_2_value[2:0]) begin
          rb_entries_5_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_5_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_5_request_operands_2_value <= _GEN_1197;
      end
    end else begin
      rb_entries_5_request_operands_2_value <= _GEN_1197;
    end
    if (reset) begin
      rb_entries_5_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_5_request_operands_2_mode[1]) begin
        if (_T_1757) begin
          rb_entries_5_request_operands_2_mode <= 2'h0;
        end else if (_T_216) begin
          if (_GEN_10344) begin
            rb_entries_5_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h5 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_5_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_216) begin
        if (_GEN_10344) begin
          rb_entries_5_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h5 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_5_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_216) begin
      if (_GEN_10344) begin
        rb_entries_5_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_2_mode <= _GEN_1205;
      end
    end else begin
      rb_entries_5_request_operands_2_mode <= _GEN_1205;
    end
    if (reset) begin
      rb_entries_5_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_5_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_5_request_inFetch_0 <= 1'h0;
    end else if (_T_143) begin
      rb_entries_5_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_0 <= _T_2593[15];
    end
    if (reset) begin
      rb_entries_5_request_inFetch_1 <= 1'h0;
    end else if (_T_143) begin
      rb_entries_5_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_1 <= _T_2593[16];
    end
    if (reset) begin
      rb_entries_5_request_inFetch_2 <= 1'h0;
    end else if (_T_143) begin
      rb_entries_5_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_2 <= _T_2593[17];
    end
    if (reset) begin
      rb_entries_5_result_isZero <= 1'h0;
    end else if (_T_164) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_isNaR <= 1'h0;
    end else if (_T_164) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_out <= 32'h0;
    end else if (_T_164) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_lt <= 1'h0;
    end else if (_T_164) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_eq <= 1'h0;
    end else if (_T_164) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_gt <= 1'h0;
    end else if (_T_164) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_exceptions <= 5'h0;
    end else if (_T_164) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h5 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_5_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_5_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_6_completed <= 1'h0;
    end else if (_T_164) begin
      rb_entries_6_completed <= _GEN_1834;
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_6_valid <= _GEN_974;
    end
    if (reset) begin
      rb_entries_6_dispatched <= 1'h0;
    end else if (_T_149) begin
      rb_entries_6_dispatched <= 1'h0;
    end else begin
      rb_entries_6_dispatched <= _T_153;
    end
    if (reset) begin
      rb_entries_6_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_6_written <= _GEN_1512;
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_6_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_6_request_operands_0_mode[1]) begin
        if (_T_1843) begin
          if (_T_1809) begin
            rb_entries_6_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_1807) begin
            rb_entries_6_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_1805) begin
            rb_entries_6_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_1803) begin
            rb_entries_6_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_1801) begin
            rb_entries_6_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_1799) begin
            rb_entries_6_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_1797) begin
            rb_entries_6_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_1795) begin
            rb_entries_6_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_6_request_operands_0_value <= 32'h0;
          end
        end else if (_T_219) begin
          if (_GEN_10828) begin
            if (3'h7 == rb_entries_6_request_operands_0_value[2:0]) begin
              rb_entries_6_request_operands_0_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_6_request_operands_0_value[2:0]) begin
              rb_entries_6_request_operands_0_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_6_request_operands_0_value[2:0]) begin
              rb_entries_6_request_operands_0_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_6_request_operands_0_value[2:0]) begin
              rb_entries_6_request_operands_0_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_6_request_operands_0_value[2:0]) begin
              rb_entries_6_request_operands_0_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_6_request_operands_0_value[2:0]) begin
              rb_entries_6_request_operands_0_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_6_request_operands_0_value[2:0]) begin
              rb_entries_6_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_6_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h6 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_6_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_219) begin
        if (_GEN_10828) begin
          if (3'h7 == rb_entries_6_request_operands_0_value[2:0]) begin
            rb_entries_6_request_operands_0_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_6_request_operands_0_value[2:0]) begin
            rb_entries_6_request_operands_0_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_6_request_operands_0_value[2:0]) begin
            rb_entries_6_request_operands_0_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_6_request_operands_0_value[2:0]) begin
            rb_entries_6_request_operands_0_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_6_request_operands_0_value[2:0]) begin
            rb_entries_6_request_operands_0_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_6_request_operands_0_value[2:0]) begin
            rb_entries_6_request_operands_0_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_6_request_operands_0_value[2:0]) begin
            rb_entries_6_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_6_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_219) begin
      if (_GEN_10828) begin
        if (3'h7 == rb_entries_6_request_operands_0_value[2:0]) begin
          rb_entries_6_request_operands_0_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_6_request_operands_0_value[2:0]) begin
          rb_entries_6_request_operands_0_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_6_request_operands_0_value[2:0]) begin
          rb_entries_6_request_operands_0_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_6_request_operands_0_value[2:0]) begin
          rb_entries_6_request_operands_0_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_6_request_operands_0_value[2:0]) begin
          rb_entries_6_request_operands_0_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_6_request_operands_0_value[2:0]) begin
          rb_entries_6_request_operands_0_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_6_request_operands_0_value[2:0]) begin
          rb_entries_6_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_6_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_6_request_operands_0_value <= _GEN_1166;
      end
    end else begin
      rb_entries_6_request_operands_0_value <= _GEN_1166;
    end
    if (reset) begin
      rb_entries_6_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_6_request_operands_0_mode[1]) begin
        if (_T_1843) begin
          rb_entries_6_request_operands_0_mode <= 2'h0;
        end else if (_T_219) begin
          if (_GEN_10828) begin
            rb_entries_6_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h6 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_6_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_219) begin
        if (_GEN_10828) begin
          rb_entries_6_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_219) begin
      if (_GEN_10828) begin
        rb_entries_6_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_0_mode <= _GEN_1174;
      end
    end else begin
      rb_entries_6_request_operands_0_mode <= _GEN_1174;
    end
    if (reset) begin
      rb_entries_6_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_6_request_operands_1_mode[1]) begin
        if (_T_1929) begin
          if (_T_1895) begin
            rb_entries_6_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_1893) begin
            rb_entries_6_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_1891) begin
            rb_entries_6_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_1889) begin
            rb_entries_6_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_1887) begin
            rb_entries_6_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_1885) begin
            rb_entries_6_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_1883) begin
            rb_entries_6_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_1881) begin
            rb_entries_6_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_6_request_operands_1_value <= 32'h0;
          end
        end else if (_T_222) begin
          if (_GEN_11312) begin
            if (3'h7 == rb_entries_6_request_operands_1_value[2:0]) begin
              rb_entries_6_request_operands_1_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_6_request_operands_1_value[2:0]) begin
              rb_entries_6_request_operands_1_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_6_request_operands_1_value[2:0]) begin
              rb_entries_6_request_operands_1_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_6_request_operands_1_value[2:0]) begin
              rb_entries_6_request_operands_1_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_6_request_operands_1_value[2:0]) begin
              rb_entries_6_request_operands_1_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_6_request_operands_1_value[2:0]) begin
              rb_entries_6_request_operands_1_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_6_request_operands_1_value[2:0]) begin
              rb_entries_6_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_6_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h6 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_6_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_222) begin
        if (_GEN_11312) begin
          if (3'h7 == rb_entries_6_request_operands_1_value[2:0]) begin
            rb_entries_6_request_operands_1_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_6_request_operands_1_value[2:0]) begin
            rb_entries_6_request_operands_1_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_6_request_operands_1_value[2:0]) begin
            rb_entries_6_request_operands_1_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_6_request_operands_1_value[2:0]) begin
            rb_entries_6_request_operands_1_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_6_request_operands_1_value[2:0]) begin
            rb_entries_6_request_operands_1_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_6_request_operands_1_value[2:0]) begin
            rb_entries_6_request_operands_1_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_6_request_operands_1_value[2:0]) begin
            rb_entries_6_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_6_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_222) begin
      if (_GEN_11312) begin
        if (3'h7 == rb_entries_6_request_operands_1_value[2:0]) begin
          rb_entries_6_request_operands_1_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_6_request_operands_1_value[2:0]) begin
          rb_entries_6_request_operands_1_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_6_request_operands_1_value[2:0]) begin
          rb_entries_6_request_operands_1_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_6_request_operands_1_value[2:0]) begin
          rb_entries_6_request_operands_1_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_6_request_operands_1_value[2:0]) begin
          rb_entries_6_request_operands_1_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_6_request_operands_1_value[2:0]) begin
          rb_entries_6_request_operands_1_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_6_request_operands_1_value[2:0]) begin
          rb_entries_6_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_6_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_6_request_operands_1_value <= _GEN_1182;
      end
    end else begin
      rb_entries_6_request_operands_1_value <= _GEN_1182;
    end
    if (reset) begin
      rb_entries_6_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_6_request_operands_1_mode[1]) begin
        if (_T_1929) begin
          rb_entries_6_request_operands_1_mode <= 2'h0;
        end else if (_T_222) begin
          if (_GEN_11312) begin
            rb_entries_6_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h6 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_6_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_222) begin
        if (_GEN_11312) begin
          rb_entries_6_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_222) begin
      if (_GEN_11312) begin
        rb_entries_6_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_1_mode <= _GEN_1190;
      end
    end else begin
      rb_entries_6_request_operands_1_mode <= _GEN_1190;
    end
    if (reset) begin
      rb_entries_6_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_6_request_operands_2_mode[1]) begin
        if (_T_2015) begin
          if (_T_1981) begin
            rb_entries_6_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_1979) begin
            rb_entries_6_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_1977) begin
            rb_entries_6_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_1975) begin
            rb_entries_6_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_1973) begin
            rb_entries_6_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_1971) begin
            rb_entries_6_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_1969) begin
            rb_entries_6_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_1967) begin
            rb_entries_6_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_6_request_operands_2_value <= 32'h0;
          end
        end else if (_T_225) begin
          if (_GEN_11796) begin
            if (3'h7 == rb_entries_6_request_operands_2_value[2:0]) begin
              rb_entries_6_request_operands_2_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_6_request_operands_2_value[2:0]) begin
              rb_entries_6_request_operands_2_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_6_request_operands_2_value[2:0]) begin
              rb_entries_6_request_operands_2_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_6_request_operands_2_value[2:0]) begin
              rb_entries_6_request_operands_2_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_6_request_operands_2_value[2:0]) begin
              rb_entries_6_request_operands_2_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_6_request_operands_2_value[2:0]) begin
              rb_entries_6_request_operands_2_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_6_request_operands_2_value[2:0]) begin
              rb_entries_6_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_6_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h6 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_6_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_225) begin
        if (_GEN_11796) begin
          if (3'h7 == rb_entries_6_request_operands_2_value[2:0]) begin
            rb_entries_6_request_operands_2_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_6_request_operands_2_value[2:0]) begin
            rb_entries_6_request_operands_2_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_6_request_operands_2_value[2:0]) begin
            rb_entries_6_request_operands_2_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_6_request_operands_2_value[2:0]) begin
            rb_entries_6_request_operands_2_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_6_request_operands_2_value[2:0]) begin
            rb_entries_6_request_operands_2_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_6_request_operands_2_value[2:0]) begin
            rb_entries_6_request_operands_2_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_6_request_operands_2_value[2:0]) begin
            rb_entries_6_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_6_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_225) begin
      if (_GEN_11796) begin
        if (3'h7 == rb_entries_6_request_operands_2_value[2:0]) begin
          rb_entries_6_request_operands_2_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_6_request_operands_2_value[2:0]) begin
          rb_entries_6_request_operands_2_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_6_request_operands_2_value[2:0]) begin
          rb_entries_6_request_operands_2_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_6_request_operands_2_value[2:0]) begin
          rb_entries_6_request_operands_2_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_6_request_operands_2_value[2:0]) begin
          rb_entries_6_request_operands_2_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_6_request_operands_2_value[2:0]) begin
          rb_entries_6_request_operands_2_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_6_request_operands_2_value[2:0]) begin
          rb_entries_6_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_6_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_6_request_operands_2_value <= _GEN_1198;
      end
    end else begin
      rb_entries_6_request_operands_2_value <= _GEN_1198;
    end
    if (reset) begin
      rb_entries_6_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_6_request_operands_2_mode[1]) begin
        if (_T_2015) begin
          rb_entries_6_request_operands_2_mode <= 2'h0;
        end else if (_T_225) begin
          if (_GEN_11796) begin
            rb_entries_6_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h6 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_6_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_225) begin
        if (_GEN_11796) begin
          rb_entries_6_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h6 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_6_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_225) begin
      if (_GEN_11796) begin
        rb_entries_6_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_2_mode <= _GEN_1206;
      end
    end else begin
      rb_entries_6_request_operands_2_mode <= _GEN_1206;
    end
    if (reset) begin
      rb_entries_6_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_6_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_6_request_inFetch_0 <= 1'h0;
    end else if (_T_149) begin
      rb_entries_6_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_0 <= _T_2593[18];
    end
    if (reset) begin
      rb_entries_6_request_inFetch_1 <= 1'h0;
    end else if (_T_149) begin
      rb_entries_6_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_1 <= _T_2593[19];
    end
    if (reset) begin
      rb_entries_6_request_inFetch_2 <= 1'h0;
    end else if (_T_149) begin
      rb_entries_6_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_2 <= _T_2593[20];
    end
    if (reset) begin
      rb_entries_6_result_isZero <= 1'h0;
    end else if (_T_164) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_isNaR <= 1'h0;
    end else if (_T_164) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_out <= 32'h0;
    end else if (_T_164) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_lt <= 1'h0;
    end else if (_T_164) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_eq <= 1'h0;
    end else if (_T_164) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_gt <= 1'h0;
    end else if (_T_164) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_exceptions <= 5'h0;
    end else if (_T_164) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h6 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_6_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_6_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_7_completed <= 1'h0;
    end else if (_T_164) begin
      rb_entries_7_completed <= _GEN_1835;
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_7_valid <= _GEN_975;
    end
    if (reset) begin
      rb_entries_7_dispatched <= 1'h0;
    end else if (_T_155) begin
      rb_entries_7_dispatched <= 1'h0;
    end else begin
      rb_entries_7_dispatched <= _T_159;
    end
    if (reset) begin
      rb_entries_7_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_7_written <= _GEN_1513;
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_wr_addr <= 8'h0;
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_7_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_7_request_operands_0_mode[1]) begin
        if (_T_2101) begin
          if (_T_2067) begin
            rb_entries_7_request_operands_0_value <= io_mem_read_data[31:0];
          end else if (_T_2065) begin
            rb_entries_7_request_operands_0_value <= io_mem_read_data[95:64];
          end else if (_T_2063) begin
            rb_entries_7_request_operands_0_value <= io_mem_read_data[159:128];
          end else if (_T_2061) begin
            rb_entries_7_request_operands_0_value <= io_mem_read_data[223:192];
          end else if (_T_2059) begin
            rb_entries_7_request_operands_0_value <= io_mem_read_data[287:256];
          end else if (_T_2057) begin
            rb_entries_7_request_operands_0_value <= io_mem_read_data[351:320];
          end else if (_T_2055) begin
            rb_entries_7_request_operands_0_value <= io_mem_read_data[415:384];
          end else if (_T_2053) begin
            rb_entries_7_request_operands_0_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_7_request_operands_0_value <= 32'h0;
          end
        end else if (_T_228) begin
          if (_GEN_12280) begin
            if (3'h7 == rb_entries_7_request_operands_0_value[2:0]) begin
              rb_entries_7_request_operands_0_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_7_request_operands_0_value[2:0]) begin
              rb_entries_7_request_operands_0_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_7_request_operands_0_value[2:0]) begin
              rb_entries_7_request_operands_0_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_7_request_operands_0_value[2:0]) begin
              rb_entries_7_request_operands_0_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_7_request_operands_0_value[2:0]) begin
              rb_entries_7_request_operands_0_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_7_request_operands_0_value[2:0]) begin
              rb_entries_7_request_operands_0_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_7_request_operands_0_value[2:0]) begin
              rb_entries_7_request_operands_0_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_7_request_operands_0_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h7 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_7_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_228) begin
        if (_GEN_12280) begin
          if (3'h7 == rb_entries_7_request_operands_0_value[2:0]) begin
            rb_entries_7_request_operands_0_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_7_request_operands_0_value[2:0]) begin
            rb_entries_7_request_operands_0_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_7_request_operands_0_value[2:0]) begin
            rb_entries_7_request_operands_0_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_7_request_operands_0_value[2:0]) begin
            rb_entries_7_request_operands_0_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_7_request_operands_0_value[2:0]) begin
            rb_entries_7_request_operands_0_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_7_request_operands_0_value[2:0]) begin
            rb_entries_7_request_operands_0_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_7_request_operands_0_value[2:0]) begin
            rb_entries_7_request_operands_0_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_7_request_operands_0_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_228) begin
      if (_GEN_12280) begin
        if (3'h7 == rb_entries_7_request_operands_0_value[2:0]) begin
          rb_entries_7_request_operands_0_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_7_request_operands_0_value[2:0]) begin
          rb_entries_7_request_operands_0_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_7_request_operands_0_value[2:0]) begin
          rb_entries_7_request_operands_0_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_7_request_operands_0_value[2:0]) begin
          rb_entries_7_request_operands_0_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_7_request_operands_0_value[2:0]) begin
          rb_entries_7_request_operands_0_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_7_request_operands_0_value[2:0]) begin
          rb_entries_7_request_operands_0_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_7_request_operands_0_value[2:0]) begin
          rb_entries_7_request_operands_0_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_7_request_operands_0_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_7_request_operands_0_value <= _GEN_1167;
      end
    end else begin
      rb_entries_7_request_operands_0_value <= _GEN_1167;
    end
    if (reset) begin
      rb_entries_7_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_7_request_operands_0_mode[1]) begin
        if (_T_2101) begin
          rb_entries_7_request_operands_0_mode <= 2'h0;
        end else if (_T_228) begin
          if (_GEN_12280) begin
            rb_entries_7_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h7 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_7_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_228) begin
        if (_GEN_12280) begin
          rb_entries_7_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_228) begin
      if (_GEN_12280) begin
        rb_entries_7_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_0_mode <= _GEN_1175;
      end
    end else begin
      rb_entries_7_request_operands_0_mode <= _GEN_1175;
    end
    if (reset) begin
      rb_entries_7_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_7_request_operands_1_mode[1]) begin
        if (_T_2187) begin
          if (_T_2153) begin
            rb_entries_7_request_operands_1_value <= io_mem_read_data[31:0];
          end else if (_T_2151) begin
            rb_entries_7_request_operands_1_value <= io_mem_read_data[95:64];
          end else if (_T_2149) begin
            rb_entries_7_request_operands_1_value <= io_mem_read_data[159:128];
          end else if (_T_2147) begin
            rb_entries_7_request_operands_1_value <= io_mem_read_data[223:192];
          end else if (_T_2145) begin
            rb_entries_7_request_operands_1_value <= io_mem_read_data[287:256];
          end else if (_T_2143) begin
            rb_entries_7_request_operands_1_value <= io_mem_read_data[351:320];
          end else if (_T_2141) begin
            rb_entries_7_request_operands_1_value <= io_mem_read_data[415:384];
          end else if (_T_2139) begin
            rb_entries_7_request_operands_1_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_7_request_operands_1_value <= 32'h0;
          end
        end else if (_T_231) begin
          if (_GEN_12764) begin
            if (3'h7 == rb_entries_7_request_operands_1_value[2:0]) begin
              rb_entries_7_request_operands_1_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_7_request_operands_1_value[2:0]) begin
              rb_entries_7_request_operands_1_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_7_request_operands_1_value[2:0]) begin
              rb_entries_7_request_operands_1_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_7_request_operands_1_value[2:0]) begin
              rb_entries_7_request_operands_1_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_7_request_operands_1_value[2:0]) begin
              rb_entries_7_request_operands_1_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_7_request_operands_1_value[2:0]) begin
              rb_entries_7_request_operands_1_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_7_request_operands_1_value[2:0]) begin
              rb_entries_7_request_operands_1_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_7_request_operands_1_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h7 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_7_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_231) begin
        if (_GEN_12764) begin
          if (3'h7 == rb_entries_7_request_operands_1_value[2:0]) begin
            rb_entries_7_request_operands_1_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_7_request_operands_1_value[2:0]) begin
            rb_entries_7_request_operands_1_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_7_request_operands_1_value[2:0]) begin
            rb_entries_7_request_operands_1_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_7_request_operands_1_value[2:0]) begin
            rb_entries_7_request_operands_1_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_7_request_operands_1_value[2:0]) begin
            rb_entries_7_request_operands_1_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_7_request_operands_1_value[2:0]) begin
            rb_entries_7_request_operands_1_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_7_request_operands_1_value[2:0]) begin
            rb_entries_7_request_operands_1_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_7_request_operands_1_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_231) begin
      if (_GEN_12764) begin
        if (3'h7 == rb_entries_7_request_operands_1_value[2:0]) begin
          rb_entries_7_request_operands_1_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_7_request_operands_1_value[2:0]) begin
          rb_entries_7_request_operands_1_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_7_request_operands_1_value[2:0]) begin
          rb_entries_7_request_operands_1_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_7_request_operands_1_value[2:0]) begin
          rb_entries_7_request_operands_1_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_7_request_operands_1_value[2:0]) begin
          rb_entries_7_request_operands_1_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_7_request_operands_1_value[2:0]) begin
          rb_entries_7_request_operands_1_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_7_request_operands_1_value[2:0]) begin
          rb_entries_7_request_operands_1_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_7_request_operands_1_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_7_request_operands_1_value <= _GEN_1183;
      end
    end else begin
      rb_entries_7_request_operands_1_value <= _GEN_1183;
    end
    if (reset) begin
      rb_entries_7_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_7_request_operands_1_mode[1]) begin
        if (_T_2187) begin
          rb_entries_7_request_operands_1_mode <= 2'h0;
        end else if (_T_231) begin
          if (_GEN_12764) begin
            rb_entries_7_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h7 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_7_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_231) begin
        if (_GEN_12764) begin
          rb_entries_7_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_231) begin
      if (_GEN_12764) begin
        rb_entries_7_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_1_mode <= _GEN_1191;
      end
    end else begin
      rb_entries_7_request_operands_1_mode <= _GEN_1191;
    end
    if (reset) begin
      rb_entries_7_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_7_request_operands_2_mode[1]) begin
        if (_T_2273) begin
          if (_T_2239) begin
            rb_entries_7_request_operands_2_value <= io_mem_read_data[31:0];
          end else if (_T_2237) begin
            rb_entries_7_request_operands_2_value <= io_mem_read_data[95:64];
          end else if (_T_2235) begin
            rb_entries_7_request_operands_2_value <= io_mem_read_data[159:128];
          end else if (_T_2233) begin
            rb_entries_7_request_operands_2_value <= io_mem_read_data[223:192];
          end else if (_T_2231) begin
            rb_entries_7_request_operands_2_value <= io_mem_read_data[287:256];
          end else if (_T_2229) begin
            rb_entries_7_request_operands_2_value <= io_mem_read_data[351:320];
          end else if (_T_2227) begin
            rb_entries_7_request_operands_2_value <= io_mem_read_data[415:384];
          end else if (_T_2225) begin
            rb_entries_7_request_operands_2_value <= io_mem_read_data[479:448];
          end else begin
            rb_entries_7_request_operands_2_value <= 32'h0;
          end
        end else if (_T_234) begin
          if (_GEN_13248) begin
            if (3'h7 == rb_entries_7_request_operands_2_value[2:0]) begin
              rb_entries_7_request_operands_2_value <= rb_entries_7_result_out;
            end else if (3'h6 == rb_entries_7_request_operands_2_value[2:0]) begin
              rb_entries_7_request_operands_2_value <= rb_entries_6_result_out;
            end else if (3'h5 == rb_entries_7_request_operands_2_value[2:0]) begin
              rb_entries_7_request_operands_2_value <= rb_entries_5_result_out;
            end else if (3'h4 == rb_entries_7_request_operands_2_value[2:0]) begin
              rb_entries_7_request_operands_2_value <= rb_entries_4_result_out;
            end else if (3'h3 == rb_entries_7_request_operands_2_value[2:0]) begin
              rb_entries_7_request_operands_2_value <= rb_entries_3_result_out;
            end else if (3'h2 == rb_entries_7_request_operands_2_value[2:0]) begin
              rb_entries_7_request_operands_2_value <= rb_entries_2_result_out;
            end else if (3'h1 == rb_entries_7_request_operands_2_value[2:0]) begin
              rb_entries_7_request_operands_2_value <= rb_entries_1_result_out;
            end else begin
              rb_entries_7_request_operands_2_value <= rb_entries_0_result_out;
            end
          end else if (new_input_log) begin
            if (3'h7 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_7_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_234) begin
        if (_GEN_13248) begin
          if (3'h7 == rb_entries_7_request_operands_2_value[2:0]) begin
            rb_entries_7_request_operands_2_value <= rb_entries_7_result_out;
          end else if (3'h6 == rb_entries_7_request_operands_2_value[2:0]) begin
            rb_entries_7_request_operands_2_value <= rb_entries_6_result_out;
          end else if (3'h5 == rb_entries_7_request_operands_2_value[2:0]) begin
            rb_entries_7_request_operands_2_value <= rb_entries_5_result_out;
          end else if (3'h4 == rb_entries_7_request_operands_2_value[2:0]) begin
            rb_entries_7_request_operands_2_value <= rb_entries_4_result_out;
          end else if (3'h3 == rb_entries_7_request_operands_2_value[2:0]) begin
            rb_entries_7_request_operands_2_value <= rb_entries_3_result_out;
          end else if (3'h2 == rb_entries_7_request_operands_2_value[2:0]) begin
            rb_entries_7_request_operands_2_value <= rb_entries_2_result_out;
          end else if (3'h1 == rb_entries_7_request_operands_2_value[2:0]) begin
            rb_entries_7_request_operands_2_value <= rb_entries_1_result_out;
          end else begin
            rb_entries_7_request_operands_2_value <= rb_entries_0_result_out;
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_234) begin
      if (_GEN_13248) begin
        if (3'h7 == rb_entries_7_request_operands_2_value[2:0]) begin
          rb_entries_7_request_operands_2_value <= rb_entries_7_result_out;
        end else if (3'h6 == rb_entries_7_request_operands_2_value[2:0]) begin
          rb_entries_7_request_operands_2_value <= rb_entries_6_result_out;
        end else if (3'h5 == rb_entries_7_request_operands_2_value[2:0]) begin
          rb_entries_7_request_operands_2_value <= rb_entries_5_result_out;
        end else if (3'h4 == rb_entries_7_request_operands_2_value[2:0]) begin
          rb_entries_7_request_operands_2_value <= rb_entries_4_result_out;
        end else if (3'h3 == rb_entries_7_request_operands_2_value[2:0]) begin
          rb_entries_7_request_operands_2_value <= rb_entries_3_result_out;
        end else if (3'h2 == rb_entries_7_request_operands_2_value[2:0]) begin
          rb_entries_7_request_operands_2_value <= rb_entries_2_result_out;
        end else if (3'h1 == rb_entries_7_request_operands_2_value[2:0]) begin
          rb_entries_7_request_operands_2_value <= rb_entries_1_result_out;
        end else begin
          rb_entries_7_request_operands_2_value <= rb_entries_0_result_out;
        end
      end else begin
        rb_entries_7_request_operands_2_value <= _GEN_1199;
      end
    end else begin
      rb_entries_7_request_operands_2_value <= _GEN_1199;
    end
    if (reset) begin
      rb_entries_7_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (rb_entries_7_request_operands_2_mode[1]) begin
        if (_T_2273) begin
          rb_entries_7_request_operands_2_mode <= 2'h0;
        end else if (_T_234) begin
          if (_GEN_13248) begin
            rb_entries_7_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h7 == io_request_bits_wr_addr[2:0]) begin
              rb_entries_7_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_234) begin
        if (_GEN_13248) begin
          rb_entries_7_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h7 == io_request_bits_wr_addr[2:0]) begin
            rb_entries_7_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_234) begin
      if (_GEN_13248) begin
        rb_entries_7_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_2_mode <= _GEN_1207;
      end
    end else begin
      rb_entries_7_request_operands_2_mode <= _GEN_1207;
    end
    if (reset) begin
      rb_entries_7_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_7_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_7_request_inFetch_0 <= 1'h0;
    end else if (_T_155) begin
      rb_entries_7_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_0 <= _T_2593[21];
    end
    if (reset) begin
      rb_entries_7_request_inFetch_1 <= 1'h0;
    end else if (_T_155) begin
      rb_entries_7_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_1 <= _T_2593[22];
    end
    if (reset) begin
      rb_entries_7_request_inFetch_2 <= 1'h0;
    end else if (_T_155) begin
      rb_entries_7_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_2 <= _T_2593[23];
    end
    if (reset) begin
      rb_entries_7_result_isZero <= 1'h0;
    end else if (_T_164) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_isNaR <= 1'h0;
    end else if (_T_164) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_out <= 32'h0;
    end else if (_T_164) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_lt <= 1'h0;
    end else if (_T_164) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_eq <= 1'h0;
    end else if (_T_164) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_gt <= 1'h0;
    end else if (_T_164) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_exceptions <= 5'h0;
    end else if (_T_164) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h7 == io_request_bits_wr_addr[2:0]) begin
          rb_entries_7_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == io_request_bits_wr_addr[2:0]) begin
        rb_entries_7_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      value <= 3'h0;
    end else if (wbCountOn) begin
      value <= _T_35;
    end
    if (reset) begin
      reg_infetch_cacheline <= 8'h0;
    end else begin
      reg_infetch_cacheline <= _GEN_13737[7:0];
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
        if (_GEN_13844 & _T_11) begin
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
        if (_GEN_13846 & _T_11) begin
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
        if (_GEN_13848 & _T_11) begin
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
        if (_GEN_13850 & _T_11) begin
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
        if (_GEN_13852 & _T_11) begin
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
        if (_GEN_13854 & _T_11) begin
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
        if (_GEN_13856 & _T_11) begin
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
        if (_GEN_13858 & _T_11) begin
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
        if (_GEN_13860 & _T_11) begin
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
        if (_GEN_13862 & _T_11) begin
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
        if (_GEN_13864 & _T_11) begin
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
        if (_GEN_13866 & _T_11) begin
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
        if (_GEN_13868 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h4,8'h0); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13870 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h4,8'h1); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13872 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h4,8'h2); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13874 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h5,8'h0); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13876 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h5,8'h1); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13878 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h5,8'h2); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13880 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h6,8'h0); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13882 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h6,8'h1); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13884 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h6,8'h2); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13886 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h7,8'h0); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13888 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h7,8'h1); // @[POSIT_Locality.scala 143:55]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_13890 & _T_11) begin
          $fwrite(32'h80000002,"inst: %d, op: %d, mode cleared\n",8'h7,8'h2); // @[POSIT_Locality.scala 143:55]
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
          $fwrite(32'h80000002,"fetchoffset: %b, subfield: %b\n",_GEN_13683,_GEN_13683[13:3]); // @[POSIT_Locality.scala 189:23]
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
          $fwrite(32'h80000002,"filter: %b\n",_T_2566); // @[POSIT_Locality.scala 191:23]
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
          $fwrite(32'h80000002,"infetch: %b\n",_T_2668); // @[POSIT_Locality.scala 192:23]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2708 & _T_11) begin
          $fwrite(32'h80000002,"\t-mem_read:\n"); // @[POSIT_Locality.scala 226:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2708 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-req_valid: %b\n",io_mem_read_req_valid); // @[POSIT_Locality.scala 227:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2708 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-req_addr: %x\n",io_mem_read_req_addr); // @[POSIT_Locality.scala 228:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2708 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-resp_valid: %b\n",io_mem_read_resp_valid); // @[POSIT_Locality.scala 229:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2708 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-data: %x\n",io_mem_read_data); // @[POSIT_Locality.scala 230:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2708 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-resp_tag: %x\n",io_mem_read_resp_tag); // @[POSIT_Locality.scala 231:31]
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
          $fwrite(32'h80000002,"\t-mem_write:\n"); // @[POSIT_Locality.scala 234:31]
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
          $fwrite(32'h80000002,"\t\t-valid: %b\n",io_mem_write_valid); // @[POSIT_Locality.scala 235:31]
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
          $fwrite(32'h80000002,"\t\t-ready: %b\n",io_mem_write_ready); // @[POSIT_Locality.scala 236:31]
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
          $fwrite(32'h80000002,"\t\t-bits:\n"); // @[POSIT_Locality.scala 237:31]
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
          $fwrite(32'h80000002,"\t\t\t-wr_addr: %x\n",io_mem_write_bits_wr_addr); // @[POSIT_Locality.scala 238:31]
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
          $fwrite(32'h80000002,"\t\t\t-result: \n"); // @[POSIT_Locality.scala 239:31]
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
          $fwrite(32'h80000002,"\t\t\t\t-isZero: %b\n",io_mem_write_bits_result_isZero); // @[POSIT_Locality.scala 240:31]
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
          $fwrite(32'h80000002,"\t\t\t\t-isNaR: %b\n",io_mem_write_bits_result_isNaR); // @[POSIT_Locality.scala 241:31]
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
          $fwrite(32'h80000002,"\t\t\t\t-lt: %b\n",io_mem_write_bits_result_lt); // @[POSIT_Locality.scala 242:31]
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
          $fwrite(32'h80000002,"\t\t\t\t-eq: %b\n",io_mem_write_bits_result_eq); // @[POSIT_Locality.scala 243:31]
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
          $fwrite(32'h80000002,"\t\t\t\t-gt: %b\n",io_mem_write_bits_result_gt); // @[POSIT_Locality.scala 244:31]
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
          $fwrite(32'h80000002,"\t\t\t\t-exceptions: %x\n",io_mem_write_bits_result_exceptions); // @[POSIT_Locality.scala 245:31]
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
          $fwrite(32'h80000002,"\t\t\t\t-out: %b\n",io_mem_write_bits_result_out); // @[POSIT_Locality.scala 246:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"top level io:\n"); // @[POSIT_Locality.scala 250:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t-request:\n"); // @[POSIT_Locality.scala 251:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-valid: %b\n",io_request_valid); // @[POSIT_Locality.scala 252:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-ready: %b\n",io_request_ready); // @[POSIT_Locality.scala 253:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
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
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-inst: %x\n",io_request_bits_inst); // @[POSIT_Locality.scala 255:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-mode: %x\n",io_request_bits_mode); // @[POSIT_Locality.scala 256:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-wr_addr: %x\n",io_request_bits_wr_addr); // @[POSIT_Locality.scala 257:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-operand0:\n"); // @[POSIT_Locality.scala 259:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-value: %x\n",io_request_bits_operands_0_value); // @[POSIT_Locality.scala 260:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-mode: %x\n",io_request_bits_operands_0_mode); // @[POSIT_Locality.scala 261:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-operand1:\n"); // @[POSIT_Locality.scala 259:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-value: %x\n",io_request_bits_operands_1_value); // @[POSIT_Locality.scala 260:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-mode: %x\n",io_request_bits_operands_1_mode); // @[POSIT_Locality.scala 261:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t-operand2:\n"); // @[POSIT_Locality.scala 259:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-value: %x\n",io_request_bits_operands_2_value); // @[POSIT_Locality.scala 260:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t\t\t-mode: %x\n",io_request_bits_operands_2_mode); // @[POSIT_Locality.scala 261:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t-fetchArb:\n"); // @[POSIT_Locality.scala 264:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-validity:%b\n",fetchArb_io_validity); // @[POSIT_Locality.scala 265:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-priority:%x\n",fetchArb_io_priority); // @[POSIT_Locality.scala 266:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-chosen:%x\n",fetchArb_io_chosen); // @[POSIT_Locality.scala 267:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-hasChosen:%b\n",fetchArb_io_hasChosen); // @[POSIT_Locality.scala 268:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t-dispatchArb\n"); // @[POSIT_Locality.scala 270:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-validity:%b\n",dispatchArb_io_validity); // @[POSIT_Locality.scala 271:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-priority:%x\n",dispatchArb_io_priority); // @[POSIT_Locality.scala 272:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-chosen:%x\n",dispatchArb_io_chosen); // @[POSIT_Locality.scala 273:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t\t-hasChosen:%b\n",dispatchArb_io_hasChosen); // @[POSIT_Locality.scala 274:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"rb data: \n"); // @[POSIT_Locality.scala 276:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"idx | completed | valid | dispatched | writtern | wr_addr| inst | mode | num0 | mode0 | infetch0 | num1 | mode1 | infetch1 | num2 | mode2 | infetch2 | isZero | isNar | out | lt | eq | gt | exceptions\n"); // @[POSIT_Locality.scala 277:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",1'h0,rb_entries_0_completed,rb_entries_0_valid,rb_entries_0_dispatched,rb_entries_0_written,rb_entries_0_wr_addr,rb_entries_0_request_inst,rb_entries_0_request_mode,rb_entries_0_request_operands_0_value,rb_entries_0_request_operands_0_mode,rb_entries_0_request_inFetch_0,rb_entries_0_request_operands_1_value,rb_entries_0_request_operands_1_mode,rb_entries_0_request_inFetch_1,rb_entries_0_request_operands_2_value,rb_entries_0_request_operands_2_mode,rb_entries_0_request_inFetch_2,rb_entries_0_result_isZero,rb_entries_0_result_isNaR,rb_entries_0_result_out,rb_entries_0_result_lt,rb_entries_0_result_eq,rb_entries_0_result_gt,rb_entries_0_result_exceptions); // @[POSIT_Locality.scala 284:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",1'h1,rb_entries_1_completed,rb_entries_1_valid,rb_entries_1_dispatched,rb_entries_1_written,rb_entries_1_wr_addr,rb_entries_1_request_inst,rb_entries_1_request_mode,rb_entries_1_request_operands_0_value,rb_entries_1_request_operands_0_mode,rb_entries_1_request_inFetch_0,rb_entries_1_request_operands_1_value,rb_entries_1_request_operands_1_mode,rb_entries_1_request_inFetch_1,rb_entries_1_request_operands_2_value,rb_entries_1_request_operands_2_mode,rb_entries_1_request_inFetch_2,rb_entries_1_result_isZero,rb_entries_1_result_isNaR,rb_entries_1_result_out,rb_entries_1_result_lt,rb_entries_1_result_eq,rb_entries_1_result_gt,rb_entries_1_result_exceptions); // @[POSIT_Locality.scala 284:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",2'h2,rb_entries_2_completed,rb_entries_2_valid,rb_entries_2_dispatched,rb_entries_2_written,rb_entries_2_wr_addr,rb_entries_2_request_inst,rb_entries_2_request_mode,rb_entries_2_request_operands_0_value,rb_entries_2_request_operands_0_mode,rb_entries_2_request_inFetch_0,rb_entries_2_request_operands_1_value,rb_entries_2_request_operands_1_mode,rb_entries_2_request_inFetch_1,rb_entries_2_request_operands_2_value,rb_entries_2_request_operands_2_mode,rb_entries_2_request_inFetch_2,rb_entries_2_result_isZero,rb_entries_2_result_isNaR,rb_entries_2_result_out,rb_entries_2_result_lt,rb_entries_2_result_eq,rb_entries_2_result_gt,rb_entries_2_result_exceptions); // @[POSIT_Locality.scala 284:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",2'h3,rb_entries_3_completed,rb_entries_3_valid,rb_entries_3_dispatched,rb_entries_3_written,rb_entries_3_wr_addr,rb_entries_3_request_inst,rb_entries_3_request_mode,rb_entries_3_request_operands_0_value,rb_entries_3_request_operands_0_mode,rb_entries_3_request_inFetch_0,rb_entries_3_request_operands_1_value,rb_entries_3_request_operands_1_mode,rb_entries_3_request_inFetch_1,rb_entries_3_request_operands_2_value,rb_entries_3_request_operands_2_mode,rb_entries_3_request_inFetch_2,rb_entries_3_result_isZero,rb_entries_3_result_isNaR,rb_entries_3_result_out,rb_entries_3_result_lt,rb_entries_3_result_eq,rb_entries_3_result_gt,rb_entries_3_result_exceptions); // @[POSIT_Locality.scala 284:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",3'h4,rb_entries_4_completed,rb_entries_4_valid,rb_entries_4_dispatched,rb_entries_4_written,rb_entries_4_wr_addr,rb_entries_4_request_inst,rb_entries_4_request_mode,rb_entries_4_request_operands_0_value,rb_entries_4_request_operands_0_mode,rb_entries_4_request_inFetch_0,rb_entries_4_request_operands_1_value,rb_entries_4_request_operands_1_mode,rb_entries_4_request_inFetch_1,rb_entries_4_request_operands_2_value,rb_entries_4_request_operands_2_mode,rb_entries_4_request_inFetch_2,rb_entries_4_result_isZero,rb_entries_4_result_isNaR,rb_entries_4_result_out,rb_entries_4_result_lt,rb_entries_4_result_eq,rb_entries_4_result_gt,rb_entries_4_result_exceptions); // @[POSIT_Locality.scala 284:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",3'h5,rb_entries_5_completed,rb_entries_5_valid,rb_entries_5_dispatched,rb_entries_5_written,rb_entries_5_wr_addr,rb_entries_5_request_inst,rb_entries_5_request_mode,rb_entries_5_request_operands_0_value,rb_entries_5_request_operands_0_mode,rb_entries_5_request_inFetch_0,rb_entries_5_request_operands_1_value,rb_entries_5_request_operands_1_mode,rb_entries_5_request_inFetch_1,rb_entries_5_request_operands_2_value,rb_entries_5_request_operands_2_mode,rb_entries_5_request_inFetch_2,rb_entries_5_result_isZero,rb_entries_5_result_isNaR,rb_entries_5_result_out,rb_entries_5_result_lt,rb_entries_5_result_eq,rb_entries_5_result_gt,rb_entries_5_result_exceptions); // @[POSIT_Locality.scala 284:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",3'h6,rb_entries_6_completed,rb_entries_6_valid,rb_entries_6_dispatched,rb_entries_6_written,rb_entries_6_wr_addr,rb_entries_6_request_inst,rb_entries_6_request_mode,rb_entries_6_request_operands_0_value,rb_entries_6_request_operands_0_mode,rb_entries_6_request_inFetch_0,rb_entries_6_request_operands_1_value,rb_entries_6_request_operands_1_mode,rb_entries_6_request_inFetch_1,rb_entries_6_request_operands_2_value,rb_entries_6_request_operands_2_mode,rb_entries_6_request_inFetch_2,rb_entries_6_result_isZero,rb_entries_6_result_isNaR,rb_entries_6_result_out,rb_entries_6_result_lt,rb_entries_6_result_eq,rb_entries_6_result_gt,rb_entries_6_result_exceptions); // @[POSIT_Locality.scala 284:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",3'h7,rb_entries_7_completed,rb_entries_7_valid,rb_entries_7_dispatched,rb_entries_7_written,rb_entries_7_wr_addr,rb_entries_7_request_inst,rb_entries_7_request_mode,rb_entries_7_request_operands_0_value,rb_entries_7_request_operands_0_mode,rb_entries_7_request_inFetch_0,rb_entries_7_request_operands_1_value,rb_entries_7_request_operands_1_mode,rb_entries_7_request_inFetch_1,rb_entries_7_request_operands_2_value,rb_entries_7_request_operands_2_mode,rb_entries_7_request_inFetch_2,rb_entries_7_result_isZero,rb_entries_7_result_isNaR,rb_entries_7_result_out,rb_entries_7_result_lt,rb_entries_7_result_eq,rb_entries_7_result_gt,rb_entries_7_result_exceptions); // @[POSIT_Locality.scala 284:39]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"waiting to be fetched: %b, notinfetch:%b\n",_T_2563,_T_2869); // @[POSIT_Locality.scala 289:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"reg_infetch_cacheline:%b\n",reg_infetch_cacheline); // @[POSIT_Locality.scala 290:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"pe: \n"); // @[POSIT_Locality.scala 292:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"request: valid | ready | num 1 | num2 | num3 | inst | mode\n"); // @[POSIT_Locality.scala 296:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t %b | %b | %b | %b | %b | %x | %x\n",pe_io_request_valid,pe_io_request_ready,pe_io_request_bits_num1,pe_io_request_bits_num2,pe_io_request_bits_num3,pe_io_request_bits_inst,pe_io_request_bits_mode); // @[POSIT_Locality.scala 297:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"result: valid | ready | isZero | isNar | out | lt | eq | gt | exceptions\n"); // @[POSIT_Locality.scala 298:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_2749 & _T_11) begin
          $fwrite(32'h80000002,"\t %b | %b | %b | %b | %x | %b | %b | %b | %x\n",pe_io_result_valid,pe_io_result_ready,pe_io_result_bits_isZero,pe_io_result_bits_isNaR,pe_io_result_bits_out,pe_io_result_bits_lt,pe_io_result_bits_eq,pe_io_result_bits_gt,pe_io_result_bits_exceptions); // @[POSIT_Locality.scala 300:31]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
