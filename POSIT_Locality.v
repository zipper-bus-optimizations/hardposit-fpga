module PositAddCore(
  input         io_num1_sign,
  input  [11:0] io_num1_exponent,
  input  [57:0] io_num1_fraction,
  input         io_num1_isZero,
  input         io_num1_isNaR,
  input         io_num2_sign,
  input  [11:0] io_num2_exponent,
  input  [57:0] io_num2_fraction,
  input         io_num2_isZero,
  input         io_num2_isNaR,
  input         io_sub,
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [11:0] io_out_exponent,
  output [57:0] io_out_fraction,
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
  wire [11:0] largeExp = num1magGt ? $signed(io_num1_exponent) : $signed(io_num2_exponent); // @[PositAdd.scala 30:22]
  wire [57:0] _T_4 = num1magGt ? io_num1_fraction : io_num2_fraction; // @[PositAdd.scala 32:12]
  wire [60:0] largeFrac = {_T_4,3'h0}; // @[Cat.scala 30:58]
  wire  smallSign = num1magGt ? num2AdjSign : io_num1_sign; // @[PositAdd.scala 34:22]
  wire [11:0] smallExp = num1magGt ? $signed(io_num2_exponent) : $signed(io_num1_exponent); // @[PositAdd.scala 35:22]
  wire [57:0] _T_5 = num1magGt ? io_num2_fraction : io_num1_fraction; // @[PositAdd.scala 37:12]
  wire [60:0] smallFrac = {_T_5,3'h0}; // @[Cat.scala 30:58]
  wire [11:0] expDiff = $signed(largeExp) - $signed(smallExp); // @[PositAdd.scala 39:45]
  wire  _T_9 = expDiff < 12'h3d; // @[PositAdd.scala 41:17]
  wire [60:0] _T_10 = smallFrac >> expDiff; // @[PositAdd.scala 41:59]
  wire [60:0] shiftedSmallFrac = _T_9 ? _T_10 : 61'h0; // @[PositAdd.scala 41:8]
  wire  _T_19 = largeSign ^ smallSign; // @[PositAdd.scala 46:32]
  wire  isAddition = ~_T_19; // @[PositAdd.scala 46:20]
  wire [60:0] _T_20 = ~shiftedSmallFrac; // @[PositAdd.scala 48:39]
  wire [60:0] _T_22 = _T_20 + 61'h1; // @[PositAdd.scala 48:57]
  wire [60:0] signedSmallerFrac = isAddition ? shiftedSmallFrac : _T_22; // @[PositAdd.scala 48:8]
  wire [61:0] adderFrac = largeFrac + signedSmallerFrac; // @[PositAdd.scala 50:54]
  wire  sumOverflow = isAddition & adderFrac[61]; // @[PositAdd.scala 52:32]
  wire  _T_25 = isAddition & adderFrac[61]; // @[PositAdd.scala 54:50]
  wire [11:0] _GEN_1 = {12{_T_25}}; // @[PositAdd.scala 54:30]
  wire [11:0] adjAdderExp = $signed(largeExp) - $signed(_GEN_1); // @[PositAdd.scala 54:30]
  wire [60:0] adjAdderFrac = sumOverflow ? adderFrac[61:1] : adderFrac[60:0]; // @[PositAdd.scala 56:8]
  wire  sumStickyBit = sumOverflow & adderFrac[0]; // @[PositAdd.scala 57:34]
  wire [5:0] _T_92 = adjAdderFrac[1] ? 6'h3b : 6'h3c; // @[Mux.scala 47:69]
  wire [5:0] _T_93 = adjAdderFrac[2] ? 6'h3a : _T_92; // @[Mux.scala 47:69]
  wire [5:0] _T_94 = adjAdderFrac[3] ? 6'h39 : _T_93; // @[Mux.scala 47:69]
  wire [5:0] _T_95 = adjAdderFrac[4] ? 6'h38 : _T_94; // @[Mux.scala 47:69]
  wire [5:0] _T_96 = adjAdderFrac[5] ? 6'h37 : _T_95; // @[Mux.scala 47:69]
  wire [5:0] _T_97 = adjAdderFrac[6] ? 6'h36 : _T_96; // @[Mux.scala 47:69]
  wire [5:0] _T_98 = adjAdderFrac[7] ? 6'h35 : _T_97; // @[Mux.scala 47:69]
  wire [5:0] _T_99 = adjAdderFrac[8] ? 6'h34 : _T_98; // @[Mux.scala 47:69]
  wire [5:0] _T_100 = adjAdderFrac[9] ? 6'h33 : _T_99; // @[Mux.scala 47:69]
  wire [5:0] _T_101 = adjAdderFrac[10] ? 6'h32 : _T_100; // @[Mux.scala 47:69]
  wire [5:0] _T_102 = adjAdderFrac[11] ? 6'h31 : _T_101; // @[Mux.scala 47:69]
  wire [5:0] _T_103 = adjAdderFrac[12] ? 6'h30 : _T_102; // @[Mux.scala 47:69]
  wire [5:0] _T_104 = adjAdderFrac[13] ? 6'h2f : _T_103; // @[Mux.scala 47:69]
  wire [5:0] _T_105 = adjAdderFrac[14] ? 6'h2e : _T_104; // @[Mux.scala 47:69]
  wire [5:0] _T_106 = adjAdderFrac[15] ? 6'h2d : _T_105; // @[Mux.scala 47:69]
  wire [5:0] _T_107 = adjAdderFrac[16] ? 6'h2c : _T_106; // @[Mux.scala 47:69]
  wire [5:0] _T_108 = adjAdderFrac[17] ? 6'h2b : _T_107; // @[Mux.scala 47:69]
  wire [5:0] _T_109 = adjAdderFrac[18] ? 6'h2a : _T_108; // @[Mux.scala 47:69]
  wire [5:0] _T_110 = adjAdderFrac[19] ? 6'h29 : _T_109; // @[Mux.scala 47:69]
  wire [5:0] _T_111 = adjAdderFrac[20] ? 6'h28 : _T_110; // @[Mux.scala 47:69]
  wire [5:0] _T_112 = adjAdderFrac[21] ? 6'h27 : _T_111; // @[Mux.scala 47:69]
  wire [5:0] _T_113 = adjAdderFrac[22] ? 6'h26 : _T_112; // @[Mux.scala 47:69]
  wire [5:0] _T_114 = adjAdderFrac[23] ? 6'h25 : _T_113; // @[Mux.scala 47:69]
  wire [5:0] _T_115 = adjAdderFrac[24] ? 6'h24 : _T_114; // @[Mux.scala 47:69]
  wire [5:0] _T_116 = adjAdderFrac[25] ? 6'h23 : _T_115; // @[Mux.scala 47:69]
  wire [5:0] _T_117 = adjAdderFrac[26] ? 6'h22 : _T_116; // @[Mux.scala 47:69]
  wire [5:0] _T_118 = adjAdderFrac[27] ? 6'h21 : _T_117; // @[Mux.scala 47:69]
  wire [5:0] _T_119 = adjAdderFrac[28] ? 6'h20 : _T_118; // @[Mux.scala 47:69]
  wire [5:0] _T_120 = adjAdderFrac[29] ? 6'h1f : _T_119; // @[Mux.scala 47:69]
  wire [5:0] _T_121 = adjAdderFrac[30] ? 6'h1e : _T_120; // @[Mux.scala 47:69]
  wire [5:0] _T_122 = adjAdderFrac[31] ? 6'h1d : _T_121; // @[Mux.scala 47:69]
  wire [5:0] _T_123 = adjAdderFrac[32] ? 6'h1c : _T_122; // @[Mux.scala 47:69]
  wire [5:0] _T_124 = adjAdderFrac[33] ? 6'h1b : _T_123; // @[Mux.scala 47:69]
  wire [5:0] _T_125 = adjAdderFrac[34] ? 6'h1a : _T_124; // @[Mux.scala 47:69]
  wire [5:0] _T_126 = adjAdderFrac[35] ? 6'h19 : _T_125; // @[Mux.scala 47:69]
  wire [5:0] _T_127 = adjAdderFrac[36] ? 6'h18 : _T_126; // @[Mux.scala 47:69]
  wire [5:0] _T_128 = adjAdderFrac[37] ? 6'h17 : _T_127; // @[Mux.scala 47:69]
  wire [5:0] _T_129 = adjAdderFrac[38] ? 6'h16 : _T_128; // @[Mux.scala 47:69]
  wire [5:0] _T_130 = adjAdderFrac[39] ? 6'h15 : _T_129; // @[Mux.scala 47:69]
  wire [5:0] _T_131 = adjAdderFrac[40] ? 6'h14 : _T_130; // @[Mux.scala 47:69]
  wire [5:0] _T_132 = adjAdderFrac[41] ? 6'h13 : _T_131; // @[Mux.scala 47:69]
  wire [5:0] _T_133 = adjAdderFrac[42] ? 6'h12 : _T_132; // @[Mux.scala 47:69]
  wire [5:0] _T_134 = adjAdderFrac[43] ? 6'h11 : _T_133; // @[Mux.scala 47:69]
  wire [5:0] _T_135 = adjAdderFrac[44] ? 6'h10 : _T_134; // @[Mux.scala 47:69]
  wire [5:0] _T_136 = adjAdderFrac[45] ? 6'hf : _T_135; // @[Mux.scala 47:69]
  wire [5:0] _T_137 = adjAdderFrac[46] ? 6'he : _T_136; // @[Mux.scala 47:69]
  wire [5:0] _T_138 = adjAdderFrac[47] ? 6'hd : _T_137; // @[Mux.scala 47:69]
  wire [5:0] _T_139 = adjAdderFrac[48] ? 6'hc : _T_138; // @[Mux.scala 47:69]
  wire [5:0] _T_140 = adjAdderFrac[49] ? 6'hb : _T_139; // @[Mux.scala 47:69]
  wire [5:0] _T_141 = adjAdderFrac[50] ? 6'ha : _T_140; // @[Mux.scala 47:69]
  wire [5:0] _T_142 = adjAdderFrac[51] ? 6'h9 : _T_141; // @[Mux.scala 47:69]
  wire [5:0] _T_143 = adjAdderFrac[52] ? 6'h8 : _T_142; // @[Mux.scala 47:69]
  wire [5:0] _T_144 = adjAdderFrac[53] ? 6'h7 : _T_143; // @[Mux.scala 47:69]
  wire [5:0] _T_145 = adjAdderFrac[54] ? 6'h6 : _T_144; // @[Mux.scala 47:69]
  wire [5:0] _T_146 = adjAdderFrac[55] ? 6'h5 : _T_145; // @[Mux.scala 47:69]
  wire [5:0] _T_147 = adjAdderFrac[56] ? 6'h4 : _T_146; // @[Mux.scala 47:69]
  wire [5:0] _T_148 = adjAdderFrac[57] ? 6'h3 : _T_147; // @[Mux.scala 47:69]
  wire [5:0] _T_149 = adjAdderFrac[58] ? 6'h2 : _T_148; // @[Mux.scala 47:69]
  wire [5:0] _T_150 = adjAdderFrac[59] ? 6'h1 : _T_149; // @[Mux.scala 47:69]
  wire [5:0] normalizationFactor = adjAdderFrac[60] ? 6'h0 : _T_150; // @[Mux.scala 47:69]
  wire [5:0] _T_151 = adjAdderFrac[60] ? 6'h0 : _T_150; // @[PositAdd.scala 61:62]
  wire [11:0] _GEN_2 = {{6{_T_151[5]}},_T_151}; // @[PositAdd.scala 61:34]
  wire [123:0] _GEN_3 = {{63'd0}, adjAdderFrac}; // @[PositAdd.scala 62:35]
  wire [123:0] normFraction = _GEN_3 << normalizationFactor; // @[PositAdd.scala 62:35]
  wire  _T_155 = io_num1_isZero & io_num2_isZero; // @[PositAdd.scala 65:35]
  wire  _T_156 = adderFrac == 62'h0; // @[PositAdd.scala 65:64]
  assign io_trailingBits = normFraction[2:1]; // @[PositAdd.scala 70:19]
  assign io_stickyBit = sumStickyBit | normFraction[0]; // @[PositAdd.scala 71:19]
  assign io_out_sign = num1magGt ? io_num1_sign : num2AdjSign; // @[PositAdd.scala 73:10]
  assign io_out_exponent = $signed(adjAdderExp) - $signed(_GEN_2); // @[PositAdd.scala 73:10]
  assign io_out_fraction = normFraction[60:3]; // @[PositAdd.scala 73:10]
  assign io_out_isZero = _T_155 | _T_156; // @[PositAdd.scala 73:10]
  assign io_out_isNaR = io_num1_isNaR | io_num2_isNaR; // @[PositAdd.scala 73:10]
endmodule
module PositCompare(
  input  [63:0] io_num1,
  input  [63:0] io_num2,
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
  input  [11:0] io_num1_exponent,
  input  [57:0] io_num1_fraction,
  input         io_num1_isNaR,
  input         io_num2_sign,
  input  [11:0] io_num2_exponent,
  input  [57:0] io_num2_fraction,
  input         io_num2_isNaR,
  input         io_sub,
  input         io_negate,
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [11:0] io_out_exponent,
  output [57:0] io_out_fraction,
  output        io_out_isNaR
);
  wire  _T = io_num1_sign ^ io_num2_sign; // @[PositFMA.scala 24:31]
  wire  productSign = _T ^ io_negate; // @[PositFMA.scala 24:43]
  wire  addendSign = io_negate ^ io_sub; // @[PositFMA.scala 25:43]
  wire [12:0] productExponent = $signed(io_num1_exponent) + $signed(io_num2_exponent); // @[PositFMA.scala 27:39]
  wire [115:0] productFraction = io_num1_fraction * io_num2_fraction; // @[PositFMA.scala 29:63]
  wire  prodOverflow = productFraction[115]; // @[PositFMA.scala 31:44]
  wire [114:0] normProductFraction = prodOverflow ? productFraction[115:1] : productFraction[114:0]; // @[PositFMA.scala 33:8]
  wire [1:0] _T_6 = {1'h0,prodOverflow}; // @[PositFMA.scala 34:76]
  wire [12:0] _GEN_0 = {{11{_T_6[1]}},_T_6}; // @[PositFMA.scala 34:45]
  wire [12:0] normProductExponent = $signed(productExponent) + $signed(_GEN_0); // @[PositFMA.scala 34:45]
  wire  prodStickyBit = prodOverflow & productFraction[0]; // @[PositFMA.scala 35:42]
  wire  isAddendGtProduct = 13'sh0 > $signed(normProductExponent); // @[PositFMA.scala 43:24]
  wire [12:0] gExp = isAddendGtProduct ? $signed(13'sh0) : $signed(normProductExponent); // @[PositFMA.scala 46:18]
  wire [114:0] gFrac = isAddendGtProduct ? 115'h0 : normProductFraction; // @[PositFMA.scala 47:18]
  wire  gSign = isAddendGtProduct ? addendSign : productSign; // @[PositFMA.scala 48:18]
  wire [12:0] lExp = isAddendGtProduct ? $signed(normProductExponent) : $signed(13'sh0); // @[PositFMA.scala 50:18]
  wire [114:0] lFrac = isAddendGtProduct ? normProductFraction : 115'h0; // @[PositFMA.scala 51:18]
  wire  lSign = isAddendGtProduct ? productSign : addendSign; // @[PositFMA.scala 52:18]
  wire [12:0] expDiff = $signed(gExp) - $signed(lExp); // @[PositFMA.scala 54:37]
  wire  shftInBound = expDiff < 13'h73; // @[PositFMA.scala 55:29]
  wire [114:0] _T_20 = lFrac >> expDiff; // @[PositFMA.scala 57:28]
  wire [115:0] shiftedLFrac = shftInBound ? {{1'd0}, _T_20} : 116'h0; // @[PositFMA.scala 57:8]
  wire [8191:0] _T_21 = 8192'h1 << expDiff; // @[OneHot.scala 58:35]
  wire [8191:0] _T_23 = _T_21 - 8192'h1; // @[common.scala 23:44]
  wire [115:0] lfracStickyMask = _T_23[115:0]; // @[PositFMA.scala 59:26]
  wire [115:0] _GEN_1 = {{1'd0}, lFrac}; // @[PositFMA.scala 60:31]
  wire [115:0] _T_24 = _GEN_1 & lfracStickyMask; // @[PositFMA.scala 60:31]
  wire  lFracStickyBit = _T_24 != 116'h0; // @[PositFMA.scala 60:53]
  wire  _T_25 = gSign ^ lSign; // @[PositFMA.scala 62:28]
  wire  isAddition = ~_T_25; // @[PositFMA.scala 62:20]
  wire [115:0] _T_26 = ~shiftedLFrac; // @[PositFMA.scala 64:35]
  wire [115:0] _T_28 = _T_26 + 116'h1; // @[PositFMA.scala 64:49]
  wire [115:0] signedLFrac = isAddition ? shiftedLFrac : _T_28; // @[PositFMA.scala 64:8]
  wire [115:0] _GEN_2 = {{1'd0}, gFrac}; // @[PositFMA.scala 66:55]
  wire [116:0] _T_29 = _GEN_2 + signedLFrac; // @[PositFMA.scala 66:55]
  wire [115:0] fmaFraction = _T_29[115:0];
  wire  fmaOverflow = isAddition & fmaFraction[115]; // @[PositFMA.scala 68:32]
  wire [115:0] _T_32 = {fmaFraction[114:0],1'h0}; // @[Cat.scala 30:58]
  wire [115:0] adjFmaFraction = fmaOverflow ? fmaFraction : _T_32; // @[PositFMA.scala 70:8]
  wire [1:0] _T_34 = {1'h0,fmaOverflow}; // @[PositFMA.scala 71:59]
  wire [12:0] _GEN_3 = {{11{_T_34[1]}},_T_34}; // @[PositFMA.scala 71:29]
  wire [12:0] adjFmaExponent = $signed(gExp) + $signed(_GEN_3); // @[PositFMA.scala 71:29]
  wire [6:0] _T_153 = adjFmaFraction[1] ? 7'h72 : 7'h73; // @[Mux.scala 47:69]
  wire [6:0] _T_154 = adjFmaFraction[2] ? 7'h71 : _T_153; // @[Mux.scala 47:69]
  wire [6:0] _T_155 = adjFmaFraction[3] ? 7'h70 : _T_154; // @[Mux.scala 47:69]
  wire [6:0] _T_156 = adjFmaFraction[4] ? 7'h6f : _T_155; // @[Mux.scala 47:69]
  wire [6:0] _T_157 = adjFmaFraction[5] ? 7'h6e : _T_156; // @[Mux.scala 47:69]
  wire [6:0] _T_158 = adjFmaFraction[6] ? 7'h6d : _T_157; // @[Mux.scala 47:69]
  wire [6:0] _T_159 = adjFmaFraction[7] ? 7'h6c : _T_158; // @[Mux.scala 47:69]
  wire [6:0] _T_160 = adjFmaFraction[8] ? 7'h6b : _T_159; // @[Mux.scala 47:69]
  wire [6:0] _T_161 = adjFmaFraction[9] ? 7'h6a : _T_160; // @[Mux.scala 47:69]
  wire [6:0] _T_162 = adjFmaFraction[10] ? 7'h69 : _T_161; // @[Mux.scala 47:69]
  wire [6:0] _T_163 = adjFmaFraction[11] ? 7'h68 : _T_162; // @[Mux.scala 47:69]
  wire [6:0] _T_164 = adjFmaFraction[12] ? 7'h67 : _T_163; // @[Mux.scala 47:69]
  wire [6:0] _T_165 = adjFmaFraction[13] ? 7'h66 : _T_164; // @[Mux.scala 47:69]
  wire [6:0] _T_166 = adjFmaFraction[14] ? 7'h65 : _T_165; // @[Mux.scala 47:69]
  wire [6:0] _T_167 = adjFmaFraction[15] ? 7'h64 : _T_166; // @[Mux.scala 47:69]
  wire [6:0] _T_168 = adjFmaFraction[16] ? 7'h63 : _T_167; // @[Mux.scala 47:69]
  wire [6:0] _T_169 = adjFmaFraction[17] ? 7'h62 : _T_168; // @[Mux.scala 47:69]
  wire [6:0] _T_170 = adjFmaFraction[18] ? 7'h61 : _T_169; // @[Mux.scala 47:69]
  wire [6:0] _T_171 = adjFmaFraction[19] ? 7'h60 : _T_170; // @[Mux.scala 47:69]
  wire [6:0] _T_172 = adjFmaFraction[20] ? 7'h5f : _T_171; // @[Mux.scala 47:69]
  wire [6:0] _T_173 = adjFmaFraction[21] ? 7'h5e : _T_172; // @[Mux.scala 47:69]
  wire [6:0] _T_174 = adjFmaFraction[22] ? 7'h5d : _T_173; // @[Mux.scala 47:69]
  wire [6:0] _T_175 = adjFmaFraction[23] ? 7'h5c : _T_174; // @[Mux.scala 47:69]
  wire [6:0] _T_176 = adjFmaFraction[24] ? 7'h5b : _T_175; // @[Mux.scala 47:69]
  wire [6:0] _T_177 = adjFmaFraction[25] ? 7'h5a : _T_176; // @[Mux.scala 47:69]
  wire [6:0] _T_178 = adjFmaFraction[26] ? 7'h59 : _T_177; // @[Mux.scala 47:69]
  wire [6:0] _T_179 = adjFmaFraction[27] ? 7'h58 : _T_178; // @[Mux.scala 47:69]
  wire [6:0] _T_180 = adjFmaFraction[28] ? 7'h57 : _T_179; // @[Mux.scala 47:69]
  wire [6:0] _T_181 = adjFmaFraction[29] ? 7'h56 : _T_180; // @[Mux.scala 47:69]
  wire [6:0] _T_182 = adjFmaFraction[30] ? 7'h55 : _T_181; // @[Mux.scala 47:69]
  wire [6:0] _T_183 = adjFmaFraction[31] ? 7'h54 : _T_182; // @[Mux.scala 47:69]
  wire [6:0] _T_184 = adjFmaFraction[32] ? 7'h53 : _T_183; // @[Mux.scala 47:69]
  wire [6:0] _T_185 = adjFmaFraction[33] ? 7'h52 : _T_184; // @[Mux.scala 47:69]
  wire [6:0] _T_186 = adjFmaFraction[34] ? 7'h51 : _T_185; // @[Mux.scala 47:69]
  wire [6:0] _T_187 = adjFmaFraction[35] ? 7'h50 : _T_186; // @[Mux.scala 47:69]
  wire [6:0] _T_188 = adjFmaFraction[36] ? 7'h4f : _T_187; // @[Mux.scala 47:69]
  wire [6:0] _T_189 = adjFmaFraction[37] ? 7'h4e : _T_188; // @[Mux.scala 47:69]
  wire [6:0] _T_190 = adjFmaFraction[38] ? 7'h4d : _T_189; // @[Mux.scala 47:69]
  wire [6:0] _T_191 = adjFmaFraction[39] ? 7'h4c : _T_190; // @[Mux.scala 47:69]
  wire [6:0] _T_192 = adjFmaFraction[40] ? 7'h4b : _T_191; // @[Mux.scala 47:69]
  wire [6:0] _T_193 = adjFmaFraction[41] ? 7'h4a : _T_192; // @[Mux.scala 47:69]
  wire [6:0] _T_194 = adjFmaFraction[42] ? 7'h49 : _T_193; // @[Mux.scala 47:69]
  wire [6:0] _T_195 = adjFmaFraction[43] ? 7'h48 : _T_194; // @[Mux.scala 47:69]
  wire [6:0] _T_196 = adjFmaFraction[44] ? 7'h47 : _T_195; // @[Mux.scala 47:69]
  wire [6:0] _T_197 = adjFmaFraction[45] ? 7'h46 : _T_196; // @[Mux.scala 47:69]
  wire [6:0] _T_198 = adjFmaFraction[46] ? 7'h45 : _T_197; // @[Mux.scala 47:69]
  wire [6:0] _T_199 = adjFmaFraction[47] ? 7'h44 : _T_198; // @[Mux.scala 47:69]
  wire [6:0] _T_200 = adjFmaFraction[48] ? 7'h43 : _T_199; // @[Mux.scala 47:69]
  wire [6:0] _T_201 = adjFmaFraction[49] ? 7'h42 : _T_200; // @[Mux.scala 47:69]
  wire [6:0] _T_202 = adjFmaFraction[50] ? 7'h41 : _T_201; // @[Mux.scala 47:69]
  wire [6:0] _T_203 = adjFmaFraction[51] ? 7'h40 : _T_202; // @[Mux.scala 47:69]
  wire [6:0] _T_204 = adjFmaFraction[52] ? 7'h3f : _T_203; // @[Mux.scala 47:69]
  wire [6:0] _T_205 = adjFmaFraction[53] ? 7'h3e : _T_204; // @[Mux.scala 47:69]
  wire [6:0] _T_206 = adjFmaFraction[54] ? 7'h3d : _T_205; // @[Mux.scala 47:69]
  wire [6:0] _T_207 = adjFmaFraction[55] ? 7'h3c : _T_206; // @[Mux.scala 47:69]
  wire [6:0] _T_208 = adjFmaFraction[56] ? 7'h3b : _T_207; // @[Mux.scala 47:69]
  wire [6:0] _T_209 = adjFmaFraction[57] ? 7'h3a : _T_208; // @[Mux.scala 47:69]
  wire [6:0] _T_210 = adjFmaFraction[58] ? 7'h39 : _T_209; // @[Mux.scala 47:69]
  wire [6:0] _T_211 = adjFmaFraction[59] ? 7'h38 : _T_210; // @[Mux.scala 47:69]
  wire [6:0] _T_212 = adjFmaFraction[60] ? 7'h37 : _T_211; // @[Mux.scala 47:69]
  wire [6:0] _T_213 = adjFmaFraction[61] ? 7'h36 : _T_212; // @[Mux.scala 47:69]
  wire [6:0] _T_214 = adjFmaFraction[62] ? 7'h35 : _T_213; // @[Mux.scala 47:69]
  wire [6:0] _T_215 = adjFmaFraction[63] ? 7'h34 : _T_214; // @[Mux.scala 47:69]
  wire [6:0] _T_216 = adjFmaFraction[64] ? 7'h33 : _T_215; // @[Mux.scala 47:69]
  wire [6:0] _T_217 = adjFmaFraction[65] ? 7'h32 : _T_216; // @[Mux.scala 47:69]
  wire [6:0] _T_218 = adjFmaFraction[66] ? 7'h31 : _T_217; // @[Mux.scala 47:69]
  wire [6:0] _T_219 = adjFmaFraction[67] ? 7'h30 : _T_218; // @[Mux.scala 47:69]
  wire [6:0] _T_220 = adjFmaFraction[68] ? 7'h2f : _T_219; // @[Mux.scala 47:69]
  wire [6:0] _T_221 = adjFmaFraction[69] ? 7'h2e : _T_220; // @[Mux.scala 47:69]
  wire [6:0] _T_222 = adjFmaFraction[70] ? 7'h2d : _T_221; // @[Mux.scala 47:69]
  wire [6:0] _T_223 = adjFmaFraction[71] ? 7'h2c : _T_222; // @[Mux.scala 47:69]
  wire [6:0] _T_224 = adjFmaFraction[72] ? 7'h2b : _T_223; // @[Mux.scala 47:69]
  wire [6:0] _T_225 = adjFmaFraction[73] ? 7'h2a : _T_224; // @[Mux.scala 47:69]
  wire [6:0] _T_226 = adjFmaFraction[74] ? 7'h29 : _T_225; // @[Mux.scala 47:69]
  wire [6:0] _T_227 = adjFmaFraction[75] ? 7'h28 : _T_226; // @[Mux.scala 47:69]
  wire [6:0] _T_228 = adjFmaFraction[76] ? 7'h27 : _T_227; // @[Mux.scala 47:69]
  wire [6:0] _T_229 = adjFmaFraction[77] ? 7'h26 : _T_228; // @[Mux.scala 47:69]
  wire [6:0] _T_230 = adjFmaFraction[78] ? 7'h25 : _T_229; // @[Mux.scala 47:69]
  wire [6:0] _T_231 = adjFmaFraction[79] ? 7'h24 : _T_230; // @[Mux.scala 47:69]
  wire [6:0] _T_232 = adjFmaFraction[80] ? 7'h23 : _T_231; // @[Mux.scala 47:69]
  wire [6:0] _T_233 = adjFmaFraction[81] ? 7'h22 : _T_232; // @[Mux.scala 47:69]
  wire [6:0] _T_234 = adjFmaFraction[82] ? 7'h21 : _T_233; // @[Mux.scala 47:69]
  wire [6:0] _T_235 = adjFmaFraction[83] ? 7'h20 : _T_234; // @[Mux.scala 47:69]
  wire [6:0] _T_236 = adjFmaFraction[84] ? 7'h1f : _T_235; // @[Mux.scala 47:69]
  wire [6:0] _T_237 = adjFmaFraction[85] ? 7'h1e : _T_236; // @[Mux.scala 47:69]
  wire [6:0] _T_238 = adjFmaFraction[86] ? 7'h1d : _T_237; // @[Mux.scala 47:69]
  wire [6:0] _T_239 = adjFmaFraction[87] ? 7'h1c : _T_238; // @[Mux.scala 47:69]
  wire [6:0] _T_240 = adjFmaFraction[88] ? 7'h1b : _T_239; // @[Mux.scala 47:69]
  wire [6:0] _T_241 = adjFmaFraction[89] ? 7'h1a : _T_240; // @[Mux.scala 47:69]
  wire [6:0] _T_242 = adjFmaFraction[90] ? 7'h19 : _T_241; // @[Mux.scala 47:69]
  wire [6:0] _T_243 = adjFmaFraction[91] ? 7'h18 : _T_242; // @[Mux.scala 47:69]
  wire [6:0] _T_244 = adjFmaFraction[92] ? 7'h17 : _T_243; // @[Mux.scala 47:69]
  wire [6:0] _T_245 = adjFmaFraction[93] ? 7'h16 : _T_244; // @[Mux.scala 47:69]
  wire [6:0] _T_246 = adjFmaFraction[94] ? 7'h15 : _T_245; // @[Mux.scala 47:69]
  wire [6:0] _T_247 = adjFmaFraction[95] ? 7'h14 : _T_246; // @[Mux.scala 47:69]
  wire [6:0] _T_248 = adjFmaFraction[96] ? 7'h13 : _T_247; // @[Mux.scala 47:69]
  wire [6:0] _T_249 = adjFmaFraction[97] ? 7'h12 : _T_248; // @[Mux.scala 47:69]
  wire [6:0] _T_250 = adjFmaFraction[98] ? 7'h11 : _T_249; // @[Mux.scala 47:69]
  wire [6:0] _T_251 = adjFmaFraction[99] ? 7'h10 : _T_250; // @[Mux.scala 47:69]
  wire [6:0] _T_252 = adjFmaFraction[100] ? 7'hf : _T_251; // @[Mux.scala 47:69]
  wire [6:0] _T_253 = adjFmaFraction[101] ? 7'he : _T_252; // @[Mux.scala 47:69]
  wire [6:0] _T_254 = adjFmaFraction[102] ? 7'hd : _T_253; // @[Mux.scala 47:69]
  wire [6:0] _T_255 = adjFmaFraction[103] ? 7'hc : _T_254; // @[Mux.scala 47:69]
  wire [6:0] _T_256 = adjFmaFraction[104] ? 7'hb : _T_255; // @[Mux.scala 47:69]
  wire [6:0] _T_257 = adjFmaFraction[105] ? 7'ha : _T_256; // @[Mux.scala 47:69]
  wire [6:0] _T_258 = adjFmaFraction[106] ? 7'h9 : _T_257; // @[Mux.scala 47:69]
  wire [6:0] _T_259 = adjFmaFraction[107] ? 7'h8 : _T_258; // @[Mux.scala 47:69]
  wire [6:0] _T_260 = adjFmaFraction[108] ? 7'h7 : _T_259; // @[Mux.scala 47:69]
  wire [6:0] _T_261 = adjFmaFraction[109] ? 7'h6 : _T_260; // @[Mux.scala 47:69]
  wire [6:0] _T_262 = adjFmaFraction[110] ? 7'h5 : _T_261; // @[Mux.scala 47:69]
  wire [6:0] _T_263 = adjFmaFraction[111] ? 7'h4 : _T_262; // @[Mux.scala 47:69]
  wire [6:0] _T_264 = adjFmaFraction[112] ? 7'h3 : _T_263; // @[Mux.scala 47:69]
  wire [6:0] _T_265 = adjFmaFraction[113] ? 7'h2 : _T_264; // @[Mux.scala 47:69]
  wire [6:0] _T_266 = adjFmaFraction[114] ? 7'h1 : _T_265; // @[Mux.scala 47:69]
  wire [6:0] normalizationFactor = adjFmaFraction[115] ? 7'h0 : _T_266; // @[Mux.scala 47:69]
  wire [6:0] _T_267 = adjFmaFraction[115] ? 7'h0 : _T_266; // @[PositFMA.scala 74:69]
  wire [12:0] _GEN_4 = {{6{_T_267[6]}},_T_267}; // @[PositFMA.scala 74:40]
  wire [13:0] normFmaExponent = $signed(adjFmaExponent) - $signed(_GEN_4); // @[PositFMA.scala 74:40]
  wire [242:0] _GEN_5 = {{127'd0}, adjFmaFraction}; // @[PositFMA.scala 75:41]
  wire [242:0] _T_268 = _GEN_5 << normalizationFactor; // @[PositFMA.scala 75:41]
  wire [115:0] normFmaFraction = _T_268[115:0]; // @[PositFMA.scala 75:64]
  wire  _T_277 = prodStickyBit | lFracStickyBit; // @[PositFMA.scala 85:36]
  wire  _T_279 = normFmaFraction[55:0] != 56'h0; // @[PositFMA.scala 85:130]
  assign io_trailingBits = normFmaFraction[57:56]; // @[PositFMA.scala 84:19]
  assign io_stickyBit = _T_277 | _T_279; // @[PositFMA.scala 85:19]
  assign io_out_sign = isAddendGtProduct ? addendSign : productSign; // @[PositFMA.scala 87:10]
  assign io_out_exponent = normFmaExponent[11:0]; // @[PositFMA.scala 87:10]
  assign io_out_fraction = normFmaFraction[115:58]; // @[PositFMA.scala 87:10]
  assign io_out_isNaR = io_num1_isNaR | io_num2_isNaR; // @[PositFMA.scala 87:10]
endmodule
module PositDivSqrtCore(
  input         clock,
  input         reset,
  input         io_validIn,
  output        io_readyIn,
  input         io_sqrtOp,
  input         io_num1_sign,
  input  [11:0] io_num1_exponent,
  input  [57:0] io_num1_fraction,
  input         io_num1_isZero,
  input         io_num1_isNaR,
  input         io_num2_sign,
  input  [11:0] io_num2_exponent,
  input  [57:0] io_num2_fraction,
  input         io_num2_isZero,
  input         io_num2_isNaR,
  output        io_validOut_div,
  output        io_validOut_sqrt,
  output [4:0]  io_exceptions,
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [11:0] io_out_exponent,
  output [57:0] io_out_fraction,
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
  reg [11:0] divSqrtExp; // @[PositDivSqrt.scala 34:30]
  reg [31:0] _RAND_6;
  reg [61:0] divSqrtFrac; // @[PositDivSqrt.scala 35:30]
  reg [63:0] _RAND_7;
  reg [58:0] remLo; // @[PositDivSqrt.scala 40:24]
  reg [63:0] _RAND_8;
  reg [61:0] remHi; // @[PositDivSqrt.scala 41:24]
  reg [63:0] _RAND_9;
  reg [61:0] divisor; // @[PositDivSqrt.scala 42:24]
  reg [63:0] _RAND_10;
  wire  _T_2 = ~io_sqrtOp; // @[PositDivSqrt.scala 44:21]
  wire  divZ = _T_2 & io_num2_isZero; // @[PositDivSqrt.scala 44:32]
  wire  _T_3 = io_num1_sign | io_num1_isNaR; // @[PositDivSqrt.scala 45:46]
  wire  _T_4 = io_num1_isNaR | io_num2_isNaR; // @[PositDivSqrt.scala 45:71]
  wire  _T_5 = _T_4 | divZ; // @[PositDivSqrt.scala 45:84]
  wire  isNaR = io_sqrtOp ? _T_3 : _T_5; // @[PositDivSqrt.scala 45:24]
  wire  specialCase = isNaR | io_num1_isZero; // @[PositDivSqrt.scala 47:27]
  wire [11:0] expDiff = $signed(io_num1_exponent) - $signed(io_num2_exponent); // @[PositDivSqrt.scala 48:35]
  wire  idle = cycleCount == 6'h0; // @[PositDivSqrt.scala 50:28]
  wire  readyIn = cycleCount <= 6'h1; // @[PositDivSqrt.scala 51:28]
  wire  starting = readyIn & io_validIn; // @[PositDivSqrt.scala 53:34]
  wire  _T_8 = ~specialCase; // @[PositDivSqrt.scala 54:38]
  wire  started_normally = starting & _T_8; // @[PositDivSqrt.scala 54:35]
  wire  _T_11 = io_sqrtOp & io_num1_exponent[0]; // @[PositDivSqrt.scala 56:32]
  wire [58:0] _T_12 = {io_num1_fraction, 1'h0}; // @[PositDivSqrt.scala 56:76]
  wire [58:0] radicand = _T_11 ? _T_12 : {{1'd0}, io_num1_fraction}; // @[PositDivSqrt.scala 56:21]
  wire  _T_13 = ~idle; // @[PositDivSqrt.scala 58:8]
  wire  _T_14 = _T_13 | io_validIn; // @[PositDivSqrt.scala 58:14]
  wire  _T_15 = starting & specialCase; // @[PositDivSqrt.scala 59:32]
  wire [1:0] _T_16 = _T_15 ? 2'h2 : 2'h0; // @[PositDivSqrt.scala 59:22]
  wire [5:0] _T_17 = started_normally ? 6'h3e : 6'h0; // @[PositDivSqrt.scala 60:22]
  wire [5:0] _GEN_9 = {{4'd0}, _T_16}; // @[PositDivSqrt.scala 59:58]
  wire [5:0] _T_18 = _GEN_9 | _T_17; // @[PositDivSqrt.scala 59:58]
  wire [5:0] _T_21 = cycleCount - 6'h1; // @[PositDivSqrt.scala 61:41]
  wire [5:0] _T_22 = _T_13 ? _T_21 : 6'h0; // @[PositDivSqrt.scala 61:22]
  wire [5:0] _T_23 = _T_18 | _T_22; // @[PositDivSqrt.scala 60:72]
  wire [3:0] _T_24 = divZ ? 4'h8 : 4'h0; // @[PositDivSqrt.scala 70:26]
  wire  _T_25 = io_num1_sign ^ io_num2_sign; // @[PositDivSqrt.scala 74:53]
  wire [10:0] _T_27 = io_num1_exponent[11:1]; // @[PositDivSqrt.scala 75:48]
  wire  _T_30 = started_normally & _T_2; // @[PositDivSqrt.scala 78:25]
  wire  _T_31 = readyIn & io_sqrtOp; // @[PositDivSqrt.scala 82:24]
  wire [60:0] _T_32 = {radicand, 2'h0}; // @[PositDivSqrt.scala 82:47]
  wire [60:0] _T_33 = _T_31 ? _T_32 : 61'h0; // @[PositDivSqrt.scala 82:15]
  wire  _T_34 = ~readyIn; // @[PositDivSqrt.scala 83:16]
  wire  _T_35 = _T_34 & sqrtOp_stored; // @[PositDivSqrt.scala 83:25]
  wire [60:0] _T_36 = {remLo, 2'h0}; // @[PositDivSqrt.scala 83:49]
  wire [60:0] _T_37 = _T_35 ? _T_36 : 61'h0; // @[PositDivSqrt.scala 83:15]
  wire [60:0] _T_38 = _T_33 | _T_37; // @[PositDivSqrt.scala 82:58]
  wire [1:0] _T_41 = _T_31 ? radicand[58:57] : 2'h0; // @[PositDivSqrt.scala 85:16]
  wire  _T_43 = readyIn & _T_2; // @[PositDivSqrt.scala 86:17]
  wire [58:0] _T_44 = _T_43 ? radicand : 59'h0; // @[PositDivSqrt.scala 86:8]
  wire [58:0] _GEN_10 = {{57'd0}, _T_41}; // @[PositDivSqrt.scala 85:118]
  wire [58:0] _T_45 = _GEN_10 | _T_44; // @[PositDivSqrt.scala 85:118]
  wire [63:0] _GEN_11 = {remHi, 2'h0}; // @[PositDivSqrt.scala 87:42]
  wire [64:0] _T_48 = {{1'd0}, _GEN_11}; // @[PositDivSqrt.scala 87:42]
  wire [58:0] _T_49 = {{57'd0}, remLo[58:57]}; // @[PositDivSqrt.scala 87:57]
  wire [64:0] _GEN_13 = {{6'd0}, _T_49}; // @[PositDivSqrt.scala 87:49]
  wire [64:0] _T_50 = _T_48 | _GEN_13; // @[PositDivSqrt.scala 87:49]
  wire [64:0] _T_51 = _T_35 ? _T_50 : 65'h0; // @[PositDivSqrt.scala 87:8]
  wire [64:0] _GEN_14 = {{6'd0}, _T_45}; // @[PositDivSqrt.scala 86:56]
  wire [64:0] _T_52 = _GEN_14 | _T_51; // @[PositDivSqrt.scala 86:56]
  wire  _T_54 = ~sqrtOp_stored; // @[PositDivSqrt.scala 88:21]
  wire  _T_55 = _T_34 & _T_54; // @[PositDivSqrt.scala 88:18]
  wire [62:0] _T_56 = {remHi, 1'h0}; // @[PositDivSqrt.scala 88:43]
  wire [62:0] _T_57 = _T_55 ? _T_56 : 63'h0; // @[PositDivSqrt.scala 88:8]
  wire [64:0] _GEN_15 = {{2'd0}, _T_57}; // @[PositDivSqrt.scala 87:84]
  wire [64:0] rem = _T_52 | _GEN_15; // @[PositDivSqrt.scala 87:84]
  wire [57:0] _T_62 = _T_43 ? io_num2_fraction : 58'h0; // @[PositDivSqrt.scala 93:8]
  wire [57:0] _GEN_16 = {{57'd0}, _T_31}; // @[PositDivSqrt.scala 92:41]
  wire [57:0] _T_63 = _GEN_16 | _T_62; // @[PositDivSqrt.scala 92:41]
  wire [62:0] _T_66 = {divSqrtFrac, 1'h0}; // @[PositDivSqrt.scala 94:52]
  wire [63:0] _T_67 = {_T_66,1'h1}; // @[Cat.scala 30:58]
  wire [63:0] _T_68 = _T_35 ? _T_67 : 64'h0; // @[PositDivSqrt.scala 94:8]
  wire [63:0] _GEN_17 = {{6'd0}, _T_63}; // @[PositDivSqrt.scala 93:52]
  wire [63:0] _T_69 = _GEN_17 | _T_68; // @[PositDivSqrt.scala 93:52]
  wire [61:0] _T_73 = _T_55 ? divisor : 62'h0; // @[PositDivSqrt.scala 95:8]
  wire [63:0] _GEN_18 = {{2'd0}, _T_73}; // @[PositDivSqrt.scala 94:71]
  wire [63:0] testDiv = _T_69 | _GEN_18; // @[PositDivSqrt.scala 94:71]
  wire [65:0] _T_74 = {1'b0,$signed(rem)}; // @[PositDivSqrt.scala 97:21]
  wire [64:0] _T_75 = {1'b0,$signed(testDiv)}; // @[PositDivSqrt.scala 97:36]
  wire [65:0] _GEN_19 = {{1{_T_75[64]}},_T_75}; // @[PositDivSqrt.scala 97:26]
  wire [65:0] testRem = $signed(_T_74) - $signed(_GEN_19); // @[PositDivSqrt.scala 97:26]
  wire  nextBit = $signed(testRem) >= 66'sh0; // @[PositDivSqrt.scala 98:25]
  wire  _T_78 = cycleCount > 6'h2; // @[PositDivSqrt.scala 100:39]
  wire  _T_79 = started_normally | _T_78; // @[PositDivSqrt.scala 100:25]
  wire [65:0] _T_80 = $signed(_T_74) - $signed(_GEN_19); // @[PositDivSqrt.scala 101:41]
  wire [65:0] _T_81 = nextBit ? _T_80 : {{1'd0}, rem}; // @[PositDivSqrt.scala 101:17]
  wire [65:0] _GEN_8 = _T_79 ? _T_81 : {{4'd0}, remHi}; // @[PositDivSqrt.scala 100:46]
  wire [62:0] nextFraction = {divSqrtFrac,nextBit}; // @[Cat.scala 30:58]
  wire  _T_82 = started_normally & nextBit; // @[PositDivSqrt.scala 105:21]
  wire [62:0] _T_84 = _T_34 ? nextFraction : 63'h0; // @[PositDivSqrt.scala 106:17]
  wire [62:0] _GEN_20 = {{62'd0}, _T_82}; // @[PositDivSqrt.scala 105:54]
  wire [62:0] _T_85 = _GEN_20 | _T_84; // @[PositDivSqrt.scala 105:54]
  wire  normReq = ~divSqrtFrac[61]; // @[PositDivSqrt.scala 108:17]
  wire [62:0] _T_87 = {divSqrtFrac,1'h0}; // @[Cat.scala 30:58]
  wire [62:0] _T_88 = normReq ? _T_87 : {{1'd0}, divSqrtFrac}; // @[PositDivSqrt.scala 109:18]
  wire  _T_89 = ~divSqrtFrac[61]; // @[PositDivSqrt.scala 110:42]
  wire [11:0] _GEN_21 = {12{_T_89}}; // @[PositDivSqrt.scala 110:26]
  wire [61:0] frac_out = _T_88[61:0]; // @[PositDivSqrt.scala 109:12]
  wire  validOut = cycleCount == 6'h1; // @[PositDivSqrt.scala 118:29]
  wire  _T_99 = frac_out[1:0] != 2'h0; // @[PositDivSqrt.scala 125:59]
  wire  _T_100 = remHi != 62'h0; // @[PositDivSqrt.scala 125:73]
  assign io_readyIn = cycleCount <= 6'h1; // @[PositDivSqrt.scala 64:14]
  assign io_validOut_div = validOut & _T_54; // @[PositDivSqrt.scala 120:20]
  assign io_validOut_sqrt = validOut & sqrtOp_stored; // @[PositDivSqrt.scala 121:20]
  assign io_exceptions = exec_out; // @[PositDivSqrt.scala 122:20]
  assign io_trailingBits = frac_out[3:2]; // @[PositDivSqrt.scala 124:19]
  assign io_stickyBit = _T_99 | _T_100; // @[PositDivSqrt.scala 125:19]
  assign io_out_sign = sign_out; // @[PositDivSqrt.scala 127:10]
  assign io_out_exponent = $signed(divSqrtExp) + $signed(_GEN_21); // @[PositDivSqrt.scala 127:10]
  assign io_out_fraction = frac_out[61:4]; // @[PositDivSqrt.scala 127:10]
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
  divSqrtExp = _RAND_6[11:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {2{`RANDOM}};
  divSqrtFrac = _RAND_7[61:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {2{`RANDOM}};
  remLo = _RAND_8[58:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {2{`RANDOM}};
  remHi = _RAND_9[61:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {2{`RANDOM}};
  divisor = _RAND_10[61:0];
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
      divSqrtExp <= 12'sh0;
    end else if (started_normally) begin
      if (io_sqrtOp) begin
        divSqrtExp <= {{1{_T_27[10]}},_T_27};
      end else begin
        divSqrtExp <= expDiff;
      end
    end
    if (reset) begin
      divSqrtFrac <= 62'h0;
    end else begin
      divSqrtFrac <= _T_85[61:0];
    end
    if (reset) begin
      remLo <= 59'h0;
    end else begin
      remLo <= _T_38[58:0];
    end
    if (reset) begin
      remHi <= 62'h0;
    end else begin
      remHi <= _GEN_8[61:0];
    end
    if (reset) begin
      divisor <= 62'h0;
    end else if (_T_30) begin
      divisor <= {{4'd0}, io_num2_fraction};
    end
  end
endmodule
module PositMulCore(
  input         io_num1_sign,
  input  [11:0] io_num1_exponent,
  input  [57:0] io_num1_fraction,
  input         io_num1_isZero,
  input         io_num1_isNaR,
  input         io_num2_sign,
  input  [11:0] io_num2_exponent,
  input  [57:0] io_num2_fraction,
  input         io_num2_isZero,
  input         io_num2_isNaR,
  output [1:0]  io_trailingBits,
  output        io_stickyBit,
  output        io_out_sign,
  output [11:0] io_out_exponent,
  output [57:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR
);
  wire [11:0] prodExp = $signed(io_num1_exponent) + $signed(io_num2_exponent); // @[PositMul.scala 19:31]
  wire [115:0] prodFrac = io_num1_fraction * io_num2_fraction; // @[PositMul.scala 21:63]
  wire  prodOverflow = prodFrac[115]; // @[PositMul.scala 22:30]
  wire  _T_3 = ~prodOverflow; // @[PositMul.scala 24:39]
  wire [116:0] _GEN_0 = {{1'd0}, prodFrac}; // @[PositMul.scala 24:35]
  wire [116:0] normProductFrac = _GEN_0 << _T_3; // @[PositMul.scala 24:35]
  wire [1:0] _T_4 = prodOverflow ? $signed(2'sh1) : $signed(2'sh0); // @[PositMul.scala 25:38]
  wire [11:0] _GEN_1 = {{10{_T_4[1]}},_T_4}; // @[PositMul.scala 25:33]
  assign io_trailingBits = normProductFrac[57:56]; // @[PositMul.scala 34:19]
  assign io_stickyBit = normProductFrac[55:0] != 56'h0; // @[PositMul.scala 35:19]
  assign io_out_sign = io_num1_sign ^ io_num2_sign; // @[PositMul.scala 37:10]
  assign io_out_exponent = $signed(prodExp) + $signed(_GEN_1); // @[PositMul.scala 37:10]
  assign io_out_fraction = normProductFrac[115:58]; // @[PositMul.scala 37:10]
  assign io_out_isZero = io_num1_isZero | io_num2_isZero; // @[PositMul.scala 37:10]
  assign io_out_isNaR = io_num1_isNaR | io_num2_isNaR; // @[PositMul.scala 37:10]
endmodule
module PositExtractor(
  input  [63:0] io_in,
  output        io_out_sign,
  output [11:0] io_out_exponent,
  output [57:0] io_out_fraction,
  output        io_out_isZero,
  output        io_out_isNaR
);
  wire  sign = io_in[63]; // @[PositExtractor.scala 12:21]
  wire [63:0] _T = ~io_in; // @[PositExtractor.scala 13:26]
  wire [63:0] _T_2 = _T + 64'h1; // @[PositExtractor.scala 13:33]
  wire [63:0] absIn = sign ? _T_2 : io_in; // @[PositExtractor.scala 13:19]
  wire  negExp = ~absIn[62]; // @[PositExtractor.scala 14:16]
  wire [62:0] regExpFrac = absIn[62:0]; // @[PositExtractor.scala 16:26]
  wire [62:0] _T_4 = ~regExpFrac; // @[PositExtractor.scala 17:45]
  wire [62:0] zerosRegime = negExp ? regExpFrac : _T_4; // @[PositExtractor.scala 17:24]
  wire  _T_5 = zerosRegime != 63'h0; // @[common.scala 61:41]
  wire  _T_6 = ~_T_5; // @[common.scala 61:33]
  wire [5:0] _T_70 = zerosRegime[1] ? 6'h3d : 6'h3e; // @[Mux.scala 47:69]
  wire [5:0] _T_71 = zerosRegime[2] ? 6'h3c : _T_70; // @[Mux.scala 47:69]
  wire [5:0] _T_72 = zerosRegime[3] ? 6'h3b : _T_71; // @[Mux.scala 47:69]
  wire [5:0] _T_73 = zerosRegime[4] ? 6'h3a : _T_72; // @[Mux.scala 47:69]
  wire [5:0] _T_74 = zerosRegime[5] ? 6'h39 : _T_73; // @[Mux.scala 47:69]
  wire [5:0] _T_75 = zerosRegime[6] ? 6'h38 : _T_74; // @[Mux.scala 47:69]
  wire [5:0] _T_76 = zerosRegime[7] ? 6'h37 : _T_75; // @[Mux.scala 47:69]
  wire [5:0] _T_77 = zerosRegime[8] ? 6'h36 : _T_76; // @[Mux.scala 47:69]
  wire [5:0] _T_78 = zerosRegime[9] ? 6'h35 : _T_77; // @[Mux.scala 47:69]
  wire [5:0] _T_79 = zerosRegime[10] ? 6'h34 : _T_78; // @[Mux.scala 47:69]
  wire [5:0] _T_80 = zerosRegime[11] ? 6'h33 : _T_79; // @[Mux.scala 47:69]
  wire [5:0] _T_81 = zerosRegime[12] ? 6'h32 : _T_80; // @[Mux.scala 47:69]
  wire [5:0] _T_82 = zerosRegime[13] ? 6'h31 : _T_81; // @[Mux.scala 47:69]
  wire [5:0] _T_83 = zerosRegime[14] ? 6'h30 : _T_82; // @[Mux.scala 47:69]
  wire [5:0] _T_84 = zerosRegime[15] ? 6'h2f : _T_83; // @[Mux.scala 47:69]
  wire [5:0] _T_85 = zerosRegime[16] ? 6'h2e : _T_84; // @[Mux.scala 47:69]
  wire [5:0] _T_86 = zerosRegime[17] ? 6'h2d : _T_85; // @[Mux.scala 47:69]
  wire [5:0] _T_87 = zerosRegime[18] ? 6'h2c : _T_86; // @[Mux.scala 47:69]
  wire [5:0] _T_88 = zerosRegime[19] ? 6'h2b : _T_87; // @[Mux.scala 47:69]
  wire [5:0] _T_89 = zerosRegime[20] ? 6'h2a : _T_88; // @[Mux.scala 47:69]
  wire [5:0] _T_90 = zerosRegime[21] ? 6'h29 : _T_89; // @[Mux.scala 47:69]
  wire [5:0] _T_91 = zerosRegime[22] ? 6'h28 : _T_90; // @[Mux.scala 47:69]
  wire [5:0] _T_92 = zerosRegime[23] ? 6'h27 : _T_91; // @[Mux.scala 47:69]
  wire [5:0] _T_93 = zerosRegime[24] ? 6'h26 : _T_92; // @[Mux.scala 47:69]
  wire [5:0] _T_94 = zerosRegime[25] ? 6'h25 : _T_93; // @[Mux.scala 47:69]
  wire [5:0] _T_95 = zerosRegime[26] ? 6'h24 : _T_94; // @[Mux.scala 47:69]
  wire [5:0] _T_96 = zerosRegime[27] ? 6'h23 : _T_95; // @[Mux.scala 47:69]
  wire [5:0] _T_97 = zerosRegime[28] ? 6'h22 : _T_96; // @[Mux.scala 47:69]
  wire [5:0] _T_98 = zerosRegime[29] ? 6'h21 : _T_97; // @[Mux.scala 47:69]
  wire [5:0] _T_99 = zerosRegime[30] ? 6'h20 : _T_98; // @[Mux.scala 47:69]
  wire [5:0] _T_100 = zerosRegime[31] ? 6'h1f : _T_99; // @[Mux.scala 47:69]
  wire [5:0] _T_101 = zerosRegime[32] ? 6'h1e : _T_100; // @[Mux.scala 47:69]
  wire [5:0] _T_102 = zerosRegime[33] ? 6'h1d : _T_101; // @[Mux.scala 47:69]
  wire [5:0] _T_103 = zerosRegime[34] ? 6'h1c : _T_102; // @[Mux.scala 47:69]
  wire [5:0] _T_104 = zerosRegime[35] ? 6'h1b : _T_103; // @[Mux.scala 47:69]
  wire [5:0] _T_105 = zerosRegime[36] ? 6'h1a : _T_104; // @[Mux.scala 47:69]
  wire [5:0] _T_106 = zerosRegime[37] ? 6'h19 : _T_105; // @[Mux.scala 47:69]
  wire [5:0] _T_107 = zerosRegime[38] ? 6'h18 : _T_106; // @[Mux.scala 47:69]
  wire [5:0] _T_108 = zerosRegime[39] ? 6'h17 : _T_107; // @[Mux.scala 47:69]
  wire [5:0] _T_109 = zerosRegime[40] ? 6'h16 : _T_108; // @[Mux.scala 47:69]
  wire [5:0] _T_110 = zerosRegime[41] ? 6'h15 : _T_109; // @[Mux.scala 47:69]
  wire [5:0] _T_111 = zerosRegime[42] ? 6'h14 : _T_110; // @[Mux.scala 47:69]
  wire [5:0] _T_112 = zerosRegime[43] ? 6'h13 : _T_111; // @[Mux.scala 47:69]
  wire [5:0] _T_113 = zerosRegime[44] ? 6'h12 : _T_112; // @[Mux.scala 47:69]
  wire [5:0] _T_114 = zerosRegime[45] ? 6'h11 : _T_113; // @[Mux.scala 47:69]
  wire [5:0] _T_115 = zerosRegime[46] ? 6'h10 : _T_114; // @[Mux.scala 47:69]
  wire [5:0] _T_116 = zerosRegime[47] ? 6'hf : _T_115; // @[Mux.scala 47:69]
  wire [5:0] _T_117 = zerosRegime[48] ? 6'he : _T_116; // @[Mux.scala 47:69]
  wire [5:0] _T_118 = zerosRegime[49] ? 6'hd : _T_117; // @[Mux.scala 47:69]
  wire [5:0] _T_119 = zerosRegime[50] ? 6'hc : _T_118; // @[Mux.scala 47:69]
  wire [5:0] _T_120 = zerosRegime[51] ? 6'hb : _T_119; // @[Mux.scala 47:69]
  wire [5:0] _T_121 = zerosRegime[52] ? 6'ha : _T_120; // @[Mux.scala 47:69]
  wire [5:0] _T_122 = zerosRegime[53] ? 6'h9 : _T_121; // @[Mux.scala 47:69]
  wire [5:0] _T_123 = zerosRegime[54] ? 6'h8 : _T_122; // @[Mux.scala 47:69]
  wire [5:0] _T_124 = zerosRegime[55] ? 6'h7 : _T_123; // @[Mux.scala 47:69]
  wire [5:0] _T_125 = zerosRegime[56] ? 6'h6 : _T_124; // @[Mux.scala 47:69]
  wire [5:0] _T_126 = zerosRegime[57] ? 6'h5 : _T_125; // @[Mux.scala 47:69]
  wire [5:0] _T_127 = zerosRegime[58] ? 6'h4 : _T_126; // @[Mux.scala 47:69]
  wire [5:0] _T_128 = zerosRegime[59] ? 6'h3 : _T_127; // @[Mux.scala 47:69]
  wire [5:0] _T_129 = zerosRegime[60] ? 6'h2 : _T_128; // @[Mux.scala 47:69]
  wire [5:0] _T_130 = zerosRegime[61] ? 6'h1 : _T_129; // @[Mux.scala 47:69]
  wire [5:0] _T_131 = zerosRegime[62] ? 6'h0 : _T_130; // @[Mux.scala 47:69]
  wire [5:0] _T_132 = _T_6 ? 6'h3f : _T_131; // @[PositExtractor.scala 20:10]
  wire [6:0] regimeCount = {1'h0,_T_132}; // @[Cat.scala 30:58]
  wire [6:0] _T_133 = ~regimeCount; // @[PositExtractor.scala 22:17]
  wire [6:0] _T_135 = _T_133 + 7'h1; // @[PositExtractor.scala 22:30]
  wire [6:0] _T_137 = regimeCount - 7'h1; // @[PositExtractor.scala 22:49]
  wire [6:0] regime = negExp ? _T_135 : _T_137; // @[PositExtractor.scala 22:8]
  wire [6:0] _T_139 = regimeCount + 7'h2; // @[PositExtractor.scala 24:39]
  wire [190:0] _GEN_0 = {{127'd0}, absIn}; // @[PositExtractor.scala 24:23]
  wire [190:0] expFrac = _GEN_0 << _T_139; // @[PositExtractor.scala 24:23]
  wire [3:0] extractedExp = expFrac[63:60]; // @[PositExtractor.scala 26:24]
  wire [56:0] frac = expFrac[59:3]; // @[PositExtractor.scala 28:21]
  wire  _T_142 = io_in[62:0] != 63'h0; // @[common.scala 27:71]
  wire  _T_143 = ~_T_142; // @[common.scala 27:53]
  wire  _T_145 = io_in != 64'h0; // @[common.scala 61:41]
  wire [10:0] _T_148 = {regime,extractedExp}; // @[PositExtractor.scala 37:11]
  assign io_out_sign = io_in[63]; // @[PositExtractor.scala 33:19]
  assign io_out_exponent = {{1{_T_148[10]}},_T_148}; // @[PositExtractor.scala 34:19]
  assign io_out_fraction = {1'h1,frac}; // @[PositExtractor.scala 38:19]
  assign io_out_isZero = ~_T_145; // @[PositExtractor.scala 31:19]
  assign io_out_isNaR = sign & _T_143; // @[PositExtractor.scala 30:19]
endmodule
module PositGenerator(
  input         io_in_sign,
  input  [11:0] io_in_exponent,
  input  [57:0] io_in_fraction,
  input         io_in_isZero,
  input         io_in_isNaR,
  input  [1:0]  io_trailingBits,
  input         io_stickyBit,
  output [63:0] io_out
);
  wire [56:0] fraction = io_in_fraction[56:0]; // @[PositGenerator.scala 15:32]
  wire  negExp = $signed(io_in_exponent) < 12'sh0; // @[PositGenerator.scala 16:31]
  wire [7:0] _T_2 = 8'h0 - io_in_exponent[11:4]; // @[PositGenerator.scala 19:17]
  wire [7:0] regime = negExp ? _T_2 : io_in_exponent[11:4]; // @[PositGenerator.scala 19:8]
  wire [3:0] exponent = io_in_exponent[3:0]; // @[PositGenerator.scala 20:32]
  wire  _T_4 = regime != 8'h3f; // @[PositGenerator.scala 22:31]
  wire  _T_5 = negExp & _T_4; // @[PositGenerator.scala 22:22]
  wire [7:0] _GEN_0 = {{7'd0}, _T_5}; // @[PositGenerator.scala 22:12]
  wire [7:0] offset = regime - _GEN_0; // @[PositGenerator.scala 22:12]
  wire [1:0] _T_7 = negExp ? 2'h1 : 2'h2; // @[PositGenerator.scala 26:14]
  wire [64:0] expFrac = {_T_7,exponent,fraction,io_trailingBits}; // @[PositGenerator.scala 26:87]
  wire [64:0] uT_uS_posit = $signed(expFrac) >>> offset; // @[PositGenerator.scala 31:40]
  wire [62:0] uR_uS_posit = uT_uS_posit[64:2]; // @[PositGenerator.scala 32:32]
  wire [255:0] _T_12 = 256'h1 << offset; // @[OneHot.scala 58:35]
  wire [255:0] _T_14 = _T_12 - 256'h1; // @[common.scala 23:44]
  wire [61:0] stickyBitMask = _T_14[61:0]; // @[PositGenerator.scala 34:43]
  wire [1:0] gr = uT_uS_posit[1:0]; // @[PositGenerator.scala 36:16]
  wire [64:0] _T_15 = {_T_7,exponent,fraction,io_trailingBits}; // @[PositGenerator.scala 38:35]
  wire [64:0] _GEN_1 = {{3'd0}, stickyBitMask}; // @[PositGenerator.scala 38:38]
  wire [64:0] _T_16 = _T_15 & _GEN_1; // @[PositGenerator.scala 38:38]
  wire  _T_17 = _T_16 != 65'h0; // @[PositGenerator.scala 38:58]
  wire  stickyBit = io_stickyBit | _T_17; // @[PositGenerator.scala 38:18]
  wire  _T_19 = uR_uS_posit == 63'h7fffffffffffffff; // @[PositGenerator.scala 43:25]
  wire  _T_22 = ~uR_uS_posit[0]; // @[PositGenerator.scala 44:17]
  wire  _T_24 = _T_22 & gr[1]; // @[PositGenerator.scala 44:33]
  wire  _T_26 = ~gr[0]; // @[PositGenerator.scala 44:43]
  wire  _T_27 = _T_24 & _T_26; // @[PositGenerator.scala 44:41]
  wire  _T_28 = ~stickyBit; // @[PositGenerator.scala 44:52]
  wire  _T_29 = _T_27 & _T_28; // @[PositGenerator.scala 44:50]
  wire  _T_30 = ~_T_29; // @[PositGenerator.scala 44:15]
  wire  _T_31 = gr[1] & _T_30; // @[PositGenerator.scala 44:13]
  wire  roundingBit = _T_19 ? 1'h0 : _T_31; // @[PositGenerator.scala 43:8]
  wire [62:0] _GEN_2 = {{62'd0}, roundingBit}; // @[PositGenerator.scala 45:32]
  wire [62:0] R_uS_posit = uR_uS_posit + _GEN_2; // @[PositGenerator.scala 45:32]
  wire  _T_33 = R_uS_posit != 63'h0; // @[common.scala 61:41]
  wire  _T_34 = ~_T_33; // @[common.scala 61:33]
  wire [62:0] _GEN_3 = {{62'd0}, _T_34}; // @[PositGenerator.scala 49:30]
  wire [62:0] _T_35 = R_uS_posit | _GEN_3; // @[PositGenerator.scala 49:30]
  wire [63:0] uFC_R_uS_posit = {1'h0,_T_35}; // @[Cat.scala 30:58]
  wire [63:0] _T_36 = ~uFC_R_uS_posit; // @[PositGenerator.scala 52:21]
  wire [63:0] _T_38 = _T_36 + 64'h1; // @[PositGenerator.scala 52:37]
  wire [63:0] R_S_posit = io_in_sign ? _T_38 : uFC_R_uS_posit; // @[PositGenerator.scala 52:8]
  wire  _T_40 = io_in_fraction == 58'h0; // @[PositGenerator.scala 55:25]
  wire  _T_41 = _T_40 | io_in_isZero; // @[PositGenerator.scala 55:34]
  wire [63:0] _T_42 = _T_41 ? 64'h0 : R_S_posit; // @[PositGenerator.scala 55:8]
  assign io_out = io_in_isNaR ? 64'h8000000000000000 : _T_42; // @[PositGenerator.scala 54:10]
endmodule
module Posit(
  input         clock,
  input         reset,
  output        io_request_ready,
  input         io_request_valid,
  input  [63:0] io_request_bits_num1,
  input  [63:0] io_request_bits_num2,
  input  [63:0] io_request_bits_num3,
  input  [2:0]  io_request_bits_inst,
  input  [1:0]  io_request_bits_mode,
  input         io_result_ready,
  output        io_result_valid,
  output        io_result_bits_isZero,
  output        io_result_bits_isNaR,
  output [63:0] io_result_bits_out,
  output        io_result_bits_lt,
  output        io_result_bits_eq,
  output        io_result_bits_gt,
  output [4:0]  io_result_bits_exceptions
);
  wire  positAddCore_io_num1_sign; // @[POSIT.scala 43:34]
  wire [11:0] positAddCore_io_num1_exponent; // @[POSIT.scala 43:34]
  wire [57:0] positAddCore_io_num1_fraction; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num1_isZero; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num1_isNaR; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num2_sign; // @[POSIT.scala 43:34]
  wire [11:0] positAddCore_io_num2_exponent; // @[POSIT.scala 43:34]
  wire [57:0] positAddCore_io_num2_fraction; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num2_isZero; // @[POSIT.scala 43:34]
  wire  positAddCore_io_num2_isNaR; // @[POSIT.scala 43:34]
  wire  positAddCore_io_sub; // @[POSIT.scala 43:34]
  wire [1:0] positAddCore_io_trailingBits; // @[POSIT.scala 43:34]
  wire  positAddCore_io_stickyBit; // @[POSIT.scala 43:34]
  wire  positAddCore_io_out_sign; // @[POSIT.scala 43:34]
  wire [11:0] positAddCore_io_out_exponent; // @[POSIT.scala 43:34]
  wire [57:0] positAddCore_io_out_fraction; // @[POSIT.scala 43:34]
  wire  positAddCore_io_out_isZero; // @[POSIT.scala 43:34]
  wire  positAddCore_io_out_isNaR; // @[POSIT.scala 43:34]
  wire [63:0] positCompare_io_num1; // @[POSIT.scala 44:34]
  wire [63:0] positCompare_io_num2; // @[POSIT.scala 44:34]
  wire  positCompare_io_lt; // @[POSIT.scala 44:34]
  wire  positCompare_io_eq; // @[POSIT.scala 44:34]
  wire  positCompare_io_gt; // @[POSIT.scala 44:34]
  wire  positFMACore_io_num1_sign; // @[POSIT.scala 45:34]
  wire [11:0] positFMACore_io_num1_exponent; // @[POSIT.scala 45:34]
  wire [57:0] positFMACore_io_num1_fraction; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num1_isNaR; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num2_sign; // @[POSIT.scala 45:34]
  wire [11:0] positFMACore_io_num2_exponent; // @[POSIT.scala 45:34]
  wire [57:0] positFMACore_io_num2_fraction; // @[POSIT.scala 45:34]
  wire  positFMACore_io_num2_isNaR; // @[POSIT.scala 45:34]
  wire  positFMACore_io_sub; // @[POSIT.scala 45:34]
  wire  positFMACore_io_negate; // @[POSIT.scala 45:34]
  wire [1:0] positFMACore_io_trailingBits; // @[POSIT.scala 45:34]
  wire  positFMACore_io_stickyBit; // @[POSIT.scala 45:34]
  wire  positFMACore_io_out_sign; // @[POSIT.scala 45:34]
  wire [11:0] positFMACore_io_out_exponent; // @[POSIT.scala 45:34]
  wire [57:0] positFMACore_io_out_fraction; // @[POSIT.scala 45:34]
  wire  positFMACore_io_out_isNaR; // @[POSIT.scala 45:34]
  wire  positDivSqrtCore_clock; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_reset; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_validIn; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_readyIn; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_sqrtOp; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num1_sign; // @[POSIT.scala 46:38]
  wire [11:0] positDivSqrtCore_io_num1_exponent; // @[POSIT.scala 46:38]
  wire [57:0] positDivSqrtCore_io_num1_fraction; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num1_isZero; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num1_isNaR; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num2_sign; // @[POSIT.scala 46:38]
  wire [11:0] positDivSqrtCore_io_num2_exponent; // @[POSIT.scala 46:38]
  wire [57:0] positDivSqrtCore_io_num2_fraction; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num2_isZero; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_num2_isNaR; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_validOut_div; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_validOut_sqrt; // @[POSIT.scala 46:38]
  wire [4:0] positDivSqrtCore_io_exceptions; // @[POSIT.scala 46:38]
  wire [1:0] positDivSqrtCore_io_trailingBits; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_stickyBit; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_out_sign; // @[POSIT.scala 46:38]
  wire [11:0] positDivSqrtCore_io_out_exponent; // @[POSIT.scala 46:38]
  wire [57:0] positDivSqrtCore_io_out_fraction; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_out_isZero; // @[POSIT.scala 46:38]
  wire  positDivSqrtCore_io_out_isNaR; // @[POSIT.scala 46:38]
  wire  positMulCore_io_num1_sign; // @[POSIT.scala 47:34]
  wire [11:0] positMulCore_io_num1_exponent; // @[POSIT.scala 47:34]
  wire [57:0] positMulCore_io_num1_fraction; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num1_isZero; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num1_isNaR; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num2_sign; // @[POSIT.scala 47:34]
  wire [11:0] positMulCore_io_num2_exponent; // @[POSIT.scala 47:34]
  wire [57:0] positMulCore_io_num2_fraction; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num2_isZero; // @[POSIT.scala 47:34]
  wire  positMulCore_io_num2_isNaR; // @[POSIT.scala 47:34]
  wire [1:0] positMulCore_io_trailingBits; // @[POSIT.scala 47:34]
  wire  positMulCore_io_stickyBit; // @[POSIT.scala 47:34]
  wire  positMulCore_io_out_sign; // @[POSIT.scala 47:34]
  wire [11:0] positMulCore_io_out_exponent; // @[POSIT.scala 47:34]
  wire [57:0] positMulCore_io_out_fraction; // @[POSIT.scala 47:34]
  wire  positMulCore_io_out_isZero; // @[POSIT.scala 47:34]
  wire  positMulCore_io_out_isNaR; // @[POSIT.scala 47:34]
  wire [63:0] num1Extractor_io_in; // @[POSIT.scala 66:35]
  wire  num1Extractor_io_out_sign; // @[POSIT.scala 66:35]
  wire [11:0] num1Extractor_io_out_exponent; // @[POSIT.scala 66:35]
  wire [57:0] num1Extractor_io_out_fraction; // @[POSIT.scala 66:35]
  wire  num1Extractor_io_out_isZero; // @[POSIT.scala 66:35]
  wire  num1Extractor_io_out_isNaR; // @[POSIT.scala 66:35]
  wire [63:0] num2Extractor_io_in; // @[POSIT.scala 67:35]
  wire  num2Extractor_io_out_sign; // @[POSIT.scala 67:35]
  wire [11:0] num2Extractor_io_out_exponent; // @[POSIT.scala 67:35]
  wire [57:0] num2Extractor_io_out_fraction; // @[POSIT.scala 67:35]
  wire  num2Extractor_io_out_isZero; // @[POSIT.scala 67:35]
  wire  num2Extractor_io_out_isNaR; // @[POSIT.scala 67:35]
  wire [63:0] num3Extractor_io_in; // @[POSIT.scala 68:35]
  wire  num3Extractor_io_out_sign; // @[POSIT.scala 68:35]
  wire [11:0] num3Extractor_io_out_exponent; // @[POSIT.scala 68:35]
  wire [57:0] num3Extractor_io_out_fraction; // @[POSIT.scala 68:35]
  wire  num3Extractor_io_out_isZero; // @[POSIT.scala 68:35]
  wire  num3Extractor_io_out_isNaR; // @[POSIT.scala 68:35]
  wire  positGenerator_io_in_sign; // @[POSIT.scala 162:36]
  wire [11:0] positGenerator_io_in_exponent; // @[POSIT.scala 162:36]
  wire [57:0] positGenerator_io_in_fraction; // @[POSIT.scala 162:36]
  wire  positGenerator_io_in_isZero; // @[POSIT.scala 162:36]
  wire  positGenerator_io_in_isNaR; // @[POSIT.scala 162:36]
  wire [1:0] positGenerator_io_trailingBits; // @[POSIT.scala 162:36]
  wire  positGenerator_io_stickyBit; // @[POSIT.scala 162:36]
  wire [63:0] positGenerator_io_out; // @[POSIT.scala 162:36]
  wire  _T = io_result_ready & positDivSqrtCore_io_readyIn; // @[POSIT.scala 49:45]
  reg [63:0] init_num1; // @[POSIT.scala 51:28]
  reg [63:0] _RAND_0;
  reg [63:0] init_num2; // @[POSIT.scala 52:28]
  reg [63:0] _RAND_1;
  reg [63:0] init_num3; // @[POSIT.scala 53:28]
  reg [63:0] _RAND_2;
  reg [2:0] init_inst; // @[POSIT.scala 55:28]
  reg [31:0] _RAND_3;
  reg [1:0] init_mode; // @[POSIT.scala 56:28]
  reg [31:0] _RAND_4;
  reg  init_valid; // @[POSIT.scala 57:29]
  reg [31:0] _RAND_5;
  reg  exec_num1_sign; // @[POSIT.scala 73:28]
  reg [31:0] _RAND_6;
  reg [11:0] exec_num1_exponent; // @[POSIT.scala 73:28]
  reg [31:0] _RAND_7;
  reg [57:0] exec_num1_fraction; // @[POSIT.scala 73:28]
  reg [63:0] _RAND_8;
  reg  exec_num1_isZero; // @[POSIT.scala 73:28]
  reg [31:0] _RAND_9;
  reg  exec_num1_isNaR; // @[POSIT.scala 73:28]
  reg [31:0] _RAND_10;
  reg  exec_num2_sign; // @[POSIT.scala 74:28]
  reg [31:0] _RAND_11;
  reg [11:0] exec_num2_exponent; // @[POSIT.scala 74:28]
  reg [31:0] _RAND_12;
  reg [57:0] exec_num2_fraction; // @[POSIT.scala 74:28]
  reg [63:0] _RAND_13;
  reg  exec_num2_isZero; // @[POSIT.scala 74:28]
  reg [31:0] _RAND_14;
  reg  exec_num2_isNaR; // @[POSIT.scala 74:28]
  reg [31:0] _RAND_15;
  reg [63:0] comp_num1; // @[POSIT.scala 76:28]
  reg [63:0] _RAND_16;
  reg [63:0] comp_num2; // @[POSIT.scala 77:28]
  reg [63:0] _RAND_17;
  reg [2:0] exec_inst; // @[POSIT.scala 79:28]
  reg [31:0] _RAND_18;
  reg [1:0] exec_mode; // @[POSIT.scala 80:28]
  reg [31:0] _RAND_19;
  reg  exec_valid; // @[POSIT.scala 81:29]
  reg [31:0] _RAND_20;
  reg  result_out_sign; // @[POSIT.scala 121:29]
  reg [31:0] _RAND_21;
  reg [11:0] result_out_exponent; // @[POSIT.scala 121:29]
  reg [31:0] _RAND_22;
  reg [57:0] result_out_fraction; // @[POSIT.scala 121:29]
  reg [63:0] _RAND_23;
  reg  result_out_isZero; // @[POSIT.scala 121:29]
  reg [31:0] _RAND_24;
  reg  result_out_isNaR; // @[POSIT.scala 121:29]
  reg [31:0] _RAND_25;
  reg  result_stickyBit; // @[POSIT.scala 122:35]
  reg [31:0] _RAND_26;
  reg [1:0] result_trailingBits; // @[POSIT.scala 123:38]
  reg [31:0] _RAND_27;
  reg  result_valid; // @[POSIT.scala 124:31]
  reg [31:0] _RAND_28;
  reg  result_lt; // @[POSIT.scala 125:28]
  reg [31:0] _RAND_29;
  reg  result_eq; // @[POSIT.scala 126:28]
  reg [31:0] _RAND_30;
  reg  result_gt; // @[POSIT.scala 127:28]
  reg [31:0] _RAND_31;
  wire  _T_10 = 3'h5 == io_request_bits_inst; // @[Mux.scala 68:19]
  wire  _T_11_sign = _T_10 & positDivSqrtCore_io_out_sign; // @[Mux.scala 68:16]
  wire  _T_11_isZero = _T_10 & positDivSqrtCore_io_out_isZero; // @[Mux.scala 68:16]
  wire  _T_11_isNaR = _T_10 & positDivSqrtCore_io_out_isNaR; // @[Mux.scala 68:16]
  wire  _T_12 = 3'h4 == io_request_bits_inst; // @[Mux.scala 68:19]
  wire  _T_14 = 3'h3 == io_request_bits_inst; // @[Mux.scala 68:19]
  wire  _T_16 = 3'h1 == io_request_bits_inst; // @[Mux.scala 68:19]
  wire  _T_18 = 3'h5 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_19 = _T_18 & positDivSqrtCore_io_stickyBit; // @[Mux.scala 68:16]
  wire  _T_20 = 3'h4 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_22 = 3'h3 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_24 = 3'h1 == exec_inst; // @[Mux.scala 68:19]
  wire  _T_34 = exec_inst != 3'h5; // @[POSIT.scala 157:59]
  wire  _T_35 = exec_valid & _T_34; // @[POSIT.scala 157:45]
  wire  _T_36 = _T_35 | positDivSqrtCore_io_validOut_div; // @[POSIT.scala 157:85]
  wire  _T_37 = _T_36 | positDivSqrtCore_io_validOut_sqrt; // @[POSIT.scala 158:58]
  wire  _T_38 = positGenerator_io_out != 64'h0; // @[common.scala 61:41]
  wire  _T_39 = ~_T_38; // @[common.scala 61:33]
  wire  _T_43 = positGenerator_io_out[62:0] != 63'h0; // @[common.scala 27:71]
  wire  _T_44 = ~_T_43; // @[common.scala 27:53]
  wire  _T_45 = positGenerator_io_out[63] & _T_44; // @[common.scala 27:51]
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
    .io_num1_isNaR(positFMACore_io_num1_isNaR),
    .io_num2_sign(positFMACore_io_num2_sign),
    .io_num2_exponent(positFMACore_io_num2_exponent),
    .io_num2_fraction(positFMACore_io_num2_fraction),
    .io_num2_isNaR(positFMACore_io_num2_isNaR),
    .io_sub(positFMACore_io_sub),
    .io_negate(positFMACore_io_negate),
    .io_trailingBits(positFMACore_io_trailingBits),
    .io_stickyBit(positFMACore_io_stickyBit),
    .io_out_sign(positFMACore_io_out_sign),
    .io_out_exponent(positFMACore_io_out_exponent),
    .io_out_fraction(positFMACore_io_out_fraction),
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
  assign io_result_bits_isZero = result_out_isZero | _T_39; // @[POSIT.scala 167:31]
  assign io_result_bits_isNaR = result_out_isNaR | _T_45; // @[POSIT.scala 168:31]
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
  assign positFMACore_io_num1_isNaR = exec_num1_isNaR; // @[POSIT.scala 107:30]
  assign positFMACore_io_num2_sign = exec_num2_sign; // @[POSIT.scala 108:30]
  assign positFMACore_io_num2_exponent = exec_num2_exponent; // @[POSIT.scala 108:30]
  assign positFMACore_io_num2_fraction = exec_num2_fraction; // @[POSIT.scala 108:30]
  assign positFMACore_io_num2_isNaR = exec_num2_isNaR; // @[POSIT.scala 108:30]
  assign positFMACore_io_sub = exec_mode[0]; // @[POSIT.scala 110:29]
  assign positFMACore_io_negate = exec_mode[1]; // @[POSIT.scala 111:32]
  assign positDivSqrtCore_clock = clock;
  assign positDivSqrtCore_reset = reset;
  assign positDivSqrtCore_io_validIn = exec_valid; // @[POSIT.scala 116:37]
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
  _RAND_0 = {2{`RANDOM}};
  init_num1 = _RAND_0[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {2{`RANDOM}};
  init_num2 = _RAND_1[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {2{`RANDOM}};
  init_num3 = _RAND_2[63:0];
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
  exec_num1_exponent = _RAND_7[11:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {2{`RANDOM}};
  exec_num1_fraction = _RAND_8[57:0];
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
  exec_num2_exponent = _RAND_12[11:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {2{`RANDOM}};
  exec_num2_fraction = _RAND_13[57:0];
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
  _RAND_16 = {2{`RANDOM}};
  comp_num1 = _RAND_16[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {2{`RANDOM}};
  comp_num2 = _RAND_17[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  exec_inst = _RAND_18[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  exec_mode = _RAND_19[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  exec_valid = _RAND_20[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  result_out_sign = _RAND_21[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  result_out_exponent = _RAND_22[11:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {2{`RANDOM}};
  result_out_fraction = _RAND_23[57:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  result_out_isZero = _RAND_24[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  result_out_isNaR = _RAND_25[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{`RANDOM}};
  result_stickyBit = _RAND_26[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  result_trailingBits = _RAND_27[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{`RANDOM}};
  result_valid = _RAND_28[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  result_lt = _RAND_29[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  result_eq = _RAND_30[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  result_gt = _RAND_31[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (_T) begin
      init_num1 <= io_request_bits_num1;
    end
    if (_T) begin
      init_num2 <= io_request_bits_num2;
    end
    if (_T) begin
      init_num3 <= io_request_bits_num3;
    end
    if (_T) begin
      init_inst <= io_request_bits_inst;
    end
    if (_T) begin
      init_mode <= io_request_bits_mode;
    end
    if (_T) begin
      init_valid <= io_request_valid;
    end
    if (_T) begin
      exec_num1_sign <= num1Extractor_io_out_sign;
    end
    if (_T) begin
      exec_num1_exponent <= num1Extractor_io_out_exponent;
    end
    if (_T) begin
      exec_num1_fraction <= num1Extractor_io_out_fraction;
    end
    if (_T) begin
      exec_num1_isZero <= num1Extractor_io_out_isZero;
    end
    if (_T) begin
      exec_num1_isNaR <= num1Extractor_io_out_isNaR;
    end
    if (_T) begin
      exec_num2_sign <= num2Extractor_io_out_sign;
    end
    if (_T) begin
      exec_num2_exponent <= num2Extractor_io_out_exponent;
    end
    if (_T) begin
      exec_num2_fraction <= num2Extractor_io_out_fraction;
    end
    if (_T) begin
      exec_num2_isZero <= num2Extractor_io_out_isZero;
    end
    if (_T) begin
      exec_num2_isNaR <= num2Extractor_io_out_isNaR;
    end
    if (_T) begin
      comp_num1 <= init_num1;
    end
    if (_T) begin
      comp_num2 <= init_num2;
    end
    if (_T) begin
      exec_inst <= init_inst;
    end
    if (_T) begin
      exec_mode <= init_mode;
    end
    if (_T) begin
      exec_valid <= init_valid;
    end
    if (_T) begin
      if (_T_16) begin
        result_out_sign <= positAddCore_io_out_sign;
      end else if (_T_14) begin
        result_out_sign <= positFMACore_io_out_sign;
      end else if (_T_12) begin
        result_out_sign <= positMulCore_io_out_sign;
      end else begin
        result_out_sign <= _T_11_sign;
      end
    end
    if (_T) begin
      if (_T_16) begin
        result_out_exponent <= positAddCore_io_out_exponent;
      end else if (_T_14) begin
        result_out_exponent <= positFMACore_io_out_exponent;
      end else if (_T_12) begin
        result_out_exponent <= positMulCore_io_out_exponent;
      end else if (_T_10) begin
        result_out_exponent <= positDivSqrtCore_io_out_exponent;
      end else begin
        result_out_exponent <= 12'sh0;
      end
    end
    if (_T) begin
      if (_T_16) begin
        result_out_fraction <= positAddCore_io_out_fraction;
      end else if (_T_14) begin
        result_out_fraction <= positFMACore_io_out_fraction;
      end else if (_T_12) begin
        result_out_fraction <= positMulCore_io_out_fraction;
      end else if (_T_10) begin
        result_out_fraction <= positDivSqrtCore_io_out_fraction;
      end else begin
        result_out_fraction <= 58'h0;
      end
    end
    if (_T) begin
      if (_T_16) begin
        result_out_isZero <= positAddCore_io_out_isZero;
      end else if (_T_14) begin
        result_out_isZero <= 1'h0;
      end else if (_T_12) begin
        result_out_isZero <= positMulCore_io_out_isZero;
      end else begin
        result_out_isZero <= _T_11_isZero;
      end
    end
    if (_T) begin
      if (_T_16) begin
        result_out_isNaR <= positAddCore_io_out_isNaR;
      end else if (_T_14) begin
        result_out_isNaR <= positFMACore_io_out_isNaR;
      end else if (_T_12) begin
        result_out_isNaR <= positMulCore_io_out_isNaR;
      end else begin
        result_out_isNaR <= _T_11_isNaR;
      end
    end
    if (_T) begin
      if (_T_24) begin
        result_stickyBit <= positAddCore_io_stickyBit;
      end else if (_T_22) begin
        result_stickyBit <= positFMACore_io_stickyBit;
      end else if (_T_20) begin
        result_stickyBit <= positMulCore_io_stickyBit;
      end else begin
        result_stickyBit <= _T_19;
      end
    end
    if (_T) begin
      if (_T_24) begin
        result_trailingBits <= positAddCore_io_trailingBits;
      end else if (_T_22) begin
        result_trailingBits <= positFMACore_io_trailingBits;
      end else if (_T_20) begin
        result_trailingBits <= positMulCore_io_trailingBits;
      end else if (_T_18) begin
        result_trailingBits <= positDivSqrtCore_io_trailingBits;
      end else begin
        result_trailingBits <= 2'h0;
      end
    end
    if (_T) begin
      result_valid <= _T_37;
    end
    if (_T) begin
      result_lt <= positCompare_io_lt;
    end
    if (_T) begin
      result_eq <= positCompare_io_eq;
    end
    if (_T) begin
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
  wire  _T = 3'h7 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_7 = _T & io_validity[7]; // @[DispatchArbiter.scala 19:28]
  wire  _T_6 = 3'h6 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_6 = _T_6 & io_validity[6]; // @[DispatchArbiter.scala 19:28]
  wire  _T_9 = 3'h6 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_6 = _T_9 & io_validity[6]; // @[DispatchArbiter.scala 21:28]
  wire  _T_12 = 3'h5 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_5 = _T_12 & io_validity[5]; // @[DispatchArbiter.scala 19:28]
  wire  _T_15 = 3'h5 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_5 = _T_15 & io_validity[5]; // @[DispatchArbiter.scala 21:28]
  wire  _T_18 = 3'h4 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_4 = _T_18 & io_validity[4]; // @[DispatchArbiter.scala 19:28]
  wire  _T_21 = 3'h4 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_4 = _T_21 & io_validity[4]; // @[DispatchArbiter.scala 21:28]
  wire  _T_24 = 3'h3 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_3 = _T_24 & io_validity[3]; // @[DispatchArbiter.scala 19:28]
  wire  _T_27 = 3'h3 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_3 = _T_27 & io_validity[3]; // @[DispatchArbiter.scala 21:28]
  wire  _T_30 = 3'h2 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_2 = _T_30 & io_validity[2]; // @[DispatchArbiter.scala 19:28]
  wire  _T_33 = 3'h2 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_2 = _T_33 & io_validity[2]; // @[DispatchArbiter.scala 21:28]
  wire  _T_36 = 3'h1 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_1 = _T_36 & io_validity[1]; // @[DispatchArbiter.scala 19:28]
  wire  _T_39 = 3'h1 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_1 = _T_39 & io_validity[1]; // @[DispatchArbiter.scala 21:28]
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
  wire [2:0] afterPriorityChosen = afterPriority_1 ? 3'h1 : _GEN_8; // @[DispatchArbiter.scala 30:29]
  wire [2:0] _GEN_11 = beforePriority_1 ? 3'h1 : _GEN_9; // @[DispatchArbiter.scala 33:32]
  wire [2:0] beforePriorityChosen = beforePriority_0 ? 3'h0 : _GEN_11; // @[DispatchArbiter.scala 33:32]
  wire  _T_50 = afterPriority_1 | afterPriority_2; // @[DispatchArbiter.scala 37:54]
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
  assign io_chosen = afterPriorityExist ? afterPriorityChosen : beforePriorityChosen; // @[DispatchArbiter.scala 40:19]
  assign io_hasChosen = afterPriorityExist | beforePriorityExist; // @[DispatchArbiter.scala 39:22]
endmodule
module DispatchArbiter_1(
  input  [23:0] io_validity,
  input  [4:0]  io_priority,
  output [4:0]  io_chosen,
  output        io_hasChosen
);
  wire  _T = 5'h17 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_23 = _T & io_validity[23]; // @[DispatchArbiter.scala 19:28]
  wire  _T_3 = 5'h17 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_23 = _T_3 & io_validity[23]; // @[DispatchArbiter.scala 21:28]
  wire  _T_6 = 5'h16 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_22 = _T_6 & io_validity[22]; // @[DispatchArbiter.scala 19:28]
  wire  _T_9 = 5'h16 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_22 = _T_9 & io_validity[22]; // @[DispatchArbiter.scala 21:28]
  wire  _T_12 = 5'h15 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_21 = _T_12 & io_validity[21]; // @[DispatchArbiter.scala 19:28]
  wire  _T_15 = 5'h15 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_21 = _T_15 & io_validity[21]; // @[DispatchArbiter.scala 21:28]
  wire  _T_18 = 5'h14 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_20 = _T_18 & io_validity[20]; // @[DispatchArbiter.scala 19:28]
  wire  _T_21 = 5'h14 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_20 = _T_21 & io_validity[20]; // @[DispatchArbiter.scala 21:28]
  wire  _T_24 = 5'h13 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_19 = _T_24 & io_validity[19]; // @[DispatchArbiter.scala 19:28]
  wire  _T_27 = 5'h13 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_19 = _T_27 & io_validity[19]; // @[DispatchArbiter.scala 21:28]
  wire  _T_30 = 5'h12 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_18 = _T_30 & io_validity[18]; // @[DispatchArbiter.scala 19:28]
  wire  _T_33 = 5'h12 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_18 = _T_33 & io_validity[18]; // @[DispatchArbiter.scala 21:28]
  wire  _T_36 = 5'h11 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_17 = _T_36 & io_validity[17]; // @[DispatchArbiter.scala 19:28]
  wire  _T_39 = 5'h11 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_17 = _T_39 & io_validity[17]; // @[DispatchArbiter.scala 21:28]
  wire  _T_42 = 5'h10 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_16 = _T_42 & io_validity[16]; // @[DispatchArbiter.scala 19:28]
  wire  _T_45 = 5'h10 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_16 = _T_45 & io_validity[16]; // @[DispatchArbiter.scala 21:28]
  wire  _T_48 = 5'hf > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_15 = _T_48 & io_validity[15]; // @[DispatchArbiter.scala 19:28]
  wire  _T_51 = 5'hf < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_15 = _T_51 & io_validity[15]; // @[DispatchArbiter.scala 21:28]
  wire  _T_54 = 5'he > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_14 = _T_54 & io_validity[14]; // @[DispatchArbiter.scala 19:28]
  wire  _T_57 = 5'he < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_14 = _T_57 & io_validity[14]; // @[DispatchArbiter.scala 21:28]
  wire  _T_60 = 5'hd > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_13 = _T_60 & io_validity[13]; // @[DispatchArbiter.scala 19:28]
  wire  _T_63 = 5'hd < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_13 = _T_63 & io_validity[13]; // @[DispatchArbiter.scala 21:28]
  wire  _T_66 = 5'hc > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_12 = _T_66 & io_validity[12]; // @[DispatchArbiter.scala 19:28]
  wire  _T_69 = 5'hc < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_12 = _T_69 & io_validity[12]; // @[DispatchArbiter.scala 21:28]
  wire  _T_72 = 5'hb > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_11 = _T_72 & io_validity[11]; // @[DispatchArbiter.scala 19:28]
  wire  _T_75 = 5'hb < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_11 = _T_75 & io_validity[11]; // @[DispatchArbiter.scala 21:28]
  wire  _T_78 = 5'ha > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_10 = _T_78 & io_validity[10]; // @[DispatchArbiter.scala 19:28]
  wire  _T_81 = 5'ha < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_10 = _T_81 & io_validity[10]; // @[DispatchArbiter.scala 21:28]
  wire  _T_84 = 5'h9 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_9 = _T_84 & io_validity[9]; // @[DispatchArbiter.scala 19:28]
  wire  _T_87 = 5'h9 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_9 = _T_87 & io_validity[9]; // @[DispatchArbiter.scala 21:28]
  wire  _T_90 = 5'h8 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_8 = _T_90 & io_validity[8]; // @[DispatchArbiter.scala 19:28]
  wire  _T_93 = 5'h8 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_8 = _T_93 & io_validity[8]; // @[DispatchArbiter.scala 21:28]
  wire  _T_96 = 5'h7 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_7 = _T_96 & io_validity[7]; // @[DispatchArbiter.scala 19:28]
  wire  _T_99 = 5'h7 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_7 = _T_99 & io_validity[7]; // @[DispatchArbiter.scala 21:28]
  wire  _T_102 = 5'h6 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_6 = _T_102 & io_validity[6]; // @[DispatchArbiter.scala 19:28]
  wire  _T_105 = 5'h6 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_6 = _T_105 & io_validity[6]; // @[DispatchArbiter.scala 21:28]
  wire  _T_108 = 5'h5 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_5 = _T_108 & io_validity[5]; // @[DispatchArbiter.scala 19:28]
  wire  _T_111 = 5'h5 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_5 = _T_111 & io_validity[5]; // @[DispatchArbiter.scala 21:28]
  wire  _T_114 = 5'h4 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_4 = _T_114 & io_validity[4]; // @[DispatchArbiter.scala 19:28]
  wire  _T_117 = 5'h4 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_4 = _T_117 & io_validity[4]; // @[DispatchArbiter.scala 21:28]
  wire  _T_120 = 5'h3 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_3 = _T_120 & io_validity[3]; // @[DispatchArbiter.scala 19:28]
  wire  _T_123 = 5'h3 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_3 = _T_123 & io_validity[3]; // @[DispatchArbiter.scala 21:28]
  wire  _T_126 = 5'h2 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_2 = _T_126 & io_validity[2]; // @[DispatchArbiter.scala 19:28]
  wire  _T_129 = 5'h2 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_2 = _T_129 & io_validity[2]; // @[DispatchArbiter.scala 21:28]
  wire  _T_132 = 5'h1 > io_priority; // @[DispatchArbiter.scala 19:37]
  wire  afterPriority_1 = _T_132 & io_validity[1]; // @[DispatchArbiter.scala 19:28]
  wire  _T_135 = 5'h1 < io_priority; // @[DispatchArbiter.scala 21:37]
  wire  beforePriority_1 = _T_135 & io_validity[1]; // @[DispatchArbiter.scala 21:28]
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
  wire [4:0] afterPriorityChosen = afterPriority_1 ? 5'h1 : _GEN_40; // @[DispatchArbiter.scala 30:29]
  wire [4:0] _GEN_43 = beforePriority_1 ? 5'h1 : _GEN_41; // @[DispatchArbiter.scala 33:32]
  wire [4:0] beforePriorityChosen = beforePriority_0 ? 5'h0 : _GEN_43; // @[DispatchArbiter.scala 33:32]
  wire  _T_146 = afterPriority_1 | afterPriority_2; // @[DispatchArbiter.scala 37:54]
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
  assign io_chosen = afterPriorityExist ? afterPriorityChosen : beforePriorityChosen; // @[DispatchArbiter.scala 40:19]
  assign io_hasChosen = afterPriorityExist | beforePriorityExist; // @[DispatchArbiter.scala 39:22]
endmodule
module POSIT_Locality(
  input         clock,
  input         reset,
  output        io_request_ready,
  input         io_request_valid,
  input  [63:0] io_request_bits_operands_0_value,
  input  [1:0]  io_request_bits_operands_0_mode,
  input  [63:0] io_request_bits_operands_1_value,
  input  [1:0]  io_request_bits_operands_1_mode,
  input  [63:0] io_request_bits_operands_2_value,
  input  [1:0]  io_request_bits_operands_2_mode,
  input  [2:0]  io_request_bits_inst,
  input  [1:0]  io_request_bits_mode,
  input  [47:0] io_request_bits_wr_addr,
  input         io_mem_write_ready,
  output        io_mem_write_valid,
  output        io_mem_write_bits_result_isZero,
  output        io_mem_write_bits_result_isNaR,
  output [63:0] io_mem_write_bits_result_out,
  output        io_mem_write_bits_result_lt,
  output        io_mem_write_bits_result_eq,
  output        io_mem_write_bits_result_gt,
  output [4:0]  io_mem_write_bits_result_exceptions,
  output [47:0] io_mem_write_bits_out_wr_addr,
  output        io_op_mem_read_req_valid,
  output [47:0] io_op_mem_read_req_addr,
  input  [63:0] io_op_mem_read_data,
  input         io_op_mem_read_resp_valid,
  input  [47:0] io_op_mem_read_resp_tag
);
  wire  pe_clock; // @[POSIT_Locality.scala 10:24]
  wire  pe_reset; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_request_ready; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_request_valid; // @[POSIT_Locality.scala 10:24]
  wire [63:0] pe_io_request_bits_num1; // @[POSIT_Locality.scala 10:24]
  wire [63:0] pe_io_request_bits_num2; // @[POSIT_Locality.scala 10:24]
  wire [63:0] pe_io_request_bits_num3; // @[POSIT_Locality.scala 10:24]
  wire [2:0] pe_io_request_bits_inst; // @[POSIT_Locality.scala 10:24]
  wire [1:0] pe_io_request_bits_mode; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_ready; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_valid; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_bits_isZero; // @[POSIT_Locality.scala 10:24]
  wire  pe_io_result_bits_isNaR; // @[POSIT_Locality.scala 10:24]
  wire [63:0] pe_io_result_bits_out; // @[POSIT_Locality.scala 10:24]
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
  wire [23:0] fetchArb_io_validity; // @[POSIT_Locality.scala 148:30]
  wire [4:0] fetchArb_io_priority; // @[POSIT_Locality.scala 148:30]
  wire [4:0] fetchArb_io_chosen; // @[POSIT_Locality.scala 148:30]
  wire  fetchArb_io_hasChosen; // @[POSIT_Locality.scala 148:30]
  reg  rb_entries_0_completed; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_0;
  reg  rb_entries_0_written; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_1;
  reg [47:0] rb_entries_0_wr_addr; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_2;
  reg [63:0] rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_3;
  reg [1:0] rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_4;
  reg [63:0] rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_5;
  reg [1:0] rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_6;
  reg [63:0] rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_7;
  reg [1:0] rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_8;
  reg [2:0] rb_entries_0_request_inst; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_9;
  reg [1:0] rb_entries_0_request_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_10;
  reg  rb_entries_0_request_inFetch_0; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_11;
  reg  rb_entries_0_request_inFetch_1; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_12;
  reg  rb_entries_0_request_inFetch_2; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_13;
  reg  rb_entries_0_result_isZero; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_14;
  reg  rb_entries_0_result_isNaR; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_15;
  reg [63:0] rb_entries_0_result_out; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_16;
  reg  rb_entries_0_result_lt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_17;
  reg  rb_entries_0_result_eq; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_18;
  reg  rb_entries_0_result_gt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_19;
  reg [4:0] rb_entries_0_result_exceptions; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_20;
  reg  rb_entries_1_completed; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_21;
  reg  rb_entries_1_written; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_22;
  reg [47:0] rb_entries_1_wr_addr; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_23;
  reg [63:0] rb_entries_1_request_operands_0_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_24;
  reg [1:0] rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_25;
  reg [63:0] rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_26;
  reg [1:0] rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_27;
  reg [63:0] rb_entries_1_request_operands_2_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_28;
  reg [1:0] rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_29;
  reg [2:0] rb_entries_1_request_inst; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_30;
  reg [1:0] rb_entries_1_request_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_31;
  reg  rb_entries_1_request_inFetch_0; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_32;
  reg  rb_entries_1_request_inFetch_1; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_33;
  reg  rb_entries_1_request_inFetch_2; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_34;
  reg  rb_entries_1_result_isZero; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_35;
  reg  rb_entries_1_result_isNaR; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_36;
  reg [63:0] rb_entries_1_result_out; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_37;
  reg  rb_entries_1_result_lt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_38;
  reg  rb_entries_1_result_eq; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_39;
  reg  rb_entries_1_result_gt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_40;
  reg [4:0] rb_entries_1_result_exceptions; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_41;
  reg  rb_entries_2_completed; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_42;
  reg  rb_entries_2_written; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_43;
  reg [47:0] rb_entries_2_wr_addr; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_44;
  reg [63:0] rb_entries_2_request_operands_0_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_45;
  reg [1:0] rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_46;
  reg [63:0] rb_entries_2_request_operands_1_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_47;
  reg [1:0] rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_48;
  reg [63:0] rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_49;
  reg [1:0] rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_50;
  reg [2:0] rb_entries_2_request_inst; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_51;
  reg [1:0] rb_entries_2_request_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_52;
  reg  rb_entries_2_request_inFetch_0; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_53;
  reg  rb_entries_2_request_inFetch_1; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_54;
  reg  rb_entries_2_request_inFetch_2; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_55;
  reg  rb_entries_2_result_isZero; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_56;
  reg  rb_entries_2_result_isNaR; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_57;
  reg [63:0] rb_entries_2_result_out; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_58;
  reg  rb_entries_2_result_lt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_59;
  reg  rb_entries_2_result_eq; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_60;
  reg  rb_entries_2_result_gt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_61;
  reg [4:0] rb_entries_2_result_exceptions; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_62;
  reg  rb_entries_3_completed; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_63;
  reg  rb_entries_3_written; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_64;
  reg [47:0] rb_entries_3_wr_addr; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_65;
  reg [63:0] rb_entries_3_request_operands_0_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_66;
  reg [1:0] rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_67;
  reg [63:0] rb_entries_3_request_operands_1_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_68;
  reg [1:0] rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_69;
  reg [63:0] rb_entries_3_request_operands_2_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_70;
  reg [1:0] rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_71;
  reg [2:0] rb_entries_3_request_inst; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_72;
  reg [1:0] rb_entries_3_request_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_73;
  reg  rb_entries_3_request_inFetch_0; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_74;
  reg  rb_entries_3_request_inFetch_1; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_75;
  reg  rb_entries_3_request_inFetch_2; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_76;
  reg  rb_entries_3_result_isZero; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_77;
  reg  rb_entries_3_result_isNaR; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_78;
  reg [63:0] rb_entries_3_result_out; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_79;
  reg  rb_entries_3_result_lt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_80;
  reg  rb_entries_3_result_eq; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_81;
  reg  rb_entries_3_result_gt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_82;
  reg [4:0] rb_entries_3_result_exceptions; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_83;
  reg  rb_entries_4_completed; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_84;
  reg  rb_entries_4_written; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_85;
  reg [47:0] rb_entries_4_wr_addr; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_86;
  reg [63:0] rb_entries_4_request_operands_0_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_87;
  reg [1:0] rb_entries_4_request_operands_0_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_88;
  reg [63:0] rb_entries_4_request_operands_1_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_89;
  reg [1:0] rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_90;
  reg [63:0] rb_entries_4_request_operands_2_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_91;
  reg [1:0] rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_92;
  reg [2:0] rb_entries_4_request_inst; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_93;
  reg [1:0] rb_entries_4_request_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_94;
  reg  rb_entries_4_request_inFetch_0; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_95;
  reg  rb_entries_4_request_inFetch_1; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_96;
  reg  rb_entries_4_request_inFetch_2; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_97;
  reg  rb_entries_4_result_isZero; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_98;
  reg  rb_entries_4_result_isNaR; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_99;
  reg [63:0] rb_entries_4_result_out; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_100;
  reg  rb_entries_4_result_lt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_101;
  reg  rb_entries_4_result_eq; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_102;
  reg  rb_entries_4_result_gt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_103;
  reg [4:0] rb_entries_4_result_exceptions; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_104;
  reg  rb_entries_5_completed; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_105;
  reg  rb_entries_5_written; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_106;
  reg [47:0] rb_entries_5_wr_addr; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_107;
  reg [63:0] rb_entries_5_request_operands_0_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_108;
  reg [1:0] rb_entries_5_request_operands_0_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_109;
  reg [63:0] rb_entries_5_request_operands_1_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_110;
  reg [1:0] rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_111;
  reg [63:0] rb_entries_5_request_operands_2_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_112;
  reg [1:0] rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_113;
  reg [2:0] rb_entries_5_request_inst; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_114;
  reg [1:0] rb_entries_5_request_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_115;
  reg  rb_entries_5_request_inFetch_0; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_116;
  reg  rb_entries_5_request_inFetch_1; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_117;
  reg  rb_entries_5_request_inFetch_2; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_118;
  reg  rb_entries_5_result_isZero; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_119;
  reg  rb_entries_5_result_isNaR; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_120;
  reg [63:0] rb_entries_5_result_out; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_121;
  reg  rb_entries_5_result_lt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_122;
  reg  rb_entries_5_result_eq; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_123;
  reg  rb_entries_5_result_gt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_124;
  reg [4:0] rb_entries_5_result_exceptions; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_125;
  reg  rb_entries_6_completed; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_126;
  reg  rb_entries_6_written; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_127;
  reg [47:0] rb_entries_6_wr_addr; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_128;
  reg [63:0] rb_entries_6_request_operands_0_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_129;
  reg [1:0] rb_entries_6_request_operands_0_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_130;
  reg [63:0] rb_entries_6_request_operands_1_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_131;
  reg [1:0] rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_132;
  reg [63:0] rb_entries_6_request_operands_2_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_133;
  reg [1:0] rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_134;
  reg [2:0] rb_entries_6_request_inst; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_135;
  reg [1:0] rb_entries_6_request_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_136;
  reg  rb_entries_6_request_inFetch_0; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_137;
  reg  rb_entries_6_request_inFetch_1; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_138;
  reg  rb_entries_6_request_inFetch_2; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_139;
  reg  rb_entries_6_result_isZero; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_140;
  reg  rb_entries_6_result_isNaR; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_141;
  reg [63:0] rb_entries_6_result_out; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_142;
  reg  rb_entries_6_result_lt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_143;
  reg  rb_entries_6_result_eq; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_144;
  reg  rb_entries_6_result_gt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_145;
  reg [4:0] rb_entries_6_result_exceptions; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_146;
  reg  rb_entries_7_completed; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_147;
  reg  rb_entries_7_written; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_148;
  reg [47:0] rb_entries_7_wr_addr; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_149;
  reg [63:0] rb_entries_7_request_operands_0_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_150;
  reg [1:0] rb_entries_7_request_operands_0_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_151;
  reg [63:0] rb_entries_7_request_operands_1_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_152;
  reg [1:0] rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_153;
  reg [63:0] rb_entries_7_request_operands_2_value; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_154;
  reg [1:0] rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_155;
  reg [2:0] rb_entries_7_request_inst; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_156;
  reg [1:0] rb_entries_7_request_mode; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_157;
  reg  rb_entries_7_request_inFetch_0; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_158;
  reg  rb_entries_7_request_inFetch_1; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_159;
  reg  rb_entries_7_request_inFetch_2; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_160;
  reg  rb_entries_7_result_isZero; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_161;
  reg  rb_entries_7_result_isNaR; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_162;
  reg [63:0] rb_entries_7_result_out; // @[POSIT_Locality.scala 14:21]
  reg [63:0] _RAND_163;
  reg  rb_entries_7_result_lt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_164;
  reg  rb_entries_7_result_eq; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_165;
  reg  rb_entries_7_result_gt; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_166;
  reg [4:0] rb_entries_7_result_exceptions; // @[POSIT_Locality.scala 14:21]
  reg [31:0] _RAND_167;
  reg [2:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_168;
  wire [2:0] _T_3 = value + 3'h1; // @[Counter.scala 39:22]
  wire  _GEN_41 = 3'h1 == value ? rb_entries_1_written : rb_entries_0_written; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_71 = 3'h2 == value ? rb_entries_2_written : _GEN_41; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_101 = 3'h3 == value ? rb_entries_3_written : _GEN_71; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_131 = 3'h4 == value ? rb_entries_4_written : _GEN_101; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_161 = 3'h5 == value ? rb_entries_5_written : _GEN_131; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_191 = 3'h6 == value ? rb_entries_6_written : _GEN_161; // @[POSIT_Locality.scala 19:83]
  wire  _GEN_221 = 3'h7 == value ? rb_entries_7_written : _GEN_191; // @[POSIT_Locality.scala 19:83]
  wire  new_input_log = io_request_valid & _GEN_221; // @[POSIT_Locality.scala 19:43]
  wire  _GEN_242 = 3'h0 == value ? 1'h0 : rb_entries_0_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_243 = 3'h1 == value ? 1'h0 : rb_entries_1_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_244 = 3'h2 == value ? 1'h0 : rb_entries_2_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_245 = 3'h3 == value ? 1'h0 : rb_entries_3_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_246 = 3'h4 == value ? 1'h0 : rb_entries_4_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_247 = 3'h5 == value ? 1'h0 : rb_entries_5_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_248 = 3'h6 == value ? 1'h0 : rb_entries_6_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_249 = 3'h7 == value ? 1'h0 : rb_entries_7_completed; // @[POSIT_Locality.scala 24:52]
  wire  _GEN_258 = 3'h0 == value ? 1'h0 : rb_entries_0_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_259 = 3'h1 == value ? 1'h0 : rb_entries_1_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_260 = 3'h2 == value ? 1'h0 : rb_entries_2_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_261 = 3'h3 == value ? 1'h0 : rb_entries_3_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_262 = 3'h4 == value ? 1'h0 : rb_entries_4_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_263 = 3'h5 == value ? 1'h0 : rb_entries_5_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_264 = 3'h6 == value ? 1'h0 : rb_entries_6_written; // @[POSIT_Locality.scala 26:50]
  wire  _GEN_265 = 3'h7 == value ? 1'h0 : rb_entries_7_written; // @[POSIT_Locality.scala 26:50]
  wire [1:0] _GEN_314 = 3'h0 == value ? io_request_bits_operands_0_mode : rb_entries_0_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_315 = 3'h1 == value ? io_request_bits_operands_0_mode : rb_entries_1_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_316 = 3'h2 == value ? io_request_bits_operands_0_mode : rb_entries_2_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_317 = 3'h3 == value ? io_request_bits_operands_0_mode : rb_entries_3_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_318 = 3'h4 == value ? io_request_bits_operands_0_mode : rb_entries_4_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_319 = 3'h5 == value ? io_request_bits_operands_0_mode : rb_entries_5_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_320 = 3'h6 == value ? io_request_bits_operands_0_mode : rb_entries_6_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_321 = 3'h7 == value ? io_request_bits_operands_0_mode : rb_entries_7_request_operands_0_mode; // @[POSIT_Locality.scala 32:70]
  wire [63:0] _GEN_322 = 3'h0 == value ? io_request_bits_operands_0_value : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_330 = 3'h0 == value ? io_request_bits_operands_1_mode : rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_331 = 3'h1 == value ? io_request_bits_operands_1_mode : rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_332 = 3'h2 == value ? io_request_bits_operands_1_mode : rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_333 = 3'h3 == value ? io_request_bits_operands_1_mode : rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_334 = 3'h4 == value ? io_request_bits_operands_1_mode : rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_335 = 3'h5 == value ? io_request_bits_operands_1_mode : rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_336 = 3'h6 == value ? io_request_bits_operands_1_mode : rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_337 = 3'h7 == value ? io_request_bits_operands_1_mode : rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 32:70]
  wire [63:0] _GEN_339 = 3'h1 == value ? io_request_bits_operands_1_value : rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_346 = 3'h0 == value ? io_request_bits_operands_2_mode : rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_347 = 3'h1 == value ? io_request_bits_operands_2_mode : rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_348 = 3'h2 == value ? io_request_bits_operands_2_mode : rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_349 = 3'h3 == value ? io_request_bits_operands_2_mode : rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_350 = 3'h4 == value ? io_request_bits_operands_2_mode : rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_351 = 3'h5 == value ? io_request_bits_operands_2_mode : rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_352 = 3'h6 == value ? io_request_bits_operands_2_mode : rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [1:0] _GEN_353 = 3'h7 == value ? io_request_bits_operands_2_mode : rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 32:70]
  wire [63:0] _GEN_356 = 3'h2 == value ? io_request_bits_operands_2_value : rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 32:70]
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
  wire [63:0] _GEN_498 = new_input_log ? _GEN_322 : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_506 = new_input_log ? _GEN_330 : rb_entries_0_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_507 = new_input_log ? _GEN_331 : rb_entries_1_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_508 = new_input_log ? _GEN_332 : rb_entries_2_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_509 = new_input_log ? _GEN_333 : rb_entries_3_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_510 = new_input_log ? _GEN_334 : rb_entries_4_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_511 = new_input_log ? _GEN_335 : rb_entries_5_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_512 = new_input_log ? _GEN_336 : rb_entries_6_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_513 = new_input_log ? _GEN_337 : rb_entries_7_request_operands_1_mode; // @[POSIT_Locality.scala 23:28]
  wire [63:0] _GEN_515 = new_input_log ? _GEN_339 : rb_entries_1_request_operands_1_value; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_522 = new_input_log ? _GEN_346 : rb_entries_0_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_523 = new_input_log ? _GEN_347 : rb_entries_1_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_524 = new_input_log ? _GEN_348 : rb_entries_2_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_525 = new_input_log ? _GEN_349 : rb_entries_3_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_526 = new_input_log ? _GEN_350 : rb_entries_4_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_527 = new_input_log ? _GEN_351 : rb_entries_5_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_528 = new_input_log ? _GEN_352 : rb_entries_6_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [1:0] _GEN_529 = new_input_log ? _GEN_353 : rb_entries_7_request_operands_2_mode; // @[POSIT_Locality.scala 23:28]
  wire [63:0] _GEN_532 = new_input_log ? _GEN_356 : rb_entries_2_request_operands_2_value; // @[POSIT_Locality.scala 23:28]
  reg [2:0] value_1; // @[Counter.scala 29:33]
  reg [31:0] _RAND_169;
  wire [2:0] _T_11 = value_1 + 3'h1; // @[Counter.scala 39:22]
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
  wire [63:0] _GEN_651 = 3'h1 == value_1 ? rb_entries_1_result_out : rb_entries_0_result_out; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_652 = 3'h1 == value_1 ? rb_entries_1_result_lt : rb_entries_0_result_lt; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_653 = 3'h1 == value_1 ? rb_entries_1_result_eq : rb_entries_0_result_eq; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_654 = 3'h1 == value_1 ? rb_entries_1_result_gt : rb_entries_0_result_gt; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_655 = 3'h1 == value_1 ? rb_entries_1_result_exceptions : rb_entries_0_result_exceptions; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_666 = 3'h2 == value_1 ? rb_entries_2_wr_addr : _GEN_636; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_679 = 3'h2 == value_1 ? rb_entries_2_result_isZero : _GEN_649; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_680 = 3'h2 == value_1 ? rb_entries_2_result_isNaR : _GEN_650; // @[POSIT_Locality.scala 41:33]
  wire [63:0] _GEN_681 = 3'h2 == value_1 ? rb_entries_2_result_out : _GEN_651; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_682 = 3'h2 == value_1 ? rb_entries_2_result_lt : _GEN_652; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_683 = 3'h2 == value_1 ? rb_entries_2_result_eq : _GEN_653; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_684 = 3'h2 == value_1 ? rb_entries_2_result_gt : _GEN_654; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_685 = 3'h2 == value_1 ? rb_entries_2_result_exceptions : _GEN_655; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_696 = 3'h3 == value_1 ? rb_entries_3_wr_addr : _GEN_666; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_709 = 3'h3 == value_1 ? rb_entries_3_result_isZero : _GEN_679; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_710 = 3'h3 == value_1 ? rb_entries_3_result_isNaR : _GEN_680; // @[POSIT_Locality.scala 41:33]
  wire [63:0] _GEN_711 = 3'h3 == value_1 ? rb_entries_3_result_out : _GEN_681; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_712 = 3'h3 == value_1 ? rb_entries_3_result_lt : _GEN_682; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_713 = 3'h3 == value_1 ? rb_entries_3_result_eq : _GEN_683; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_714 = 3'h3 == value_1 ? rb_entries_3_result_gt : _GEN_684; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_715 = 3'h3 == value_1 ? rb_entries_3_result_exceptions : _GEN_685; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_726 = 3'h4 == value_1 ? rb_entries_4_wr_addr : _GEN_696; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_739 = 3'h4 == value_1 ? rb_entries_4_result_isZero : _GEN_709; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_740 = 3'h4 == value_1 ? rb_entries_4_result_isNaR : _GEN_710; // @[POSIT_Locality.scala 41:33]
  wire [63:0] _GEN_741 = 3'h4 == value_1 ? rb_entries_4_result_out : _GEN_711; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_742 = 3'h4 == value_1 ? rb_entries_4_result_lt : _GEN_712; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_743 = 3'h4 == value_1 ? rb_entries_4_result_eq : _GEN_713; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_744 = 3'h4 == value_1 ? rb_entries_4_result_gt : _GEN_714; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_745 = 3'h4 == value_1 ? rb_entries_4_result_exceptions : _GEN_715; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_756 = 3'h5 == value_1 ? rb_entries_5_wr_addr : _GEN_726; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_769 = 3'h5 == value_1 ? rb_entries_5_result_isZero : _GEN_739; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_770 = 3'h5 == value_1 ? rb_entries_5_result_isNaR : _GEN_740; // @[POSIT_Locality.scala 41:33]
  wire [63:0] _GEN_771 = 3'h5 == value_1 ? rb_entries_5_result_out : _GEN_741; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_772 = 3'h5 == value_1 ? rb_entries_5_result_lt : _GEN_742; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_773 = 3'h5 == value_1 ? rb_entries_5_result_eq : _GEN_743; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_774 = 3'h5 == value_1 ? rb_entries_5_result_gt : _GEN_744; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_775 = 3'h5 == value_1 ? rb_entries_5_result_exceptions : _GEN_745; // @[POSIT_Locality.scala 41:33]
  wire [47:0] _GEN_786 = 3'h6 == value_1 ? rb_entries_6_wr_addr : _GEN_756; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_799 = 3'h6 == value_1 ? rb_entries_6_result_isZero : _GEN_769; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_800 = 3'h6 == value_1 ? rb_entries_6_result_isNaR : _GEN_770; // @[POSIT_Locality.scala 41:33]
  wire [63:0] _GEN_801 = 3'h6 == value_1 ? rb_entries_6_result_out : _GEN_771; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_802 = 3'h6 == value_1 ? rb_entries_6_result_lt : _GEN_772; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_803 = 3'h6 == value_1 ? rb_entries_6_result_eq : _GEN_773; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_804 = 3'h6 == value_1 ? rb_entries_6_result_gt : _GEN_774; // @[POSIT_Locality.scala 41:33]
  wire [4:0] _GEN_805 = 3'h6 == value_1 ? rb_entries_6_result_exceptions : _GEN_775; // @[POSIT_Locality.scala 41:33]
  wire  _GEN_13028 = 3'h0 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_836 = _GEN_13028 | _GEN_434; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13029 = 3'h1 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_837 = _GEN_13029 | _GEN_435; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13030 = 3'h2 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_838 = _GEN_13030 | _GEN_436; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13031 = 3'h3 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_839 = _GEN_13031 | _GEN_437; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13032 = 3'h4 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_840 = _GEN_13032 | _GEN_438; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13033 = 3'h5 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_841 = _GEN_13033 | _GEN_439; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13034 = 3'h6 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_842 = _GEN_13034 | _GEN_440; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_13035 = 3'h7 == value_1; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_843 = _GEN_13035 | _GEN_441; // @[POSIT_Locality.scala 43:47]
  wire  _GEN_845 = wbCountOn ? _GEN_836 : _GEN_434; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_846 = wbCountOn ? _GEN_837 : _GEN_435; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_847 = wbCountOn ? _GEN_838 : _GEN_436; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_848 = wbCountOn ? _GEN_839 : _GEN_437; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_849 = wbCountOn ? _GEN_840 : _GEN_438; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_850 = wbCountOn ? _GEN_841 : _GEN_439; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_851 = wbCountOn ? _GEN_842 : _GEN_440; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_852 = wbCountOn ? _GEN_843 : _GEN_441; // @[POSIT_Locality.scala 41:68]
  wire  _GEN_853 = _GEN_13028 | _GEN_845; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_854 = _GEN_13029 | _GEN_846; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_855 = _GEN_13030 | _GEN_847; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_856 = _GEN_13031 | _GEN_848; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_857 = _GEN_13032 | _GEN_849; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_858 = _GEN_13033 | _GEN_850; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_859 = _GEN_13034 | _GEN_851; // @[POSIT_Locality.scala 55:47]
  wire  _GEN_860 = _GEN_13035 | _GEN_852; // @[POSIT_Locality.scala 55:47]
  wire  opsValidVec_0 = rb_entries_0_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 69:43]
  wire  opsValidVec_1 = rb_entries_1_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 69:43]
  wire  opsValidVec_2 = rb_entries_2_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 69:43]
  wire  opsValidVec_3 = rb_entries_3_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 69:43]
  wire  opsValidVec_4 = rb_entries_4_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 69:43]
  wire  opsValidVec_5 = rb_entries_5_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 69:43]
  wire  opsValidVec_6 = rb_entries_6_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 69:43]
  wire  opsValidVec_7 = rb_entries_7_request_operands_2_mode == 2'h0; // @[POSIT_Locality.scala 69:43]
  wire [3:0] _T_63 = {opsValidVec_3,opsValidVec_2,opsValidVec_1,opsValidVec_0}; // @[POSIT_Locality.scala 78:58]
  wire [3:0] _T_66 = {opsValidVec_7,opsValidVec_6,opsValidVec_5,opsValidVec_4}; // @[POSIT_Locality.scala 78:58]
  wire  _T_68 = dispatchArb_io_hasChosen & pe_io_request_ready; // @[POSIT_Locality.scala 84:39]
  wire [63:0] _GEN_911 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_0_value : rb_entries_0_request_operands_0_value; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_913 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_1_value : rb_entries_0_request_operands_1_value; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_915 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_operands_2_value : rb_entries_0_request_operands_2_value; // @[POSIT_Locality.scala 93:33]
  wire [2:0] _GEN_917 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_inst : rb_entries_0_request_inst; // @[POSIT_Locality.scala 93:33]
  wire [1:0] _GEN_918 = 3'h1 == dispatchArb_io_chosen ? rb_entries_1_request_mode : rb_entries_0_request_mode; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_941 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_0_value : _GEN_911; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_943 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_1_value : _GEN_913; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_945 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_operands_2_value : _GEN_915; // @[POSIT_Locality.scala 93:33]
  wire [2:0] _GEN_947 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_inst : _GEN_917; // @[POSIT_Locality.scala 93:33]
  wire [1:0] _GEN_948 = 3'h2 == dispatchArb_io_chosen ? rb_entries_2_request_mode : _GEN_918; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_971 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_0_value : _GEN_941; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_973 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_1_value : _GEN_943; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_975 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_operands_2_value : _GEN_945; // @[POSIT_Locality.scala 93:33]
  wire [2:0] _GEN_977 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_inst : _GEN_947; // @[POSIT_Locality.scala 93:33]
  wire [1:0] _GEN_978 = 3'h3 == dispatchArb_io_chosen ? rb_entries_3_request_mode : _GEN_948; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1001 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_0_value : _GEN_971; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1003 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_1_value : _GEN_973; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1005 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_operands_2_value : _GEN_975; // @[POSIT_Locality.scala 93:33]
  wire [2:0] _GEN_1007 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_inst : _GEN_977; // @[POSIT_Locality.scala 93:33]
  wire [1:0] _GEN_1008 = 3'h4 == dispatchArb_io_chosen ? rb_entries_4_request_mode : _GEN_978; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1031 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_0_value : _GEN_1001; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1033 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_1_value : _GEN_1003; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1035 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_operands_2_value : _GEN_1005; // @[POSIT_Locality.scala 93:33]
  wire [2:0] _GEN_1037 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_inst : _GEN_1007; // @[POSIT_Locality.scala 93:33]
  wire [1:0] _GEN_1038 = 3'h5 == dispatchArb_io_chosen ? rb_entries_5_request_mode : _GEN_1008; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1061 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_0_value : _GEN_1031; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1063 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_1_value : _GEN_1033; // @[POSIT_Locality.scala 93:33]
  wire [63:0] _GEN_1065 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_operands_2_value : _GEN_1035; // @[POSIT_Locality.scala 93:33]
  wire [2:0] _GEN_1067 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_inst : _GEN_1037; // @[POSIT_Locality.scala 93:33]
  wire [1:0] _GEN_1068 = 3'h6 == dispatchArb_io_chosen ? rb_entries_6_request_mode : _GEN_1038; // @[POSIT_Locality.scala 93:33]
  wire  _T_70 = pe_io_result_ready & pe_io_result_valid; // @[POSIT_Locality.scala 101:33]
  wire [2:0] result_idx = processQueue_io_deq_bits; // @[POSIT_Locality.scala 99:30 POSIT_Locality.scala 100:20]
  wire [4:0] _rb_entries_result_idx_result_exceptions = pe_io_result_bits_exceptions; // @[POSIT_Locality.scala 103:47 POSIT_Locality.scala 103:47]
  wire  _rb_entries_result_idx_result_gt = pe_io_result_bits_gt; // @[POSIT_Locality.scala 103:47 POSIT_Locality.scala 103:47]
  wire  _rb_entries_result_idx_result_eq = pe_io_result_bits_eq; // @[POSIT_Locality.scala 103:47 POSIT_Locality.scala 103:47]
  wire  _rb_entries_result_idx_result_lt = pe_io_result_bits_lt; // @[POSIT_Locality.scala 103:47 POSIT_Locality.scala 103:47]
  wire [63:0] _rb_entries_result_idx_result_out = pe_io_result_bits_out; // @[POSIT_Locality.scala 103:47 POSIT_Locality.scala 103:47]
  wire  _rb_entries_result_idx_result_isNaR = pe_io_result_bits_isNaR; // @[POSIT_Locality.scala 103:47 POSIT_Locality.scala 103:47]
  wire  _rb_entries_result_idx_result_isZero = pe_io_result_bits_isZero; // @[POSIT_Locality.scala 103:47 POSIT_Locality.scala 103:47]
  wire  _GEN_13044 = 3'h0 == result_idx; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_1166 = _GEN_13044 | _GEN_418; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_13045 = 3'h1 == result_idx; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_1167 = _GEN_13045 | _GEN_419; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_13046 = 3'h2 == result_idx; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_1168 = _GEN_13046 | _GEN_420; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_13047 = 3'h3 == result_idx; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_1169 = _GEN_13047 | _GEN_421; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_13048 = 3'h4 == result_idx; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_1170 = _GEN_13048 | _GEN_422; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_13049 = 3'h5 == result_idx; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_1171 = _GEN_13049 | _GEN_423; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_13050 = 3'h6 == result_idx; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_1172 = _GEN_13050 | _GEN_424; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_13051 = 3'h7 == result_idx; // @[POSIT_Locality.scala 104:50]
  wire  _GEN_1173 = _GEN_13051 | _GEN_425; // @[POSIT_Locality.scala 104:50]
  wire  _T_71 = rb_entries_0_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_1275 = 3'h1 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1294 = 3'h1 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_1_result_out : rb_entries_0_result_out; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1305 = 3'h2 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_1275; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1324 = 3'h2 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_2_result_out : _GEN_1294; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1335 = 3'h3 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_1305; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1354 = 3'h3 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_3_result_out : _GEN_1324; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1365 = 3'h4 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_1335; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1384 = 3'h4 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_4_result_out : _GEN_1354; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1395 = 3'h5 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_1365; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1414 = 3'h5 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_5_result_out : _GEN_1384; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1425 = 3'h6 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_1395; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1444 = 3'h6 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_6_result_out : _GEN_1414; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1455 = 3'h7 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_1425; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1474 = 3'h7 == rb_entries_0_request_operands_0_value[2:0] ? rb_entries_7_result_out : _GEN_1444; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1719 = _GEN_1455 ? _GEN_1474 : _GEN_498; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_1721 = _T_71 ? _GEN_1719 : _GEN_498; // @[POSIT_Locality.scala 112:77]
  wire  _T_74 = rb_entries_0_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_1759 = 3'h1 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1789 = 3'h2 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_1759; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1819 = 3'h3 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_1789; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1849 = 3'h4 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_1819; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1879 = 3'h5 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_1849; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1909 = 3'h6 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_1879; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_1939 = 3'h7 == rb_entries_0_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_1909; // @[POSIT_Locality.scala 113:100]
  wire  _T_77 = rb_entries_0_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_2243 = 3'h1 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2273 = 3'h2 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_2243; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2303 = 3'h3 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_2273; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2333 = 3'h4 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_2303; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2363 = 3'h5 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_2333; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2393 = 3'h6 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_2363; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2423 = 3'h7 == rb_entries_0_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_2393; // @[POSIT_Locality.scala 113:100]
  wire  _T_80 = rb_entries_1_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_2727 = 3'h1 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2757 = 3'h2 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_2727; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2787 = 3'h3 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_2757; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2817 = 3'h4 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_2787; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2847 = 3'h5 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_2817; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2877 = 3'h6 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_2847; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_2907 = 3'h7 == rb_entries_1_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_2877; // @[POSIT_Locality.scala 113:100]
  wire  _T_83 = rb_entries_1_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_3211 = 3'h1 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3230 = 3'h1 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_1_result_out : rb_entries_0_result_out; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3241 = 3'h2 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_3211; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3260 = 3'h2 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_2_result_out : _GEN_3230; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3271 = 3'h3 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_3241; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3290 = 3'h3 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_3_result_out : _GEN_3260; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3301 = 3'h4 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_3271; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3320 = 3'h4 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_4_result_out : _GEN_3290; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3331 = 3'h5 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_3301; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3350 = 3'h5 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_5_result_out : _GEN_3320; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3361 = 3'h6 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_3331; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3380 = 3'h6 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_6_result_out : _GEN_3350; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3391 = 3'h7 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_3361; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3410 = 3'h7 == rb_entries_1_request_operands_1_value[2:0] ? rb_entries_7_result_out : _GEN_3380; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3655 = _GEN_3391 ? _GEN_3410 : _GEN_515; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_3657 = _T_83 ? _GEN_3655 : _GEN_515; // @[POSIT_Locality.scala 112:77]
  wire  _T_86 = rb_entries_1_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_3695 = 3'h1 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3725 = 3'h2 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_3695; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3755 = 3'h3 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_3725; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3785 = 3'h4 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_3755; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3815 = 3'h5 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_3785; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3845 = 3'h6 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_3815; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_3875 = 3'h7 == rb_entries_1_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_3845; // @[POSIT_Locality.scala 113:100]
  wire  _T_89 = rb_entries_2_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_4179 = 3'h1 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4209 = 3'h2 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_4179; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4239 = 3'h3 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_4209; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4269 = 3'h4 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_4239; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4299 = 3'h5 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_4269; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4329 = 3'h6 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_4299; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4359 = 3'h7 == rb_entries_2_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_4329; // @[POSIT_Locality.scala 113:100]
  wire  _T_92 = rb_entries_2_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_4663 = 3'h1 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4693 = 3'h2 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_4663; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4723 = 3'h3 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_4693; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4753 = 3'h4 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_4723; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4783 = 3'h5 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_4753; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4813 = 3'h6 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_4783; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_4843 = 3'h7 == rb_entries_2_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_4813; // @[POSIT_Locality.scala 113:100]
  wire  _T_95 = rb_entries_2_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_5147 = 3'h1 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5166 = 3'h1 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_1_result_out : rb_entries_0_result_out; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5177 = 3'h2 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_5147; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5196 = 3'h2 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_2_result_out : _GEN_5166; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5207 = 3'h3 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_5177; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5226 = 3'h3 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_3_result_out : _GEN_5196; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5237 = 3'h4 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_5207; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5256 = 3'h4 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_4_result_out : _GEN_5226; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5267 = 3'h5 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_5237; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5286 = 3'h5 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_5_result_out : _GEN_5256; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5297 = 3'h6 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_5267; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5316 = 3'h6 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_6_result_out : _GEN_5286; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5327 = 3'h7 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_5297; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5346 = 3'h7 == rb_entries_2_request_operands_2_value[2:0] ? rb_entries_7_result_out : _GEN_5316; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5591 = _GEN_5327 ? _GEN_5346 : _GEN_532; // @[POSIT_Locality.scala 113:100]
  wire [63:0] _GEN_5593 = _T_95 ? _GEN_5591 : _GEN_532; // @[POSIT_Locality.scala 112:77]
  wire  _T_98 = rb_entries_3_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_5631 = 3'h1 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5661 = 3'h2 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_5631; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5691 = 3'h3 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_5661; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5721 = 3'h4 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_5691; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5751 = 3'h5 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_5721; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5781 = 3'h6 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_5751; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_5811 = 3'h7 == rb_entries_3_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_5781; // @[POSIT_Locality.scala 113:100]
  wire  _T_101 = rb_entries_3_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_6115 = 3'h1 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6145 = 3'h2 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_6115; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6175 = 3'h3 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_6145; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6205 = 3'h4 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_6175; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6235 = 3'h5 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_6205; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6265 = 3'h6 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_6235; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6295 = 3'h7 == rb_entries_3_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_6265; // @[POSIT_Locality.scala 113:100]
  wire  _T_104 = rb_entries_3_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_6599 = 3'h1 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6629 = 3'h2 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_6599; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6659 = 3'h3 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_6629; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6689 = 3'h4 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_6659; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6719 = 3'h5 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_6689; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6749 = 3'h6 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_6719; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_6779 = 3'h7 == rb_entries_3_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_6749; // @[POSIT_Locality.scala 113:100]
  wire  _T_107 = rb_entries_4_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_7083 = 3'h1 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7113 = 3'h2 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_7083; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7143 = 3'h3 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_7113; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7173 = 3'h4 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_7143; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7203 = 3'h5 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_7173; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7233 = 3'h6 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_7203; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7263 = 3'h7 == rb_entries_4_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_7233; // @[POSIT_Locality.scala 113:100]
  wire  _T_110 = rb_entries_4_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_7567 = 3'h1 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7597 = 3'h2 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_7567; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7627 = 3'h3 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_7597; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7657 = 3'h4 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_7627; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7687 = 3'h5 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_7657; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7717 = 3'h6 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_7687; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_7747 = 3'h7 == rb_entries_4_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_7717; // @[POSIT_Locality.scala 113:100]
  wire  _T_113 = rb_entries_4_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_8051 = 3'h1 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8081 = 3'h2 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_8051; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8111 = 3'h3 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_8081; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8141 = 3'h4 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_8111; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8171 = 3'h5 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_8141; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8201 = 3'h6 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_8171; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8231 = 3'h7 == rb_entries_4_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_8201; // @[POSIT_Locality.scala 113:100]
  wire  _T_116 = rb_entries_5_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_8535 = 3'h1 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8565 = 3'h2 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_8535; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8595 = 3'h3 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_8565; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8625 = 3'h4 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_8595; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8655 = 3'h5 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_8625; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8685 = 3'h6 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_8655; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_8715 = 3'h7 == rb_entries_5_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_8685; // @[POSIT_Locality.scala 113:100]
  wire  _T_119 = rb_entries_5_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_9019 = 3'h1 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9049 = 3'h2 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_9019; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9079 = 3'h3 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_9049; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9109 = 3'h4 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_9079; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9139 = 3'h5 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_9109; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9169 = 3'h6 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_9139; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9199 = 3'h7 == rb_entries_5_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_9169; // @[POSIT_Locality.scala 113:100]
  wire  _T_122 = rb_entries_5_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_9503 = 3'h1 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9533 = 3'h2 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_9503; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9563 = 3'h3 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_9533; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9593 = 3'h4 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_9563; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9623 = 3'h5 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_9593; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9653 = 3'h6 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_9623; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_9683 = 3'h7 == rb_entries_5_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_9653; // @[POSIT_Locality.scala 113:100]
  wire  _T_125 = rb_entries_6_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_9987 = 3'h1 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10017 = 3'h2 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_9987; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10047 = 3'h3 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_10017; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10077 = 3'h4 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_10047; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10107 = 3'h5 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_10077; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10137 = 3'h6 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_10107; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10167 = 3'h7 == rb_entries_6_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_10137; // @[POSIT_Locality.scala 113:100]
  wire  _T_128 = rb_entries_6_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_10471 = 3'h1 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10501 = 3'h2 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_10471; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10531 = 3'h3 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_10501; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10561 = 3'h4 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_10531; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10591 = 3'h5 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_10561; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10621 = 3'h6 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_10591; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10651 = 3'h7 == rb_entries_6_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_10621; // @[POSIT_Locality.scala 113:100]
  wire  _T_131 = rb_entries_6_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_10955 = 3'h1 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_10985 = 3'h2 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_10955; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11015 = 3'h3 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_10985; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11045 = 3'h4 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_11015; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11075 = 3'h5 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_11045; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11105 = 3'h6 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_11075; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11135 = 3'h7 == rb_entries_6_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_11105; // @[POSIT_Locality.scala 113:100]
  wire  _T_134 = rb_entries_7_request_operands_0_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_11439 = 3'h1 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11469 = 3'h2 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_2_completed : _GEN_11439; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11499 = 3'h3 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_3_completed : _GEN_11469; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11529 = 3'h4 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_4_completed : _GEN_11499; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11559 = 3'h5 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_5_completed : _GEN_11529; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11589 = 3'h6 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_6_completed : _GEN_11559; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11619 = 3'h7 == rb_entries_7_request_operands_0_value[2:0] ? rb_entries_7_completed : _GEN_11589; // @[POSIT_Locality.scala 113:100]
  wire  _T_137 = rb_entries_7_request_operands_1_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_11923 = 3'h1 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11953 = 3'h2 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_2_completed : _GEN_11923; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_11983 = 3'h3 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_3_completed : _GEN_11953; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12013 = 3'h4 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_4_completed : _GEN_11983; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12043 = 3'h5 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_5_completed : _GEN_12013; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12073 = 3'h6 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_6_completed : _GEN_12043; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12103 = 3'h7 == rb_entries_7_request_operands_1_value[2:0] ? rb_entries_7_completed : _GEN_12073; // @[POSIT_Locality.scala 113:100]
  wire  _T_140 = rb_entries_7_request_operands_2_mode == 2'h1; // @[POSIT_Locality.scala 112:69]
  wire  _GEN_12407 = 3'h1 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_1_completed : rb_entries_0_completed; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12437 = 3'h2 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_2_completed : _GEN_12407; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12467 = 3'h3 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_3_completed : _GEN_12437; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12497 = 3'h4 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_4_completed : _GEN_12467; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12527 = 3'h5 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_5_completed : _GEN_12497; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12557 = 3'h6 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_6_completed : _GEN_12527; // @[POSIT_Locality.scala 113:100]
  wire  _GEN_12587 = 3'h7 == rb_entries_7_request_operands_2_value[2:0] ? rb_entries_7_completed : _GEN_12557; // @[POSIT_Locality.scala 113:100]
  wire  _T_143 = rb_entries_0_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_13052 = {{16'd0}, io_op_mem_read_resp_tag}; // @[POSIT_Locality.scala 127:86]
  wire  _T_144 = rb_entries_0_request_operands_0_value == _GEN_13052; // @[POSIT_Locality.scala 127:86]
  wire [63:0] _GEN_12855 = _T_144 ? io_op_mem_read_data : _GEN_1721; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12857 = _T_143 ? _GEN_12855 : _GEN_1721; // @[POSIT_Locality.scala 126:85]
  wire  _T_145 = rb_entries_0_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_146 = rb_entries_1_request_operands_1_value == _GEN_13052; // @[POSIT_Locality.scala 127:86]
  wire [63:0] _GEN_12859 = _T_146 ? io_op_mem_read_data : _GEN_3657; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12861 = _T_145 ? _GEN_12859 : _GEN_3657; // @[POSIT_Locality.scala 126:85]
  wire  _T_147 = rb_entries_0_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_148 = rb_entries_2_request_operands_2_value == _GEN_13052; // @[POSIT_Locality.scala 127:86]
  wire [63:0] _GEN_12863 = _T_148 ? io_op_mem_read_data : _GEN_5593; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12865 = _T_147 ? _GEN_12863 : _GEN_5593; // @[POSIT_Locality.scala 126:85]
  wire  _T_149 = rb_entries_1_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12867 = _T_144 ? io_op_mem_read_data : _GEN_12857; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12869 = _T_149 ? _GEN_12867 : _GEN_12857; // @[POSIT_Locality.scala 126:85]
  wire  _T_151 = rb_entries_1_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12871 = _T_146 ? io_op_mem_read_data : _GEN_12861; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12873 = _T_151 ? _GEN_12871 : _GEN_12861; // @[POSIT_Locality.scala 126:85]
  wire  _T_153 = rb_entries_1_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12875 = _T_148 ? io_op_mem_read_data : _GEN_12865; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12877 = _T_153 ? _GEN_12875 : _GEN_12865; // @[POSIT_Locality.scala 126:85]
  wire  _T_155 = rb_entries_2_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12879 = _T_144 ? io_op_mem_read_data : _GEN_12869; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12881 = _T_155 ? _GEN_12879 : _GEN_12869; // @[POSIT_Locality.scala 126:85]
  wire  _T_157 = rb_entries_2_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12883 = _T_146 ? io_op_mem_read_data : _GEN_12873; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12885 = _T_157 ? _GEN_12883 : _GEN_12873; // @[POSIT_Locality.scala 126:85]
  wire  _T_159 = rb_entries_2_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12887 = _T_148 ? io_op_mem_read_data : _GEN_12877; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12889 = _T_159 ? _GEN_12887 : _GEN_12877; // @[POSIT_Locality.scala 126:85]
  wire  _T_161 = rb_entries_3_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12891 = _T_144 ? io_op_mem_read_data : _GEN_12881; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12893 = _T_161 ? _GEN_12891 : _GEN_12881; // @[POSIT_Locality.scala 126:85]
  wire  _T_163 = rb_entries_3_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12895 = _T_146 ? io_op_mem_read_data : _GEN_12885; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12897 = _T_163 ? _GEN_12895 : _GEN_12885; // @[POSIT_Locality.scala 126:85]
  wire  _T_165 = rb_entries_3_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12899 = _T_148 ? io_op_mem_read_data : _GEN_12889; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12901 = _T_165 ? _GEN_12899 : _GEN_12889; // @[POSIT_Locality.scala 126:85]
  wire  _T_167 = rb_entries_4_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12903 = _T_144 ? io_op_mem_read_data : _GEN_12893; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12905 = _T_167 ? _GEN_12903 : _GEN_12893; // @[POSIT_Locality.scala 126:85]
  wire  _T_169 = rb_entries_4_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12907 = _T_146 ? io_op_mem_read_data : _GEN_12897; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12909 = _T_169 ? _GEN_12907 : _GEN_12897; // @[POSIT_Locality.scala 126:85]
  wire  _T_171 = rb_entries_4_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire [63:0] _GEN_12911 = _T_148 ? io_op_mem_read_data : _GEN_12901; // @[POSIT_Locality.scala 127:114]
  wire [63:0] _GEN_12913 = _T_171 ? _GEN_12911 : _GEN_12901; // @[POSIT_Locality.scala 126:85]
  wire  _T_173 = rb_entries_5_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_175 = rb_entries_5_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_177 = rb_entries_5_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_179 = rb_entries_6_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_181 = rb_entries_6_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_183 = rb_entries_6_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_185 = rb_entries_7_request_operands_0_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_187 = rb_entries_7_request_operands_1_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_189 = rb_entries_7_request_operands_2_mode == 2'h2; // @[POSIT_Locality.scala 126:77]
  wire  _T_193 = ~rb_entries_0_request_inFetch_0; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_0 = _T_143 & _T_193; // @[POSIT_Locality.scala 143:105]
  wire  _T_197 = ~rb_entries_0_request_inFetch_1; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_1 = _T_145 & _T_197; // @[POSIT_Locality.scala 143:105]
  wire  _T_201 = ~rb_entries_0_request_inFetch_2; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_2 = _T_147 & _T_201; // @[POSIT_Locality.scala 143:105]
  wire  _T_205 = ~rb_entries_1_request_inFetch_0; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_3 = _T_149 & _T_205; // @[POSIT_Locality.scala 143:105]
  wire  _T_209 = ~rb_entries_1_request_inFetch_1; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_4 = _T_151 & _T_209; // @[POSIT_Locality.scala 143:105]
  wire  _T_213 = ~rb_entries_1_request_inFetch_2; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_5 = _T_153 & _T_213; // @[POSIT_Locality.scala 143:105]
  wire  _T_217 = ~rb_entries_2_request_inFetch_0; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_6 = _T_155 & _T_217; // @[POSIT_Locality.scala 143:105]
  wire  _T_221 = ~rb_entries_2_request_inFetch_1; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_7 = _T_157 & _T_221; // @[POSIT_Locality.scala 143:105]
  wire  _T_225 = ~rb_entries_2_request_inFetch_2; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_8 = _T_159 & _T_225; // @[POSIT_Locality.scala 143:105]
  wire  _T_229 = ~rb_entries_3_request_inFetch_0; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_9 = _T_161 & _T_229; // @[POSIT_Locality.scala 143:105]
  wire  _T_233 = ~rb_entries_3_request_inFetch_1; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_10 = _T_163 & _T_233; // @[POSIT_Locality.scala 143:105]
  wire  _T_237 = ~rb_entries_3_request_inFetch_2; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_11 = _T_165 & _T_237; // @[POSIT_Locality.scala 143:105]
  wire  _T_241 = ~rb_entries_4_request_inFetch_0; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_12 = _T_167 & _T_241; // @[POSIT_Locality.scala 143:105]
  wire  _T_245 = ~rb_entries_4_request_inFetch_1; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_13 = _T_169 & _T_245; // @[POSIT_Locality.scala 143:105]
  wire  _T_249 = ~rb_entries_4_request_inFetch_2; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_14 = _T_171 & _T_249; // @[POSIT_Locality.scala 143:105]
  wire  _T_253 = ~rb_entries_5_request_inFetch_0; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_15 = _T_173 & _T_253; // @[POSIT_Locality.scala 143:105]
  wire  _T_257 = ~rb_entries_5_request_inFetch_1; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_16 = _T_175 & _T_257; // @[POSIT_Locality.scala 143:105]
  wire  _T_261 = ~rb_entries_5_request_inFetch_2; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_17 = _T_177 & _T_261; // @[POSIT_Locality.scala 143:105]
  wire  _T_265 = ~rb_entries_6_request_inFetch_0; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_18 = _T_179 & _T_265; // @[POSIT_Locality.scala 143:105]
  wire  _T_269 = ~rb_entries_6_request_inFetch_1; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_19 = _T_181 & _T_269; // @[POSIT_Locality.scala 143:105]
  wire  _T_273 = ~rb_entries_6_request_inFetch_2; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_20 = _T_183 & _T_273; // @[POSIT_Locality.scala 143:105]
  wire  _T_277 = ~rb_entries_7_request_inFetch_0; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_21 = _T_185 & _T_277; // @[POSIT_Locality.scala 143:105]
  wire  _T_281 = ~rb_entries_7_request_inFetch_1; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_22 = _T_187 & _T_281; // @[POSIT_Locality.scala 143:105]
  wire  _T_285 = ~rb_entries_7_request_inFetch_2; // @[POSIT_Locality.scala 143:109]
  wire  waitingToBeFetched_23 = _T_189 & _T_285; // @[POSIT_Locality.scala 143:105]
  wire [5:0] _T_291 = {waitingToBeFetched_5,waitingToBeFetched_4,waitingToBeFetched_3,waitingToBeFetched_2,waitingToBeFetched_1,waitingToBeFetched_0}; // @[POSIT_Locality.scala 149:52]
  wire [11:0] _T_297 = {waitingToBeFetched_11,waitingToBeFetched_10,waitingToBeFetched_9,waitingToBeFetched_8,waitingToBeFetched_7,waitingToBeFetched_6,_T_291}; // @[POSIT_Locality.scala 149:52]
  wire [5:0] _T_302 = {waitingToBeFetched_17,waitingToBeFetched_16,waitingToBeFetched_15,waitingToBeFetched_14,waitingToBeFetched_13,waitingToBeFetched_12}; // @[POSIT_Locality.scala 149:52]
  wire [11:0] _T_308 = {waitingToBeFetched_23,waitingToBeFetched_22,waitingToBeFetched_21,waitingToBeFetched_20,waitingToBeFetched_19,waitingToBeFetched_18,_T_302}; // @[POSIT_Locality.scala 149:52]
  wire [5:0] _T_314 = {rb_entries_1_request_inFetch_2,rb_entries_1_request_inFetch_1,rb_entries_1_request_inFetch_0,rb_entries_0_request_inFetch_2,rb_entries_0_request_inFetch_1,rb_entries_0_request_inFetch_0}; // @[POSIT_Locality.scala 158:42]
  wire [11:0] _T_320 = {rb_entries_3_request_inFetch_2,rb_entries_3_request_inFetch_1,rb_entries_3_request_inFetch_0,rb_entries_2_request_inFetch_2,rb_entries_2_request_inFetch_1,rb_entries_2_request_inFetch_0,_T_314}; // @[POSIT_Locality.scala 158:42]
  wire [5:0] _T_325 = {rb_entries_5_request_inFetch_2,rb_entries_5_request_inFetch_1,rb_entries_5_request_inFetch_0,rb_entries_4_request_inFetch_2,rb_entries_4_request_inFetch_1,rb_entries_4_request_inFetch_0}; // @[POSIT_Locality.scala 158:42]
  wire [23:0] _T_332 = {rb_entries_7_request_inFetch_2,rb_entries_7_request_inFetch_1,rb_entries_7_request_inFetch_0,rb_entries_6_request_inFetch_2,rb_entries_6_request_inFetch_1,rb_entries_6_request_inFetch_0,_T_325,_T_320}; // @[POSIT_Locality.scala 158:42]
  wire [31:0] _T_333 = 32'h1 << fetchArb_io_chosen; // @[OneHot.scala 58:35]
  wire [23:0] _T_335 = _T_332 ^ _T_333[23:0]; // @[POSIT_Locality.scala 158:49]
  wire [47:0] fetchOffSet_0 = rb_entries_0_request_operands_0_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] fetchOffSet_1 = rb_entries_0_request_operands_1_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12979 = 5'h1 == fetchArb_io_chosen ? fetchOffSet_1 : fetchOffSet_0; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_2 = rb_entries_0_request_operands_2_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12980 = 5'h2 == fetchArb_io_chosen ? fetchOffSet_2 : _GEN_12979; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_3 = rb_entries_1_request_operands_0_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12981 = 5'h3 == fetchArb_io_chosen ? fetchOffSet_3 : _GEN_12980; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_4 = rb_entries_1_request_operands_1_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12982 = 5'h4 == fetchArb_io_chosen ? fetchOffSet_4 : _GEN_12981; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_5 = rb_entries_1_request_operands_2_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12983 = 5'h5 == fetchArb_io_chosen ? fetchOffSet_5 : _GEN_12982; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_6 = rb_entries_2_request_operands_0_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12984 = 5'h6 == fetchArb_io_chosen ? fetchOffSet_6 : _GEN_12983; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_7 = rb_entries_2_request_operands_1_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12985 = 5'h7 == fetchArb_io_chosen ? fetchOffSet_7 : _GEN_12984; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_8 = rb_entries_2_request_operands_2_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12986 = 5'h8 == fetchArb_io_chosen ? fetchOffSet_8 : _GEN_12985; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_9 = rb_entries_3_request_operands_0_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12987 = 5'h9 == fetchArb_io_chosen ? fetchOffSet_9 : _GEN_12986; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_10 = rb_entries_3_request_operands_1_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12988 = 5'ha == fetchArb_io_chosen ? fetchOffSet_10 : _GEN_12987; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_11 = rb_entries_3_request_operands_2_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12989 = 5'hb == fetchArb_io_chosen ? fetchOffSet_11 : _GEN_12988; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_12 = rb_entries_4_request_operands_0_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12990 = 5'hc == fetchArb_io_chosen ? fetchOffSet_12 : _GEN_12989; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_13 = rb_entries_4_request_operands_1_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12991 = 5'hd == fetchArb_io_chosen ? fetchOffSet_13 : _GEN_12990; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_14 = rb_entries_4_request_operands_2_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12992 = 5'he == fetchArb_io_chosen ? fetchOffSet_14 : _GEN_12991; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_15 = rb_entries_5_request_operands_0_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12993 = 5'hf == fetchArb_io_chosen ? fetchOffSet_15 : _GEN_12992; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_16 = rb_entries_5_request_operands_1_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12994 = 5'h10 == fetchArb_io_chosen ? fetchOffSet_16 : _GEN_12993; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_17 = rb_entries_5_request_operands_2_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12995 = 5'h11 == fetchArb_io_chosen ? fetchOffSet_17 : _GEN_12994; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_18 = rb_entries_6_request_operands_0_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12996 = 5'h12 == fetchArb_io_chosen ? fetchOffSet_18 : _GEN_12995; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_19 = rb_entries_6_request_operands_1_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12997 = 5'h13 == fetchArb_io_chosen ? fetchOffSet_19 : _GEN_12996; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_20 = rb_entries_6_request_operands_2_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12998 = 5'h14 == fetchArb_io_chosen ? fetchOffSet_20 : _GEN_12997; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_21 = rb_entries_7_request_operands_0_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_12999 = 5'h15 == fetchArb_io_chosen ? fetchOffSet_21 : _GEN_12998; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_22 = rb_entries_7_request_operands_1_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
  wire [47:0] _GEN_13000 = 5'h16 == fetchArb_io_chosen ? fetchOffSet_22 : _GEN_12999; // @[POSIT_Locality.scala 160:41]
  wire [47:0] fetchOffSet_23 = rb_entries_7_request_operands_2_value[47:0]; // @[POSIT_Locality.scala 137:31 POSIT_Locality.scala 144:60]
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
  DispatchArbiter_1 fetchArb ( // @[POSIT_Locality.scala 148:30]
    .io_validity(fetchArb_io_validity),
    .io_priority(fetchArb_io_priority),
    .io_chosen(fetchArb_io_chosen),
    .io_hasChosen(fetchArb_io_hasChosen)
  );
  assign io_request_ready = 3'h7 == value ? rb_entries_7_written : _GEN_191; // @[POSIT_Locality.scala 22:26]
  assign io_mem_write_valid = 3'h7 == value_1 ? rb_entries_7_completed : _GEN_782; // @[POSIT_Locality.scala 49:28]
  assign io_mem_write_bits_result_isZero = 3'h7 == value_1 ? rb_entries_7_result_isZero : _GEN_799; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_isNaR = 3'h7 == value_1 ? rb_entries_7_result_isNaR : _GEN_800; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_out = 3'h7 == value_1 ? rb_entries_7_result_out : _GEN_801; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_lt = 3'h7 == value_1 ? rb_entries_7_result_lt : _GEN_802; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_eq = 3'h7 == value_1 ? rb_entries_7_result_eq : _GEN_803; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_gt = 3'h7 == value_1 ? rb_entries_7_result_gt : _GEN_804; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_result_exceptions = 3'h7 == value_1 ? rb_entries_7_result_exceptions : _GEN_805; // @[POSIT_Locality.scala 51:34]
  assign io_mem_write_bits_out_wr_addr = 3'h7 == value_1 ? rb_entries_7_wr_addr : _GEN_786; // @[POSIT_Locality.scala 50:39]
  assign io_op_mem_read_req_valid = fetchArb_io_hasChosen; // @[POSIT_Locality.scala 159:42 POSIT_Locality.scala 163:42]
  assign io_op_mem_read_req_addr = 5'h17 == fetchArb_io_chosen ? fetchOffSet_23 : _GEN_13000; // @[POSIT_Locality.scala 160:41 POSIT_Locality.scala 164:41]
  assign pe_clock = clock;
  assign pe_reset = reset;
  assign pe_io_request_valid = _T_68 & processQueue_io_enq_ready; // @[POSIT_Locality.scala 85:37 POSIT_Locality.scala 88:37]
  assign pe_io_request_bits_num1 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_0_value : _GEN_1061; // @[POSIT_Locality.scala 93:33]
  assign pe_io_request_bits_num2 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_1_value : _GEN_1063; // @[POSIT_Locality.scala 94:33]
  assign pe_io_request_bits_num3 = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_operands_2_value : _GEN_1065; // @[POSIT_Locality.scala 95:33]
  assign pe_io_request_bits_inst = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_inst : _GEN_1067; // @[POSIT_Locality.scala 97:33]
  assign pe_io_request_bits_mode = 3'h7 == dispatchArb_io_chosen ? rb_entries_7_request_mode : _GEN_1068; // @[POSIT_Locality.scala 96:33]
  assign pe_io_result_ready = io_mem_write_ready; // @[POSIT_Locality.scala 92:28]
  assign processQueue_clock = clock;
  assign processQueue_reset = reset;
  assign processQueue_io_enq_valid = _T_68 & processQueue_io_enq_ready; // @[POSIT_Locality.scala 86:43 POSIT_Locality.scala 89:43]
  assign processQueue_io_enq_bits = dispatchArb_io_chosen; // @[POSIT_Locality.scala 83:34]
  assign processQueue_io_deq_ready = pe_io_result_ready & pe_io_result_valid; // @[POSIT_Locality.scala 102:43 POSIT_Locality.scala 106:43]
  assign dispatchArb_io_validity = {_T_66,_T_63}; // @[POSIT_Locality.scala 78:33]
  assign dispatchArb_io_priority = {{2'd0}, wbCountOn}; // @[POSIT_Locality.scala 79:33]
  assign fetchArb_io_validity = {_T_308,_T_297}; // @[POSIT_Locality.scala 149:30]
  assign fetchArb_io_priority = {{4'd0}, wbCountOn}; // @[POSIT_Locality.scala 150:30]
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
  rb_entries_0_written = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {2{`RANDOM}};
  rb_entries_0_wr_addr = _RAND_2[47:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {2{`RANDOM}};
  rb_entries_0_request_operands_0_value = _RAND_3[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  rb_entries_0_request_operands_0_mode = _RAND_4[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {2{`RANDOM}};
  rb_entries_0_request_operands_1_value = _RAND_5[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  rb_entries_0_request_operands_1_mode = _RAND_6[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {2{`RANDOM}};
  rb_entries_0_request_operands_2_value = _RAND_7[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  rb_entries_0_request_operands_2_mode = _RAND_8[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  rb_entries_0_request_inst = _RAND_9[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  rb_entries_0_request_mode = _RAND_10[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  rb_entries_0_request_inFetch_0 = _RAND_11[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  rb_entries_0_request_inFetch_1 = _RAND_12[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  rb_entries_0_request_inFetch_2 = _RAND_13[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  rb_entries_0_result_isZero = _RAND_14[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  rb_entries_0_result_isNaR = _RAND_15[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {2{`RANDOM}};
  rb_entries_0_result_out = _RAND_16[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  rb_entries_0_result_lt = _RAND_17[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  rb_entries_0_result_eq = _RAND_18[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  rb_entries_0_result_gt = _RAND_19[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  rb_entries_0_result_exceptions = _RAND_20[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  rb_entries_1_completed = _RAND_21[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  rb_entries_1_written = _RAND_22[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {2{`RANDOM}};
  rb_entries_1_wr_addr = _RAND_23[47:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {2{`RANDOM}};
  rb_entries_1_request_operands_0_value = _RAND_24[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  rb_entries_1_request_operands_0_mode = _RAND_25[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {2{`RANDOM}};
  rb_entries_1_request_operands_1_value = _RAND_26[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  rb_entries_1_request_operands_1_mode = _RAND_27[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {2{`RANDOM}};
  rb_entries_1_request_operands_2_value = _RAND_28[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  rb_entries_1_request_operands_2_mode = _RAND_29[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  rb_entries_1_request_inst = _RAND_30[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  rb_entries_1_request_mode = _RAND_31[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{`RANDOM}};
  rb_entries_1_request_inFetch_0 = _RAND_32[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_33 = {1{`RANDOM}};
  rb_entries_1_request_inFetch_1 = _RAND_33[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{`RANDOM}};
  rb_entries_1_request_inFetch_2 = _RAND_34[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_35 = {1{`RANDOM}};
  rb_entries_1_result_isZero = _RAND_35[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{`RANDOM}};
  rb_entries_1_result_isNaR = _RAND_36[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_37 = {2{`RANDOM}};
  rb_entries_1_result_out = _RAND_37[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_38 = {1{`RANDOM}};
  rb_entries_1_result_lt = _RAND_38[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_39 = {1{`RANDOM}};
  rb_entries_1_result_eq = _RAND_39[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_40 = {1{`RANDOM}};
  rb_entries_1_result_gt = _RAND_40[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_41 = {1{`RANDOM}};
  rb_entries_1_result_exceptions = _RAND_41[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_42 = {1{`RANDOM}};
  rb_entries_2_completed = _RAND_42[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_43 = {1{`RANDOM}};
  rb_entries_2_written = _RAND_43[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_44 = {2{`RANDOM}};
  rb_entries_2_wr_addr = _RAND_44[47:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_45 = {2{`RANDOM}};
  rb_entries_2_request_operands_0_value = _RAND_45[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_46 = {1{`RANDOM}};
  rb_entries_2_request_operands_0_mode = _RAND_46[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_47 = {2{`RANDOM}};
  rb_entries_2_request_operands_1_value = _RAND_47[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_48 = {1{`RANDOM}};
  rb_entries_2_request_operands_1_mode = _RAND_48[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_49 = {2{`RANDOM}};
  rb_entries_2_request_operands_2_value = _RAND_49[63:0];
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
  rb_entries_2_request_inFetch_0 = _RAND_53[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_54 = {1{`RANDOM}};
  rb_entries_2_request_inFetch_1 = _RAND_54[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_55 = {1{`RANDOM}};
  rb_entries_2_request_inFetch_2 = _RAND_55[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_56 = {1{`RANDOM}};
  rb_entries_2_result_isZero = _RAND_56[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_57 = {1{`RANDOM}};
  rb_entries_2_result_isNaR = _RAND_57[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_58 = {2{`RANDOM}};
  rb_entries_2_result_out = _RAND_58[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_59 = {1{`RANDOM}};
  rb_entries_2_result_lt = _RAND_59[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_60 = {1{`RANDOM}};
  rb_entries_2_result_eq = _RAND_60[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_61 = {1{`RANDOM}};
  rb_entries_2_result_gt = _RAND_61[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_62 = {1{`RANDOM}};
  rb_entries_2_result_exceptions = _RAND_62[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_63 = {1{`RANDOM}};
  rb_entries_3_completed = _RAND_63[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_64 = {1{`RANDOM}};
  rb_entries_3_written = _RAND_64[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_65 = {2{`RANDOM}};
  rb_entries_3_wr_addr = _RAND_65[47:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_66 = {2{`RANDOM}};
  rb_entries_3_request_operands_0_value = _RAND_66[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_67 = {1{`RANDOM}};
  rb_entries_3_request_operands_0_mode = _RAND_67[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_68 = {2{`RANDOM}};
  rb_entries_3_request_operands_1_value = _RAND_68[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_69 = {1{`RANDOM}};
  rb_entries_3_request_operands_1_mode = _RAND_69[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_70 = {2{`RANDOM}};
  rb_entries_3_request_operands_2_value = _RAND_70[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_71 = {1{`RANDOM}};
  rb_entries_3_request_operands_2_mode = _RAND_71[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_72 = {1{`RANDOM}};
  rb_entries_3_request_inst = _RAND_72[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_73 = {1{`RANDOM}};
  rb_entries_3_request_mode = _RAND_73[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_74 = {1{`RANDOM}};
  rb_entries_3_request_inFetch_0 = _RAND_74[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_75 = {1{`RANDOM}};
  rb_entries_3_request_inFetch_1 = _RAND_75[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_76 = {1{`RANDOM}};
  rb_entries_3_request_inFetch_2 = _RAND_76[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_77 = {1{`RANDOM}};
  rb_entries_3_result_isZero = _RAND_77[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_78 = {1{`RANDOM}};
  rb_entries_3_result_isNaR = _RAND_78[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_79 = {2{`RANDOM}};
  rb_entries_3_result_out = _RAND_79[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_80 = {1{`RANDOM}};
  rb_entries_3_result_lt = _RAND_80[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_81 = {1{`RANDOM}};
  rb_entries_3_result_eq = _RAND_81[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_82 = {1{`RANDOM}};
  rb_entries_3_result_gt = _RAND_82[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_83 = {1{`RANDOM}};
  rb_entries_3_result_exceptions = _RAND_83[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_84 = {1{`RANDOM}};
  rb_entries_4_completed = _RAND_84[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_85 = {1{`RANDOM}};
  rb_entries_4_written = _RAND_85[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_86 = {2{`RANDOM}};
  rb_entries_4_wr_addr = _RAND_86[47:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_87 = {2{`RANDOM}};
  rb_entries_4_request_operands_0_value = _RAND_87[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_88 = {1{`RANDOM}};
  rb_entries_4_request_operands_0_mode = _RAND_88[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_89 = {2{`RANDOM}};
  rb_entries_4_request_operands_1_value = _RAND_89[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_90 = {1{`RANDOM}};
  rb_entries_4_request_operands_1_mode = _RAND_90[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_91 = {2{`RANDOM}};
  rb_entries_4_request_operands_2_value = _RAND_91[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_92 = {1{`RANDOM}};
  rb_entries_4_request_operands_2_mode = _RAND_92[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_93 = {1{`RANDOM}};
  rb_entries_4_request_inst = _RAND_93[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_94 = {1{`RANDOM}};
  rb_entries_4_request_mode = _RAND_94[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_95 = {1{`RANDOM}};
  rb_entries_4_request_inFetch_0 = _RAND_95[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_96 = {1{`RANDOM}};
  rb_entries_4_request_inFetch_1 = _RAND_96[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_97 = {1{`RANDOM}};
  rb_entries_4_request_inFetch_2 = _RAND_97[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_98 = {1{`RANDOM}};
  rb_entries_4_result_isZero = _RAND_98[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_99 = {1{`RANDOM}};
  rb_entries_4_result_isNaR = _RAND_99[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_100 = {2{`RANDOM}};
  rb_entries_4_result_out = _RAND_100[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_101 = {1{`RANDOM}};
  rb_entries_4_result_lt = _RAND_101[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_102 = {1{`RANDOM}};
  rb_entries_4_result_eq = _RAND_102[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_103 = {1{`RANDOM}};
  rb_entries_4_result_gt = _RAND_103[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_104 = {1{`RANDOM}};
  rb_entries_4_result_exceptions = _RAND_104[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_105 = {1{`RANDOM}};
  rb_entries_5_completed = _RAND_105[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_106 = {1{`RANDOM}};
  rb_entries_5_written = _RAND_106[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_107 = {2{`RANDOM}};
  rb_entries_5_wr_addr = _RAND_107[47:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_108 = {2{`RANDOM}};
  rb_entries_5_request_operands_0_value = _RAND_108[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_109 = {1{`RANDOM}};
  rb_entries_5_request_operands_0_mode = _RAND_109[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_110 = {2{`RANDOM}};
  rb_entries_5_request_operands_1_value = _RAND_110[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_111 = {1{`RANDOM}};
  rb_entries_5_request_operands_1_mode = _RAND_111[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_112 = {2{`RANDOM}};
  rb_entries_5_request_operands_2_value = _RAND_112[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_113 = {1{`RANDOM}};
  rb_entries_5_request_operands_2_mode = _RAND_113[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_114 = {1{`RANDOM}};
  rb_entries_5_request_inst = _RAND_114[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_115 = {1{`RANDOM}};
  rb_entries_5_request_mode = _RAND_115[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_116 = {1{`RANDOM}};
  rb_entries_5_request_inFetch_0 = _RAND_116[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_117 = {1{`RANDOM}};
  rb_entries_5_request_inFetch_1 = _RAND_117[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_118 = {1{`RANDOM}};
  rb_entries_5_request_inFetch_2 = _RAND_118[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_119 = {1{`RANDOM}};
  rb_entries_5_result_isZero = _RAND_119[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_120 = {1{`RANDOM}};
  rb_entries_5_result_isNaR = _RAND_120[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_121 = {2{`RANDOM}};
  rb_entries_5_result_out = _RAND_121[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_122 = {1{`RANDOM}};
  rb_entries_5_result_lt = _RAND_122[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_123 = {1{`RANDOM}};
  rb_entries_5_result_eq = _RAND_123[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_124 = {1{`RANDOM}};
  rb_entries_5_result_gt = _RAND_124[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_125 = {1{`RANDOM}};
  rb_entries_5_result_exceptions = _RAND_125[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_126 = {1{`RANDOM}};
  rb_entries_6_completed = _RAND_126[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_127 = {1{`RANDOM}};
  rb_entries_6_written = _RAND_127[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_128 = {2{`RANDOM}};
  rb_entries_6_wr_addr = _RAND_128[47:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_129 = {2{`RANDOM}};
  rb_entries_6_request_operands_0_value = _RAND_129[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_130 = {1{`RANDOM}};
  rb_entries_6_request_operands_0_mode = _RAND_130[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_131 = {2{`RANDOM}};
  rb_entries_6_request_operands_1_value = _RAND_131[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_132 = {1{`RANDOM}};
  rb_entries_6_request_operands_1_mode = _RAND_132[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_133 = {2{`RANDOM}};
  rb_entries_6_request_operands_2_value = _RAND_133[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_134 = {1{`RANDOM}};
  rb_entries_6_request_operands_2_mode = _RAND_134[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_135 = {1{`RANDOM}};
  rb_entries_6_request_inst = _RAND_135[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_136 = {1{`RANDOM}};
  rb_entries_6_request_mode = _RAND_136[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_137 = {1{`RANDOM}};
  rb_entries_6_request_inFetch_0 = _RAND_137[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_138 = {1{`RANDOM}};
  rb_entries_6_request_inFetch_1 = _RAND_138[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_139 = {1{`RANDOM}};
  rb_entries_6_request_inFetch_2 = _RAND_139[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_140 = {1{`RANDOM}};
  rb_entries_6_result_isZero = _RAND_140[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_141 = {1{`RANDOM}};
  rb_entries_6_result_isNaR = _RAND_141[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_142 = {2{`RANDOM}};
  rb_entries_6_result_out = _RAND_142[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_143 = {1{`RANDOM}};
  rb_entries_6_result_lt = _RAND_143[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_144 = {1{`RANDOM}};
  rb_entries_6_result_eq = _RAND_144[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_145 = {1{`RANDOM}};
  rb_entries_6_result_gt = _RAND_145[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_146 = {1{`RANDOM}};
  rb_entries_6_result_exceptions = _RAND_146[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_147 = {1{`RANDOM}};
  rb_entries_7_completed = _RAND_147[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_148 = {1{`RANDOM}};
  rb_entries_7_written = _RAND_148[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_149 = {2{`RANDOM}};
  rb_entries_7_wr_addr = _RAND_149[47:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_150 = {2{`RANDOM}};
  rb_entries_7_request_operands_0_value = _RAND_150[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_151 = {1{`RANDOM}};
  rb_entries_7_request_operands_0_mode = _RAND_151[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_152 = {2{`RANDOM}};
  rb_entries_7_request_operands_1_value = _RAND_152[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_153 = {1{`RANDOM}};
  rb_entries_7_request_operands_1_mode = _RAND_153[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_154 = {2{`RANDOM}};
  rb_entries_7_request_operands_2_value = _RAND_154[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_155 = {1{`RANDOM}};
  rb_entries_7_request_operands_2_mode = _RAND_155[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_156 = {1{`RANDOM}};
  rb_entries_7_request_inst = _RAND_156[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_157 = {1{`RANDOM}};
  rb_entries_7_request_mode = _RAND_157[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_158 = {1{`RANDOM}};
  rb_entries_7_request_inFetch_0 = _RAND_158[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_159 = {1{`RANDOM}};
  rb_entries_7_request_inFetch_1 = _RAND_159[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_160 = {1{`RANDOM}};
  rb_entries_7_request_inFetch_2 = _RAND_160[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_161 = {1{`RANDOM}};
  rb_entries_7_result_isZero = _RAND_161[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_162 = {1{`RANDOM}};
  rb_entries_7_result_isNaR = _RAND_162[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_163 = {2{`RANDOM}};
  rb_entries_7_result_out = _RAND_163[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_164 = {1{`RANDOM}};
  rb_entries_7_result_lt = _RAND_164[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_165 = {1{`RANDOM}};
  rb_entries_7_result_eq = _RAND_165[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_166 = {1{`RANDOM}};
  rb_entries_7_result_gt = _RAND_166[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_167 = {1{`RANDOM}};
  rb_entries_7_result_exceptions = _RAND_167[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_168 = {1{`RANDOM}};
  value = _RAND_168[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_169 = {1{`RANDOM}};
  value_1 = _RAND_169[2:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (_T_70) begin
      rb_entries_0_completed <= _GEN_1166;
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_completed <= 1'h0;
      end
    end
    if (wbCountOn) begin
      rb_entries_0_written <= _GEN_853;
    end else if (wbCountOn) begin
      rb_entries_0_written <= _GEN_836;
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_written <= 1'h0;
      end
    end
    if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (io_op_mem_read_resp_valid) begin
      if (_T_185) begin
        if (_T_144) begin
          rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
        end else if (_T_179) begin
          if (_T_144) begin
            rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
          end else if (_T_173) begin
            if (_T_144) begin
              rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
            end else if (_T_167) begin
              if (_T_144) begin
                rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
              end else if (_T_161) begin
                if (_T_144) begin
                  rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                end else if (_T_155) begin
                  if (_T_144) begin
                    rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                  end else if (_T_149) begin
                    if (_T_144) begin
                      rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                    end else if (_T_143) begin
                      if (_T_144) begin
                        rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                      end else if (_T_71) begin
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
                    end else if (_T_71) begin
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
                  end else if (_T_143) begin
                    if (_T_144) begin
                      rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                    end else if (_T_71) begin
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
                  end else if (_T_71) begin
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
                end else if (_T_149) begin
                  if (_T_144) begin
                    rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                  end else if (_T_143) begin
                    if (_T_144) begin
                      rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                    end else begin
                      rb_entries_0_request_operands_0_value <= _GEN_1721;
                    end
                  end else begin
                    rb_entries_0_request_operands_0_value <= _GEN_1721;
                  end
                end else if (_T_143) begin
                  if (_T_144) begin
                    rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                  end else begin
                    rb_entries_0_request_operands_0_value <= _GEN_1721;
                  end
                end else begin
                  rb_entries_0_request_operands_0_value <= _GEN_1721;
                end
              end else if (_T_155) begin
                if (_T_144) begin
                  rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                end else if (_T_149) begin
                  if (_T_144) begin
                    rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                  end else begin
                    rb_entries_0_request_operands_0_value <= _GEN_12857;
                  end
                end else begin
                  rb_entries_0_request_operands_0_value <= _GEN_12857;
                end
              end else if (_T_149) begin
                if (_T_144) begin
                  rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                end else begin
                  rb_entries_0_request_operands_0_value <= _GEN_12857;
                end
              end else begin
                rb_entries_0_request_operands_0_value <= _GEN_12857;
              end
            end else if (_T_161) begin
              if (_T_144) begin
                rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
              end else if (_T_155) begin
                if (_T_144) begin
                  rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
                end else begin
                  rb_entries_0_request_operands_0_value <= _GEN_12869;
                end
              end else begin
                rb_entries_0_request_operands_0_value <= _GEN_12869;
              end
            end else if (_T_155) begin
              if (_T_144) begin
                rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
              end else begin
                rb_entries_0_request_operands_0_value <= _GEN_12869;
              end
            end else begin
              rb_entries_0_request_operands_0_value <= _GEN_12869;
            end
          end else if (_T_167) begin
            if (_T_144) begin
              rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
            end else if (_T_161) begin
              if (_T_144) begin
                rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
              end else begin
                rb_entries_0_request_operands_0_value <= _GEN_12881;
              end
            end else begin
              rb_entries_0_request_operands_0_value <= _GEN_12881;
            end
          end else if (_T_161) begin
            if (_T_144) begin
              rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
            end else begin
              rb_entries_0_request_operands_0_value <= _GEN_12881;
            end
          end else begin
            rb_entries_0_request_operands_0_value <= _GEN_12881;
          end
        end else if (_T_173) begin
          if (_T_144) begin
            rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
          end else if (_T_167) begin
            if (_T_144) begin
              rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
            end else begin
              rb_entries_0_request_operands_0_value <= _GEN_12893;
            end
          end else begin
            rb_entries_0_request_operands_0_value <= _GEN_12893;
          end
        end else if (_T_167) begin
          if (_T_144) begin
            rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
          end else begin
            rb_entries_0_request_operands_0_value <= _GEN_12893;
          end
        end else begin
          rb_entries_0_request_operands_0_value <= _GEN_12893;
        end
      end else if (_T_179) begin
        if (_T_144) begin
          rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
        end else if (_T_173) begin
          if (_T_144) begin
            rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
          end else begin
            rb_entries_0_request_operands_0_value <= _GEN_12905;
          end
        end else begin
          rb_entries_0_request_operands_0_value <= _GEN_12905;
        end
      end else if (_T_173) begin
        if (_T_144) begin
          rb_entries_0_request_operands_0_value <= io_op_mem_read_data;
        end else begin
          rb_entries_0_request_operands_0_value <= _GEN_12905;
        end
      end else begin
        rb_entries_0_request_operands_0_value <= _GEN_12905;
      end
    end else begin
      rb_entries_0_request_operands_0_value <= _GEN_1721;
    end
    if (io_op_mem_read_resp_valid) begin
      if (_T_143) begin
        if (_T_144) begin
          rb_entries_0_request_operands_0_mode <= 2'h0;
        end else if (_T_71) begin
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
      end else if (_T_71) begin
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
    end else if (_T_71) begin
      if (_GEN_1455) begin
        rb_entries_0_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_0_mode <= _GEN_490;
      end
    end else begin
      rb_entries_0_request_operands_0_mode <= _GEN_490;
    end
    if (_T_74) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_145) begin
        if (_T_146) begin
          rb_entries_0_request_operands_1_mode <= 2'h0;
        end else if (_T_74) begin
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
      end else if (_T_74) begin
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
    end else if (_T_74) begin
      if (_GEN_1939) begin
        rb_entries_0_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_1_mode <= _GEN_506;
      end
    end else begin
      rb_entries_0_request_operands_1_mode <= _GEN_506;
    end
    if (_T_77) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_147) begin
        if (_T_148) begin
          rb_entries_0_request_operands_2_mode <= 2'h0;
        end else if (_T_77) begin
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
      end else if (_T_77) begin
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
    end else if (_T_77) begin
      if (_GEN_2423) begin
        rb_entries_0_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_0_request_operands_2_mode <= _GEN_522;
      end
    end else begin
      rb_entries_0_request_operands_2_mode <= _GEN_522;
    end
    if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_request_inst <= io_request_bits_inst;
      end
    end
    if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_request_mode <= io_request_bits_mode;
      end
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_0 <= _T_335[0];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_1 <= _T_335[1];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_0_request_inFetch_2 <= _T_335[2];
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      if (3'h0 == result_idx) begin
        rb_entries_0_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h0 == value) begin
          rb_entries_0_result_out <= 64'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h0 == value) begin
        rb_entries_0_result_out <= 64'h0;
      end
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      rb_entries_1_completed <= _GEN_1167;
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_completed <= 1'h0;
      end
    end
    if (wbCountOn) begin
      rb_entries_1_written <= _GEN_854;
    end else if (wbCountOn) begin
      rb_entries_1_written <= _GEN_837;
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_written <= 1'h0;
      end
    end
    if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (_T_80) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_149) begin
        if (_T_144) begin
          rb_entries_1_request_operands_0_mode <= 2'h0;
        end else if (_T_80) begin
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
      end else if (_T_80) begin
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
    end else if (_T_80) begin
      if (_GEN_2907) begin
        rb_entries_1_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_0_mode <= _GEN_491;
      end
    end else begin
      rb_entries_1_request_operands_0_mode <= _GEN_491;
    end
    if (io_op_mem_read_resp_valid) begin
      if (_T_187) begin
        if (_T_146) begin
          rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
        end else if (_T_181) begin
          if (_T_146) begin
            rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
          end else if (_T_175) begin
            if (_T_146) begin
              rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
            end else if (_T_169) begin
              if (_T_146) begin
                rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
              end else if (_T_163) begin
                if (_T_146) begin
                  rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                end else if (_T_157) begin
                  if (_T_146) begin
                    rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                  end else if (_T_151) begin
                    if (_T_146) begin
                      rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                    end else if (_T_145) begin
                      if (_T_146) begin
                        rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                      end else if (_T_83) begin
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
                    end else if (_T_83) begin
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
                  end else if (_T_145) begin
                    if (_T_146) begin
                      rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                    end else if (_T_83) begin
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
                  end else if (_T_83) begin
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
                end else if (_T_151) begin
                  if (_T_146) begin
                    rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                  end else if (_T_145) begin
                    if (_T_146) begin
                      rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                    end else begin
                      rb_entries_1_request_operands_1_value <= _GEN_3657;
                    end
                  end else begin
                    rb_entries_1_request_operands_1_value <= _GEN_3657;
                  end
                end else if (_T_145) begin
                  if (_T_146) begin
                    rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                  end else begin
                    rb_entries_1_request_operands_1_value <= _GEN_3657;
                  end
                end else begin
                  rb_entries_1_request_operands_1_value <= _GEN_3657;
                end
              end else if (_T_157) begin
                if (_T_146) begin
                  rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                end else if (_T_151) begin
                  if (_T_146) begin
                    rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                  end else begin
                    rb_entries_1_request_operands_1_value <= _GEN_12861;
                  end
                end else begin
                  rb_entries_1_request_operands_1_value <= _GEN_12861;
                end
              end else if (_T_151) begin
                if (_T_146) begin
                  rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                end else begin
                  rb_entries_1_request_operands_1_value <= _GEN_12861;
                end
              end else begin
                rb_entries_1_request_operands_1_value <= _GEN_12861;
              end
            end else if (_T_163) begin
              if (_T_146) begin
                rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
              end else if (_T_157) begin
                if (_T_146) begin
                  rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
                end else begin
                  rb_entries_1_request_operands_1_value <= _GEN_12873;
                end
              end else begin
                rb_entries_1_request_operands_1_value <= _GEN_12873;
              end
            end else if (_T_157) begin
              if (_T_146) begin
                rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
              end else begin
                rb_entries_1_request_operands_1_value <= _GEN_12873;
              end
            end else begin
              rb_entries_1_request_operands_1_value <= _GEN_12873;
            end
          end else if (_T_169) begin
            if (_T_146) begin
              rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
            end else if (_T_163) begin
              if (_T_146) begin
                rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
              end else begin
                rb_entries_1_request_operands_1_value <= _GEN_12885;
              end
            end else begin
              rb_entries_1_request_operands_1_value <= _GEN_12885;
            end
          end else if (_T_163) begin
            if (_T_146) begin
              rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
            end else begin
              rb_entries_1_request_operands_1_value <= _GEN_12885;
            end
          end else begin
            rb_entries_1_request_operands_1_value <= _GEN_12885;
          end
        end else if (_T_175) begin
          if (_T_146) begin
            rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
          end else if (_T_169) begin
            if (_T_146) begin
              rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
            end else begin
              rb_entries_1_request_operands_1_value <= _GEN_12897;
            end
          end else begin
            rb_entries_1_request_operands_1_value <= _GEN_12897;
          end
        end else if (_T_169) begin
          if (_T_146) begin
            rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
          end else begin
            rb_entries_1_request_operands_1_value <= _GEN_12897;
          end
        end else begin
          rb_entries_1_request_operands_1_value <= _GEN_12897;
        end
      end else if (_T_181) begin
        if (_T_146) begin
          rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
        end else if (_T_175) begin
          if (_T_146) begin
            rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
          end else begin
            rb_entries_1_request_operands_1_value <= _GEN_12909;
          end
        end else begin
          rb_entries_1_request_operands_1_value <= _GEN_12909;
        end
      end else if (_T_175) begin
        if (_T_146) begin
          rb_entries_1_request_operands_1_value <= io_op_mem_read_data;
        end else begin
          rb_entries_1_request_operands_1_value <= _GEN_12909;
        end
      end else begin
        rb_entries_1_request_operands_1_value <= _GEN_12909;
      end
    end else begin
      rb_entries_1_request_operands_1_value <= _GEN_3657;
    end
    if (io_op_mem_read_resp_valid) begin
      if (_T_151) begin
        if (_T_146) begin
          rb_entries_1_request_operands_1_mode <= 2'h0;
        end else if (_T_83) begin
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
      end else if (_T_83) begin
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
    end else if (_T_83) begin
      if (_GEN_3391) begin
        rb_entries_1_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_1_mode <= _GEN_507;
      end
    end else begin
      rb_entries_1_request_operands_1_mode <= _GEN_507;
    end
    if (_T_86) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_153) begin
        if (_T_148) begin
          rb_entries_1_request_operands_2_mode <= 2'h0;
        end else if (_T_86) begin
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
      end else if (_T_86) begin
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
    end else if (_T_86) begin
      if (_GEN_3875) begin
        rb_entries_1_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_1_request_operands_2_mode <= _GEN_523;
      end
    end else begin
      rb_entries_1_request_operands_2_mode <= _GEN_523;
    end
    if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_request_inst <= io_request_bits_inst;
      end
    end
    if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_request_mode <= io_request_bits_mode;
      end
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_0 <= _T_335[3];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_1 <= _T_335[4];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_1_request_inFetch_2 <= _T_335[5];
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      if (3'h1 == result_idx) begin
        rb_entries_1_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h1 == value) begin
          rb_entries_1_result_out <= 64'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h1 == value) begin
        rb_entries_1_result_out <= 64'h0;
      end
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      rb_entries_2_completed <= _GEN_1168;
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_completed <= 1'h0;
      end
    end
    if (wbCountOn) begin
      rb_entries_2_written <= _GEN_855;
    end else if (wbCountOn) begin
      rb_entries_2_written <= _GEN_838;
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_written <= 1'h0;
      end
    end
    if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (_T_89) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_155) begin
        if (_T_144) begin
          rb_entries_2_request_operands_0_mode <= 2'h0;
        end else if (_T_89) begin
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
      end else if (_T_89) begin
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
    end else if (_T_89) begin
      if (_GEN_4359) begin
        rb_entries_2_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_0_mode <= _GEN_492;
      end
    end else begin
      rb_entries_2_request_operands_0_mode <= _GEN_492;
    end
    if (_T_92) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_157) begin
        if (_T_146) begin
          rb_entries_2_request_operands_1_mode <= 2'h0;
        end else if (_T_92) begin
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
      end else if (_T_92) begin
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
    end else if (_T_92) begin
      if (_GEN_4843) begin
        rb_entries_2_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_1_mode <= _GEN_508;
      end
    end else begin
      rb_entries_2_request_operands_1_mode <= _GEN_508;
    end
    if (io_op_mem_read_resp_valid) begin
      if (_T_189) begin
        if (_T_148) begin
          rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
        end else if (_T_183) begin
          if (_T_148) begin
            rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
          end else if (_T_177) begin
            if (_T_148) begin
              rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
            end else if (_T_171) begin
              if (_T_148) begin
                rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
              end else if (_T_165) begin
                if (_T_148) begin
                  rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                end else if (_T_159) begin
                  if (_T_148) begin
                    rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                  end else if (_T_153) begin
                    if (_T_148) begin
                      rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                    end else if (_T_147) begin
                      if (_T_148) begin
                        rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                      end else if (_T_95) begin
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
                    end else if (_T_95) begin
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
                  end else if (_T_147) begin
                    if (_T_148) begin
                      rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                    end else if (_T_95) begin
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
                  end else if (_T_95) begin
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
                end else if (_T_153) begin
                  if (_T_148) begin
                    rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                  end else if (_T_147) begin
                    if (_T_148) begin
                      rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                    end else begin
                      rb_entries_2_request_operands_2_value <= _GEN_5593;
                    end
                  end else begin
                    rb_entries_2_request_operands_2_value <= _GEN_5593;
                  end
                end else if (_T_147) begin
                  if (_T_148) begin
                    rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                  end else begin
                    rb_entries_2_request_operands_2_value <= _GEN_5593;
                  end
                end else begin
                  rb_entries_2_request_operands_2_value <= _GEN_5593;
                end
              end else if (_T_159) begin
                if (_T_148) begin
                  rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                end else if (_T_153) begin
                  if (_T_148) begin
                    rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                  end else begin
                    rb_entries_2_request_operands_2_value <= _GEN_12865;
                  end
                end else begin
                  rb_entries_2_request_operands_2_value <= _GEN_12865;
                end
              end else if (_T_153) begin
                if (_T_148) begin
                  rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                end else begin
                  rb_entries_2_request_operands_2_value <= _GEN_12865;
                end
              end else begin
                rb_entries_2_request_operands_2_value <= _GEN_12865;
              end
            end else if (_T_165) begin
              if (_T_148) begin
                rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
              end else if (_T_159) begin
                if (_T_148) begin
                  rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
                end else begin
                  rb_entries_2_request_operands_2_value <= _GEN_12877;
                end
              end else begin
                rb_entries_2_request_operands_2_value <= _GEN_12877;
              end
            end else if (_T_159) begin
              if (_T_148) begin
                rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
              end else begin
                rb_entries_2_request_operands_2_value <= _GEN_12877;
              end
            end else begin
              rb_entries_2_request_operands_2_value <= _GEN_12877;
            end
          end else if (_T_171) begin
            if (_T_148) begin
              rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
            end else if (_T_165) begin
              if (_T_148) begin
                rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
              end else begin
                rb_entries_2_request_operands_2_value <= _GEN_12889;
              end
            end else begin
              rb_entries_2_request_operands_2_value <= _GEN_12889;
            end
          end else if (_T_165) begin
            if (_T_148) begin
              rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
            end else begin
              rb_entries_2_request_operands_2_value <= _GEN_12889;
            end
          end else begin
            rb_entries_2_request_operands_2_value <= _GEN_12889;
          end
        end else if (_T_177) begin
          if (_T_148) begin
            rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
          end else if (_T_171) begin
            if (_T_148) begin
              rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
            end else begin
              rb_entries_2_request_operands_2_value <= _GEN_12901;
            end
          end else begin
            rb_entries_2_request_operands_2_value <= _GEN_12901;
          end
        end else if (_T_171) begin
          if (_T_148) begin
            rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
          end else begin
            rb_entries_2_request_operands_2_value <= _GEN_12901;
          end
        end else begin
          rb_entries_2_request_operands_2_value <= _GEN_12901;
        end
      end else if (_T_183) begin
        if (_T_148) begin
          rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
        end else if (_T_177) begin
          if (_T_148) begin
            rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
          end else begin
            rb_entries_2_request_operands_2_value <= _GEN_12913;
          end
        end else begin
          rb_entries_2_request_operands_2_value <= _GEN_12913;
        end
      end else if (_T_177) begin
        if (_T_148) begin
          rb_entries_2_request_operands_2_value <= io_op_mem_read_data;
        end else begin
          rb_entries_2_request_operands_2_value <= _GEN_12913;
        end
      end else begin
        rb_entries_2_request_operands_2_value <= _GEN_12913;
      end
    end else begin
      rb_entries_2_request_operands_2_value <= _GEN_5593;
    end
    if (io_op_mem_read_resp_valid) begin
      if (_T_159) begin
        if (_T_148) begin
          rb_entries_2_request_operands_2_mode <= 2'h0;
        end else if (_T_95) begin
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
      end else if (_T_95) begin
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
    end else if (_T_95) begin
      if (_GEN_5327) begin
        rb_entries_2_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_2_request_operands_2_mode <= _GEN_524;
      end
    end else begin
      rb_entries_2_request_operands_2_mode <= _GEN_524;
    end
    if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_request_inst <= io_request_bits_inst;
      end
    end
    if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_request_mode <= io_request_bits_mode;
      end
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_0 <= _T_335[6];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_1 <= _T_335[7];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_2_request_inFetch_2 <= _T_335[8];
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      if (3'h2 == result_idx) begin
        rb_entries_2_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h2 == value) begin
          rb_entries_2_result_out <= 64'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h2 == value) begin
        rb_entries_2_result_out <= 64'h0;
      end
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      rb_entries_3_completed <= _GEN_1169;
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_completed <= 1'h0;
      end
    end
    if (wbCountOn) begin
      rb_entries_3_written <= _GEN_856;
    end else if (wbCountOn) begin
      rb_entries_3_written <= _GEN_839;
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_written <= 1'h0;
      end
    end
    if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (_T_98) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_161) begin
        if (_T_144) begin
          rb_entries_3_request_operands_0_mode <= 2'h0;
        end else if (_T_98) begin
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
      end else if (_T_98) begin
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
    end else if (_T_98) begin
      if (_GEN_5811) begin
        rb_entries_3_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_0_mode <= _GEN_493;
      end
    end else begin
      rb_entries_3_request_operands_0_mode <= _GEN_493;
    end
    if (_T_101) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_163) begin
        if (_T_146) begin
          rb_entries_3_request_operands_1_mode <= 2'h0;
        end else if (_T_101) begin
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
      end else if (_T_101) begin
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
    end else if (_T_101) begin
      if (_GEN_6295) begin
        rb_entries_3_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_1_mode <= _GEN_509;
      end
    end else begin
      rb_entries_3_request_operands_1_mode <= _GEN_509;
    end
    if (_T_104) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_165) begin
        if (_T_148) begin
          rb_entries_3_request_operands_2_mode <= 2'h0;
        end else if (_T_104) begin
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
      end else if (_T_104) begin
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
    end else if (_T_104) begin
      if (_GEN_6779) begin
        rb_entries_3_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_3_request_operands_2_mode <= _GEN_525;
      end
    end else begin
      rb_entries_3_request_operands_2_mode <= _GEN_525;
    end
    if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_request_inst <= io_request_bits_inst;
      end
    end
    if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_request_mode <= io_request_bits_mode;
      end
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_0 <= _T_335[9];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_1 <= _T_335[10];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_3_request_inFetch_2 <= _T_335[11];
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      if (3'h3 == result_idx) begin
        rb_entries_3_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h3 == value) begin
          rb_entries_3_result_out <= 64'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h3 == value) begin
        rb_entries_3_result_out <= 64'h0;
      end
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      rb_entries_4_completed <= _GEN_1170;
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_completed <= 1'h0;
      end
    end
    if (wbCountOn) begin
      rb_entries_4_written <= _GEN_857;
    end else if (wbCountOn) begin
      rb_entries_4_written <= _GEN_840;
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_written <= 1'h0;
      end
    end
    if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (_T_107) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_167) begin
        if (_T_144) begin
          rb_entries_4_request_operands_0_mode <= 2'h0;
        end else if (_T_107) begin
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
      end else if (_T_107) begin
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
    end else if (_T_107) begin
      if (_GEN_7263) begin
        rb_entries_4_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_0_mode <= _GEN_494;
      end
    end else begin
      rb_entries_4_request_operands_0_mode <= _GEN_494;
    end
    if (_T_110) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_169) begin
        if (_T_146) begin
          rb_entries_4_request_operands_1_mode <= 2'h0;
        end else if (_T_110) begin
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
      end else if (_T_110) begin
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
    end else if (_T_110) begin
      if (_GEN_7747) begin
        rb_entries_4_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_1_mode <= _GEN_510;
      end
    end else begin
      rb_entries_4_request_operands_1_mode <= _GEN_510;
    end
    if (_T_113) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_171) begin
        if (_T_148) begin
          rb_entries_4_request_operands_2_mode <= 2'h0;
        end else if (_T_113) begin
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
      end else if (_T_113) begin
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
    end else if (_T_113) begin
      if (_GEN_8231) begin
        rb_entries_4_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_4_request_operands_2_mode <= _GEN_526;
      end
    end else begin
      rb_entries_4_request_operands_2_mode <= _GEN_526;
    end
    if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_request_inst <= io_request_bits_inst;
      end
    end
    if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_request_mode <= io_request_bits_mode;
      end
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_0 <= _T_335[12];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_1 <= _T_335[13];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_4_request_inFetch_2 <= _T_335[14];
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      if (3'h4 == result_idx) begin
        rb_entries_4_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h4 == value) begin
          rb_entries_4_result_out <= 64'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h4 == value) begin
        rb_entries_4_result_out <= 64'h0;
      end
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      rb_entries_5_completed <= _GEN_1171;
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_completed <= 1'h0;
      end
    end
    if (wbCountOn) begin
      rb_entries_5_written <= _GEN_858;
    end else if (wbCountOn) begin
      rb_entries_5_written <= _GEN_841;
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_written <= 1'h0;
      end
    end
    if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (_T_116) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_173) begin
        if (_T_144) begin
          rb_entries_5_request_operands_0_mode <= 2'h0;
        end else if (_T_116) begin
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
      end else if (_T_116) begin
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
    end else if (_T_116) begin
      if (_GEN_8715) begin
        rb_entries_5_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_0_mode <= _GEN_495;
      end
    end else begin
      rb_entries_5_request_operands_0_mode <= _GEN_495;
    end
    if (_T_119) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_175) begin
        if (_T_146) begin
          rb_entries_5_request_operands_1_mode <= 2'h0;
        end else if (_T_119) begin
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
      end else if (_T_119) begin
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
    end else if (_T_119) begin
      if (_GEN_9199) begin
        rb_entries_5_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_1_mode <= _GEN_511;
      end
    end else begin
      rb_entries_5_request_operands_1_mode <= _GEN_511;
    end
    if (_T_122) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_177) begin
        if (_T_148) begin
          rb_entries_5_request_operands_2_mode <= 2'h0;
        end else if (_T_122) begin
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
      end else if (_T_122) begin
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
    end else if (_T_122) begin
      if (_GEN_9683) begin
        rb_entries_5_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_5_request_operands_2_mode <= _GEN_527;
      end
    end else begin
      rb_entries_5_request_operands_2_mode <= _GEN_527;
    end
    if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_request_inst <= io_request_bits_inst;
      end
    end
    if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_request_mode <= io_request_bits_mode;
      end
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_0 <= _T_335[15];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_1 <= _T_335[16];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_5_request_inFetch_2 <= _T_335[17];
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      if (3'h5 == result_idx) begin
        rb_entries_5_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h5 == value) begin
          rb_entries_5_result_out <= 64'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h5 == value) begin
        rb_entries_5_result_out <= 64'h0;
      end
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      rb_entries_6_completed <= _GEN_1172;
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_completed <= 1'h0;
      end
    end
    if (wbCountOn) begin
      rb_entries_6_written <= _GEN_859;
    end else if (wbCountOn) begin
      rb_entries_6_written <= _GEN_842;
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_written <= 1'h0;
      end
    end
    if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (_T_125) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_179) begin
        if (_T_144) begin
          rb_entries_6_request_operands_0_mode <= 2'h0;
        end else if (_T_125) begin
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
      end else if (_T_125) begin
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
    end else if (_T_125) begin
      if (_GEN_10167) begin
        rb_entries_6_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_0_mode <= _GEN_496;
      end
    end else begin
      rb_entries_6_request_operands_0_mode <= _GEN_496;
    end
    if (_T_128) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_181) begin
        if (_T_146) begin
          rb_entries_6_request_operands_1_mode <= 2'h0;
        end else if (_T_128) begin
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
      end else if (_T_128) begin
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
    end else if (_T_128) begin
      if (_GEN_10651) begin
        rb_entries_6_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_1_mode <= _GEN_512;
      end
    end else begin
      rb_entries_6_request_operands_1_mode <= _GEN_512;
    end
    if (_T_131) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_183) begin
        if (_T_148) begin
          rb_entries_6_request_operands_2_mode <= 2'h0;
        end else if (_T_131) begin
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
      end else if (_T_131) begin
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
    end else if (_T_131) begin
      if (_GEN_11135) begin
        rb_entries_6_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_6_request_operands_2_mode <= _GEN_528;
      end
    end else begin
      rb_entries_6_request_operands_2_mode <= _GEN_528;
    end
    if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_request_inst <= io_request_bits_inst;
      end
    end
    if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_request_mode <= io_request_bits_mode;
      end
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_0 <= _T_335[18];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_1 <= _T_335[19];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_6_request_inFetch_2 <= _T_335[20];
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      if (3'h6 == result_idx) begin
        rb_entries_6_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h6 == value) begin
          rb_entries_6_result_out <= 64'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h6 == value) begin
        rb_entries_6_result_out <= 64'h0;
      end
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      rb_entries_7_completed <= _GEN_1173;
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_completed <= 1'h0;
      end
    end
    if (wbCountOn) begin
      rb_entries_7_written <= _GEN_860;
    end else if (wbCountOn) begin
      rb_entries_7_written <= _GEN_843;
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_written <= 1'h0;
      end
    end
    if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_wr_addr <= io_request_bits_wr_addr;
      end
    end
    if (_T_134) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_185) begin
        if (_T_144) begin
          rb_entries_7_request_operands_0_mode <= 2'h0;
        end else if (_T_134) begin
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
      end else if (_T_134) begin
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
    end else if (_T_134) begin
      if (_GEN_11619) begin
        rb_entries_7_request_operands_0_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_0_mode <= _GEN_497;
      end
    end else begin
      rb_entries_7_request_operands_0_mode <= _GEN_497;
    end
    if (_T_137) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_187) begin
        if (_T_146) begin
          rb_entries_7_request_operands_1_mode <= 2'h0;
        end else if (_T_137) begin
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
      end else if (_T_137) begin
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
    end else if (_T_137) begin
      if (_GEN_12103) begin
        rb_entries_7_request_operands_1_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_1_mode <= _GEN_513;
      end
    end else begin
      rb_entries_7_request_operands_1_mode <= _GEN_513;
    end
    if (_T_140) begin
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
    if (io_op_mem_read_resp_valid) begin
      if (_T_189) begin
        if (_T_148) begin
          rb_entries_7_request_operands_2_mode <= 2'h0;
        end else if (_T_140) begin
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
      end else if (_T_140) begin
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
    end else if (_T_140) begin
      if (_GEN_12587) begin
        rb_entries_7_request_operands_2_mode <= 2'h0;
      end else begin
        rb_entries_7_request_operands_2_mode <= _GEN_529;
      end
    end else begin
      rb_entries_7_request_operands_2_mode <= _GEN_529;
    end
    if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_request_inst <= io_request_bits_inst;
      end
    end
    if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_request_mode <= io_request_bits_mode;
      end
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_0 <= _T_335[21];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_1 <= _T_335[22];
    end
    if (fetchArb_io_hasChosen) begin
      rb_entries_7_request_inFetch_2 <= _T_335[23];
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
      if (3'h7 == result_idx) begin
        rb_entries_7_result_out <= _rb_entries_result_idx_result_out;
      end else if (new_input_log) begin
        if (3'h7 == value) begin
          rb_entries_7_result_out <= 64'h0;
        end
      end
    end else if (new_input_log) begin
      if (3'h7 == value) begin
        rb_entries_7_result_out <= 64'h0;
      end
    end
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
    if (_T_70) begin
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
      value <= _T_3;
    end
    if (reset) begin
      value_1 <= 3'h0;
    end else if (wbCountOn) begin
      value_1 <= _T_11;
    end
  end
endmodule
