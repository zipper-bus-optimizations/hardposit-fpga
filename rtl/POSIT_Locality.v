module PositAddCore(
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
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [8:0]  io_out_exponent,
  output [27:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR
);
  wire  _T = $signed(io_num1_exponent) > $signed(io_num2_exponent); // @[PositAdd.scala 24:20]
  wire  _T_1 = $signed(io_num1_exponent) == $signed(io_num2_exponent); // @[PositAdd.scala 25:21]
  wire  _T_2 = io_num1_fraction > io_num2_fraction; // @[PositAdd.scala 26:22]
  wire  _T_3 = _T_1 & _T_2; // @[PositAdd.scala 25:39]
  wire  num1magGt = _T | _T_3; // @[PositAdd.scala 24:37]
  wire  num2AdjSign = io_num2_sign ^ io_sub; // @[PositAdd.scala 27:31]
  wire  largeSign = num1magGt ? io_num1_sign : num2AdjSign; // @[PositAdd.scala 29:22]
  wire [8:0] largeExp = num1magGt ? $signed(io_num1_exponent) : $signed(io_num2_exponent); // @[PositAdd.scala 30:22]
  wire [27:0] _T_4 = num1magGt ? io_num1_fraction : io_num2_fraction; // @[PositAdd.scala 32:12]
  wire [30:0] largeFrac = {_T_4,3'h0}; // @[Cat.scala 30:58]
  wire  smallSign = num1magGt ? num2AdjSign : io_num1_sign; // @[PositAdd.scala 34:22]
  wire [8:0] smallExp = num1magGt ? $signed(io_num2_exponent) : $signed(io_num1_exponent); // @[PositAdd.scala 35:22]
  wire [27:0] _T_5 = num1magGt ? io_num2_fraction : io_num1_fraction; // @[PositAdd.scala 37:12]
  wire [30:0] smallFrac = {_T_5,3'h0}; // @[Cat.scala 30:58]
  wire [8:0] expDiff = $signed(largeExp) - $signed(smallExp); // @[PositAdd.scala 39:45]
  wire  _T_9 = expDiff < 9'h1f; // @[PositAdd.scala 41:17]
  wire [30:0] _T_10 = smallFrac >> expDiff; // @[PositAdd.scala 41:59]
  wire [30:0] shiftedSmallFrac = _T_9 ? _T_10 : 31'h0; // @[PositAdd.scala 41:8]
  wire  _T_19 = largeSign ^ smallSign; // @[PositAdd.scala 46:32]
  wire  isAddition = ~_T_19; // @[PositAdd.scala 46:20]
  wire [30:0] _T_20 = ~shiftedSmallFrac; // @[PositAdd.scala 48:39]
  wire [30:0] _T_22 = _T_20 + 31'h1; // @[PositAdd.scala 48:57]
  wire [30:0] signedSmallerFrac = isAddition ? shiftedSmallFrac : _T_22; // @[PositAdd.scala 48:8]
  wire [31:0] adderFrac = largeFrac + signedSmallerFrac; // @[PositAdd.scala 50:54]
  wire  sumOverflow = isAddition & adderFrac[31]; // @[PositAdd.scala 52:32]
  wire  _T_25 = isAddition & adderFrac[31]; // @[PositAdd.scala 54:50]
  wire [8:0] _GEN_1 = {9{_T_25}}; // @[PositAdd.scala 54:30]
  wire [8:0] adjAdderExp = $signed(largeExp) - $signed(_GEN_1); // @[PositAdd.scala 54:30]
  wire [30:0] adjAdderFrac = sumOverflow ? adderFrac[31:1] : adderFrac[30:0]; // @[PositAdd.scala 56:8]
  wire  sumStickyBit = sumOverflow & adderFrac[0]; // @[PositAdd.scala 57:34]
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
  wire [4:0] _T_91 = adjAdderFrac[30] ? 5'h0 : _T_90; // @[PositAdd.scala 61:62]
  wire [8:0] _GEN_2 = {{4{_T_91[4]}},_T_91}; // @[PositAdd.scala 61:34]
  wire [61:0] _GEN_3 = {{31'd0}, adjAdderFrac}; // @[PositAdd.scala 62:35]
  wire [61:0] normFraction = _GEN_3 << normalizationFactor; // @[PositAdd.scala 62:35]
  wire  _T_95 = io_num1_isZero & io_num2_isZero; // @[PositAdd.scala 65:35]
  wire  _T_96 = adderFrac == 32'h0; // @[PositAdd.scala 65:64]
  assign io_trailingBits = normFraction[2:1]; // @[PositAdd.scala 70:19]
  assign io_stickyBit = sumStickyBit | normFraction[0]; // @[PositAdd.scala 71:19]
  assign io_out_sign = num1magGt ? io_num1_sign : num2AdjSign; // @[PositAdd.scala 73:10]
  assign io_out_exponent = $signed(adjAdderExp) - $signed(_GEN_2); // @[PositAdd.scala 73:10]
  assign io_out_fraction = normFraction[30:3]; // @[PositAdd.scala 73:10]
  assign io_out_isZero = _T_95 | _T_96; // @[PositAdd.scala 73:10]
  assign io_out_isNaR = io_num1_isNaR | io_num2_isNaR; // @[PositAdd.scala 73:10]
endmodule
module PositCompare(
  input  [31:0] io_num1,
  input  [31:0] io_num2,
  output        io_lt,
  output        io_eq,
  output        io_gt
);
  wire  _T_2 = ~io_lt; // @[PositCompare.scala 16:13]
  wire  _T_3 = ~io_eq; // @[PositCompare.scala 16:23]
  assign io_lt = $signed(io_num1) < $signed(io_num2); // @[PositCompare.scala 14:9]
  assign io_eq = $signed(io_num1) == $signed(io_num2); // @[PositCompare.scala 15:9]
  assign io_gt = _T_2 & _T_3; // @[PositCompare.scala 16:9]
endmodule
module PositFMACore(
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
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [8:0]  io_out_exponent,
  output [27:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR
);
  wire  _T = io_num1_sign ^ io_num2_sign; // @[PositFMA.scala 24:31]
  wire  productSign = _T ^ io_negate; // @[PositFMA.scala 24:43]
  wire  _T_1 = io_num3_sign ^ io_negate; // @[PositFMA.scala 25:31]
  wire  addendSign = _T_1 ^ io_sub; // @[PositFMA.scala 25:43]
  wire [9:0] productExponent = $signed(io_num1_exponent) + $signed(io_num2_exponent); // @[PositFMA.scala 27:39]
  wire [55:0] productFraction = io_num1_fraction * io_num2_fraction; // @[PositFMA.scala 29:63]
  wire  prodOverflow = productFraction[55]; // @[PositFMA.scala 31:44]
  wire [54:0] normProductFraction = prodOverflow ? productFraction[55:1] : productFraction[54:0]; // @[PositFMA.scala 33:8]
  wire [1:0] _T_6 = {1'h0,prodOverflow}; // @[PositFMA.scala 34:76]
  wire [9:0] _GEN_0 = {{8{_T_6[1]}},_T_6}; // @[PositFMA.scala 34:45]
  wire [9:0] normProductExponent = $signed(productExponent) + $signed(_GEN_0); // @[PositFMA.scala 34:45]
  wire  prodStickyBit = prodOverflow & productFraction[0]; // @[PositFMA.scala 35:42]
  wire [54:0] _T_10 = {io_num3_fraction,27'h0}; // @[Cat.scala 30:58]
  wire [54:0] addendFraction = io_num3_isZero ? 55'h0 : _T_10; // @[PositFMA.scala 38:27]
  wire  _T_11 = ~io_num3_isZero; // @[PositFMA.scala 42:5]
  wire [9:0] _GEN_1 = {{1{io_num3_exponent[8]}},io_num3_exponent}; // @[PositFMA.scala 43:24]
  wire  _T_12 = $signed(_GEN_1) > $signed(normProductExponent); // @[PositFMA.scala 43:24]
  wire  _T_13 = $signed(_GEN_1) == $signed(normProductExponent); // @[PositFMA.scala 44:25]
  wire  _T_14 = addendFraction > normProductFraction; // @[PositFMA.scala 44:68]
  wire  _T_15 = _T_13 & _T_14; // @[PositFMA.scala 44:49]
  wire  _T_16 = _T_12 | _T_15; // @[PositFMA.scala 43:47]
  wire  isAddendGtProduct = _T_11 & _T_16; // @[PositFMA.scala 42:19]
  wire [9:0] gExp = isAddendGtProduct ? $signed({{1{io_num3_exponent[8]}},io_num3_exponent}) : $signed(normProductExponent); // @[PositFMA.scala 46:18]
  wire [54:0] gFrac = isAddendGtProduct ? addendFraction : normProductFraction; // @[PositFMA.scala 47:18]
  wire  gSign = isAddendGtProduct ? addendSign : productSign; // @[PositFMA.scala 48:18]
  wire [9:0] lExp = isAddendGtProduct ? $signed(normProductExponent) : $signed({{1{io_num3_exponent[8]}},io_num3_exponent}); // @[PositFMA.scala 50:18]
  wire [54:0] lFrac = isAddendGtProduct ? normProductFraction : addendFraction; // @[PositFMA.scala 51:18]
  wire  lSign = isAddendGtProduct ? productSign : addendSign; // @[PositFMA.scala 52:18]
  wire [9:0] expDiff = $signed(gExp) - $signed(lExp); // @[PositFMA.scala 54:37]
  wire  shftInBound = expDiff < 10'h37; // @[PositFMA.scala 55:29]
  wire [54:0] _T_20 = lFrac >> expDiff; // @[PositFMA.scala 57:28]
  wire [55:0] shiftedLFrac = shftInBound ? {{1'd0}, _T_20} : 56'h0; // @[PositFMA.scala 57:8]
  wire [1023:0] _T_21 = 1024'h1 << expDiff; // @[OneHot.scala 58:35]
  wire [1023:0] _T_23 = _T_21 - 1024'h1; // @[common.scala 23:44]
  wire [55:0] lfracStickyMask = _T_23[55:0]; // @[PositFMA.scala 59:26]
  wire [55:0] _GEN_3 = {{1'd0}, lFrac}; // @[PositFMA.scala 60:31]
  wire [55:0] _T_24 = _GEN_3 & lfracStickyMask; // @[PositFMA.scala 60:31]
  wire  lFracStickyBit = _T_24 != 56'h0; // @[PositFMA.scala 60:53]
  wire  _T_25 = gSign ^ lSign; // @[PositFMA.scala 62:28]
  wire  isAddition = ~_T_25; // @[PositFMA.scala 62:20]
  wire [55:0] _T_26 = ~shiftedLFrac; // @[PositFMA.scala 64:35]
  wire [55:0] _T_28 = _T_26 + 56'h1; // @[PositFMA.scala 64:49]
  wire [55:0] signedLFrac = isAddition ? shiftedLFrac : _T_28; // @[PositFMA.scala 64:8]
  wire [55:0] _GEN_4 = {{1'd0}, gFrac}; // @[PositFMA.scala 66:55]
  wire [56:0] _T_29 = _GEN_4 + signedLFrac; // @[PositFMA.scala 66:55]
  wire [55:0] fmaFraction = _T_29[55:0];
  wire  fmaOverflow = isAddition & fmaFraction[55]; // @[PositFMA.scala 68:32]
  wire [55:0] _T_32 = {fmaFraction[54:0],1'h0}; // @[Cat.scala 30:58]
  wire [55:0] adjFmaFraction = fmaOverflow ? fmaFraction : _T_32; // @[PositFMA.scala 70:8]
  wire [1:0] _T_34 = {1'h0,fmaOverflow}; // @[PositFMA.scala 71:59]
  wire [9:0] _GEN_5 = {{8{_T_34[1]}},_T_34}; // @[PositFMA.scala 71:29]
  wire [9:0] adjFmaExponent = $signed(gExp) + $signed(_GEN_5); // @[PositFMA.scala 71:29]
  wire [5:0] _T_93 = adjFmaFraction[1] ? 6'h36 : 6'h37; // @[Mux.scala 47:69]
  wire [5:0] _T_94 = adjFmaFraction[2] ? 6'h35 : _T_93; // @[Mux.scala 47:69]
  wire [5:0] _T_95 = adjFmaFraction[3] ? 6'h34 : _T_94; // @[Mux.scala 47:69]
  wire [5:0] _T_96 = adjFmaFraction[4] ? 6'h33 : _T_95; // @[Mux.scala 47:69]
  wire [5:0] _T_97 = adjFmaFraction[5] ? 6'h32 : _T_96; // @[Mux.scala 47:69]
  wire [5:0] _T_98 = adjFmaFraction[6] ? 6'h31 : _T_97; // @[Mux.scala 47:69]
  wire [5:0] _T_99 = adjFmaFraction[7] ? 6'h30 : _T_98; // @[Mux.scala 47:69]
  wire [5:0] _T_100 = adjFmaFraction[8] ? 6'h2f : _T_99; // @[Mux.scala 47:69]
  wire [5:0] _T_101 = adjFmaFraction[9] ? 6'h2e : _T_100; // @[Mux.scala 47:69]
  wire [5:0] _T_102 = adjFmaFraction[10] ? 6'h2d : _T_101; // @[Mux.scala 47:69]
  wire [5:0] _T_103 = adjFmaFraction[11] ? 6'h2c : _T_102; // @[Mux.scala 47:69]
  wire [5:0] _T_104 = adjFmaFraction[12] ? 6'h2b : _T_103; // @[Mux.scala 47:69]
  wire [5:0] _T_105 = adjFmaFraction[13] ? 6'h2a : _T_104; // @[Mux.scala 47:69]
  wire [5:0] _T_106 = adjFmaFraction[14] ? 6'h29 : _T_105; // @[Mux.scala 47:69]
  wire [5:0] _T_107 = adjFmaFraction[15] ? 6'h28 : _T_106; // @[Mux.scala 47:69]
  wire [5:0] _T_108 = adjFmaFraction[16] ? 6'h27 : _T_107; // @[Mux.scala 47:69]
  wire [5:0] _T_109 = adjFmaFraction[17] ? 6'h26 : _T_108; // @[Mux.scala 47:69]
  wire [5:0] _T_110 = adjFmaFraction[18] ? 6'h25 : _T_109; // @[Mux.scala 47:69]
  wire [5:0] _T_111 = adjFmaFraction[19] ? 6'h24 : _T_110; // @[Mux.scala 47:69]
  wire [5:0] _T_112 = adjFmaFraction[20] ? 6'h23 : _T_111; // @[Mux.scala 47:69]
  wire [5:0] _T_113 = adjFmaFraction[21] ? 6'h22 : _T_112; // @[Mux.scala 47:69]
  wire [5:0] _T_114 = adjFmaFraction[22] ? 6'h21 : _T_113; // @[Mux.scala 47:69]
  wire [5:0] _T_115 = adjFmaFraction[23] ? 6'h20 : _T_114; // @[Mux.scala 47:69]
  wire [5:0] _T_116 = adjFmaFraction[24] ? 6'h1f : _T_115; // @[Mux.scala 47:69]
  wire [5:0] _T_117 = adjFmaFraction[25] ? 6'h1e : _T_116; // @[Mux.scala 47:69]
  wire [5:0] _T_118 = adjFmaFraction[26] ? 6'h1d : _T_117; // @[Mux.scala 47:69]
  wire [5:0] _T_119 = adjFmaFraction[27] ? 6'h1c : _T_118; // @[Mux.scala 47:69]
  wire [5:0] _T_120 = adjFmaFraction[28] ? 6'h1b : _T_119; // @[Mux.scala 47:69]
  wire [5:0] _T_121 = adjFmaFraction[29] ? 6'h1a : _T_120; // @[Mux.scala 47:69]
  wire [5:0] _T_122 = adjFmaFraction[30] ? 6'h19 : _T_121; // @[Mux.scala 47:69]
  wire [5:0] _T_123 = adjFmaFraction[31] ? 6'h18 : _T_122; // @[Mux.scala 47:69]
  wire [5:0] _T_124 = adjFmaFraction[32] ? 6'h17 : _T_123; // @[Mux.scala 47:69]
  wire [5:0] _T_125 = adjFmaFraction[33] ? 6'h16 : _T_124; // @[Mux.scala 47:69]
  wire [5:0] _T_126 = adjFmaFraction[34] ? 6'h15 : _T_125; // @[Mux.scala 47:69]
  wire [5:0] _T_127 = adjFmaFraction[35] ? 6'h14 : _T_126; // @[Mux.scala 47:69]
  wire [5:0] _T_128 = adjFmaFraction[36] ? 6'h13 : _T_127; // @[Mux.scala 47:69]
  wire [5:0] _T_129 = adjFmaFraction[37] ? 6'h12 : _T_128; // @[Mux.scala 47:69]
  wire [5:0] _T_130 = adjFmaFraction[38] ? 6'h11 : _T_129; // @[Mux.scala 47:69]
  wire [5:0] _T_131 = adjFmaFraction[39] ? 6'h10 : _T_130; // @[Mux.scala 47:69]
  wire [5:0] _T_132 = adjFmaFraction[40] ? 6'hf : _T_131; // @[Mux.scala 47:69]
  wire [5:0] _T_133 = adjFmaFraction[41] ? 6'he : _T_132; // @[Mux.scala 47:69]
  wire [5:0] _T_134 = adjFmaFraction[42] ? 6'hd : _T_133; // @[Mux.scala 47:69]
  wire [5:0] _T_135 = adjFmaFraction[43] ? 6'hc : _T_134; // @[Mux.scala 47:69]
  wire [5:0] _T_136 = adjFmaFraction[44] ? 6'hb : _T_135; // @[Mux.scala 47:69]
  wire [5:0] _T_137 = adjFmaFraction[45] ? 6'ha : _T_136; // @[Mux.scala 47:69]
  wire [5:0] _T_138 = adjFmaFraction[46] ? 6'h9 : _T_137; // @[Mux.scala 47:69]
  wire [5:0] _T_139 = adjFmaFraction[47] ? 6'h8 : _T_138; // @[Mux.scala 47:69]
  wire [5:0] _T_140 = adjFmaFraction[48] ? 6'h7 : _T_139; // @[Mux.scala 47:69]
  wire [5:0] _T_141 = adjFmaFraction[49] ? 6'h6 : _T_140; // @[Mux.scala 47:69]
  wire [5:0] _T_142 = adjFmaFraction[50] ? 6'h5 : _T_141; // @[Mux.scala 47:69]
  wire [5:0] _T_143 = adjFmaFraction[51] ? 6'h4 : _T_142; // @[Mux.scala 47:69]
  wire [5:0] _T_144 = adjFmaFraction[52] ? 6'h3 : _T_143; // @[Mux.scala 47:69]
  wire [5:0] _T_145 = adjFmaFraction[53] ? 6'h2 : _T_144; // @[Mux.scala 47:69]
  wire [5:0] _T_146 = adjFmaFraction[54] ? 6'h1 : _T_145; // @[Mux.scala 47:69]
  wire [5:0] normalizationFactor = adjFmaFraction[55] ? 6'h0 : _T_146; // @[Mux.scala 47:69]
  wire [5:0] _T_147 = adjFmaFraction[55] ? 6'h0 : _T_146; // @[PositFMA.scala 74:69]
  wire [9:0] _GEN_6 = {{4{_T_147[5]}},_T_147}; // @[PositFMA.scala 74:40]
  wire [10:0] normFmaExponent = $signed(adjFmaExponent) - $signed(_GEN_6); // @[PositFMA.scala 74:40]
  wire [118:0] _GEN_7 = {{63'd0}, adjFmaFraction}; // @[PositFMA.scala 75:41]
  wire [118:0] _T_148 = _GEN_7 << normalizationFactor; // @[PositFMA.scala 75:41]
  wire [55:0] normFmaFraction = _T_148[55:0]; // @[PositFMA.scala 75:64]
  wire  _T_149 = io_num1_isNaR | io_num2_isNaR; // @[PositFMA.scala 78:33]
  wire  result_isNaR = _T_149 | io_num3_isNaR; // @[PositFMA.scala 78:46]
  wire  _T_151 = ~result_isNaR; // @[PositFMA.scala 79:22]
  wire  _T_152 = io_num1_isZero | io_num2_isZero; // @[PositFMA.scala 79:52]
  wire  _T_153 = _T_152 & io_num3_isZero; // @[PositFMA.scala 79:67]
  wire  _T_157 = prodStickyBit | lFracStickyBit; // @[PositFMA.scala 85:36]
  wire  _T_159 = normFmaFraction[25:0] != 26'h0; // @[PositFMA.scala 85:130]
  assign io_trailingBits = normFmaFraction[27:26]; // @[PositFMA.scala 84:19]
  assign io_stickyBit = _T_157 | _T_159; // @[PositFMA.scala 85:19]
  assign io_out_sign = isAddendGtProduct ? addendSign : productSign; // @[PositFMA.scala 87:10]
  assign io_out_exponent = normFmaExponent[8:0]; // @[PositFMA.scala 87:10]
  assign io_out_fraction = normFmaFraction[55:28]; // @[PositFMA.scala 87:10]
  assign io_out_isZero = _T_151 & _T_153; // @[PositFMA.scala 87:10]
  assign io_out_isNaR = _T_149 | io_num3_isNaR; // @[PositFMA.scala 87:10]
endmodule
module PositDivSqrtCore(
  input         clock,
  input         reset,
  input         io_validIn,
  output        io_readyIn,
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
  assign io_readyIn = cycleCount <= 6'h1; // @[PositDivSqrt.scala 64:14]
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
  output        io_out_isNaR
);
  wire [8:0] prodExp = $signed(io_num1_exponent) + $signed(io_num2_exponent); // @[PositMul.scala 19:31]
  wire [55:0] prodFrac = io_num1_fraction * io_num2_fraction; // @[PositMul.scala 21:63]
  wire  prodOverflow = prodFrac[55]; // @[PositMul.scala 22:30]
  wire  _T_3 = ~prodOverflow; // @[PositMul.scala 24:39]
  wire [56:0] _GEN_0 = {{1'd0}, prodFrac}; // @[PositMul.scala 24:35]
  wire [56:0] normProductFrac = _GEN_0 << _T_3; // @[PositMul.scala 24:35]
  wire [1:0] _T_4 = prodOverflow ? $signed(2'sh1) : $signed(2'sh0); // @[PositMul.scala 25:38]
  wire [8:0] _GEN_1 = {{7{_T_4[1]}},_T_4}; // @[PositMul.scala 25:33]
  assign io_trailingBits = normProductFrac[27:26]; // @[PositMul.scala 34:19]
  assign io_stickyBit = normProductFrac[25:0] != 26'h0; // @[PositMul.scala 35:19]
  assign io_out_sign = io_num1_sign ^ io_num2_sign; // @[PositMul.scala 37:10]
  assign io_out_exponent = $signed(prodExp) + $signed(_GEN_1); // @[PositMul.scala 37:10]
  assign io_out_fraction = normProductFrac[55:28]; // @[PositMul.scala 37:10]
  assign io_out_isZero = io_num1_isZero | io_num2_isZero; // @[PositMul.scala 37:10]
  assign io_out_isNaR = io_num1_isNaR | io_num2_isNaR; // @[PositMul.scala 37:10]
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
  output [4:0]  io_result_bits_exceptions
);
  wire  positAddCore_io_num1_sign; // @[POSIT.scala 43:34]
  wire [8:0] positAddCore_io_num1_exponent; // @[POSIT.scala 43:34]
  wire [27:0] positAddCore_io_num1_fraction; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num1_isZero; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num1_isNaR; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num2_sign; // @[POSIT.scala 43:34]
  wire [8:0] positAddCore_io_num2_exponent; // @[POSIT.scala 43:34]
  wire [27:0] positAddCore_io_num2_fraction; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num2_isZero; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num2_isNaR; // @[POSIT.scala 43:34]
  wire  positAddCore_io_sub; // @[POSIT.scala 43:34]
  wire [1:0] positAddCore_io_trailingBits; // @[POSIT.scala 43:34]
  wire  positAddCore_io_stickyBit; // @[POSIT.scala 43:34]
  wire  positAddCore_io_out_sign; // @[POSIT.scala 43:34]
  wire [8:0] positAddCore_io_out_exponent; // @[POSIT.scala 43:34]
  wire [27:0] positAddCore_io_out_fraction; // @[POSIT.scala 43:34]
  wire  positAddCore_io_out_isZero; // @[POSIT.scala 43:34]
  wire  positAddCore_io_out_isNaR; // @[POSIT.scala 43:34]
  wire [31:0] positCompare_io_num1; // @[POSIT.scala 44:34]
  wire [31:0] positCompare_io_num2; // @[POSIT.scala 44:34]
  wire  positCompare_io_lt; // @[POSIT.scala 44:34]
  wire  positCompare_io_eq; // @[POSIT.scala 44:34]
  wire  positCompare_io_gt; // @[POSIT.scala 44:34]
  wire  positFMACore_io_num1_sign; // @[POSIT.scala 45:34]
  wire [8:0] positFMACore_io_num1_exponent; // @[POSIT.scala 45:34]
  wire [27:0] positFMACore_io_num1_fraction; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num1_isZero; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num1_isNaR; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num2_sign; // @[POSIT.scala 45:34]
  wire [8:0] positFMACore_io_num2_exponent; // @[POSIT.scala 45:34]
  wire [27:0] positFMACore_io_num2_fraction; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num2_isZero; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num2_isNaR; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num3_sign; // @[POSIT.scala 45:34]
  wire [8:0] positFMACore_io_num3_exponent; // @[POSIT.scala 45:34]
  wire [27:0] positFMACore_io_num3_fraction; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num3_isZero; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num3_isNaR; // @[POSIT.scala 45:34]
  wire  positFMACore_io_sub; // @[POSIT.scala 45:34]
  wire  positFMACore_io_negate; // @[POSIT.scala 45:34]
  wire [1:0] positFMACore_io_trailingBits; // @[POSIT.scala 45:34]
  wire  positFMACore_io_stickyBit; // @[POSIT.scala 45:34]
  wire  positFMACore_io_out_sign; // @[POSIT.scala 45:34]
  wire [8:0] positFMACore_io_out_exponent; // @[POSIT.scala 45:34]
  wire [27:0] positFMACore_io_out_fraction; // @[POSIT.scala 45:34]
  wire  positFMACore_io_out_isZero; // @[POSIT.scala 45:34]
  wire  positFMACore_io_out_isNaR; // @[POSIT.scala 45:34]
  wire  positDivSqrtCore_clock; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_reset; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_validIn; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_readyIn; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_sqrtOp; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num1_sign; // @[POSIT.scala 46:38]
  wire [8:0] positDivSqrtCore_io_num1_exponent; // @[POSIT.scala 46:38]
  wire [27:0] positDivSqrtCore_io_num1_fraction; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num1_isZero; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num1_isNaR; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num2_sign; // @[POSIT.scala 46:38]
  wire [8:0] positDivSqrtCore_io_num2_exponent; // @[POSIT.scala 46:38]
  wire [27:0] positDivSqrtCore_io_num2_fraction; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num2_isZero; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num2_isNaR; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_validOut_div; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_validOut_sqrt; // @[POSIT.scala 46:38]
  wire [4:0] positDivSqrtCore_io_exceptions; // @[POSIT.scala 46:38]
  wire [1:0] positDivSqrtCore_io_trailingBits; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_stickyBit; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_out_sign; // @[POSIT.scala 46:38]
  wire [8:0] positDivSqrtCore_io_out_exponent; // @[POSIT.scala 46:38]
  wire [27:0] positDivSqrtCore_io_out_fraction; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_out_isZero; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_out_isNaR; // @[POSIT.scala 46:38]
  wire  positMulCore_io_num1_sign; // @[POSIT.scala 47:34]
  wire [8:0] positMulCore_io_num1_exponent; // @[POSIT.scala 47:34]
  wire [27:0] positMulCore_io_num1_fraction; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num1_isZero; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num1_isNaR; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num2_sign; // @[POSIT.scala 47:34]
  wire [8:0] positMulCore_io_num2_exponent; // @[POSIT.scala 47:34]
  wire [27:0] positMulCore_io_num2_fraction; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num2_isZero; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num2_isNaR; // @[POSIT.scala 47:34]
  wire [1:0] positMulCore_io_trailingBits; // @[POSIT.scala 47:34]
  wire  positMulCore_io_stickyBit; // @[POSIT.scala 47:34]
  wire  positMulCore_io_out_sign; // @[POSIT.scala 47:34]
  wire [8:0] positMulCore_io_out_exponent; // @[POSIT.scala 47:34]
  wire [27:0] positMulCore_io_out_fraction; // @[POSIT.scala 47:34]
  wire  positMulCore_io_out_isZero; // @[POSIT.scala 47:34]
  wire  positMulCore_io_out_isNaR; // @[POSIT.scala 47:34]
  wire [31:0] num1Extractor_io_in; // @[POSIT.scala 66:35]
  wire  num1Extractor_io_out_sign; // @[POSIT.scala 66:35]
  wire [8:0] num1Extractor_io_out_exponent; // @[POSIT.scala 66:35]
  wire [27:0] num1Extractor_io_out_fraction; // @[POSIT.scala 66:35]
  wire  num1Extractor_io_out_isZero; // @[POSIT.scala 66:35]
  wire  num1Extractor_io_out_isNaR; // @[POSIT.scala 66:35]
  wire [31:0] num2Extractor_io_in; // @[POSIT.scala 67:35]
  wire  num2Extractor_io_out_sign; // @[POSIT.scala 67:35]
  wire [8:0] num2Extractor_io_out_exponent; // @[POSIT.scala 67:35]
  wire [27:0] num2Extractor_io_out_fraction; // @[POSIT.scala 67:35]
  wire  num2Extractor_io_out_isZero; // @[POSIT.scala 67:35]
  wire  num2Extractor_io_out_isNaR; // @[POSIT.scala 67:35]
  wire [31:0] num3Extractor_io_in; // @[POSIT.scala 68:35]
  wire  num3Extractor_io_out_sign; // @[POSIT.scala 68:35]
  wire [8:0] num3Extractor_io_out_exponent; // @[POSIT.scala 68:35]
  wire [27:0] num3Extractor_io_out_fraction; // @[POSIT.scala 68:35]
  wire  num3Extractor_io_out_isZero; // @[POSIT.scala 68:35]
  wire  num3Extractor_io_out_isNaR; // @[POSIT.scala 68:35]
  wire  positGenerator_io_in_sign; // @[POSIT.scala 162:36]
  wire [8:0] positGenerator_io_in_exponent; // @[POSIT.scala 162:36]
  wire [27:0] positGenerator_io_in_fraction; // @[POSIT.scala 162:36]
  wire  positGenerator_io_in_isZero; // @[POSIT.scala 162:36]
  wire  positGenerator_io_in_isNaR; // @[POSIT.scala 162:36]
  wire [1:0] positGenerator_io_trailingBits; // @[POSIT.scala 162:36]
  wire  positGenerator_io_stickyBit; // @[POSIT.scala 162:36]
  wire [31:0] positGenerator_io_out; // @[POSIT.scala 162:36]
  wire  _T = io_result_ready & positDivSqrtCore_io_readyIn; // @[POSIT.scala 49:45]
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
  reg  exec_num1_sign; // @[POSIT.scala 73:32]
  reg [31:0] _RAND_6;
  reg [8:0] exec_num1_exponent; // @[POSIT.scala 73:32]
  reg [31:0] _RAND_7;
  reg [27:0] exec_num1_fraction; // @[POSIT.scala 73:32]
  reg [31:0] _RAND_8;
  reg  exec_num1_isZero; // @[POSIT.scala 73:32]
  reg [31:0] _RAND_9;
  reg  exec_num1_isNaR; // @[POSIT.scala 73:32]
  reg [31:0] _RAND_10;
  reg  exec_num2_sign; // @[POSIT.scala 74:32]
  reg [31:0] _RAND_11;
  reg [8:0] exec_num2_exponent; // @[POSIT.scala 74:32]
  reg [31:0] _RAND_12;
  reg [27:0] exec_num2_fraction; // @[POSIT.scala 74:32]
  reg [31:0] _RAND_13;
  reg  exec_num2_isZero; // @[POSIT.scala 74:32]
  reg [31:0] _RAND_14;
  reg  exec_num2_isNaR; // @[POSIT.scala 74:32]
  reg [31:0] _RAND_15;
  reg  exec_num3_sign; // @[POSIT.scala 75:32]
  reg [31:0] _RAND_16;
  reg [8:0] exec_num3_exponent; // @[POSIT.scala 75:32]
  reg [31:0] _RAND_17;
  reg [27:0] exec_num3_fraction; // @[POSIT.scala 75:32]
  reg [31:0] _RAND_18;
  reg  exec_num3_isZero; // @[POSIT.scala 75:32]
  reg [31:0] _RAND_19;
  reg  exec_num3_isNaR; // @[POSIT.scala 75:32]
  reg [31:0] _RAND_20;
  reg [31:0] comp_num1; // @[POSIT.scala 76:32]
  reg [31:0] _RAND_21;
  reg [31:0] comp_num2; // @[POSIT.scala 77:32]
  reg [31:0] _RAND_22;
  reg [2:0] exec_inst; // @[POSIT.scala 79:32]
  reg [31:0] _RAND_23;
  reg [1:0] exec_mode; // @[POSIT.scala 80:32]
  reg [31:0] _RAND_24;
  reg  exec_valid; // @[POSIT.scala 81:33]
  reg [31:0] _RAND_25;
  wire  _T_15 = exec_inst == 3'h5; // @[POSIT.scala 116:64]
  reg  result_out_sign; // @[POSIT.scala 121:33]
  reg [31:0] _RAND_26;
  reg [8:0] result_out_exponent; // @[POSIT.scala 121:33]
  reg [31:0] _RAND_27;
  reg [27:0] result_out_fraction; // @[POSIT.scala 121:33]
  reg [31:0] _RAND_28;
  reg  result_out_isZero; // @[POSIT.scala 121:33]
  reg [31:0] _RAND_29;
  reg  result_out_isNaR; // @[POSIT.scala 121:33]
  reg [31:0] _RAND_30;
  reg  result_stickyBit; // @[POSIT.scala 122:39]
  reg [31:0] _RAND_31;
  reg [1:0] result_trailingBits; // @[POSIT.scala 123:42]
  reg [31:0] _RAND_32;
  reg  result_valid; // @[POSIT.scala 124:35]
  reg [31:0] _RAND_33;
  reg  result_lt; // @[POSIT.scala 125:32]
  reg [31:0] _RAND_34;
  reg  result_eq; // @[POSIT.scala 126:32]
  reg [31:0] _RAND_35;
  reg  result_gt; // @[POSIT.scala 127:32]
  reg [31:0] _RAND_36;
  wire  _T_20 = 3'h5 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_21_sign = _T_20 & positDivSqrtCore_io_out_sign; // @[Mux.scala 68:16]
  wire  _T_21_isZero = _T_20 & positDivSqrtCore_io_out_isZero; // @[Mux.scala 68:16]
  wire  _T_21_isNaR = _T_20 & positDivSqrtCore_io_out_isNaR; // @[Mux.scala 68:16]
  wire  _T_22 = 3'h4 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_24 = 3'h3 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_26 = 3'h1 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_29 = _T_20 & positDivSqrtCore_io_stickyBit; // @[Mux.scala 68:16]
  wire  _T_44 = exec_inst != 3'h5; // @[POSIT.scala 157:59]
  wire  _T_45 = exec_valid & _T_44; // @[POSIT.scala 157:45]
  wire  _T_46 = _T_45 | positDivSqrtCore_io_validOut_div; // @[POSIT.scala 157:85]
  wire  _T_47 = _T_46 | positDivSqrtCore_io_validOut_sqrt; // @[POSIT.scala 158:58]
  wire  _T_48 = positGenerator_io_out != 32'h0; // @[common.scala 61:41]
  wire  _T_49 = ~_T_48; // @[common.scala 61:33]
  wire  _T_53 = positGenerator_io_out[30:0] != 31'h0; // @[common.scala 27:71]
  wire  _T_54 = ~_T_53; // @[common.scala 27:53]
  wire  _T_55 = positGenerator_io_out[31] & _T_54; // @[common.scala 27:51]
  PositAddCore positAddCore ( // @[POSIT.scala 43:34]
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
    .io_trailingBits(positAddCore_io_trailingBits),
    .io_stickyBit(positAddCore_io_stickyBit),
    .io_out_sign(positAddCore_io_out_sign),
    .io_out_exponent(positAddCore_io_out_exponent),
    .io_out_fraction(positAddCore_io_out_fraction),
    .io_out_isZero(positAddCore_io_out_isZero),
    .io_out_isNaR(positAddCore_io_out_isNaR)
  );
  PositCompare positCompare ( // @[POSIT.scala 44:34]
    .io_num1(positCompare_io_num1),
    .io_num2(positCompare_io_num2),
    .io_lt(positCompare_io_lt),
    .io_eq(positCompare_io_eq),
    .io_gt(positCompare_io_gt)
  );
  PositFMACore positFMACore ( // @[POSIT.scala 45:34]
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
    .io_trailingBits(positFMACore_io_trailingBits),
    .io_stickyBit(positFMACore_io_stickyBit),
    .io_out_sign(positFMACore_io_out_sign),
    .io_out_exponent(positFMACore_io_out_exponent),
    .io_out_fraction(positFMACore_io_out_fraction),
    .io_out_isZero(positFMACore_io_out_isZero),
    .io_out_isNaR(positFMACore_io_out_isNaR)
  );
  PositDivSqrtCore positDivSqrtCore ( // @[POSIT.scala 46:38]
    .clock(positDivSqrtCore_clock),
    .reset(positDivSqrtCore_reset),
    .io_validIn(positDivSqrtCore_io_validIn),
    .io_readyIn(positDivSqrtCore_io_readyIn),
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
  PositMulCore positMulCore ( // @[POSIT.scala 47:34]
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
    .io_out_isNaR(positMulCore_io_out_isNaR)
  );
  PositExtractor num1Extractor ( // @[POSIT.scala 66:35]
    .io_in(num1Extractor_io_in),
    .io_out_sign(num1Extractor_io_out_sign),
    .io_out_exponent(num1Extractor_io_out_exponent),
    .io_out_fraction(num1Extractor_io_out_fraction),
    .io_out_isZero(num1Extractor_io_out_isZero),
    .io_out_isNaR(num1Extractor_io_out_isNaR)
  );
  PositExtractor num2Extractor ( // @[POSIT.scala 67:35]
    .io_in(num2Extractor_io_in),
    .io_out_sign(num2Extractor_io_out_sign),
    .io_out_exponent(num2Extractor_io_out_exponent),
    .io_out_fraction(num2Extractor_io_out_fraction),
    .io_out_isZero(num2Extractor_io_out_isZero),
    .io_out_isNaR(num2Extractor_io_out_isNaR)
  );
  PositExtractor num3Extractor ( // @[POSIT.scala 68:35]
    .io_in(num3Extractor_io_in),
    .io_out_sign(num3Extractor_io_out_sign),
    .io_out_exponent(num3Extractor_io_out_exponent),
    .io_out_fraction(num3Extractor_io_out_fraction),
    .io_out_isZero(num3Extractor_io_out_isZero),
    .io_out_isNaR(num3Extractor_io_out_isNaR)
  );
  PositGenerator positGenerator ( // @[POSIT.scala 162:36]
    .io_in_sign(positGenerator_io_in_sign),
    .io_in_exponent(positGenerator_io_in_exponent),
    .io_in_fraction(positGenerator_io_in_fraction),
    .io_in_isZero(positGenerator_io_in_isZero),
    .io_in_isNaR(positGenerator_io_in_isNaR),
    .io_trailingBits(positGenerator_io_trailingBits),
    .io_stickyBit(positGenerator_io_stickyBit),
    .io_out(positGenerator_io_out)
  );
  assign io_request_ready = io_result_ready & positDivSqrtCore_io_readyIn; // @[POSIT.scala 49:26]
  assign io_result_valid = result_valid; // @[POSIT.scala 175:25]
  assign io_result_bits_isZero = result_out_isZero | _T_49; // @[POSIT.scala 167:31]
  assign io_result_bits_isNaR = result_out_isNaR | _T_55; // @[POSIT.scala 168:31]
  assign io_result_bits_out = positGenerator_io_out; // @[POSIT.scala 169:31]
  assign io_result_bits_lt = result_lt; // @[POSIT.scala 170:27]
  assign io_result_bits_eq = result_eq; // @[POSIT.scala 171:27]
  assign io_result_bits_gt = result_gt; // @[POSIT.scala 172:27]
  assign io_result_bits_exceptions = positDivSqrtCore_io_exceptions; // @[POSIT.scala 173:35]
  assign positAddCore_io_num1_sign = exec_num1_sign; // @[POSIT.scala 100:30]
  assign positAddCore_io_num1_exponent = exec_num1_exponent; // @[POSIT.scala 100:30]
  assign positAddCore_io_num1_fraction = exec_num1_fraction; // @[POSIT.scala 100:30]
  assign positAddCore_io_num1_isZero = exec_num1_isZero; // @[POSIT.scala 100:30]
  assign positAddCore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 100:30]
  assign positAddCore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 101:30]
  assign positAddCore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 101:30]
  assign positAddCore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 101:30]
  assign positAddCore_io_num2_isZero = exec_num2_isZero; // @[POSIT.scala 101:30]
  assign positAddCore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 101:30]
  assign positAddCore_io_sub = exec_mode[0]; // @[POSIT.scala 102:29]
  assign positCompare_io_num1 = comp_num1; // @[POSIT.scala 104:30]
  assign positCompare_io_num2 = comp_num2; // @[POSIT.scala 105:30]
  assign positFMACore_io_num1_sign = exec_num1_sign; // @[POSIT.scala 107:30]
  assign positFMACore_io_num1_exponent = exec_num1_exponent; // @[POSIT.scala 107:30]
  assign positFMACore_io_num1_fraction = exec_num1_fraction; // @[POSIT.scala 107:30]
  assign positFMACore_io_num1_isZero = exec_num1_isZero; // @[POSIT.scala 107:30]
  assign positFMACore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 107:30]
  assign positFMACore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 108:30]
  assign positFMACore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 108:30]
  assign positFMACore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 108:30]
  assign positFMACore_io_num2_isZero = exec_num2_isZero; // @[POSIT.scala 108:30]
  assign positFMACore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 108:30]
  assign positFMACore_io_num3_sign = exec_num3_sign; // @[POSIT.scala 109:30]
  assign positFMACore_io_num3_exponent = exec_num3_exponent; // @[POSIT.scala 109:30]
  assign positFMACore_io_num3_fraction = exec_num3_fraction; // @[POSIT.scala 109:30]
  assign positFMACore_io_num3_isZero = exec_num3_isZero; // @[POSIT.scala 109:30]
  assign positFMACore_io_num3_isNaR = exec_num3_isNaR; // @[POSIT.scala 109:30]
  assign positFMACore_io_sub = exec_mode[0]; // @[POSIT.scala 110:29]
  assign positFMACore_io_negate = exec_mode[1]; // @[POSIT.scala 111:32]
  assign positDivSqrtCore_clock = clock;
  assign positDivSqrtCore_reset = reset;
  assign positDivSqrtCore_io_validIn = exec_valid & _T_15; // @[POSIT.scala 116:37]
  assign positDivSqrtCore_io_sqrtOp = exec_mode[0]; // @[POSIT.scala 115:36]
  assign positDivSqrtCore_io_num1_sign = exec_num1_sign; // @[POSIT.scala 113:34]
  assign positDivSqrtCore_io_num1_exponent = exec_num1_exponent; // @[POSIT.scala 113:34]
  assign positDivSqrtCore_io_num1_fraction = exec_num1_fraction; // @[POSIT.scala 113:34]
  assign positDivSqrtCore_io_num1_isZero = exec_num1_isZero; // @[POSIT.scala 113:34]
  assign positDivSqrtCore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 113:34]
  assign positDivSqrtCore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 114:34]
  assign positDivSqrtCore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 114:34]
  assign positDivSqrtCore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 114:34]
  assign positDivSqrtCore_io_num2_isZero = exec_num2_isZero; // @[POSIT.scala 114:34]
  assign positDivSqrtCore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 114:34]
  assign positMulCore_io_num1_sign = exec_num1_sign; // @[POSIT.scala 118:30]
  assign positMulCore_io_num1_exponent = exec_num1_exponent; // @[POSIT.scala 118:30]
  assign positMulCore_io_num1_fraction = exec_num1_fraction; // @[POSIT.scala 118:30]
  assign positMulCore_io_num1_isZero = exec_num1_isZero; // @[POSIT.scala 118:30]
  assign positMulCore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 118:30]
  assign positMulCore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 119:30]
  assign positMulCore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 119:30]
  assign positMulCore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 119:30]
  assign positMulCore_io_num2_isZero = exec_num2_isZero; // @[POSIT.scala 119:30]
  assign positMulCore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 119:30]
  assign num1Extractor_io_in = init_num1; // @[POSIT.scala 69:29]
  assign num2Extractor_io_in = init_num2; // @[POSIT.scala 70:29]
  assign num3Extractor_io_in = init_num3; // @[POSIT.scala 71:29]
  assign positGenerator_io_in_sign = result_out_sign; // @[POSIT.scala 163:40]
  assign positGenerator_io_in_exponent = result_out_exponent; // @[POSIT.scala 163:40]
  assign positGenerator_io_in_fraction = result_out_fraction; // @[POSIT.scala 163:40]
  assign positGenerator_io_in_isZero = result_out_isZero; // @[POSIT.scala 163:40]
  assign positGenerator_io_in_isNaR = result_out_isNaR; // @[POSIT.scala 163:40]
  assign positGenerator_io_trailingBits = result_trailingBits; // @[POSIT.scala 164:40]
  assign positGenerator_io_stickyBit = result_stickyBit; // @[POSIT.scala 165:40]
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
  exec_num1_sign = _RAND_6[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  exec_num1_exponent = _RAND_7[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  exec_num1_fraction = _RAND_8[27:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  exec_num1_isZero = _RAND_9[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  exec_num1_isNaR = _RAND_10[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  exec_num2_sign = _RAND_11[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  exec_num2_exponent = _RAND_12[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  exec_num2_fraction = _RAND_13[27:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  exec_num2_isZero = _RAND_14[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  exec_num2_isNaR = _RAND_15[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  exec_num3_sign = _RAND_16[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  exec_num3_exponent = _RAND_17[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  exec_num3_fraction = _RAND_18[27:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  exec_num3_isZero = _RAND_19[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  exec_num3_isNaR = _RAND_20[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  comp_num1 = _RAND_21[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  comp_num2 = _RAND_22[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {1{`RANDOM}};
  exec_inst = _RAND_23[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  exec_mode = _RAND_24[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  exec_valid = _RAND_25[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{`RANDOM}};
  result_out_sign = _RAND_26[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  result_out_exponent = _RAND_27[8:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{`RANDOM}};
  result_out_fraction = _RAND_28[27:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  result_out_isZero = _RAND_29[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  result_out_isNaR = _RAND_30[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  result_stickyBit = _RAND_31[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{`RANDOM}};
  result_trailingBits = _RAND_32[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_33 = {1{`RANDOM}};
  result_valid = _RAND_33[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{`RANDOM}};
  result_lt = _RAND_34[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_35 = {1{`RANDOM}};
  result_eq = _RAND_35[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{`RANDOM}};
  result_gt = _RAND_36[0:0];
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
    end
    if (reset) begin
      exec_num1_sign <= 1'h0;
    end else if (_T) begin
      exec_num1_sign <= num1Extractor_io_out_sign;
    end
    if (reset) begin
      exec_num1_exponent <= 9'sh0;
    end else if (_T) begin
      exec_num1_exponent <= num1Extractor_io_out_exponent;
    end
    if (reset) begin
      exec_num1_fraction <= 28'h0;
    end else if (_T) begin
      exec_num1_fraction <= num1Extractor_io_out_fraction;
    end
    if (reset) begin
      exec_num1_isZero <= 1'h0;
    end else if (_T) begin
      exec_num1_isZero <= num1Extractor_io_out_isZero;
    end
    if (reset) begin
      exec_num1_isNaR <= 1'h0;
    end else if (_T) begin
      exec_num1_isNaR <= num1Extractor_io_out_isNaR;
    end
    if (reset) begin
      exec_num2_sign <= 1'h0;
    end else if (_T) begin
      exec_num2_sign <= num2Extractor_io_out_sign;
    end
    if (reset) begin
      exec_num2_exponent <= 9'sh0;
    end else if (_T) begin
      exec_num2_exponent <= num2Extractor_io_out_exponent;
    end
    if (reset) begin
      exec_num2_fraction <= 28'h0;
    end else if (_T) begin
      exec_num2_fraction <= num2Extractor_io_out_fraction;
    end
    if (reset) begin
      exec_num2_isZero <= 1'h0;
    end else if (_T) begin
      exec_num2_isZero <= num2Extractor_io_out_isZero;
    end
    if (reset) begin
      exec_num2_isNaR <= 1'h0;
    end else if (_T) begin
      exec_num2_isNaR <= num2Extractor_io_out_isNaR;
    end
    if (reset) begin
      exec_num3_sign <= 1'h0;
    end else if (_T) begin
      exec_num3_sign <= num3Extractor_io_out_sign;
    end
    if (reset) begin
      exec_num3_exponent <= 9'sh0;
    end else if (_T) begin
      exec_num3_exponent <= num3Extractor_io_out_exponent;
    end
    if (reset) begin
      exec_num3_fraction <= 28'h0;
    end else if (_T) begin
      exec_num3_fraction <= num3Extractor_io_out_fraction;
    end
    if (reset) begin
      exec_num3_isZero <= 1'h0;
    end else if (_T) begin
      exec_num3_isZero <= num3Extractor_io_out_isZero;
    end
    if (reset) begin
      exec_num3_isNaR <= 1'h0;
    end else if (_T) begin
      exec_num3_isNaR <= num3Extractor_io_out_isNaR;
    end
    if (reset) begin
      comp_num1 <= 32'h0;
    end else if (_T) begin
      comp_num1 <= init_num1;
    end
    if (reset) begin
      comp_num2 <= 32'h0;
    end else if (_T) begin
      comp_num2 <= init_num2;
    end
    if (reset) begin
      exec_inst <= 3'h0;
    end else if (_T) begin
      exec_inst <= init_inst;
    end
    if (reset) begin
      exec_mode <= 2'h0;
    end else if (_T) begin
      exec_mode <= init_mode;
    end
    if (reset) begin
      exec_valid <= 1'h0;
    end else if (_T) begin
      exec_valid <= init_valid;
    end
    if (reset) begin
      result_out_sign <= 1'h0;
    end else if (_T) begin
      if (_T_26) begin
        result_out_sign <= positAddCore_io_out_sign;
      end else if (_T_24) begin
        result_out_sign <= positFMACore_io_out_sign;
      end else if (_T_22) begin
        result_out_sign <= positMulCore_io_out_sign;
      end else begin
        result_out_sign <= _T_21_sign;
      end
    end
    if (reset) begin
      result_out_exponent <= 9'sh0;
    end else if (_T) begin
      if (_T_26) begin
        result_out_exponent <= positAddCore_io_out_exponent;
      end else if (_T_24) begin
        result_out_exponent <= positFMACore_io_out_exponent;
      end else if (_T_22) begin
        result_out_exponent <= positMulCore_io_out_exponent;
      end else if (_T_20) begin
        result_out_exponent <= positDivSqrtCore_io_out_exponent;
      end else begin
        result_out_exponent <= 9'sh0;
      end
    end
    if (reset) begin
      result_out_fraction <= 28'h0;
    end else if (_T) begin
      if (_T_26) begin
        result_out_fraction <= positAddCore_io_out_fraction;
      end else if (_T_24) begin
        result_out_fraction <= positFMACore_io_out_fraction;
      end else if (_T_22) begin
        result_out_fraction <= positMulCore_io_out_fraction;
      end else if (_T_20) begin
        result_out_fraction <= positDivSqrtCore_io_out_fraction;
      end else begin
        result_out_fraction <= 28'h0;
      end
    end
    if (reset) begin
      result_out_isZero <= 1'h0;
    end else if (_T) begin
      if (_T_26) begin
        result_out_isZero <= positAddCore_io_out_isZero;
      end else if (_T_24) begin
        result_out_isZero <= positFMACore_io_out_isZero;
      end else if (_T_22) begin
        result_out_isZero <= positMulCore_io_out_isZero;
      end else begin
        result_out_isZero <= _T_21_isZero;
      end
    end
    if (reset) begin
      result_out_isNaR <= 1'h0;
    end else if (_T) begin
      if (_T_26) begin
        result_out_isNaR <= positAddCore_io_out_isNaR;
      end else if (_T_24) begin
        result_out_isNaR <= positFMACore_io_out_isNaR;
      end else if (_T_22) begin
        result_out_isNaR <= positMulCore_io_out_isNaR;
      end else begin
        result_out_isNaR <= _T_21_isNaR;
      end
    end
    if (reset) begin
      result_stickyBit <= 1'h0;
    end else if (_T) begin
      if (_T_26) begin
        result_stickyBit <= positAddCore_io_stickyBit;
      end else if (_T_24) begin
        result_stickyBit <= positFMACore_io_stickyBit;
      end else if (_T_22) begin
        result_stickyBit <= positMulCore_io_stickyBit;
      end else begin
        result_stickyBit <= _T_29;
      end
    end
    if (reset) begin
      result_trailingBits <= 2'h0;
    end else if (_T) begin
      if (_T_26) begin
        result_trailingBits <= positAddCore_io_trailingBits;
      end else if (_T_24) begin
        result_trailingBits <= positFMACore_io_trailingBits;
      end else if (_T_22) begin
        result_trailingBits <= positMulCore_io_trailingBits;
      end else if (_T_20) begin
        result_trailingBits <= positDivSqrtCore_io_trailingBits;
      end else begin
        result_trailingBits <= 2'h0;
      end
    end
    if (reset) begin
      result_valid <= 1'h0;
    end else if (_T) begin
      result_valid <= _T_47;
    end
    if (reset) begin
      result_lt <= 1'h0;
    end else if (_T) begin
      result_lt <= positCompare_io_lt;
    end
    if (reset) begin
      result_eq <= 1'h0;
    end else if (_T) begin
      result_eq <= positCompare_io_eq;
    end
    if (reset) begin
      result_gt <= 1'h0;
    end else if (_T) begin
      result_gt <= positCompare_io_gt;
    end
  end
endmodule
module Queue(
  input        clock,
  input        reset,
  output       io_enq_ready,
  input        io_enq_valid,
  input  [2:0] io_enq_bits,
  input        io_deq_ready,
  output       io_deq_valid,
  output [2:0] io_deq_bits
);
  reg [2:0] _T [0:7]; // @[Decoupled.scala 218:24]
  reg [31:0] _RAND_0;
  wire [2:0] _T__T_18_data; // @[Decoupled.scala 218:24]
  wire [2:0] _T__T_18_addr; // @[Decoupled.scala 218:24]
  wire [2:0] _T__T_10_data; // @[Decoupled.scala 218:24]
  wire [2:0] _T__T_10_addr; // @[Decoupled.scala 218:24]
  wire  _T__T_10_mask; // @[Decoupled.scala 218:24]
  wire  _T__T_10_en; // @[Decoupled.scala 218:24]
  reg [2:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_1;
  reg [2:0] value_1; // @[Counter.scala 29:33]
  reg [31:0] _RAND_2;
  reg  _T_1; // @[Decoupled.scala 221:35]
  reg [31:0] _RAND_3;
  wire  _T_2 = value == value_1; // @[Decoupled.scala 223:41]
  wire  _T_3 = ~_T_1; // @[Decoupled.scala 224:36]
  wire  _T_4 = _T_2 & _T_3; // @[Decoupled.scala 224:33]
  wire  _T_5 = _T_2 & _T_1; // @[Decoupled.scala 225:32]
  wire  _T_6 = io_enq_ready & io_enq_valid; // @[Decoupled.scala 40:37]
  wire  _T_8 = io_deq_ready & io_deq_valid; // @[Decoupled.scala 40:37]
  wire [2:0] _T_12 = value + 3'h1; // @[Counter.scala 39:22]
  wire  _GEN_9 = io_deq_ready ? 1'h0 : _T_6; // @[Decoupled.scala 249:27]
  wire  _GEN_12 = _T_4 ? _GEN_9 : _T_6; // @[Decoupled.scala 246:18]
  wire [2:0] _T_14 = value_1 + 3'h1; // @[Counter.scala 39:22]
  wire  _GEN_11 = _T_4 ? 1'h0 : _T_8; // @[Decoupled.scala 246:18]
  wire  _T_15 = _GEN_12 != _GEN_11; // @[Decoupled.scala 236:16]
  wire  _T_16 = ~_T_4; // @[Decoupled.scala 240:19]
  wire  _T_17 = ~_T_5; // @[Decoupled.scala 241:19]
  assign _T__T_18_addr = value_1;
  assign _T__T_18_data = _T[_T__T_18_addr]; // @[Decoupled.scala 218:24]
  assign _T__T_10_data = io_enq_bits;
  assign _T__T_10_addr = value;
  assign _T__T_10_mask = 1'h1;
  assign _T__T_10_en = _T_4 ? _GEN_9 : _T_6;
  assign io_enq_ready = io_deq_ready | _T_17; // @[Decoupled.scala 241:16 Decoupled.scala 254:40]
  assign io_deq_valid = io_enq_valid | _T_16; // @[Decoupled.scala 240:16 Decoupled.scala 245:40]
  assign io_deq_bits = _T_4 ? io_enq_bits : _T__T_18_data; // @[Decoupled.scala 242:15 Decoupled.scala 247:19]
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
  _RAND_0 = {1{`RANDOM}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 8; initvar = initvar+1)
    _T[initvar] = _RAND_0[2:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  value = _RAND_1[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  value_1 = _RAND_2[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_1 = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(_T__T_10_en & _T__T_10_mask) begin
      _T[_T__T_10_addr] <= _T__T_10_data; // @[Decoupled.scala 218:24]
    end
    if (reset) begin
      value <= 3'h0;
    end else if (_GEN_12) begin
      value <= _T_12;
    end
    if (reset) begin
      value_1 <= 3'h0;
    end else if (_GEN_11) begin
      value_1 <= _T_14;
    end
    if (reset) begin
      _T_1 <= 1'h0;
    end else if (_T_15) begin
      if (_T_4) begin
        if (io_deq_ready) begin
          _T_1 <= 1'h0;
        end else begin
          _T_1 <= _T_6;
        end
      end else begin
        _T_1 <= _T_6;
      end
    end
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
  wire [2:0] _GEN_1 = beforePriority_6 ? 3'h6 : 3'h7; // @[DispatchArbiter.scala 33:32]
  wire [2:0] _GEN_2 = afterPriority_5 ? 3'h5 : _GEN_0; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_3 = beforePriority_5 ? 3'h5 : _GEN_1; // @[DispatchArbiter.scala 33:32]
  wire [2:0] _GEN_4 = afterPriority_4 ? 3'h4 : _GEN_2; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_5 = beforePriority_4 ? 3'h4 : _GEN_3; // @[DispatchArbiter.scala 33:32]
  wire [2:0] _GEN_6 = afterPriority_3 ? 3'h3 : _GEN_4; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_7 = beforePriority_3 ? 3'h3 : _GEN_5; // @[DispatchArbiter.scala 33:32]
  wire [2:0] _GEN_8 = afterPriority_2 ? 3'h2 : _GEN_6; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_9 = beforePriority_2 ? 3'h2 : _GEN_7; // @[DispatchArbiter.scala 33:32]
  wire [2:0] _GEN_10 = afterPriority_1 ? 3'h1 : _GEN_8; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_11 = beforePriority_1 ? 3'h1 : _GEN_9; // @[DispatchArbiter.scala 33:32]
  wire [2:0] afterPriorityChosen = afterPriority_0 ? 3'h0 : _GEN_10; // @[DispatchArbiter.scala 30:29]
  wire [2:0] beforePriorityChosen = beforePriority_0 ? 3'h0 : _GEN_11; // @[DispatchArbiter.scala 33:32]
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
  wire [4:0] _GEN_1 = beforePriority_22 ? 5'h16 : 5'h17; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_2 = afterPriority_21 ? 5'h15 : _GEN_0; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_3 = beforePriority_21 ? 5'h15 : _GEN_1; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_4 = afterPriority_20 ? 5'h14 : _GEN_2; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_5 = beforePriority_20 ? 5'h14 : _GEN_3; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_6 = afterPriority_19 ? 5'h13 : _GEN_4; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_7 = beforePriority_19 ? 5'h13 : _GEN_5; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_8 = afterPriority_18 ? 5'h12 : _GEN_6; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_9 = beforePriority_18 ? 5'h12 : _GEN_7; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_10 = afterPriority_17 ? 5'h11 : _GEN_8; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_11 = beforePriority_17 ? 5'h11 : _GEN_9; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_12 = afterPriority_16 ? 5'h10 : _GEN_10; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_13 = beforePriority_16 ? 5'h10 : _GEN_11; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_14 = afterPriority_15 ? 5'hf : _GEN_12; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_15 = beforePriority_15 ? 5'hf : _GEN_13; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_16 = afterPriority_14 ? 5'he : _GEN_14; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_17 = beforePriority_14 ? 5'he : _GEN_15; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_18 = afterPriority_13 ? 5'hd : _GEN_16; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_19 = beforePriority_13 ? 5'hd : _GEN_17; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_20 = afterPriority_12 ? 5'hc : _GEN_18; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_21 = beforePriority_12 ? 5'hc : _GEN_19; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_22 = afterPriority_11 ? 5'hb : _GEN_20; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_23 = beforePriority_11 ? 5'hb : _GEN_21; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_24 = afterPriority_10 ? 5'ha : _GEN_22; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_25 = beforePriority_10 ? 5'ha : _GEN_23; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_26 = afterPriority_9 ? 5'h9 : _GEN_24; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_27 = beforePriority_9 ? 5'h9 : _GEN_25; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_28 = afterPriority_8 ? 5'h8 : _GEN_26; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_29 = beforePriority_8 ? 5'h8 : _GEN_27; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_30 = afterPriority_7 ? 5'h7 : _GEN_28; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_31 = beforePriority_7 ? 5'h7 : _GEN_29; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_32 = afterPriority_6 ? 5'h6 : _GEN_30; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_33 = beforePriority_6 ? 5'h6 : _GEN_31; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_34 = afterPriority_5 ? 5'h5 : _GEN_32; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_35 = beforePriority_5 ? 5'h5 : _GEN_33; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_36 = afterPriority_4 ? 5'h4 : _GEN_34; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_37 = beforePriority_4 ? 5'h4 : _GEN_35; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_38 = afterPriority_3 ? 5'h3 : _GEN_36; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_39 = beforePriority_3 ? 5'h3 : _GEN_37; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_40 = afterPriority_2 ? 5'h2 : _GEN_38; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_41 = beforePriority_2 ? 5'h2 : _GEN_39; // @[DispatchArbiter.scala 33:32]
  wire [4:0] _GEN_42 = afterPriority_1 ? 5'h1 : _GEN_40; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_43 = beforePriority_1 ? 5'h1 : _GEN_41; // @[DispatchArbiter.scala 33:32]
  wire [4:0] afterPriorityChosen = afterPriority_0 ? 5'h0 : _GEN_42; // @[DispatchArbiter.scala 30:29]
  wire [4:0] beforePriorityChosen = beforePriority_0 ? 5'h0 : _GEN_43; // @[DispatchArbiter.scala 33:32]
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
  input         clock,
  input         reset,
  output        io_request_ready,
  input         io_request_valid,
  input  [31:0] io_request_bits_operands_0_value,
  input  [1:0]  io_request_bits_operands_0_mode,
  input  [31:0] io_request_bits_operands_1_value,
  input  [1:0]  io_request_bits_operands_1_mode,
  input  [31:0] io_request_bits_operands_2_value,
  input  [1:0]  io_request_bits_operands_2_mode,
  input  [2:0]  io_request_bits_inst,
  input  [1:0]  io_request_bits_mode,
  input  [7:0]  io_request_bits_wr_addr,
  input         io_mem_write_ready,
  output        io_mem_write_valid,
  output        io_mem_write_bits_result_isZero,
  output        io_mem_write_bits_result_isNaR,
  output [31:0] io_mem_write_bits_result_out,
  output        io_mem_write_bits_result_lt,
  output        io_mem_write_bits_result_eq,
  output        io_mem_write_bits_result_gt,
  output [4:0]  io_mem_write_bits_result_exceptions,
  output [47:0] io_mem_write_bits_wr_addr,
  output        io_mem_read_req_valid,
  output [7:0]  io_mem_read_req_addr,
  input  [31:0] io_mem_read_data,
  input         io_mem_read_resp_valid,
  input  [7:0]  io_mem_read_resp_tag
);
  wire  pe_clock; // @[POSIT_Locality.scala 10:24]
  wire  pe_reset; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_request_ready; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_request_valid; // @[POSIT_Locality.scala 10:24]
  wire [31:0] pe_io_request_bits_num1; // @[POSIT_Locality.scala 10:24]
  wire [31:0] pe_io_request_bits_num2; // @[POSIT_Locality.scala 10:24]
  wire [31:0] pe_io_request_bits_num3; // @[POSIT_Locality.scala 10:24]
  wire [2:0] pe_io_request_bits_inst; // @[POSIT_Locality.scala 10:24]
  wire [1:0] pe_io_request_bits_mode; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_ready; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_valid; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_bits_isZero; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_bits_isNaR; // @[POSIT_Locality.scala 10:24]
  wire [31:0] pe_io_result_bits_out; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_bits_lt; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_bits_eq; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_bits_gt; // @[POSIT_Locality.scala 10:24]
  wire [4:0] pe_io_result_bits_exceptions; // @[POSIT_Locality.scala 10:24]
  wire  processQueue_clock; // @[POSIT_Locality.scala 59:31]
  wire  processQueue_reset; // @[POSIT_Locality.scala 59:31]
  wire  processQueue_io_enq_ready; // @[POSIT_Locality.scala 59:31]
  wire  processQueue_io_enq_valid; // @[POSIT_Locality.scala 59:31]
  wire [2:0] processQueue_io_enq_bits; // @[POSIT_Locality.scala 59:31]
  wire  processQueue_io_deq_ready; // @[POSIT_Locality.scala 59:31]
  wire  processQueue_io_deq_valid; // @[POSIT_Locality.scala 59:31]
  wire [2:0] processQueue_io_deq_bits; // @[POSIT_Locality.scala 59:31]
  wire [7:0] dispatchArb_io_validity; // @[POSIT_Locality.scala 61:33]
  wire [2:0] dispatchArb_io_priority; // @[POSIT_Locality.scala 61:33]
  wire [2:0] dispatchArb_io_chosen; // @[POSIT_Locality.scala 61:33]
  wire  dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 61:33]
  wire [23:0] fetchArb_io_validity; // @[POSIT_Locality.scala 155:30]
  wire [4:0] fetchArb_io_priority; // @[POSIT_Locality.scala 155:30]
  wire [4:0] fetchArb_io_chosen; // @[POSIT_Locality.scala 155:30]
  wire  fetchArb_io_hasChosen; // @[POSIT_Locality.scala 155:30]
  reg  rb_entries_0_completed; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_0;
  reg  rb_entries_0_valid; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_1;
  reg  rb_entries_0_dispatched; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_2;
  reg  rb_entries_0_written; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_3;
  reg [47:0] rb_entries_0_wr_addr; // @[POSIT_Locality.scala 14:25]
  reg [63:0] _RAND_4;
  reg [31:0] rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_5;
  reg [1:0] rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_6;
  reg [31:0] rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_7;
  reg [1:0] rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_8;
  reg [31:0] rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_9;
  reg [1:0] rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_10;
  reg [2:0] rb_entries_0_request_inst; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_11;
  reg [1:0] rb_entries_0_request_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_12;
  reg  rb_entries_0_request_inFetch_0; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_13;
  reg  rb_entries_0_request_inFetch_1; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_14;
  reg  rb_entries_0_request_inFetch_2; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_15;
  reg  rb_entries_0_result_isZero; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_16;
  reg  rb_entries_0_result_isNaR; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_17;
  reg [31:0] rb_entries_0_result_out; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_18;
  reg  rb_entries_0_result_lt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_19;
  reg  rb_entries_0_result_eq; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_20;
  reg  rb_entries_0_result_gt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_21;
  reg [4:0] rb_entries_0_result_exceptions; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_22;
  reg  rb_entries_1_completed; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_23;
  reg  rb_entries_1_valid; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_24;
  reg  rb_entries_1_dispatched; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_25;
  reg  rb_entries_1_written; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_26;
  reg [47:0] rb_entries_1_wr_addr; // @[POSIT_Locality.scala 14:25]
  reg [63:0] _RAND_27;
  reg [31:0] rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_28;
  reg [1:0] rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_29;
  reg [31:0] rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_30;
  reg [1:0] rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_31;
  reg [31:0] rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_32;
  reg [1:0] rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_33;
  reg [2:0] rb_entries_1_request_inst; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_34;
  reg [1:0] rb_entries_1_request_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_35;
  reg  rb_entries_1_request_inFetch_0; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_36;
  reg  rb_entries_1_request_inFetch_1; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_37;
  reg  rb_entries_1_request_inFetch_2; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_38;
  reg  rb_entries_1_result_isZero; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_39;
  reg  rb_entries_1_result_isNaR; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_40;
  reg [31:0] rb_entries_1_result_out; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_41;
  reg  rb_entries_1_result_lt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_42;
  reg  rb_entries_1_result_eq; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_43;
  reg  rb_entries_1_result_gt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_44;
  reg [4:0] rb_entries_1_result_exceptions; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_45;
  reg  rb_entries_2_completed; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_46;
  reg  rb_entries_2_valid; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_47;
  reg  rb_entries_2_dispatched; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_48;
  reg  rb_entries_2_written; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_49;
  reg [47:0] rb_entries_2_wr_addr; // @[POSIT_Locality.scala 14:25]
  reg [63:0] _RAND_50;
  reg [31:0] rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_51;
  reg [1:0] rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_52;
  reg [31:0] rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_53;
  reg [1:0] rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_54;
  reg [31:0] rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_55;
  reg [1:0] rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_56;
  reg [2:0] rb_entries_2_request_inst; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_57;
  reg [1:0] rb_entries_2_request_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_58;
  reg  rb_entries_2_request_inFetch_0; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_59;
  reg  rb_entries_2_request_inFetch_1; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_60;
  reg  rb_entries_2_request_inFetch_2; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_61;
  reg  rb_entries_2_result_isZero; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_62;
  reg  rb_entries_2_result_isNaR; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_63;
  reg [31:0] rb_entries_2_result_out; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_64;
  reg  rb_entries_2_result_lt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_65;
  reg  rb_entries_2_result_eq; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_66;
  reg  rb_entries_2_result_gt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_67;
  reg [4:0] rb_entries_2_result_exceptions; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_68;
  reg  rb_entries_3_completed; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_69;
  reg  rb_entries_3_valid; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_70;
  reg  rb_entries_3_dispatched; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_71;
  reg  rb_entries_3_written; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_72;
  reg [47:0] rb_entries_3_wr_addr; // @[POSIT_Locality.scala 14:25]
  reg [63:0] _RAND_73;
  reg [31:0] rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_74;
  reg [1:0] rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_75;
  reg [31:0] rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_76;
  reg [1:0] rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_77;
  reg [31:0] rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_78;
  reg [1:0] rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_79;
  reg [2:0] rb_entries_3_request_inst; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_80;
  reg [1:0] rb_entries_3_request_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_81;
  reg  rb_entries_3_request_inFetch_0; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_82;
  reg  rb_entries_3_request_inFetch_1; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_83;
  reg  rb_entries_3_request_inFetch_2; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_84;
  reg  rb_entries_3_result_isZero; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_85;
  reg  rb_entries_3_result_isNaR; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_86;
  reg [31:0] rb_entries_3_result_out; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_87;
  reg  rb_entries_3_result_lt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_88;
  reg  rb_entries_3_result_eq; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_89;
  reg  rb_entries_3_result_gt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_90;
  reg [4:0] rb_entries_3_result_exceptions; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_91;
  reg  rb_entries_4_completed; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_92;
  reg  rb_entries_4_valid; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_93;
  reg  rb_entries_4_dispatched; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_94;
  reg  rb_entries_4_written; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_95;
  reg [47:0] rb_entries_4_wr_addr; // @[POSIT_Locality.scala 14:25]
  reg [63:0] _RAND_96;
  reg [31:0] rb_entries_4_request_operands_0_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_97;
  reg [1:0] rb_entries_4_request_operands_0_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_98;
  reg [31:0] rb_entries_4_request_operands_1_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_99;
  reg [1:0] rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_100;
  reg [31:0] rb_entries_4_request_operands_2_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_101;
  reg [1:0] rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_102;
  reg [2:0] rb_entries_4_request_inst; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_103;
  reg [1:0] rb_entries_4_request_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_104;
  reg  rb_entries_4_request_inFetch_0; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_105;
  reg  rb_entries_4_request_inFetch_1; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_106;
  reg  rb_entries_4_request_inFetch_2; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_107;
  reg  rb_entries_4_result_isZero; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_108;
  reg  rb_entries_4_result_isNaR; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_109;
  reg [31:0] rb_entries_4_result_out; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_110;
  reg  rb_entries_4_result_lt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_111;
  reg  rb_entries_4_result_eq; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_112;
  reg  rb_entries_4_result_gt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_113;
  reg [4:0] rb_entries_4_result_exceptions; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_114;
  reg  rb_entries_5_completed; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_115;
  reg  rb_entries_5_valid; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_116;
  reg  rb_entries_5_dispatched; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_117;
  reg  rb_entries_5_written; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_118;
  reg [47:0] rb_entries_5_wr_addr; // @[POSIT_Locality.scala 14:25]
  reg [63:0] _RAND_119;
  reg [31:0] rb_entries_5_request_operands_0_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_120;
  reg [1:0] rb_entries_5_request_operands_0_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_121;
  reg [31:0] rb_entries_5_request_operands_1_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_122;
  reg [1:0] rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_123;
  reg [31:0] rb_entries_5_request_operands_2_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_124;
  reg [1:0] rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_125;
  reg [2:0] rb_entries_5_request_inst; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_126;
  reg [1:0] rb_entries_5_request_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_127;
  reg  rb_entries_5_request_inFetch_0; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_128;
  reg  rb_entries_5_request_inFetch_1; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_129;
  reg  rb_entries_5_request_inFetch_2; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_130;
  reg  rb_entries_5_result_isZero; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_131;
  reg  rb_entries_5_result_isNaR; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_132;
  reg [31:0] rb_entries_5_result_out; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_133;
  reg  rb_entries_5_result_lt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_134;
  reg  rb_entries_5_result_eq; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_135;
  reg  rb_entries_5_result_gt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_136;
  reg [4:0] rb_entries_5_result_exceptions; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_137;
  reg  rb_entries_6_completed; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_138;
  reg  rb_entries_6_valid; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_139;
  reg  rb_entries_6_dispatched; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_140;
  reg  rb_entries_6_written; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_141;
  reg [47:0] rb_entries_6_wr_addr; // @[POSIT_Locality.scala 14:25]
  reg [63:0] _RAND_142;
  reg [31:0] rb_entries_6_request_operands_0_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_143;
  reg [1:0] rb_entries_6_request_operands_0_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_144;
  reg [31:0] rb_entries_6_request_operands_1_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_145;
  reg [1:0] rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_146;
  reg [31:0] rb_entries_6_request_operands_2_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_147;
  reg [1:0] rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_148;
  reg [2:0] rb_entries_6_request_inst; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_149;
  reg [1:0] rb_entries_6_request_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_150;
  reg  rb_entries_6_request_inFetch_0; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_151;
  reg  rb_entries_6_request_inFetch_1; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_152;
  reg  rb_entries_6_request_inFetch_2; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_153;
  reg  rb_entries_6_result_isZero; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_154;
  reg  rb_entries_6_result_isNaR; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_155;
  reg [31:0] rb_entries_6_result_out; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_156;
  reg  rb_entries_6_result_lt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_157;
  reg  rb_entries_6_result_eq; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_158;
  reg  rb_entries_6_result_gt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_159;
  reg [4:0] rb_entries_6_result_exceptions; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_160;
  reg  rb_entries_7_completed; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_161;
  reg  rb_entries_7_valid; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_162;
  reg  rb_entries_7_dispatched; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_163;
  reg  rb_entries_7_written; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_164;
  reg [47:0] rb_entries_7_wr_addr; // @[POSIT_Locality.scala 14:25]
  reg [63:0] _RAND_165;
  reg [31:0] rb_entries_7_request_operands_0_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_166;
  reg [1:0] rb_entries_7_request_operands_0_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_167;
  reg [31:0] rb_entries_7_request_operands_1_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_168;
  reg [1:0] rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_169;
  reg [31:0] rb_entries_7_request_operands_2_value; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_170;
  reg [1:0] rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_171;
  reg [2:0] rb_entries_7_request_inst; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_172;
  reg [1:0] rb_entries_7_request_mode; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_173;
  reg  rb_entries_7_request_inFetch_0; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_174;
  reg  rb_entries_7_request_inFetch_1; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_175;
  reg  rb_entries_7_request_inFetch_2; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_176;
  reg  rb_entries_7_result_isZero; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_177;
  reg  rb_entries_7_result_isNaR; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_178;
  reg [31:0] rb_entries_7_result_out; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_179;
  reg  rb_entries_7_result_lt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_180;
  reg  rb_entries_7_result_eq; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_181;
  reg  rb_entries_7_result_gt; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_182;
  reg [4:0] rb_entries_7_result_exceptions; // @[POSIT_Locality.scala 14:25]
  reg [31:0] _RAND_183;
  reg [2:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_184;
  wire [2:0] _T_4 = value + 3'h1; // @[Counter.scala 39:22]
  wire  _GEN_41 = 3'h1 == value ? rb_entries_1_written : rb_entries_0_written; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_71 = 3'h2 == value ? rb_entries_2_written : _GEN_41; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_101 = 3'h3 == value ? rb_entries_3_written : _GEN_71; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_131 = 3'h4 == value ? rb_entries_4_written : _GEN_101; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_161 = 3'h5 == value ? rb_entries_5_written : _GEN_131; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_191 = 3'h6 == value ? rb_entries_6_written : _GEN_161; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_221 = 3'h7 == value ? rb_entries_7_written : _GEN_191; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_39 = 3'h1 == value ? rb_entries_1_valid : rb_entries_0_valid; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_69 = 3'h2 == value ? rb_entries_2_valid : _GEN_39; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_99 = 3'h3 == value ? rb_entries_3_valid : _GEN_69; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_129 = 3'h4 == value ? rb_entries_4_valid : _GEN_99; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_159 = 3'h5 == value ? rb_entries_5_valid : _GEN_129; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_189 = 3'h6 == value ? rb_entries_6_valid : _GEN_159; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_219 = 3'h7 == value ? rb_entries_7_valid : _GEN_189; // @[POSIT_Locality.scala 19:83]
  wire  _T_5 = ~_GEN_219; // @[POSIT_Locality.scala 19:83]
  wire  _T_6 = _GEN_221 | _T_5; // @[POSIT_Locality.scala 19:80]
  wire  new_input_log = io_request_valid & _T_6; // @[POSIT_Locality.scala 19:43]
  wire  _GEN_242 = 3'h0 == value ? 1'h0 : rb_entries_0_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_243 = 3'h1 == value ? 1'h0 : rb_entries_1_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_244 = 3'h2 == value ? 1'h0 : rb_entries_2_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_245 = 3'h3 == value ? 1'h0 : rb_entries_3_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_246 = 3'h4 == value ? 1'h0 : rb_entries_4_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_247 = 3'h5 == value ? 1'h0 : rb_entries_5_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_248 = 3'h6 == value ? 1'h0 : rb_entries_6_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_249 = 3'h7 == value ? 1'h0 : rb_entries_7_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_13049 = 3'h0 == value; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_250 = _GEN_13049 | rb_entries_0_valid; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_13050 = 3'h1 == value; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_251 = _GEN_13050 | rb_entries_1_valid; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_13051 = 3'h2 == value; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_252 = _GEN_13051 | rb_entries_2_valid; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_13052 = 3'h3 == value; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_253 = _GEN_13052 | rb_entries_3_valid; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_13053 = 3'h4 == value; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_254 = _GEN_13053 | rb_entries_4_valid; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_13054 = 3'h5 == value; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_255 = _GEN_13054 | rb_entries_5_valid; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_13055 = 3'h6 == value; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_256 = _GEN_13055 | rb_entries_6_valid; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_13056 = 3'h7 == value; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_257 = _GEN_13056 | rb_entries_7_valid; // @[POSIT_Locality.scala 25:48]
  wire  _GEN_258 = 3'h0 == value ? 1'h0 : rb_entries_0_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_259 = 3'h1 == value ? 1'h0 : rb_entries_1_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_260 = 3'h2 == value ? 1'h0 : rb_entries_2_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_261 = 3'h3 == value ? 1'h0 : rb_entries_3_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_262 = 3'h4 == value ? 1'h0 : rb_entries_4_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_263 = 3'h5 == value ? 1'h0 : rb_entries_5_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_264 = 3'h6 == value ? 1'h0 : rb_entries_6_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_265 = 3'h7 == value ? 1'h0 : rb_entries_7_written; // @[POSIT_Locality.scala 26:50]
  wire [47:0] _rb_entries_value_wr_addr = {{40'd0}, io_request_bits_wr_addr}; // @[POSIT_Locality.scala 27:50 POSIT_Locality.scala 27:50]
  wire [1:0] _GEN_314 = 3'h0 == value ? io_request_bits_operands_0_mode : rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_315 = 3'h1 == value ? io_request_bits_operands_0_mode : rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_316 = 3'h2 == value ? io_request_bits_operands_0_mode : rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_317 = 3'h3 == value ? io_request_bits_operands_0_mode : rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_318 = 3'h4 == value ? io_request_bits_operands_0_mode : rb_entries_4_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_319 = 3'h5 == value ? io_request_bits_operands_0_mode : rb_entries_5_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_320 = 3'h6 == value ? io_request_bits_operands_0_mode : rb_entries_6_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_321 = 3'h7 == value ? io_request_bits_operands_0_mode : rb_entries_7_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_322 = 3'h0 == value ? io_request_bits_operands_0_value : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_323 = 3'h1 == value ? io_request_bits_operands_0_value : rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_324 = 3'h2 == value ? io_request_bits_operands_0_value : rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_325 = 3'h3 == value ? io_request_bits_operands_0_value : rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_326 = 3'h4 == value ? io_request_bits_operands_0_value : rb_entries_4_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_327 = 3'h5 == value ? io_request_bits_operands_0_value : rb_entries_5_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_328 = 3'h6 == value ? io_request_bits_operands_0_value : rb_entries_6_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_329 = 3'h7 == value ? io_request_bits_operands_0_value : rb_entries_7_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_330 = 3'h0 == value ? io_request_bits_operands_1_mode : rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_331 = 3'h1 == value ? io_request_bits_operands_1_mode : rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_332 = 3'h2 == value ? io_request_bits_operands_1_mode : rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_333 = 3'h3 == value ? io_request_bits_operands_1_mode : rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_334 = 3'h4 == value ? io_request_bits_operands_1_mode : rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_335 = 3'h5 == value ? io_request_bits_operands_1_mode : rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_336 = 3'h6 == value ? io_request_bits_operands_1_mode : rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_337 = 3'h7 == value ? io_request_bits_operands_1_mode : rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_338 = 3'h0 == value ? io_request_bits_operands_1_value : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_339 = 3'h1 == value ? io_request_bits_operands_1_value : rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_340 = 3'h2 == value ? io_request_bits_operands_1_value : rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_341 = 3'h3 == value ? io_request_bits_operands_1_value : rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_342 = 3'h4 == value ? io_request_bits_operands_1_value : rb_entries_4_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_343 = 3'h5 == value ? io_request_bits_operands_1_value : rb_entries_5_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_344 = 3'h6 == value ? io_request_bits_operands_1_value : rb_entries_6_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_345 = 3'h7 == value ? io_request_bits_operands_1_value : rb_entries_7_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_346 = 3'h0 == value ? io_request_bits_operands_2_mode : rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_347 = 3'h1 == value ? io_request_bits_operands_2_mode : rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_348 = 3'h2 == value ? io_request_bits_operands_2_mode : rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_349 = 3'h3 == value ? io_request_bits_operands_2_mode : rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_350 = 3'h4 == value ? io_request_bits_operands_2_mode : rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_351 = 3'h5 == value ? io_request_bits_operands_2_mode : rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_352 = 3'h6 == value ? io_request_bits_operands_2_mode : rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_353 = 3'h7 == value ? io_request_bits_operands_2_mode : rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_354 = 3'h0 == value ? io_request_bits_operands_2_value : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_355 = 3'h1 == value ? io_request_bits_operands_2_value : rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_356 = 3'h2 == value ? io_request_bits_operands_2_value : rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_357 = 3'h3 == value ? io_request_bits_operands_2_value : rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_358 = 3'h4 == value ? io_request_bits_operands_2_value : rb_entries_4_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_359 = 3'h5 == value ? io_request_bits_operands_2_value : rb_entries_5_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_360 = 3'h6 == value ? io_request_bits_operands_2_value : rb_entries_6_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
  wire [31:0] _GEN_361 = 3'h7 == value ? io_request_bits_operands_2_value : rb_entries_7_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
  wire  _GEN_418 = new_input_log ? _GEN_242 : rb_entries_0_completed; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_419 = new_input_log ? _GEN_243 : rb_entries_1_completed; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_420 = new_input_log ? _GEN_244 : rb_entries_2_completed; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_421 = new_input_log ? _GEN_245 : rb_entries_3_completed; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_422 = new_input_log ? _GEN_246 : rb_entries_4_completed; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_423 = new_input_log ? _GEN_247 : rb_entries_5_completed; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_424 = new_input_log ? _GEN_248 : rb_entries_6_completed; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_425 = new_input_log ? _GEN_249 : rb_entries_7_completed; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_434 = new_input_log ? _GEN_258 : rb_entries_0_written; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_435 = new_input_log ? _GEN_259 : rb_entries_1_written; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_436 = new_input_log ? _GEN_260 : rb_entries_2_written; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_437 = new_input_log ? _GEN_261 : rb_entries_3_written; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_438 = new_input_log ? _GEN_262 : rb_entries_4_written; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_439 = new_input_log ? _GEN_263 : rb_entries_5_written; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_440 = new_input_log ? _GEN_264 : rb_entries_6_written; // @[POSIT_Locality.scala 23:28]
  wire  _GEN_441 = new_input_log ? _GEN_265 : rb_entries_7_written; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_490 = new_input_log ? _GEN_314 : rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_491 = new_input_log ? _GEN_315 : rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_492 = new_input_log ? _GEN_316 : rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_493 = new_input_log ? _GEN_317 : rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_494 = new_input_log ? _GEN_318 : rb_entries_4_request_operands_0_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_495 = new_input_log ? _GEN_319 : rb_entries_5_request_operands_0_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_496 = new_input_log ? _GEN_320 : rb_entries_6_request_operands_0_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_497 = new_input_log ? _GEN_321 : rb_entries_7_request_operands_0_mode; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_498 = new_input_log ? _GEN_322 : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_499 = new_input_log ? _GEN_323 : rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_500 = new_input_log ? _GEN_324 : rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_501 = new_input_log ? _GEN_325 : rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_502 = new_input_log ? _GEN_326 : rb_entries_4_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_503 = new_input_log ? _GEN_327 : rb_entries_5_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_504 = new_input_log ? _GEN_328 : rb_entries_6_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_505 = new_input_log ? _GEN_329 : rb_entries_7_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_506 = new_input_log ? _GEN_330 : rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_507 = new_input_log ? _GEN_331 : rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_508 = new_input_log ? _GEN_332 : rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_509 = new_input_log ? _GEN_333 : rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_510 = new_input_log ? _GEN_334 : rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_511 = new_input_log ? _GEN_335 : rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_512 = new_input_log ? _GEN_336 : rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_513 = new_input_log ? _GEN_337 : rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_514 = new_input_log ? _GEN_338 : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_515 = new_input_log ? _GEN_339 : rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_516 = new_input_log ? _GEN_340 : rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_517 = new_input_log ? _GEN_341 : rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_518 = new_input_log ? _GEN_342 : rb_entries_4_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_519 = new_input_log ? _GEN_343 : rb_entries_5_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_520 = new_input_log ? _GEN_344 : rb_entries_6_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_521 = new_input_log ? _GEN_345 : rb_entries_7_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_522 = new_input_log ? _GEN_346 : rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_523 = new_input_log ? _GEN_347 : rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_524 = new_input_log ? _GEN_348 : rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_525 = new_input_log ? _GEN_349 : rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_526 = new_input_log ? _GEN_350 : rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_527 = new_input_log ? _GEN_351 : rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_528 = new_input_log ? _GEN_352 : rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_529 = new_input_log ? _GEN_353 : rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_530 = new_input_log ? _GEN_354 : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_531 = new_input_log ? _GEN_355 : rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_532 = new_input_log ? _GEN_356 : rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_533 = new_input_log ? _GEN_357 : rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_534 = new_input_log ? _GEN_358 : rb_entries_4_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_535 = new_input_log ? _GEN_359 : rb_entries_5_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_536 = new_input_log ? _GEN_360 : rb_entries_6_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  wire [31:0] _GEN_537 = new_input_log ? _GEN_361 : rb_entries_7_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  reg [2:0] value_1; // @[Counter.scala 29:33]
  reg [31:0] _RAND_185;
  wire [2:0] _T_14 = value_1 + 3'h1; // @[Counter.scala 39:22]
  wire  _GEN_632 = 3'h1 == value_1 ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_662 = 3'h2 == value_1 ? rb_entries_2_completed : _GEN_632; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_692 = 3'h3 == value_1 ? rb_entries_3_completed : _GEN_662; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_722 = 3'h4 == value_1 ? rb_entries_4_completed : _GEN_692; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_752 = 3'h5 == value_1 ? rb_entries_5_completed : _GEN_722; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_782 = 3'h6 == value_1 ? rb_entries_6_completed : _GEN_752; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_812 = 3'h7 == value_1 ? rb_entries_7_completed : _GEN_782; // @[POSIT_Locality.scala 41:33]
  wire  wbCountOn = io_mem_write_ready & _GEN_812; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_636 = 3'h1 == value_1 ? rb_entries_1_wr_addr : rb_entries_0_wr_addr; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_649 = 3'h1 == value_1 ? rb_entries_1_result_isZero : rb_entries_0_result_isZero; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_650 = 3'h1 == value_1 ? rb_entries_1_result_isNaR : rb_entries_0_result_isNaR; // @[POSIT_Locality.scala 41:33]
  wire [31:0] _GEN_651 = 3'h1 == value_1 ? rb_entries_1_result_out : rb_entries_0_result_out; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_652 = 3'h1 == value_1 ? rb_entries_1_result_lt : rb_entries_0_result_lt; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_653 = 3'h1 == value_1 ? rb_entries_1_result_eq : rb_entries_0_result_eq; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_654 = 3'h1 == value_1 ? rb_entries_1_result_gt : rb_entries_0_result_gt; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_655 = 3'h1 == value_1 ? rb_entries_1_result_exceptions : rb_entries_0_result_exceptions; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_666 = 3'h2 == value_1 ? rb_entries_2_wr_addr : _GEN_636; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_679 = 3'h2 == value_1 ? rb_entries_2_result_isZero : _GEN_649; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_680 = 3'h2 == value_1 ? rb_entries_2_result_isNaR : _GEN_650; // @[POSIT_Locality.scala 41:33]
  wire [31:0] _GEN_681 = 3'h2 == value_1 ? rb_entries_2_result_out : _GEN_651; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_682 = 3'h2 == value_1 ? rb_entries_2_result_lt : _GEN_652; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_683 = 3'h2 == value_1 ? rb_entries_2_result_eq : _GEN_653; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_684 = 3'h2 == value_1 ? rb_entries_2_result_gt : _GEN_654; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_685 = 3'h2 == value_1 ? rb_entries_2_result_exceptions : _GEN_655; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_696 = 3'h3 == value_1 ? rb_entries_3_wr_addr : _GEN_666; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_709 = 3'h3 == value_1 ? rb_entries_3_result_isZero : _GEN_679; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_710 = 3'h3 == value_1 ? rb_entries_3_result_isNaR : _GEN_680; // @[POSIT_Locality.scala 41:33]
  wire [31:0] _GEN_711 = 3'h3 == value_1 ? rb_entries_3_result_out : _GEN_681; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_712 = 3'h3 == value_1 ? rb_entries_3_result_lt : _GEN_682; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_713 = 3'h3 == value_1 ? rb_entries_3_result_eq : _GEN_683; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_714 = 3'h3 == value_1 ? rb_entries_3_result_gt : _GEN_684; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_715 = 3'h3 == value_1 ? rb_entries_3_result_exceptions : _GEN_685; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_726 = 3'h4 == value_1 ? rb_entries_4_wr_addr : _GEN_696; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_739 = 3'h4 == value_1 ? rb_entries_4_result_isZero : _GEN_709; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_740 = 3'h4 == value_1 ? rb_entries_4_result_isNaR : _GEN_710; // @[POSIT_Locality.scala 41:33]
  wire [31:0] _GEN_741 = 3'h4 == value_1 ? rb_entries_4_result_out : _GEN_711; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_742 = 3'h4 == value_1 ? rb_entries_4_result_lt : _GEN_712; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_743 = 3'h4 == value_1 ? rb_entries_4_result_eq : _GEN_713; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_744 = 3'h4 == value_1 ? rb_entries_4_result_gt : _GEN_714; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_745 = 3'h4 == value_1 ? rb_entries_4_result_exceptions : _GEN_715; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_756 = 3'h5 == value_1 ? rb_entries_5_wr_addr : _GEN_726; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_769 = 3'h5 == value_1 ? rb_entries_5_result_isZero : _GEN_739; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_770 = 3'h5 == value_1 ? rb_entries_5_result_isNaR : _GEN_740; // @[POSIT_Locality.scala 41:33]
  wire [31:0] _GEN_771 = 3'h5 == value_1 ? rb_entries_5_result_out : _GEN_741; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_772 = 3'h5 == value_1 ? rb_entries_5_result_lt : _GEN_742; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_773 = 3'h5 == value_1 ? rb_entries_5_result_eq : _GEN_743; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_774 = 3'h5 == value_1 ? rb_entries_5_result_gt : _GEN_744; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_775 = 3'h5 == value_1 ? rb_entries_5_result_exceptions : _GEN_745; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_786 = 3'h6 == value_1 ? rb_entries_6_wr_addr : _GEN_756; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_799 = 3'h6 == value_1 ? rb_entries_6_result_isZero : _GEN_769; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_800 = 3'h6 == value_1 ? rb_entries_6_result_isNaR : _GEN_770; // @[POSIT_Locality.scala 41:33]
  wire [31:0] _GEN_801 = 3'h6 == value_1 ? rb_entries_6_result_out : _GEN_771; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_802 = 3'h6 == value_1 ? rb_entries_6_result_lt : _GEN_772; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_803 = 3'h6 == value_1 ? rb_entries_6_result_eq : _GEN_773; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_804 = 3'h6 == value_1 ? rb_entries_6_result_gt : _GEN_774; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_805 = 3'h6 == value_1 ? rb_entries_6_result_exceptions : _GEN_775; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_13057 = 3'h0 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_836 = _GEN_13057 | _GEN_434; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13058 = 3'h1 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_837 = _GEN_13058 | _GEN_435; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13059 = 3'h2 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_838 = _GEN_13059 | _GEN_436; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13060 = 3'h3 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_839 = _GEN_13060 | _GEN_437; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13061 = 3'h4 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_840 = _GEN_13061 | _GEN_438; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13062 = 3'h5 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_841 = _GEN_13062 | _GEN_439; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13063 = 3'h6 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_842 = _GEN_13063 | _GEN_440; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13064 = 3'h7 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_843 = _GEN_13064 | _GEN_441; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_845 = wbCountOn ? _GEN_836 : _GEN_434; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_846 = wbCountOn ? _GEN_837 : _GEN_435; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_847 = wbCountOn ? _GEN_838 : _GEN_436; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_848 = wbCountOn ? _GEN_839 : _GEN_437; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_849 = wbCountOn ? _GEN_840 : _GEN_438; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_850 = wbCountOn ? _GEN_841 : _GEN_439; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_851 = wbCountOn ? _GEN_842 : _GEN_440; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_852 = wbCountOn ? _GEN_843 : _GEN_441; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_853 = _GEN_13057 | _GEN_845; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_854 = _GEN_13058 | _GEN_846; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_855 = _GEN_13059 | _GEN_847; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_856 = _GEN_13060 | _GEN_848; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_857 = _GEN_13061 | _GEN_849; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_858 = _GEN_13062 | _GEN_850; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_859 = _GEN_13063 | _GEN_851; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_860 = _GEN_13064 | _GEN_852; // @[POSIT_Locality.scala 55:47]
  wire  singleOpValidVec_0 = rb_entries_0_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 70:59]
  wire  _T_17 = rb_entries_0_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_1 = singleOpValidVec_0 & _T_17; // @[POSIT_Locality.scala 72:110]
  wire  _T_19 = rb_entries_0_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_2 = singleOpValidVec_1 & _T_19; // @[POSIT_Locality.scala 72:110]
  wire  singleOpValidVec_3 = rb_entries_1_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 70:59]
  wire  _T_22 = rb_entries_1_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_4 = singleOpValidVec_3 & _T_22; // @[POSIT_Locality.scala 72:110]
  wire  _T_24 = rb_entries_1_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_5 = singleOpValidVec_4 & _T_24; // @[POSIT_Locality.scala 72:110]
  wire  singleOpValidVec_6 = rb_entries_2_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 70:59]
  wire  _T_27 = rb_entries_2_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_7 = singleOpValidVec_6 & _T_27; // @[POSIT_Locality.scala 72:110]
  wire  _T_29 = rb_entries_2_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_8 = singleOpValidVec_7 & _T_29; // @[POSIT_Locality.scala 72:110]
  wire  singleOpValidVec_9 = rb_entries_3_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 70:59]
  wire  _T_32 = rb_entries_3_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_10 = singleOpValidVec_9 & _T_32; // @[POSIT_Locality.scala 72:110]
  wire  _T_34 = rb_entries_3_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_11 = singleOpValidVec_10 & _T_34; // @[POSIT_Locality.scala 72:110]
  wire  singleOpValidVec_12 = rb_entries_4_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 70:59]
  wire  _T_37 = rb_entries_4_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_13 = singleOpValidVec_12 & _T_37; // @[POSIT_Locality.scala 72:110]
  wire  _T_39 = rb_entries_4_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_14 = singleOpValidVec_13 & _T_39; // @[POSIT_Locality.scala 72:110]
  wire  singleOpValidVec_15 = rb_entries_5_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 70:59]
  wire  _T_42 = rb_entries_5_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_16 = singleOpValidVec_15 & _T_42; // @[POSIT_Locality.scala 72:110]
  wire  _T_44 = rb_entries_5_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_17 = singleOpValidVec_16 & _T_44; // @[POSIT_Locality.scala 72:110]
  wire  singleOpValidVec_18 = rb_entries_6_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 70:59]
  wire  _T_47 = rb_entries_6_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_19 = singleOpValidVec_18 & _T_47; // @[POSIT_Locality.scala 72:110]
  wire  _T_49 = rb_entries_6_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_20 = singleOpValidVec_19 & _T_49; // @[POSIT_Locality.scala 72:110]
  wire  singleOpValidVec_21 = rb_entries_7_request_operands_0_mode == 2'h0; // @[POSIT_Locality.scala 70:59]
  wire  _T_52 = rb_entries_7_request_operands_1_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_22 = singleOpValidVec_21 & _T_52; // @[POSIT_Locality.scala 72:110]
  wire  _T_54 = rb_entries_7_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 72:153]
  wire  singleOpValidVec_23 = singleOpValidVec_22 & _T_54; // @[POSIT_Locality.scala 72:110]
  wire  _T_56 = singleOpValidVec_2 & rb_entries_0_valid; // @[POSIT_Locality.scala 78:60]
  wire  _T_57 = ~rb_entries_0_dispatched; // @[POSIT_Locality.scala 78:85]
  wire  waitingForDispatchVec_0 = _T_56 & _T_57; // @[POSIT_Locality.scala 78:82]
  wire  _T_59 = singleOpValidVec_5 & rb_entries_1_valid; // @[POSIT_Locality.scala 78:60]
  wire  _T_60 = ~rb_entries_1_dispatched; // @[POSIT_Locality.scala 78:85]
  wire  waitingForDispatchVec_1 = _T_59 & _T_60; // @[POSIT_Locality.scala 78:82]
  wire  _T_62 = singleOpValidVec_8 & rb_entries_2_valid; // @[POSIT_Locality.scala 78:60]
  wire  _T_63 = ~rb_entries_2_dispatched; // @[POSIT_Locality.scala 78:85]
  wire  waitingForDispatchVec_2 = _T_62 & _T_63; // @[POSIT_Locality.scala 78:82]
  wire  _T_65 = singleOpValidVec_11 & rb_entries_3_valid; // @[POSIT_Locality.scala 78:60]
  wire  _T_66 = ~rb_entries_3_dispatched; // @[POSIT_Locality.scala 78:85]
  wire  waitingForDispatchVec_3 = _T_65 & _T_66; // @[POSIT_Locality.scala 78:82]
  wire  _T_68 = singleOpValidVec_14 & rb_entries_4_valid; // @[POSIT_Locality.scala 78:60]
  wire  _T_69 = ~rb_entries_4_dispatched; // @[POSIT_Locality.scala 78:85]
  wire  waitingForDispatchVec_4 = _T_68 & _T_69; // @[POSIT_Locality.scala 78:82]
  wire  _T_71 = singleOpValidVec_17 & rb_entries_5_valid; // @[POSIT_Locality.scala 78:60]
  wire  _T_72 = ~rb_entries_5_dispatched; // @[POSIT_Locality.scala 78:85]
  wire  waitingForDispatchVec_5 = _T_71 & _T_72; // @[POSIT_Locality.scala 78:82]
  wire  _T_74 = singleOpValidVec_20 & rb_entries_6_valid; // @[POSIT_Locality.scala 78:60]
  wire  _T_75 = ~rb_entries_6_dispatched; // @[POSIT_Locality.scala 78:85]
  wire  waitingForDispatchVec_6 = _T_74 & _T_75; // @[POSIT_Locality.scala 78:82]
  wire  _T_77 = singleOpValidVec_23 & rb_entries_7_valid; // @[POSIT_Locality.scala 78:60]
  wire  _T_78 = ~rb_entries_7_dispatched; // @[POSIT_Locality.scala 78:85]
  wire  waitingForDispatchVec_7 = _T_77 & _T_78; // @[POSIT_Locality.scala 78:82]
  wire [3:0] _T_82 = {waitingForDispatchVec_3,waitingForDispatchVec_2,waitingForDispatchVec_1,waitingForDispatchVec_0}; // @[POSIT_Locality.scala 82:58]
  wire [3:0] _T_85 = {waitingForDispatchVec_7,waitingForDispatchVec_6,waitingForDispatchVec_5,waitingForDispatchVec_4}; // @[POSIT_Locality.scala 82:58]
  wire  _T_87 = dispatchArb_io_chosen == 3'h0; // @[POSIT_Locality.scala 87:81]
  wire  _T_88 = _T_87 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 87:94]
  wire  _T_89 = rb_entries_0_dispatched | _T_88; // @[POSIT_Locality.scala 87:70]
  wire  _T_90 = dispatchArb_io_chosen == 3'h1; // @[POSIT_Locality.scala 87:81]
  wire  _T_91 = _T_90 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 87:94]
  wire  _T_92 = rb_entries_1_dispatched | _T_91; // @[POSIT_Locality.scala 87:70]
  wire  _T_93 = dispatchArb_io_chosen == 3'h2; // @[POSIT_Locality.scala 87:81]
  wire  _T_94 = _T_93 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 87:94]
  wire  _T_95 = rb_entries_2_dispatched | _T_94; // @[POSIT_Locality.scala 87:70]
  wire  _T_96 = dispatchArb_io_chosen == 3'h3; // @[POSIT_Locality.scala 87:81]
  wire  _T_97 = _T_96 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 87:94]
  wire  _T_98 = rb_entries_3_dispatched | _T_97; // @[POSIT_Locality.scala 87:70]
  wire  _T_99 = dispatchArb_io_chosen == 3'h4; // @[POSIT_Locality.scala 87:81]
  wire  _T_100 = _T_99 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 87:94]
  wire  _T_101 = rb_entries_4_dispatched | _T_100; // @[POSIT_Locality.scala 87:70]
  wire  _T_102 = dispatchArb_io_chosen == 3'h5; // @[POSIT_Locality.scala 87:81]
  wire  _T_103 = _T_102 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 87:94]
  wire  _T_104 = rb_entries_5_dispatched | _T_103; // @[POSIT_Locality.scala 87:70]
  wire  _T_105 = dispatchArb_io_chosen == 3'h6; // @[POSIT_Locality.scala 87:81]
  wire  _T_106 = _T_105 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 87:94]
  wire  _T_107 = rb_entries_6_dispatched | _T_106; // @[POSIT_Locality.scala 87:70]
  wire  _T_108 = dispatchArb_io_chosen == 3'h7; // @[POSIT_Locality.scala 87:81]
  wire  _T_109 = _T_108 & dispatchArb_io_hasChosen; // @[POSIT_Locality.scala 87:94]
  wire  _T_110 = rb_entries_7_dispatched | _T_109; // @[POSIT_Locality.scala 87:70]
  wire  _T_111 = dispatchArb_io_hasChosen & pe_io_request_ready; // @[POSIT_Locality.scala 91:39]
  wire [31:0] _GEN_911 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_0_value : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_913 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_1_value : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_915 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_2_value : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_917 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_inst : rb_entries_0_request_inst; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_918 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_mode : rb_entries_0_request_mode; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_941 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_0_value : _GEN_911; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_943 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_1_value : _GEN_913; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_945 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_2_value : _GEN_915; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_947 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_inst : _GEN_917; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_948 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_mode : _GEN_918; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_971 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_0_value : _GEN_941; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_973 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_1_value : _GEN_943; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_975 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_2_value : _GEN_945; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_977 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_inst : _GEN_947; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_978 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_mode : _GEN_948; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1001 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_0_value : _GEN_971; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1003 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_1_value : _GEN_973; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1005 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_2_value : _GEN_975; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1007 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_inst : _GEN_977; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1008 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_mode : _GEN_978; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1031 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_0_value : _GEN_1001; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1033 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_1_value : _GEN_1003; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1035 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_2_value : _GEN_1005; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1037 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_inst : _GEN_1007; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1038 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_mode : _GEN_1008; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1061 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_0_value : _GEN_1031; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1063 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_1_value : _GEN_1033; // @[POSIT_Locality.scala 100:80]
  wire [31:0] _GEN_1065 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_2_value : _GEN_1035; // @[POSIT_Locality.scala 100:80]
  wire [2:0] _GEN_1067 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_inst : _GEN_1037; // @[POSIT_Locality.scala 100:80]
  wire [1:0] _GEN_1068 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_mode : _GEN_1038; // @[POSIT_Locality.scala 100:80]
  wire  _T_116 = pe_io_result_ready & pe_io_result_valid; // @[POSIT_Locality.scala 108:33]
  wire [2:0] result_idx = processQueue_io_deq_bits; // @[POSIT_Locality.scala 106:30 POSIT_Locality.scala 107:20]
  wire [4:0] _rb_entries_result_idx_result_exceptions = pe_io_result_bits_exceptions; // @[POSIT_Locality.scala 110:47 POSIT_Locality.scala 110:47]
  wire  _rb_entries_result_idx_result_gt = pe_io_result_bits_gt; // @[POSIT_Locality.scala 110:47 POSIT_Locality.scala 110:47]
  wire  _rb_entries_result_idx_result_eq = pe_io_result_bits_eq; // @[POSIT_Locality.scala 110:47 POSIT_Locality.scala 110:47]
  wire  _rb_entries_result_idx_result_lt = pe_io_result_bits_lt; // @[POSIT_Locality.scala 110:47 POSIT_Locality.scala 110:47]
  wire [31:0] _rb_entries_result_idx_result_out = pe_io_result_bits_out; // @[POSIT_Locality.scala 110:47 POSIT_Locality.scala 110:47]
  wire  _rb_entries_result_idx_result_isNaR = pe_io_result_bits_isNaR; // @[POSIT_Locality.scala 110:47 POSIT_Locality.scala 110:47]
  wire  _rb_entries_result_idx_result_isZero = pe_io_result_bits_isZero; // @[POSIT_Locality.scala 110:47 POSIT_Locality.scala 110:47]
  wire  _GEN_13073 = 3'h0 == result_idx; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_1166 = _GEN_13073 | _GEN_418; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_13074 = 3'h1 == result_idx; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_1167 = _GEN_13074 | _GEN_419; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_13075 = 3'h2 == result_idx; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_1168 = _GEN_13075 | _GEN_420; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_13076 = 3'h3 == result_idx; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_1169 = _GEN_13076 | _GEN_421; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_13077 = 3'h4 == result_idx; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_1170 = _GEN_13077 | _GEN_422; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_13078 = 3'h5 == result_idx; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_1171 = _GEN_13078 | _GEN_423; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_13079 = 3'h6 == result_idx; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_1172 = _GEN_13079 | _GEN_424; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_13080 = 3'h7 == result_idx; // @[POSIT_Locality.scala 111:50]
  wire  _GEN_1173 = _GEN_13080 | _GEN_425; // @[POSIT_Locality.scala 111:50]
  wire  _T_117 = rb_entries_0_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_1275 = 3'h1 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1305 = 3'h2 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_1275; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1335 = 3'h3 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_1305; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1365 = 3'h4 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_1335; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1395 = 3'h5 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_1365; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1425 = 3'h6 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_1395; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1455 = 3'h7 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_1425; // @[POSIT_Locality.scala 120:100]
  wire  _T_120 = rb_entries_0_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_1759 = 3'h1 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1789 = 3'h2 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_1759; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1819 = 3'h3 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_1789; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1849 = 3'h4 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_1819; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1879 = 3'h5 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_1849; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1909 = 3'h6 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_1879; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_1939 = 3'h7 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_1909; // @[POSIT_Locality.scala 120:100]
  wire  _T_123 = rb_entries_0_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_2243 = 3'h1 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2273 = 3'h2 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_2243; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2303 = 3'h3 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_2273; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2333 = 3'h4 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_2303; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2363 = 3'h5 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_2333; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2393 = 3'h6 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_2363; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2423 = 3'h7 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_2393; // @[POSIT_Locality.scala 120:100]
  wire  _T_126 = rb_entries_1_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_2727 = 3'h1 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2757 = 3'h2 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_2727; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2787 = 3'h3 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_2757; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2817 = 3'h4 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_2787; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2847 = 3'h5 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_2817; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2877 = 3'h6 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_2847; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_2907 = 3'h7 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_2877; // @[POSIT_Locality.scala 120:100]
  wire  _T_129 = rb_entries_1_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_3211 = 3'h1 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3241 = 3'h2 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_3211; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3271 = 3'h3 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_3241; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3301 = 3'h4 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_3271; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3331 = 3'h5 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_3301; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3361 = 3'h6 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_3331; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3391 = 3'h7 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_3361; // @[POSIT_Locality.scala 120:100]
  wire  _T_132 = rb_entries_1_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_3695 = 3'h1 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3725 = 3'h2 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_3695; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3755 = 3'h3 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_3725; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3785 = 3'h4 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_3755; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3815 = 3'h5 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_3785; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3845 = 3'h6 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_3815; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_3875 = 3'h7 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_3845; // @[POSIT_Locality.scala 120:100]
  wire  _T_135 = rb_entries_2_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_4179 = 3'h1 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4209 = 3'h2 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_4179; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4239 = 3'h3 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_4209; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4269 = 3'h4 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_4239; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4299 = 3'h5 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_4269; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4329 = 3'h6 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_4299; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4359 = 3'h7 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_4329; // @[POSIT_Locality.scala 120:100]
  wire  _T_138 = rb_entries_2_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_4663 = 3'h1 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4693 = 3'h2 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_4663; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4723 = 3'h3 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_4693; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4753 = 3'h4 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_4723; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4783 = 3'h5 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_4753; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4813 = 3'h6 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_4783; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_4843 = 3'h7 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_4813; // @[POSIT_Locality.scala 120:100]
  wire  _T_141 = rb_entries_2_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_5147 = 3'h1 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5177 = 3'h2 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_5147; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5207 = 3'h3 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_5177; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5237 = 3'h4 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_5207; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5267 = 3'h5 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_5237; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5297 = 3'h6 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_5267; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5327 = 3'h7 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_5297; // @[POSIT_Locality.scala 120:100]
  wire  _T_144 = rb_entries_3_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_5631 = 3'h1 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5661 = 3'h2 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_5631; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5691 = 3'h3 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_5661; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5721 = 3'h4 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_5691; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5751 = 3'h5 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_5721; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5781 = 3'h6 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_5751; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_5811 = 3'h7 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_5781; // @[POSIT_Locality.scala 120:100]
  wire  _T_147 = rb_entries_3_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_6115 = 3'h1 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6145 = 3'h2 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_6115; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6175 = 3'h3 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_6145; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6205 = 3'h4 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_6175; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6235 = 3'h5 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_6205; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6265 = 3'h6 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_6235; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6295 = 3'h7 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_6265; // @[POSIT_Locality.scala 120:100]
  wire  _T_150 = rb_entries_3_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_6599 = 3'h1 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6629 = 3'h2 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_6599; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6659 = 3'h3 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_6629; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6689 = 3'h4 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_6659; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6719 = 3'h5 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_6689; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6749 = 3'h6 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_6719; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_6779 = 3'h7 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_6749; // @[POSIT_Locality.scala 120:100]
  wire  _T_153 = rb_entries_4_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_7083 = 3'h1 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7113 = 3'h2 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_7083; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7143 = 3'h3 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_7113; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7173 = 3'h4 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_7143; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7203 = 3'h5 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_7173; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7233 = 3'h6 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_7203; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7263 = 3'h7 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_7233; // @[POSIT_Locality.scala 120:100]
  wire  _T_156 = rb_entries_4_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_7567 = 3'h1 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7597 = 3'h2 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_7567; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7627 = 3'h3 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_7597; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7657 = 3'h4 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_7627; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7687 = 3'h5 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_7657; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7717 = 3'h6 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_7687; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_7747 = 3'h7 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_7717; // @[POSIT_Locality.scala 120:100]
  wire  _T_159 = rb_entries_4_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_8051 = 3'h1 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8081 = 3'h2 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_8051; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8111 = 3'h3 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_8081; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8141 = 3'h4 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_8111; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8171 = 3'h5 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_8141; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8201 = 3'h6 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_8171; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8231 = 3'h7 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_8201; // @[POSIT_Locality.scala 120:100]
  wire  _T_162 = rb_entries_5_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_8535 = 3'h1 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8565 = 3'h2 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_8535; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8595 = 3'h3 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_8565; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8625 = 3'h4 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_8595; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8655 = 3'h5 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_8625; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8685 = 3'h6 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_8655; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_8715 = 3'h7 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_8685; // @[POSIT_Locality.scala 120:100]
  wire  _T_165 = rb_entries_5_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_9019 = 3'h1 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9049 = 3'h2 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_9019; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9079 = 3'h3 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_9049; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9109 = 3'h4 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_9079; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9139 = 3'h5 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_9109; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9169 = 3'h6 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_9139; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9199 = 3'h7 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_9169; // @[POSIT_Locality.scala 120:100]
  wire  _T_168 = rb_entries_5_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_9503 = 3'h1 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9533 = 3'h2 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_9503; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9563 = 3'h3 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_9533; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9593 = 3'h4 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_9563; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9623 = 3'h5 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_9593; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9653 = 3'h6 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_9623; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_9683 = 3'h7 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_9653; // @[POSIT_Locality.scala 120:100]
  wire  _T_171 = rb_entries_6_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_9987 = 3'h1 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10017 = 3'h2 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_9987; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10047 = 3'h3 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_10017; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10077 = 3'h4 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_10047; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10107 = 3'h5 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_10077; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10137 = 3'h6 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_10107; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10167 = 3'h7 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_10137; // @[POSIT_Locality.scala 120:100]
  wire  _T_174 = rb_entries_6_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_10471 = 3'h1 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10501 = 3'h2 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_10471; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10531 = 3'h3 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_10501; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10561 = 3'h4 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_10531; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10591 = 3'h5 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_10561; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10621 = 3'h6 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_10591; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10651 = 3'h7 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_10621; // @[POSIT_Locality.scala 120:100]
  wire  _T_177 = rb_entries_6_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_10955 = 3'h1 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_10985 = 3'h2 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_10955; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11015 = 3'h3 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_10985; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11045 = 3'h4 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_11015; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11075 = 3'h5 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_11045; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11105 = 3'h6 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_11075; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11135 = 3'h7 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_11105; // @[POSIT_Locality.scala 120:100]
  wire  _T_180 = rb_entries_7_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_11439 = 3'h1 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11469 = 3'h2 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_11439; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11499 = 3'h3 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_11469; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11529 = 3'h4 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_11499; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11559 = 3'h5 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_11529; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11589 = 3'h6 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_11559; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11619 = 3'h7 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_11589; // @[POSIT_Locality.scala 120:100]
  wire  _T_183 = rb_entries_7_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_11923 = 3'h1 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11953 = 3'h2 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_11923; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_11983 = 3'h3 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_11953; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12013 = 3'h4 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_11983; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12043 = 3'h5 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_12013; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12073 = 3'h6 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_12043; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12103 = 3'h7 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_12073; // @[POSIT_Locality.scala 120:100]
  wire  _T_186 = rb_entries_7_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 119:69]
  wire  _GEN_12407 = 3'h1 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12437 = 3'h2 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_12407; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12467 = 3'h3 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_12437; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12497 = 3'h4 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_12467; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12527 = 3'h5 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_12497; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12557 = 3'h6 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_12527; // @[POSIT_Locality.scala 120:100]
  wire  _GEN_12587 = 3'h7 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_12557; // @[POSIT_Locality.scala 120:100]
  wire  _T_189 = rb_entries_0_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire [31:0] _GEN_13081 = {{24'd0}, io_mem_read_resp_tag}; // @[POSIT_Locality.scala 134:86]
  wire  _T_190 = rb_entries_0_request_operands_0_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_191 = rb_entries_0_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_192 = rb_entries_0_request_operands_1_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_193 = rb_entries_0_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_194 = rb_entries_0_request_operands_2_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_195 = rb_entries_1_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_196 = rb_entries_1_request_operands_0_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_197 = rb_entries_1_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_198 = rb_entries_1_request_operands_1_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_199 = rb_entries_1_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_200 = rb_entries_1_request_operands_2_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_201 = rb_entries_2_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_202 = rb_entries_2_request_operands_0_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_203 = rb_entries_2_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_204 = rb_entries_2_request_operands_1_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_205 = rb_entries_2_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_206 = rb_entries_2_request_operands_2_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_207 = rb_entries_3_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_208 = rb_entries_3_request_operands_0_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_209 = rb_entries_3_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_210 = rb_entries_3_request_operands_1_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_211 = rb_entries_3_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_212 = rb_entries_3_request_operands_2_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_213 = rb_entries_4_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_214 = rb_entries_4_request_operands_0_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_215 = rb_entries_4_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_216 = rb_entries_4_request_operands_1_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_217 = rb_entries_4_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_218 = rb_entries_4_request_operands_2_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_219 = rb_entries_5_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_220 = rb_entries_5_request_operands_0_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_221 = rb_entries_5_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_222 = rb_entries_5_request_operands_1_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_223 = rb_entries_5_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_224 = rb_entries_5_request_operands_2_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_225 = rb_entries_6_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_226 = rb_entries_6_request_operands_0_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_227 = rb_entries_6_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_228 = rb_entries_6_request_operands_1_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_229 = rb_entries_6_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_230 = rb_entries_6_request_operands_2_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_231 = rb_entries_7_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_232 = rb_entries_7_request_operands_0_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_233 = rb_entries_7_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_234 = rb_entries_7_request_operands_1_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_235 = rb_entries_7_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 133:77]
  wire  _T_236 = rb_entries_7_request_operands_2_value == _GEN_13081; // @[POSIT_Locality.scala 134:86]
  wire  _T_238 = rb_entries_0_valid & _T_189; // @[POSIT_Locality.scala 150:53]
  wire  _T_239 = ~rb_entries_0_request_inFetch_0; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_0 = _T_238 & _T_239; // @[POSIT_Locality.scala 150:105]
  wire  _T_242 = rb_entries_0_valid & _T_191; // @[POSIT_Locality.scala 150:53]
  wire  _T_243 = ~rb_entries_0_request_inFetch_1; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_1 = _T_242 & _T_243; // @[POSIT_Locality.scala 150:105]
  wire  _T_246 = rb_entries_0_valid & _T_193; // @[POSIT_Locality.scala 150:53]
  wire  _T_247 = ~rb_entries_0_request_inFetch_2; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_2 = _T_246 & _T_247; // @[POSIT_Locality.scala 150:105]
  wire  _T_250 = rb_entries_1_valid & _T_195; // @[POSIT_Locality.scala 150:53]
  wire  _T_251 = ~rb_entries_1_request_inFetch_0; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_3 = _T_250 & _T_251; // @[POSIT_Locality.scala 150:105]
  wire  _T_254 = rb_entries_1_valid & _T_197; // @[POSIT_Locality.scala 150:53]
  wire  _T_255 = ~rb_entries_1_request_inFetch_1; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_4 = _T_254 & _T_255; // @[POSIT_Locality.scala 150:105]
  wire  _T_258 = rb_entries_1_valid & _T_199; // @[POSIT_Locality.scala 150:53]
  wire  _T_259 = ~rb_entries_1_request_inFetch_2; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_5 = _T_258 & _T_259; // @[POSIT_Locality.scala 150:105]
  wire  _T_262 = rb_entries_2_valid & _T_201; // @[POSIT_Locality.scala 150:53]
  wire  _T_263 = ~rb_entries_2_request_inFetch_0; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_6 = _T_262 & _T_263; // @[POSIT_Locality.scala 150:105]
  wire  _T_266 = rb_entries_2_valid & _T_203; // @[POSIT_Locality.scala 150:53]
  wire  _T_267 = ~rb_entries_2_request_inFetch_1; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_7 = _T_266 & _T_267; // @[POSIT_Locality.scala 150:105]
  wire  _T_270 = rb_entries_2_valid & _T_205; // @[POSIT_Locality.scala 150:53]
  wire  _T_271 = ~rb_entries_2_request_inFetch_2; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_8 = _T_270 & _T_271; // @[POSIT_Locality.scala 150:105]
  wire  _T_274 = rb_entries_3_valid & _T_207; // @[POSIT_Locality.scala 150:53]
  wire  _T_275 = ~rb_entries_3_request_inFetch_0; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_9 = _T_274 & _T_275; // @[POSIT_Locality.scala 150:105]
  wire  _T_278 = rb_entries_3_valid & _T_209; // @[POSIT_Locality.scala 150:53]
  wire  _T_279 = ~rb_entries_3_request_inFetch_1; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_10 = _T_278 & _T_279; // @[POSIT_Locality.scala 150:105]
  wire  _T_282 = rb_entries_3_valid & _T_211; // @[POSIT_Locality.scala 150:53]
  wire  _T_283 = ~rb_entries_3_request_inFetch_2; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_11 = _T_282 & _T_283; // @[POSIT_Locality.scala 150:105]
  wire  _T_286 = rb_entries_4_valid & _T_213; // @[POSIT_Locality.scala 150:53]
  wire  _T_287 = ~rb_entries_4_request_inFetch_0; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_12 = _T_286 & _T_287; // @[POSIT_Locality.scala 150:105]
  wire  _T_290 = rb_entries_4_valid & _T_215; // @[POSIT_Locality.scala 150:53]
  wire  _T_291 = ~rb_entries_4_request_inFetch_1; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_13 = _T_290 & _T_291; // @[POSIT_Locality.scala 150:105]
  wire  _T_294 = rb_entries_4_valid & _T_217; // @[POSIT_Locality.scala 150:53]
  wire  _T_295 = ~rb_entries_4_request_inFetch_2; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_14 = _T_294 & _T_295; // @[POSIT_Locality.scala 150:105]
  wire  _T_298 = rb_entries_5_valid & _T_219; // @[POSIT_Locality.scala 150:53]
  wire  _T_299 = ~rb_entries_5_request_inFetch_0; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_15 = _T_298 & _T_299; // @[POSIT_Locality.scala 150:105]
  wire  _T_302 = rb_entries_5_valid & _T_221; // @[POSIT_Locality.scala 150:53]
  wire  _T_303 = ~rb_entries_5_request_inFetch_1; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_16 = _T_302 & _T_303; // @[POSIT_Locality.scala 150:105]
  wire  _T_306 = rb_entries_5_valid & _T_223; // @[POSIT_Locality.scala 150:53]
  wire  _T_307 = ~rb_entries_5_request_inFetch_2; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_17 = _T_306 & _T_307; // @[POSIT_Locality.scala 150:105]
  wire  _T_310 = rb_entries_6_valid & _T_225; // @[POSIT_Locality.scala 150:53]
  wire  _T_311 = ~rb_entries_6_request_inFetch_0; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_18 = _T_310 & _T_311; // @[POSIT_Locality.scala 150:105]
  wire  _T_314 = rb_entries_6_valid & _T_227; // @[POSIT_Locality.scala 150:53]
  wire  _T_315 = ~rb_entries_6_request_inFetch_1; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_19 = _T_314 & _T_315; // @[POSIT_Locality.scala 150:105]
  wire  _T_318 = rb_entries_6_valid & _T_229; // @[POSIT_Locality.scala 150:53]
  wire  _T_319 = ~rb_entries_6_request_inFetch_2; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_20 = _T_318 & _T_319; // @[POSIT_Locality.scala 150:105]
  wire  _T_322 = rb_entries_7_valid & _T_231; // @[POSIT_Locality.scala 150:53]
  wire  _T_323 = ~rb_entries_7_request_inFetch_0; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_21 = _T_322 & _T_323; // @[POSIT_Locality.scala 150:105]
  wire  _T_326 = rb_entries_7_valid & _T_233; // @[POSIT_Locality.scala 150:53]
  wire  _T_327 = ~rb_entries_7_request_inFetch_1; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_22 = _T_326 & _T_327; // @[POSIT_Locality.scala 150:105]
  wire  _T_330 = rb_entries_7_valid & _T_235; // @[POSIT_Locality.scala 150:53]
  wire  _T_331 = ~rb_entries_7_request_inFetch_2; // @[POSIT_Locality.scala 150:109]
  wire  waitingToBeFetched_23 = _T_330 & _T_331; // @[POSIT_Locality.scala 150:105]
  wire [5:0] _T_337 = {waitingToBeFetched_5,waitingToBeFetched_4,waitingToBeFetched_3,waitingToBeFetched_2,waitingToBeFetched_1,waitingToBeFetched_0}; // @[POSIT_Locality.scala 156:52]
  wire [11:0] _T_343 = {waitingToBeFetched_11,waitingToBeFetched_10,waitingToBeFetched_9,waitingToBeFetched_8,waitingToBeFetched_7,waitingToBeFetched_6,_T_337}; // @[POSIT_Locality.scala 156:52]
  wire [5:0] _T_348 = {waitingToBeFetched_17,waitingToBeFetched_16,waitingToBeFetched_15,waitingToBeFetched_14,waitingToBeFetched_13,waitingToBeFetched_12}; // @[POSIT_Locality.scala 156:52]
  wire [11:0] _T_354 = {waitingToBeFetched_23,waitingToBeFetched_22,waitingToBeFetched_21,waitingToBeFetched_20,waitingToBeFetched_19,waitingToBeFetched_18,_T_348}; // @[POSIT_Locality.scala 156:52]
  wire [5:0] _T_360 = {rb_entries_1_request_inFetch_2,rb_entries_1_request_inFetch_1,rb_entries_1_request_inFetch_0,rb_entries_0_request_inFetch_2,rb_entries_0_request_inFetch_1,rb_entries_0_request_inFetch_0}; // @[POSIT_Locality.scala 165:42]
  wire [11:0] _T_366 = {rb_entries_3_request_inFetch_2,rb_entries_3_request_inFetch_1,rb_entries_3_request_inFetch_0,rb_entries_2_request_inFetch_2,rb_entries_2_request_inFetch_1,rb_entries_2_request_inFetch_0,_T_360}; // @[POSIT_Locality.scala 165:42]
  wire [5:0] _T_371 = {rb_entries_5_request_inFetch_2,rb_entries_5_request_inFetch_1,rb_entries_5_request_inFetch_0,rb_entries_4_request_inFetch_2,rb_entries_4_request_inFetch_1,rb_entries_4_request_inFetch_0}; // @[POSIT_Locality.scala 165:42]
  wire [23:0] _T_378 = {rb_entries_7_request_inFetch_2,rb_entries_7_request_inFetch_1,rb_entries_7_request_inFetch_0,rb_entries_6_request_inFetch_2,rb_entries_6_request_inFetch_1,rb_entries_6_request_inFetch_0,_T_371,_T_366}; // @[POSIT_Locality.scala 165:42]
  wire [31:0] _T_379 = 32'h1 << fetchArb_io_chosen; // @[OneHot.scala 58:35]
  wire [23:0] _T_381 = _T_378 ^ _T_379[23:0]; // @[POSIT_Locality.scala 165:49]
  wire [47:0] fetchOffSet_0 = {{16'd0}, rb_entries_0_request_operands_0_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] fetchOffSet_1 = {{16'd0}, rb_entries_0_request_operands_1_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13000 = 5'h1 == fetchArb_io_chosen ? fetchOffSet_1 : fetchOffSet_0; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_2 = {{16'd0}, rb_entries_0_request_operands_2_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13001 = 5'h2 == fetchArb_io_chosen ? fetchOffSet_2 : _GEN_13000; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_3 = {{16'd0}, rb_entries_1_request_operands_0_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13002 = 5'h3 == fetchArb_io_chosen ? fetchOffSet_3 : _GEN_13001; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_4 = {{16'd0}, rb_entries_1_request_operands_1_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13003 = 5'h4 == fetchArb_io_chosen ? fetchOffSet_4 : _GEN_13002; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_5 = {{16'd0}, rb_entries_1_request_operands_2_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13004 = 5'h5 == fetchArb_io_chosen ? fetchOffSet_5 : _GEN_13003; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_6 = {{16'd0}, rb_entries_2_request_operands_0_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13005 = 5'h6 == fetchArb_io_chosen ? fetchOffSet_6 : _GEN_13004; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_7 = {{16'd0}, rb_entries_2_request_operands_1_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13006 = 5'h7 == fetchArb_io_chosen ? fetchOffSet_7 : _GEN_13005; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_8 = {{16'd0}, rb_entries_2_request_operands_2_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13007 = 5'h8 == fetchArb_io_chosen ? fetchOffSet_8 : _GEN_13006; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_9 = {{16'd0}, rb_entries_3_request_operands_0_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13008 = 5'h9 == fetchArb_io_chosen ? fetchOffSet_9 : _GEN_13007; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_10 = {{16'd0}, rb_entries_3_request_operands_1_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13009 = 5'ha == fetchArb_io_chosen ? fetchOffSet_10 : _GEN_13008; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_11 = {{16'd0}, rb_entries_3_request_operands_2_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13010 = 5'hb == fetchArb_io_chosen ? fetchOffSet_11 : _GEN_13009; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_12 = {{16'd0}, rb_entries_4_request_operands_0_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13011 = 5'hc == fetchArb_io_chosen ? fetchOffSet_12 : _GEN_13010; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_13 = {{16'd0}, rb_entries_4_request_operands_1_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13012 = 5'hd == fetchArb_io_chosen ? fetchOffSet_13 : _GEN_13011; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_14 = {{16'd0}, rb_entries_4_request_operands_2_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13013 = 5'he == fetchArb_io_chosen ? fetchOffSet_14 : _GEN_13012; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_15 = {{16'd0}, rb_entries_5_request_operands_0_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13014 = 5'hf == fetchArb_io_chosen ? fetchOffSet_15 : _GEN_13013; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_16 = {{16'd0}, rb_entries_5_request_operands_1_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13015 = 5'h10 == fetchArb_io_chosen ? fetchOffSet_16 : _GEN_13014; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_17 = {{16'd0}, rb_entries_5_request_operands_2_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13016 = 5'h11 == fetchArb_io_chosen ? fetchOffSet_17 : _GEN_13015; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_18 = {{16'd0}, rb_entries_6_request_operands_0_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13017 = 5'h12 == fetchArb_io_chosen ? fetchOffSet_18 : _GEN_13016; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_19 = {{16'd0}, rb_entries_6_request_operands_1_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13018 = 5'h13 == fetchArb_io_chosen ? fetchOffSet_19 : _GEN_13017; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_20 = {{16'd0}, rb_entries_6_request_operands_2_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13019 = 5'h14 == fetchArb_io_chosen ? fetchOffSet_20 : _GEN_13018; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_21 = {{16'd0}, rb_entries_7_request_operands_0_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13020 = 5'h15 == fetchArb_io_chosen ? fetchOffSet_21 : _GEN_13019; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_22 = {{16'd0}, rb_entries_7_request_operands_1_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13021 = 5'h16 == fetchArb_io_chosen ? fetchOffSet_22 : _GEN_13020; // @[POSIT_Locality.scala 167:38]
  wire [47:0] fetchOffSet_23 = {{16'd0}, rb_entries_7_request_operands_2_value}; // @[POSIT_Locality.scala 144:31 POSIT_Locality.scala 151:60]
  wire [47:0] _GEN_13022 = 5'h17 == fetchArb_io_chosen ? fetchOffSet_23 : _GEN_13021; // @[POSIT_Locality.scala 167:38]
  Posit pe ( // @[POSIT_Locality.scala 10:24]
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
    .io_result_bits_exceptions(pe_io_result_bits_exceptions)
  );
  Queue processQueue ( // @[POSIT_Locality.scala 59:31]
    .clock(processQueue_clock),
    .reset(processQueue_reset),
    .io_enq_ready(processQueue_io_enq_ready),
    .io_enq_valid(processQueue_io_enq_valid),
    .io_enq_bits(processQueue_io_enq_bits),
    .io_deq_ready(processQueue_io_deq_ready),
    .io_deq_valid(processQueue_io_deq_valid),
    .io_deq_bits(processQueue_io_deq_bits)
  );
  DispatchArbiter dispatchArb ( // @[POSIT_Locality.scala 61:33]
    .io_validity(dispatchArb_io_validity),
    .io_priority(dispatchArb_io_priority),
    .io_chosen(dispatchArb_io_chosen),
    .io_hasChosen(dispatchArb_io_hasChosen)
  );
  DispatchArbiter_1 fetchArb ( // @[POSIT_Locality.scala 155:30]
    .io_validity(fetchArb_io_validity),
    .io_priority(fetchArb_io_priority),
    .io_chosen(fetchArb_io_chosen),
    .io_hasChosen(fetchArb_io_hasChosen)
  );
  assign io_request_ready = _GEN_221 | _T_5; // @[POSIT_Locality.scala 22:26]
  assign io_mem_write_valid = 3'h7 == value_1 ? rb_entries_7_completed : _GEN_782; // @[POSIT_Locality.scala 49:28]
  assign io_mem_write_bits_result_isZero = 3'h7 == value_1 ? rb_entries_7_result_isZero : _GEN_799; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_isNaR = 3'h7 == value_1 ? rb_entries_7_result_isNaR : _GEN_800; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_out = 3'h7 == value_1 ? rb_entries_7_result_out : _GEN_801; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_lt = 3'h7 == value_1 ? rb_entries_7_result_lt : _GEN_802; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_eq = 3'h7 == value_1 ? rb_entries_7_result_eq : _GEN_803; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_gt = 3'h7 == value_1 ? rb_entries_7_result_gt : _GEN_804; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_exceptions = 3'h7 == value_1 ? rb_entries_7_result_exceptions : _GEN_805; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_wr_addr = 3'h7 == value_1 ? rb_entries_7_wr_addr : _GEN_786; // @[POSIT_Locality.scala 50:35]
  assign io_mem_read_req_valid = fetchArb_io_hasChosen; // @[POSIT_Locality.scala 166:39 POSIT_Locality.scala 170:39]
  assign io_mem_read_req_addr = _GEN_13022[7:0]; // @[POSIT_Locality.scala 167:38 POSIT_Locality.scala 171:38]
  assign pe_clock = clock;
  assign pe_reset = reset;
  assign pe_io_request_valid = _T_111 & processQueue_io_enq_ready; // @[POSIT_Locality.scala 92:37 POSIT_Locality.scala 95:37]
  assign pe_io_request_bits_num1 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_0_value : _GEN_1061; // @[POSIT_Locality.scala 100:33]
  assign pe_io_request_bits_num2 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_1_value : _GEN_1063; // @[POSIT_Locality.scala 101:33]
  assign pe_io_request_bits_num3 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_2_value : _GEN_1065; // @[POSIT_Locality.scala 102:33]
  assign pe_io_request_bits_inst = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_inst : _GEN_1067; // @[POSIT_Locality.scala 104:33]
  assign pe_io_request_bits_mode = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_mode : _GEN_1068; // @[POSIT_Locality.scala 103:33]
  assign pe_io_result_ready = io_mem_write_ready; // @[POSIT_Locality.scala 99:28]
  assign processQueue_clock = clock;
  assign processQueue_reset = reset;
  assign processQueue_io_enq_valid = _T_111 & processQueue_io_enq_ready; // @[POSIT_Locality.scala 93:43 POSIT_Locality.scala 96:43]
  assign processQueue_io_enq_bits = dispatchArb_io_chosen; // @[POSIT_Locality.scala 90:34]
  assign processQueue_io_deq_ready = pe_io_result_ready & pe_io_result_valid; // @[POSIT_Locality.scala 109:43 POSIT_Locality.scala 113:43]
  assign dispatchArb_io_validity = {_T_85,_T_82}; // @[POSIT_Locality.scala 82:33]
  assign dispatchArb_io_priority = {{2'd0}, wbCountOn}; // @[POSIT_Locality.scala 83:33]
  assign fetchArb_io_validity = {_T_354,_T_343}; // @[POSIT_Locality.scala 156:30]
  assign fetchArb_io_priority = {{4'd0}, wbCountOn}; // @[POSIT_Locality.scala 157:30]
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
  _RAND_4 = {2{`RANDOM}};
  rb_entries_0_wr_addr = _RAND_4[47:0];
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
  _RAND_27 = {2{`RANDOM}};
  rb_entries_1_wr_addr = _RAND_27[47:0];
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
  _RAND_50 = {2{`RANDOM}};
  rb_entries_2_wr_addr = _RAND_50[47:0];
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
  _RAND_73 = {2{`RANDOM}};
  rb_entries_3_wr_addr = _RAND_73[47:0];
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
  _RAND_96 = {2{`RANDOM}};
  rb_entries_4_wr_addr = _RAND_96[47:0];
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
  _RAND_119 = {2{`RANDOM}};
  rb_entries_5_wr_addr = _RAND_119[47:0];
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
  _RAND_142 = {2{`RANDOM}};
  rb_entries_6_wr_addr = _RAND_142[47:0];
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
  _RAND_165 = {2{`RANDOM}};
  rb_entries_7_wr_addr = _RAND_165[47:0];
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
  value_1 = _RAND_185[2:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      rb_entries_0_completed <= 1'h0;
    end else if (_T_116) begin
      rb_entries_0_completed <= _GEN_1166;
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_0_valid <= _GEN_250;
    end
    if (reset) begin
      rb_entries_0_dispatched <= 1'h0;
    end else begin
      rb_entries_0_dispatched <= _T_89;
    end
    if (reset) begin
      rb_entries_0_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_0_written <= _GEN_853;
    end else if (wbCountOn) begin
      rb_entries_0_written <= _GEN_836;
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_wr_addr <= 48'h0;
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_wr_addr <= _rb_entries_value_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_0_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_189) begin
        if (_T_190) begin
          rb_entries_0_request_operands_0_value <= io_mem_read_data;
        end else if (_T_117) begin
          if (_GEN_1455) begin
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
            if (3'h0 == value) begin
              rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_117) begin
        if (_GEN_1455) begin
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
          if (3'h0 == value) begin
            rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_117) begin
      if (_GEN_1455) begin
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
        rb_entries_0_request_operands_0_value <= _GEN_498;
      end
    end else begin
      rb_entries_0_request_operands_0_value <= _GEN_498;
    end
    if (reset) begin
      rb_entries_0_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_189) begin
        if (_T_190) begin
          rb_entries_0_request_operands_0_mode <= 2'h0;
        end else if (_T_117) begin
          if (_GEN_1455) begin
            rb_entries_0_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h0 == value) begin
              rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_117) begin
        if (_GEN_1455) begin
          rb_entries_0_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_117) begin
      if (_GEN_1455) begin
        rb_entries_0_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_0_mode <= _GEN_490;
      end
    end else begin
      rb_entries_0_request_operands_0_mode <= _GEN_490;
    end
    if (reset) begin
      rb_entries_0_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_191) begin
        if (_T_192) begin
          rb_entries_0_request_operands_1_value <= io_mem_read_data;
        end else if (_T_120) begin
          if (_GEN_1939) begin
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
            if (3'h0 == value) begin
              rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_120) begin
        if (_GEN_1939) begin
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
          if (3'h0 == value) begin
            rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_120) begin
      if (_GEN_1939) begin
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
        rb_entries_0_request_operands_1_value <= _GEN_514;
      end
    end else begin
      rb_entries_0_request_operands_1_value <= _GEN_514;
    end
    if (reset) begin
      rb_entries_0_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_191) begin
        if (_T_192) begin
          rb_entries_0_request_operands_1_mode <= 2'h0;
        end else if (_T_120) begin
          if (_GEN_1939) begin
            rb_entries_0_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h0 == value) begin
              rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_120) begin
        if (_GEN_1939) begin
          rb_entries_0_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_120) begin
      if (_GEN_1939) begin
        rb_entries_0_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_1_mode <= _GEN_506;
      end
    end else begin
      rb_entries_0_request_operands_1_mode <= _GEN_506;
    end
    if (reset) begin
      rb_entries_0_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_193) begin
        if (_T_194) begin
          rb_entries_0_request_operands_2_value <= io_mem_read_data;
        end else if (_T_123) begin
          if (_GEN_2423) begin
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
            if (3'h0 == value) begin
              rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_123) begin
        if (_GEN_2423) begin
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
          if (3'h0 == value) begin
            rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_123) begin
      if (_GEN_2423) begin
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
        rb_entries_0_request_operands_2_value <= _GEN_530;
      end
    end else begin
      rb_entries_0_request_operands_2_value <= _GEN_530;
    end
    if (reset) begin
      rb_entries_0_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_193) begin
        if (_T_194) begin
          rb_entries_0_request_operands_2_mode <= 2'h0;
        end else if (_T_123) begin
          if (_GEN_2423) begin
            rb_entries_0_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h0 == value) begin
              rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_123) begin
        if (_GEN_2423) begin
          rb_entries_0_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h0 == value) begin
            rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_123) begin
      if (_GEN_2423) begin
        rb_entries_0_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_2_mode <= _GEN_522;
      end
    end else begin
      rb_entries_0_request_operands_2_mode <= _GEN_522;
    end
    if (reset) begin
      rb_entries_0_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_0_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_0_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_0 <= _T_381[0];
    end
    if (reset) begin
      rb_entries_0_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_1 <= _T_381[1];
    end
    if (reset) begin
      rb_entries_0_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_2 <= _T_381[2];
    end
    if (reset) begin
      rb_entries_0_result_isZero <= 1'h0;
    end else if (_T_116) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_isNaR <= 1'h0;
    end else if (_T_116) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_out <= 32'h0;
    end else if (_T_116) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_lt <= 1'h0;
    end else if (_T_116) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_eq <= 1'h0;
    end else if (_T_116) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_gt <= 1'h0;
    end else if (_T_116) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_0_result_exceptions <= 5'h0;
    end else if (_T_116) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_1_completed <= 1'h0;
    end else if (_T_116) begin
      rb_entries_1_completed <= _GEN_1167;
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_1_valid <= _GEN_251;
    end
    if (reset) begin
      rb_entries_1_dispatched <= 1'h0;
    end else begin
      rb_entries_1_dispatched <= _T_92;
    end
    if (reset) begin
      rb_entries_1_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_1_written <= _GEN_854;
    end else if (wbCountOn) begin
      rb_entries_1_written <= _GEN_837;
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_wr_addr <= 48'h0;
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_wr_addr <= _rb_entries_value_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_1_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_195) begin
        if (_T_196) begin
          rb_entries_1_request_operands_0_value <= io_mem_read_data;
        end else if (_T_126) begin
          if (_GEN_2907) begin
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
            if (3'h1 == value) begin
              rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_126) begin
        if (_GEN_2907) begin
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
          if (3'h1 == value) begin
            rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_126) begin
      if (_GEN_2907) begin
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
        rb_entries_1_request_operands_0_value <= _GEN_499;
      end
    end else begin
      rb_entries_1_request_operands_0_value <= _GEN_499;
    end
    if (reset) begin
      rb_entries_1_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_195) begin
        if (_T_196) begin
          rb_entries_1_request_operands_0_mode <= 2'h0;
        end else if (_T_126) begin
          if (_GEN_2907) begin
            rb_entries_1_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h1 == value) begin
              rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_126) begin
        if (_GEN_2907) begin
          rb_entries_1_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_126) begin
      if (_GEN_2907) begin
        rb_entries_1_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_0_mode <= _GEN_491;
      end
    end else begin
      rb_entries_1_request_operands_0_mode <= _GEN_491;
    end
    if (reset) begin
      rb_entries_1_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_197) begin
        if (_T_198) begin
          rb_entries_1_request_operands_1_value <= io_mem_read_data;
        end else if (_T_129) begin
          if (_GEN_3391) begin
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
            if (3'h1 == value) begin
              rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_129) begin
        if (_GEN_3391) begin
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
          if (3'h1 == value) begin
            rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_129) begin
      if (_GEN_3391) begin
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
        rb_entries_1_request_operands_1_value <= _GEN_515;
      end
    end else begin
      rb_entries_1_request_operands_1_value <= _GEN_515;
    end
    if (reset) begin
      rb_entries_1_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_197) begin
        if (_T_198) begin
          rb_entries_1_request_operands_1_mode <= 2'h0;
        end else if (_T_129) begin
          if (_GEN_3391) begin
            rb_entries_1_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h1 == value) begin
              rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_129) begin
        if (_GEN_3391) begin
          rb_entries_1_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_129) begin
      if (_GEN_3391) begin
        rb_entries_1_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_1_mode <= _GEN_507;
      end
    end else begin
      rb_entries_1_request_operands_1_mode <= _GEN_507;
    end
    if (reset) begin
      rb_entries_1_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_199) begin
        if (_T_200) begin
          rb_entries_1_request_operands_2_value <= io_mem_read_data;
        end else if (_T_132) begin
          if (_GEN_3875) begin
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
            if (3'h1 == value) begin
              rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_132) begin
        if (_GEN_3875) begin
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
          if (3'h1 == value) begin
            rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_132) begin
      if (_GEN_3875) begin
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
        rb_entries_1_request_operands_2_value <= _GEN_531;
      end
    end else begin
      rb_entries_1_request_operands_2_value <= _GEN_531;
    end
    if (reset) begin
      rb_entries_1_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_199) begin
        if (_T_200) begin
          rb_entries_1_request_operands_2_mode <= 2'h0;
        end else if (_T_132) begin
          if (_GEN_3875) begin
            rb_entries_1_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h1 == value) begin
              rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_132) begin
        if (_GEN_3875) begin
          rb_entries_1_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h1 == value) begin
            rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_132) begin
      if (_GEN_3875) begin
        rb_entries_1_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_2_mode <= _GEN_523;
      end
    end else begin
      rb_entries_1_request_operands_2_mode <= _GEN_523;
    end
    if (reset) begin
      rb_entries_1_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_1_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_1_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_0 <= _T_381[3];
    end
    if (reset) begin
      rb_entries_1_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_1 <= _T_381[4];
    end
    if (reset) begin
      rb_entries_1_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_2 <= _T_381[5];
    end
    if (reset) begin
      rb_entries_1_result_isZero <= 1'h0;
    end else if (_T_116) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_isNaR <= 1'h0;
    end else if (_T_116) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_out <= 32'h0;
    end else if (_T_116) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_lt <= 1'h0;
    end else if (_T_116) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_eq <= 1'h0;
    end else if (_T_116) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_gt <= 1'h0;
    end else if (_T_116) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_1_result_exceptions <= 5'h0;
    end else if (_T_116) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_2_completed <= 1'h0;
    end else if (_T_116) begin
      rb_entries_2_completed <= _GEN_1168;
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_2_valid <= _GEN_252;
    end
    if (reset) begin
      rb_entries_2_dispatched <= 1'h0;
    end else begin
      rb_entries_2_dispatched <= _T_95;
    end
    if (reset) begin
      rb_entries_2_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_2_written <= _GEN_855;
    end else if (wbCountOn) begin
      rb_entries_2_written <= _GEN_838;
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_wr_addr <= 48'h0;
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_wr_addr <= _rb_entries_value_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_2_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_201) begin
        if (_T_202) begin
          rb_entries_2_request_operands_0_value <= io_mem_read_data;
        end else if (_T_135) begin
          if (_GEN_4359) begin
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
            if (3'h2 == value) begin
              rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_135) begin
        if (_GEN_4359) begin
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
          if (3'h2 == value) begin
            rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_135) begin
      if (_GEN_4359) begin
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
        rb_entries_2_request_operands_0_value <= _GEN_500;
      end
    end else begin
      rb_entries_2_request_operands_0_value <= _GEN_500;
    end
    if (reset) begin
      rb_entries_2_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_201) begin
        if (_T_202) begin
          rb_entries_2_request_operands_0_mode <= 2'h0;
        end else if (_T_135) begin
          if (_GEN_4359) begin
            rb_entries_2_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h2 == value) begin
              rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_135) begin
        if (_GEN_4359) begin
          rb_entries_2_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_135) begin
      if (_GEN_4359) begin
        rb_entries_2_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_0_mode <= _GEN_492;
      end
    end else begin
      rb_entries_2_request_operands_0_mode <= _GEN_492;
    end
    if (reset) begin
      rb_entries_2_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_203) begin
        if (_T_204) begin
          rb_entries_2_request_operands_1_value <= io_mem_read_data;
        end else if (_T_138) begin
          if (_GEN_4843) begin
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
            if (3'h2 == value) begin
              rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_138) begin
        if (_GEN_4843) begin
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
          if (3'h2 == value) begin
            rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_138) begin
      if (_GEN_4843) begin
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
        rb_entries_2_request_operands_1_value <= _GEN_516;
      end
    end else begin
      rb_entries_2_request_operands_1_value <= _GEN_516;
    end
    if (reset) begin
      rb_entries_2_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_203) begin
        if (_T_204) begin
          rb_entries_2_request_operands_1_mode <= 2'h0;
        end else if (_T_138) begin
          if (_GEN_4843) begin
            rb_entries_2_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h2 == value) begin
              rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_138) begin
        if (_GEN_4843) begin
          rb_entries_2_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_138) begin
      if (_GEN_4843) begin
        rb_entries_2_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_1_mode <= _GEN_508;
      end
    end else begin
      rb_entries_2_request_operands_1_mode <= _GEN_508;
    end
    if (reset) begin
      rb_entries_2_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_205) begin
        if (_T_206) begin
          rb_entries_2_request_operands_2_value <= io_mem_read_data;
        end else if (_T_141) begin
          if (_GEN_5327) begin
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
            if (3'h2 == value) begin
              rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_141) begin
        if (_GEN_5327) begin
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
          if (3'h2 == value) begin
            rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_141) begin
      if (_GEN_5327) begin
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
        rb_entries_2_request_operands_2_value <= _GEN_532;
      end
    end else begin
      rb_entries_2_request_operands_2_value <= _GEN_532;
    end
    if (reset) begin
      rb_entries_2_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_205) begin
        if (_T_206) begin
          rb_entries_2_request_operands_2_mode <= 2'h0;
        end else if (_T_141) begin
          if (_GEN_5327) begin
            rb_entries_2_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h2 == value) begin
              rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_141) begin
        if (_GEN_5327) begin
          rb_entries_2_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h2 == value) begin
            rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_141) begin
      if (_GEN_5327) begin
        rb_entries_2_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_2_mode <= _GEN_524;
      end
    end else begin
      rb_entries_2_request_operands_2_mode <= _GEN_524;
    end
    if (reset) begin
      rb_entries_2_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_2_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_2_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_0 <= _T_381[6];
    end
    if (reset) begin
      rb_entries_2_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_1 <= _T_381[7];
    end
    if (reset) begin
      rb_entries_2_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_2 <= _T_381[8];
    end
    if (reset) begin
      rb_entries_2_result_isZero <= 1'h0;
    end else if (_T_116) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_isNaR <= 1'h0;
    end else if (_T_116) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_out <= 32'h0;
    end else if (_T_116) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_lt <= 1'h0;
    end else if (_T_116) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_eq <= 1'h0;
    end else if (_T_116) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_gt <= 1'h0;
    end else if (_T_116) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_2_result_exceptions <= 5'h0;
    end else if (_T_116) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_3_completed <= 1'h0;
    end else if (_T_116) begin
      rb_entries_3_completed <= _GEN_1169;
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_3_valid <= _GEN_253;
    end
    if (reset) begin
      rb_entries_3_dispatched <= 1'h0;
    end else begin
      rb_entries_3_dispatched <= _T_98;
    end
    if (reset) begin
      rb_entries_3_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_3_written <= _GEN_856;
    end else if (wbCountOn) begin
      rb_entries_3_written <= _GEN_839;
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_wr_addr <= 48'h0;
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_wr_addr <= _rb_entries_value_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_3_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_207) begin
        if (_T_208) begin
          rb_entries_3_request_operands_0_value <= io_mem_read_data;
        end else if (_T_144) begin
          if (_GEN_5811) begin
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
            if (3'h3 == value) begin
              rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_144) begin
        if (_GEN_5811) begin
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
          if (3'h3 == value) begin
            rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_144) begin
      if (_GEN_5811) begin
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
        rb_entries_3_request_operands_0_value <= _GEN_501;
      end
    end else begin
      rb_entries_3_request_operands_0_value <= _GEN_501;
    end
    if (reset) begin
      rb_entries_3_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_207) begin
        if (_T_208) begin
          rb_entries_3_request_operands_0_mode <= 2'h0;
        end else if (_T_144) begin
          if (_GEN_5811) begin
            rb_entries_3_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h3 == value) begin
              rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_144) begin
        if (_GEN_5811) begin
          rb_entries_3_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_144) begin
      if (_GEN_5811) begin
        rb_entries_3_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_0_mode <= _GEN_493;
      end
    end else begin
      rb_entries_3_request_operands_0_mode <= _GEN_493;
    end
    if (reset) begin
      rb_entries_3_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_209) begin
        if (_T_210) begin
          rb_entries_3_request_operands_1_value <= io_mem_read_data;
        end else if (_T_147) begin
          if (_GEN_6295) begin
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
            if (3'h3 == value) begin
              rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_147) begin
        if (_GEN_6295) begin
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
          if (3'h3 == value) begin
            rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_147) begin
      if (_GEN_6295) begin
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
        rb_entries_3_request_operands_1_value <= _GEN_517;
      end
    end else begin
      rb_entries_3_request_operands_1_value <= _GEN_517;
    end
    if (reset) begin
      rb_entries_3_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_209) begin
        if (_T_210) begin
          rb_entries_3_request_operands_1_mode <= 2'h0;
        end else if (_T_147) begin
          if (_GEN_6295) begin
            rb_entries_3_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h3 == value) begin
              rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_147) begin
        if (_GEN_6295) begin
          rb_entries_3_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_147) begin
      if (_GEN_6295) begin
        rb_entries_3_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_1_mode <= _GEN_509;
      end
    end else begin
      rb_entries_3_request_operands_1_mode <= _GEN_509;
    end
    if (reset) begin
      rb_entries_3_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_211) begin
        if (_T_212) begin
          rb_entries_3_request_operands_2_value <= io_mem_read_data;
        end else if (_T_150) begin
          if (_GEN_6779) begin
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
            if (3'h3 == value) begin
              rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_150) begin
        if (_GEN_6779) begin
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
          if (3'h3 == value) begin
            rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_150) begin
      if (_GEN_6779) begin
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
        rb_entries_3_request_operands_2_value <= _GEN_533;
      end
    end else begin
      rb_entries_3_request_operands_2_value <= _GEN_533;
    end
    if (reset) begin
      rb_entries_3_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_211) begin
        if (_T_212) begin
          rb_entries_3_request_operands_2_mode <= 2'h0;
        end else if (_T_150) begin
          if (_GEN_6779) begin
            rb_entries_3_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h3 == value) begin
              rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_150) begin
        if (_GEN_6779) begin
          rb_entries_3_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h3 == value) begin
            rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_150) begin
      if (_GEN_6779) begin
        rb_entries_3_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_2_mode <= _GEN_525;
      end
    end else begin
      rb_entries_3_request_operands_2_mode <= _GEN_525;
    end
    if (reset) begin
      rb_entries_3_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_3_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_3_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_0 <= _T_381[9];
    end
    if (reset) begin
      rb_entries_3_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_1 <= _T_381[10];
    end
    if (reset) begin
      rb_entries_3_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_2 <= _T_381[11];
    end
    if (reset) begin
      rb_entries_3_result_isZero <= 1'h0;
    end else if (_T_116) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_isNaR <= 1'h0;
    end else if (_T_116) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_out <= 32'h0;
    end else if (_T_116) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_lt <= 1'h0;
    end else if (_T_116) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_eq <= 1'h0;
    end else if (_T_116) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_gt <= 1'h0;
    end else if (_T_116) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_3_result_exceptions <= 5'h0;
    end else if (_T_116) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_4_completed <= 1'h0;
    end else if (_T_116) begin
      rb_entries_4_completed <= _GEN_1170;
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_4_valid <= _GEN_254;
    end
    if (reset) begin
      rb_entries_4_dispatched <= 1'h0;
    end else begin
      rb_entries_4_dispatched <= _T_101;
    end
    if (reset) begin
      rb_entries_4_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_4_written <= _GEN_857;
    end else if (wbCountOn) begin
      rb_entries_4_written <= _GEN_840;
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_wr_addr <= 48'h0;
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_wr_addr <= _rb_entries_value_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_4_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_213) begin
        if (_T_214) begin
          rb_entries_4_request_operands_0_value <= io_mem_read_data;
        end else if (_T_153) begin
          if (_GEN_7263) begin
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
            if (3'h4 == value) begin
              rb_entries_4_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_153) begin
        if (_GEN_7263) begin
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
          if (3'h4 == value) begin
            rb_entries_4_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_153) begin
      if (_GEN_7263) begin
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
        rb_entries_4_request_operands_0_value <= _GEN_502;
      end
    end else begin
      rb_entries_4_request_operands_0_value <= _GEN_502;
    end
    if (reset) begin
      rb_entries_4_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_213) begin
        if (_T_214) begin
          rb_entries_4_request_operands_0_mode <= 2'h0;
        end else if (_T_153) begin
          if (_GEN_7263) begin
            rb_entries_4_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h4 == value) begin
              rb_entries_4_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_153) begin
        if (_GEN_7263) begin
          rb_entries_4_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_153) begin
      if (_GEN_7263) begin
        rb_entries_4_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_0_mode <= _GEN_494;
      end
    end else begin
      rb_entries_4_request_operands_0_mode <= _GEN_494;
    end
    if (reset) begin
      rb_entries_4_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_215) begin
        if (_T_216) begin
          rb_entries_4_request_operands_1_value <= io_mem_read_data;
        end else if (_T_156) begin
          if (_GEN_7747) begin
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
            if (3'h4 == value) begin
              rb_entries_4_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_156) begin
        if (_GEN_7747) begin
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
          if (3'h4 == value) begin
            rb_entries_4_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_156) begin
      if (_GEN_7747) begin
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
        rb_entries_4_request_operands_1_value <= _GEN_518;
      end
    end else begin
      rb_entries_4_request_operands_1_value <= _GEN_518;
    end
    if (reset) begin
      rb_entries_4_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_215) begin
        if (_T_216) begin
          rb_entries_4_request_operands_1_mode <= 2'h0;
        end else if (_T_156) begin
          if (_GEN_7747) begin
            rb_entries_4_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h4 == value) begin
              rb_entries_4_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_156) begin
        if (_GEN_7747) begin
          rb_entries_4_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_156) begin
      if (_GEN_7747) begin
        rb_entries_4_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_1_mode <= _GEN_510;
      end
    end else begin
      rb_entries_4_request_operands_1_mode <= _GEN_510;
    end
    if (reset) begin
      rb_entries_4_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_217) begin
        if (_T_218) begin
          rb_entries_4_request_operands_2_value <= io_mem_read_data;
        end else if (_T_159) begin
          if (_GEN_8231) begin
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
            if (3'h4 == value) begin
              rb_entries_4_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_159) begin
        if (_GEN_8231) begin
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
          if (3'h4 == value) begin
            rb_entries_4_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_159) begin
      if (_GEN_8231) begin
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
        rb_entries_4_request_operands_2_value <= _GEN_534;
      end
    end else begin
      rb_entries_4_request_operands_2_value <= _GEN_534;
    end
    if (reset) begin
      rb_entries_4_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_217) begin
        if (_T_218) begin
          rb_entries_4_request_operands_2_mode <= 2'h0;
        end else if (_T_159) begin
          if (_GEN_8231) begin
            rb_entries_4_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h4 == value) begin
              rb_entries_4_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_159) begin
        if (_GEN_8231) begin
          rb_entries_4_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h4 == value) begin
            rb_entries_4_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_159) begin
      if (_GEN_8231) begin
        rb_entries_4_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_2_mode <= _GEN_526;
      end
    end else begin
      rb_entries_4_request_operands_2_mode <= _GEN_526;
    end
    if (reset) begin
      rb_entries_4_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_4_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_4_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_0 <= _T_381[12];
    end
    if (reset) begin
      rb_entries_4_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_1 <= _T_381[13];
    end
    if (reset) begin
      rb_entries_4_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_2 <= _T_381[14];
    end
    if (reset) begin
      rb_entries_4_result_isZero <= 1'h0;
    end else if (_T_116) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_isNaR <= 1'h0;
    end else if (_T_116) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_out <= 32'h0;
    end else if (_T_116) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_lt <= 1'h0;
    end else if (_T_116) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_eq <= 1'h0;
    end else if (_T_116) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_gt <= 1'h0;
    end else if (_T_116) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_4_result_exceptions <= 5'h0;
    end else if (_T_116) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_5_completed <= 1'h0;
    end else if (_T_116) begin
      rb_entries_5_completed <= _GEN_1171;
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_5_valid <= _GEN_255;
    end
    if (reset) begin
      rb_entries_5_dispatched <= 1'h0;
    end else begin
      rb_entries_5_dispatched <= _T_104;
    end
    if (reset) begin
      rb_entries_5_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_5_written <= _GEN_858;
    end else if (wbCountOn) begin
      rb_entries_5_written <= _GEN_841;
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_wr_addr <= 48'h0;
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_wr_addr <= _rb_entries_value_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_5_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_219) begin
        if (_T_220) begin
          rb_entries_5_request_operands_0_value <= io_mem_read_data;
        end else if (_T_162) begin
          if (_GEN_8715) begin
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
            if (3'h5 == value) begin
              rb_entries_5_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_162) begin
        if (_GEN_8715) begin
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
          if (3'h5 == value) begin
            rb_entries_5_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_162) begin
      if (_GEN_8715) begin
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
        rb_entries_5_request_operands_0_value <= _GEN_503;
      end
    end else begin
      rb_entries_5_request_operands_0_value <= _GEN_503;
    end
    if (reset) begin
      rb_entries_5_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_219) begin
        if (_T_220) begin
          rb_entries_5_request_operands_0_mode <= 2'h0;
        end else if (_T_162) begin
          if (_GEN_8715) begin
            rb_entries_5_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h5 == value) begin
              rb_entries_5_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_162) begin
        if (_GEN_8715) begin
          rb_entries_5_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_162) begin
      if (_GEN_8715) begin
        rb_entries_5_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_0_mode <= _GEN_495;
      end
    end else begin
      rb_entries_5_request_operands_0_mode <= _GEN_495;
    end
    if (reset) begin
      rb_entries_5_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_221) begin
        if (_T_222) begin
          rb_entries_5_request_operands_1_value <= io_mem_read_data;
        end else if (_T_165) begin
          if (_GEN_9199) begin
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
            if (3'h5 == value) begin
              rb_entries_5_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_165) begin
        if (_GEN_9199) begin
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
          if (3'h5 == value) begin
            rb_entries_5_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_165) begin
      if (_GEN_9199) begin
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
        rb_entries_5_request_operands_1_value <= _GEN_519;
      end
    end else begin
      rb_entries_5_request_operands_1_value <= _GEN_519;
    end
    if (reset) begin
      rb_entries_5_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_221) begin
        if (_T_222) begin
          rb_entries_5_request_operands_1_mode <= 2'h0;
        end else if (_T_165) begin
          if (_GEN_9199) begin
            rb_entries_5_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h5 == value) begin
              rb_entries_5_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_165) begin
        if (_GEN_9199) begin
          rb_entries_5_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_165) begin
      if (_GEN_9199) begin
        rb_entries_5_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_1_mode <= _GEN_511;
      end
    end else begin
      rb_entries_5_request_operands_1_mode <= _GEN_511;
    end
    if (reset) begin
      rb_entries_5_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_223) begin
        if (_T_224) begin
          rb_entries_5_request_operands_2_value <= io_mem_read_data;
        end else if (_T_168) begin
          if (_GEN_9683) begin
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
            if (3'h5 == value) begin
              rb_entries_5_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_168) begin
        if (_GEN_9683) begin
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
          if (3'h5 == value) begin
            rb_entries_5_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_168) begin
      if (_GEN_9683) begin
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
        rb_entries_5_request_operands_2_value <= _GEN_535;
      end
    end else begin
      rb_entries_5_request_operands_2_value <= _GEN_535;
    end
    if (reset) begin
      rb_entries_5_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_223) begin
        if (_T_224) begin
          rb_entries_5_request_operands_2_mode <= 2'h0;
        end else if (_T_168) begin
          if (_GEN_9683) begin
            rb_entries_5_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h5 == value) begin
              rb_entries_5_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_168) begin
        if (_GEN_9683) begin
          rb_entries_5_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h5 == value) begin
            rb_entries_5_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_168) begin
      if (_GEN_9683) begin
        rb_entries_5_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_2_mode <= _GEN_527;
      end
    end else begin
      rb_entries_5_request_operands_2_mode <= _GEN_527;
    end
    if (reset) begin
      rb_entries_5_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_5_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_5_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_0 <= _T_381[15];
    end
    if (reset) begin
      rb_entries_5_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_1 <= _T_381[16];
    end
    if (reset) begin
      rb_entries_5_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_2 <= _T_381[17];
    end
    if (reset) begin
      rb_entries_5_result_isZero <= 1'h0;
    end else if (_T_116) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_isNaR <= 1'h0;
    end else if (_T_116) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_out <= 32'h0;
    end else if (_T_116) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_lt <= 1'h0;
    end else if (_T_116) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_eq <= 1'h0;
    end else if (_T_116) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_gt <= 1'h0;
    end else if (_T_116) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_5_result_exceptions <= 5'h0;
    end else if (_T_116) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_6_completed <= 1'h0;
    end else if (_T_116) begin
      rb_entries_6_completed <= _GEN_1172;
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_6_valid <= _GEN_256;
    end
    if (reset) begin
      rb_entries_6_dispatched <= 1'h0;
    end else begin
      rb_entries_6_dispatched <= _T_107;
    end
    if (reset) begin
      rb_entries_6_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_6_written <= _GEN_859;
    end else if (wbCountOn) begin
      rb_entries_6_written <= _GEN_842;
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_wr_addr <= 48'h0;
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_wr_addr <= _rb_entries_value_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_6_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_225) begin
        if (_T_226) begin
          rb_entries_6_request_operands_0_value <= io_mem_read_data;
        end else if (_T_171) begin
          if (_GEN_10167) begin
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
            if (3'h6 == value) begin
              rb_entries_6_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_171) begin
        if (_GEN_10167) begin
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
          if (3'h6 == value) begin
            rb_entries_6_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_171) begin
      if (_GEN_10167) begin
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
        rb_entries_6_request_operands_0_value <= _GEN_504;
      end
    end else begin
      rb_entries_6_request_operands_0_value <= _GEN_504;
    end
    if (reset) begin
      rb_entries_6_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_225) begin
        if (_T_226) begin
          rb_entries_6_request_operands_0_mode <= 2'h0;
        end else if (_T_171) begin
          if (_GEN_10167) begin
            rb_entries_6_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h6 == value) begin
              rb_entries_6_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_171) begin
        if (_GEN_10167) begin
          rb_entries_6_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_171) begin
      if (_GEN_10167) begin
        rb_entries_6_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_0_mode <= _GEN_496;
      end
    end else begin
      rb_entries_6_request_operands_0_mode <= _GEN_496;
    end
    if (reset) begin
      rb_entries_6_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_227) begin
        if (_T_228) begin
          rb_entries_6_request_operands_1_value <= io_mem_read_data;
        end else if (_T_174) begin
          if (_GEN_10651) begin
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
            if (3'h6 == value) begin
              rb_entries_6_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_174) begin
        if (_GEN_10651) begin
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
          if (3'h6 == value) begin
            rb_entries_6_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_174) begin
      if (_GEN_10651) begin
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
        rb_entries_6_request_operands_1_value <= _GEN_520;
      end
    end else begin
      rb_entries_6_request_operands_1_value <= _GEN_520;
    end
    if (reset) begin
      rb_entries_6_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_227) begin
        if (_T_228) begin
          rb_entries_6_request_operands_1_mode <= 2'h0;
        end else if (_T_174) begin
          if (_GEN_10651) begin
            rb_entries_6_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h6 == value) begin
              rb_entries_6_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_174) begin
        if (_GEN_10651) begin
          rb_entries_6_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_174) begin
      if (_GEN_10651) begin
        rb_entries_6_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_1_mode <= _GEN_512;
      end
    end else begin
      rb_entries_6_request_operands_1_mode <= _GEN_512;
    end
    if (reset) begin
      rb_entries_6_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_229) begin
        if (_T_230) begin
          rb_entries_6_request_operands_2_value <= io_mem_read_data;
        end else if (_T_177) begin
          if (_GEN_11135) begin
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
            if (3'h6 == value) begin
              rb_entries_6_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_177) begin
        if (_GEN_11135) begin
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
          if (3'h6 == value) begin
            rb_entries_6_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_177) begin
      if (_GEN_11135) begin
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
        rb_entries_6_request_operands_2_value <= _GEN_536;
      end
    end else begin
      rb_entries_6_request_operands_2_value <= _GEN_536;
    end
    if (reset) begin
      rb_entries_6_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_229) begin
        if (_T_230) begin
          rb_entries_6_request_operands_2_mode <= 2'h0;
        end else if (_T_177) begin
          if (_GEN_11135) begin
            rb_entries_6_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h6 == value) begin
              rb_entries_6_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_177) begin
        if (_GEN_11135) begin
          rb_entries_6_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h6 == value) begin
            rb_entries_6_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_177) begin
      if (_GEN_11135) begin
        rb_entries_6_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_2_mode <= _GEN_528;
      end
    end else begin
      rb_entries_6_request_operands_2_mode <= _GEN_528;
    end
    if (reset) begin
      rb_entries_6_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_6_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_6_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_0 <= _T_381[18];
    end
    if (reset) begin
      rb_entries_6_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_1 <= _T_381[19];
    end
    if (reset) begin
      rb_entries_6_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_2 <= _T_381[20];
    end
    if (reset) begin
      rb_entries_6_result_isZero <= 1'h0;
    end else if (_T_116) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_isNaR <= 1'h0;
    end else if (_T_116) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_out <= 32'h0;
    end else if (_T_116) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_lt <= 1'h0;
    end else if (_T_116) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_eq <= 1'h0;
    end else if (_T_116) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_gt <= 1'h0;
    end else if (_T_116) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_6_result_exceptions <= 5'h0;
    end else if (_T_116) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      rb_entries_7_completed <= 1'h0;
    end else if (_T_116) begin
      rb_entries_7_completed <= _GEN_1173;
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_completed <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_valid <= 1'h0;
    end else if (new_input_log) begin
      rb_entries_7_valid <= _GEN_257;
    end
    if (reset) begin
      rb_entries_7_dispatched <= 1'h0;
    end else begin
      rb_entries_7_dispatched <= _T_110;
    end
    if (reset) begin
      rb_entries_7_written <= 1'h0;
    end else if (wbCountOn) begin
      rb_entries_7_written <= _GEN_860;
    end else if (wbCountOn) begin
      rb_entries_7_written <= _GEN_843;
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_written <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_wr_addr <= 48'h0;
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_wr_addr <= _rb_entries_value_wr_addr;
      end
    end
    if (reset) begin
      rb_entries_7_request_operands_0_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_231) begin
        if (_T_232) begin
          rb_entries_7_request_operands_0_value <= io_mem_read_data;
        end else if (_T_180) begin
          if (_GEN_11619) begin
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
            if (3'h7 == value) begin
              rb_entries_7_request_operands_0_value <= io_request_bits_operands_0_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (_T_180) begin
        if (_GEN_11619) begin
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
          if (3'h7 == value) begin
            rb_entries_7_request_operands_0_value <= io_request_bits_operands_0_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_request_operands_0_value <= io_request_bits_operands_0_value;
        end
      end
    end else if (_T_180) begin
      if (_GEN_11619) begin
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
        rb_entries_7_request_operands_0_value <= _GEN_505;
      end
    end else begin
      rb_entries_7_request_operands_0_value <= _GEN_505;
    end
    if (reset) begin
      rb_entries_7_request_operands_0_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_231) begin
        if (_T_232) begin
          rb_entries_7_request_operands_0_mode <= 2'h0;
        end else if (_T_180) begin
          if (_GEN_11619) begin
            rb_entries_7_request_operands_0_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h7 == value) begin
              rb_entries_7_request_operands_0_mode <= io_request_bits_operands_0_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (_T_180) begin
        if (_GEN_11619) begin
          rb_entries_7_request_operands_0_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_0_mode <= io_request_bits_operands_0_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_request_operands_0_mode <= io_request_bits_operands_0_mode;
        end
      end
    end else if (_T_180) begin
      if (_GEN_11619) begin
        rb_entries_7_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_0_mode <= _GEN_497;
      end
    end else begin
      rb_entries_7_request_operands_0_mode <= _GEN_497;
    end
    if (reset) begin
      rb_entries_7_request_operands_1_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_233) begin
        if (_T_234) begin
          rb_entries_7_request_operands_1_value <= io_mem_read_data;
        end else if (_T_183) begin
          if (_GEN_12103) begin
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
            if (3'h7 == value) begin
              rb_entries_7_request_operands_1_value <= io_request_bits_operands_1_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (_T_183) begin
        if (_GEN_12103) begin
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
          if (3'h7 == value) begin
            rb_entries_7_request_operands_1_value <= io_request_bits_operands_1_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_request_operands_1_value <= io_request_bits_operands_1_value;
        end
      end
    end else if (_T_183) begin
      if (_GEN_12103) begin
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
        rb_entries_7_request_operands_1_value <= _GEN_521;
      end
    end else begin
      rb_entries_7_request_operands_1_value <= _GEN_521;
    end
    if (reset) begin
      rb_entries_7_request_operands_1_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_233) begin
        if (_T_234) begin
          rb_entries_7_request_operands_1_mode <= 2'h0;
        end else if (_T_183) begin
          if (_GEN_12103) begin
            rb_entries_7_request_operands_1_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h7 == value) begin
              rb_entries_7_request_operands_1_mode <= io_request_bits_operands_1_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (_T_183) begin
        if (_GEN_12103) begin
          rb_entries_7_request_operands_1_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_1_mode <= io_request_bits_operands_1_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_request_operands_1_mode <= io_request_bits_operands_1_mode;
        end
      end
    end else if (_T_183) begin
      if (_GEN_12103) begin
        rb_entries_7_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_1_mode <= _GEN_513;
      end
    end else begin
      rb_entries_7_request_operands_1_mode <= _GEN_513;
    end
    if (reset) begin
      rb_entries_7_request_operands_2_value <= 32'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_235) begin
        if (_T_236) begin
          rb_entries_7_request_operands_2_value <= io_mem_read_data;
        end else if (_T_186) begin
          if (_GEN_12587) begin
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
            if (3'h7 == value) begin
              rb_entries_7_request_operands_2_value <= io_request_bits_operands_2_value;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (_T_186) begin
        if (_GEN_12587) begin
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
          if (3'h7 == value) begin
            rb_entries_7_request_operands_2_value <= io_request_bits_operands_2_value;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_request_operands_2_value <= io_request_bits_operands_2_value;
        end
      end
    end else if (_T_186) begin
      if (_GEN_12587) begin
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
        rb_entries_7_request_operands_2_value <= _GEN_537;
      end
    end else begin
      rb_entries_7_request_operands_2_value <= _GEN_537;
    end
    if (reset) begin
      rb_entries_7_request_operands_2_mode <= 2'h0;
    end else if (io_mem_read_resp_valid) begin
      if (_T_235) begin
        if (_T_236) begin
          rb_entries_7_request_operands_2_mode <= 2'h0;
        end else if (_T_186) begin
          if (_GEN_12587) begin
            rb_entries_7_request_operands_2_mode <= 2'h0;
          end else if (new_input_log) begin
            if (3'h7 == value) begin
              rb_entries_7_request_operands_2_mode <= io_request_bits_operands_2_mode;
            end
          end
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (_T_186) begin
        if (_GEN_12587) begin
          rb_entries_7_request_operands_2_mode <= 2'h0;
        end else if (new_input_log) begin
          if (3'h7 == value) begin
            rb_entries_7_request_operands_2_mode <= io_request_bits_operands_2_mode;
          end
        end
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_request_operands_2_mode <= io_request_bits_operands_2_mode;
        end
      end
    end else if (_T_186) begin
      if (_GEN_12587) begin
        rb_entries_7_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_2_mode <= _GEN_529;
      end
    end else begin
      rb_entries_7_request_operands_2_mode <= _GEN_529;
    end
    if (reset) begin
      rb_entries_7_request_inst <= 3'h0;
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_request_inst <= io_request_bits_inst;
      end
    end
    if (reset) begin
      rb_entries_7_request_mode <= 2'h0;
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_request_mode <= io_request_bits_mode;
      end
    end
    if (reset) begin
      rb_entries_7_request_inFetch_0 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_0 <= _T_381[21];
    end
    if (reset) begin
      rb_entries_7_request_inFetch_1 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_1 <= _T_381[22];
    end
    if (reset) begin
      rb_entries_7_request_inFetch_2 <= 1'h0;
    end else if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_2 <= _T_381[23];
    end
    if (reset) begin
      rb_entries_7_result_isZero <= 1'h0;
    end else if (_T_116) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_isZero <= _rb_entries_result_idx_result_isZero;
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_result_isZero <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_result_isZero <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_isNaR <= 1'h0;
    end else if (_T_116) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_isNaR <= _rb_entries_result_idx_result_isNaR;
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_result_isNaR <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_result_isNaR <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_out <= 32'h0;
    end else if (_T_116) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_result_out <= 32'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_result_out <= 32'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_lt <= 1'h0;
    end else if (_T_116) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_lt <= _rb_entries_result_idx_result_lt;
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_result_lt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_result_lt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_eq <= 1'h0;
    end else if (_T_116) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_eq <= _rb_entries_result_idx_result_eq;
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_result_eq <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_result_eq <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_gt <= 1'h0;
    end else if (_T_116) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_gt <= _rb_entries_result_idx_result_gt;
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_result_gt <= 1'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_result_gt <= 1'h0;
      end
    end
    if (reset) begin
      rb_entries_7_result_exceptions <= 5'h0;
    end else if (_T_116) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_exceptions <= _rb_entries_result_idx_result_exceptions;
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_result_exceptions <= 5'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_result_exceptions <= 5'h0;
      end
    end
    if (reset) begin
      value <= 3'h0;
    end else if (new_input_log) begin
      value <= _T_4;
    end
    if (reset) begin
      value_1 <= 3'h0;
    end else if (wbCountOn) begin
      value_1 <= _T_14;
    end
  end
endmodule
