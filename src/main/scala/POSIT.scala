package hardposit

import chisel3._
import chisel3.util._

// first two bits are for which module
object Instruction{
	val none = 0.U(3.W)
	val addsub = 1.U(3.W)
	val cmp = 2.U(3.W)
	val fma = 3.U(3.W)
	val mul = 4.U(3.W)
	val sqrtdiv = 5.U(3.W)
}
class PositRequest(val nbits: Int, val es: Int)  extends Bundle{
	val num1 = UInt(nbits.W)
	val num2 = UInt(nbits.W)
	val num3 = UInt(nbits.W)
	val inst = UInt(3.W)
	val mode = UInt(2.W)
}

class PositResult(val nbits: Int, val es: Int)  extends Bundle{
	val isZero = Bool()
	val isNaR  = Bool()
	val out    = UInt(nbits.W)
	val lt = Bool()
	val eq = Bool()
	val gt = Bool()
	val exceptions    = UInt(5.W)
}


class PositInterface(val nbits: Int, val es: Int) extends Bundle{
	val request = Flipped(DecoupledIO(new PositRequest(nbits, es)))
	val result = Decoupled(new PositResult(nbits, es))

}

class Posit(val nbits: Int, val es: Int) extends Module with HasHardPositParams {

  val io = IO(new PositInterface(nbits, es))
	val positAddCore = Module(new PositAddCore(nbits, es))
	val positCompare = Module(new PositCompare(nbits,es))
	val positFMACore = Module(new PositFMACore(nbits, es))
	val positDivSqrtCore = Module(new PositDivSqrtCore(nbits, es))
	val positMulCore = Module(new PositMulCore(nbits, es))

	io.request.ready := io.result.ready && positDivSqrtCore.io.readyIn

	val init_num1 = RegInit(UInt(nbits.W), 0.U)
	val init_num2 = RegInit(UInt(nbits.W), 0.U)
	val init_num3 = RegInit(UInt(nbits.W), 0.U)
	val init_input_valid = RegInit(Bool(), false.B)
	val init_inst = RegInit(UInt(3.W), 0.U)
	val init_mode = RegInit(UInt(2.W), 0.U)
	val init_valid = RegInit(Bool(), false.B)
	when(io.result.ready && positDivSqrtCore.io.readyIn){
		init_num1 := io.request.bits.num1
		init_num2 := io.request.bits.num2
		init_num3 := io.request.bits.num3
		init_valid := io.request.valid
		init_inst := io.request.bits.inst
		init_mode := io.request.bits.mode
	}
	val num1Extractor = Module(new PositExtractor(nbits, es))
	val num2Extractor = Module(new PositExtractor(nbits, es))
	val num3Extractor = Module(new PositExtractor(nbits, es))
	num1Extractor.io.in := init_num1
	num2Extractor.io.in := init_num2
	num3Extractor.io.in := init_num3

	val exec_num1 = RegInit(new unpackedPosit(nbits, es), 0.U.asTypeOf(new unpackedPosit(nbits, es)))
	val exec_num2 = RegInit(new unpackedPosit(nbits, es), 0.U.asTypeOf(new unpackedPosit(nbits, es)))
	val exec_num3 = RegInit(new unpackedPosit(nbits, es), 0.U.asTypeOf(new unpackedPosit(nbits, es)))
	val comp_num1 = RegInit(UInt(nbits.W), 0.U)
	val comp_num2 = RegInit(UInt(nbits.W), 0.U)
	val exec_input_valid = RegInit(Bool(), false.B)
	val exec_inst = RegInit(UInt(3.W), 0.U)
	val exec_mode = RegInit(UInt(2.W), 0.U)
	val exec_valid = RegInit(Bool(), false.B)
	val default_unpacked = Wire(new unpackedPosit(nbits, es))
	default_unpacked .sign := false.B
	default_unpacked.exponent := 0.S
	default_unpacked.fraction := 0.U
	default_unpacked.isZero := false.B
	default_unpacked.isNaR := false.B

	when(io.result.ready && positDivSqrtCore.io.readyIn){
		comp_num1 := init_num1
		comp_num2 := init_num2
		exec_num1 := num1Extractor.io.out
		exec_num2 := num2Extractor.io.out
		exec_num3 := num3Extractor.io.out
		exec_valid := init_valid
		exec_inst := init_inst
		exec_mode := init_mode
	}

	positAddCore.io.num1 := exec_num1
	positAddCore.io.num2 := exec_num2
	positAddCore.io.sub := exec_mode(0)

	positCompare.io.num1 := comp_num1.asSInt
	positCompare.io.num2 := comp_num2.asSInt

	positFMACore.io.num1 := exec_num1
	positFMACore.io.num2 := exec_num2
	positFMACore.io.num3 := exec_num3
	positFMACore.io.sub := exec_mode(0)
	positFMACore.io.negate := exec_mode(1)

	positDivSqrtCore.io.num1 := exec_num1
	positDivSqrtCore.io.num2 := exec_num2
	positDivSqrtCore.io.sqrtOp := exec_mode(0)
	positDivSqrtCore.io.validIn := exec_valid && exec_inst === Instruction.sqrtdiv

	positMulCore.io.num1 := exec_num1
	positMulCore.io.num2 := exec_num2

	val result_out = RegInit(new unpackedPosit(nbits, es), 0.U.asTypeOf(new unpackedPosit(nbits,es)))
	val result_stickyBit = RegInit(Bool(), 0.U)
	val result_trailingBits = RegInit(UInt(trailingBitCount.W), 0.U)
	val result_valid = RegInit(Bool(), false.B)
	val result_lt = RegInit(Bool(), false.B)
	val result_eq = RegInit(Bool(), false.B)
	val result_gt = RegInit(Bool(), false.B)


	when(io.result.ready && positDivSqrtCore.io.readyIn){
		result_out := MuxLookup( exec_inst, default_unpacked, Array(
				Instruction.addsub -> positAddCore.io.out,
				Instruction.fma -> positFMACore.io.out,
				Instruction.mul -> positMulCore.io.out,
				Instruction.sqrtdiv -> positDivSqrtCore.io.out
			)
		)

		result_stickyBit := MuxLookup( exec_inst, 0.B, Array(
				Instruction.addsub -> positAddCore.io.stickyBit,
				Instruction.fma -> positFMACore.io.stickyBit,
				Instruction.mul -> positMulCore.io.stickyBit,
				Instruction.sqrtdiv -> positDivSqrtCore.io.stickyBit
			)
		)

		result_trailingBits := MuxLookup( exec_inst, 0.U, Array(
				Instruction.addsub -> positAddCore.io.trailingBits,
				Instruction.fma -> positFMACore.io.trailingBits,
				Instruction.mul -> positMulCore.io.trailingBits,
				Instruction.sqrtdiv -> positDivSqrtCore.io.trailingBits
			)
		)
		result_lt := positCompare.io.lt
		result_eq := positCompare.io.eq
		result_gt := positCompare.io.gt
		result_valid := (exec_valid && (exec_inst =/= Instruction.sqrtdiv)) | 
			positDivSqrtCore.io.validOut_div | 
			positDivSqrtCore.io.validOut_sqrt
	}

	val positGenerator = Module(new PositGenerator(nbits, es))
	positGenerator.io.in           := result_out
	positGenerator.io.trailingBits := result_trailingBits
	positGenerator.io.stickyBit    := result_stickyBit

	io.result.bits.isZero := result_out.isZero | isZero(positGenerator.io.out)
	io.result.bits.isNaR  := result_out.isNaR  | isNaR(positGenerator.io.out)
	io.result.bits.out    := positGenerator.io.out
	io.result.bits.lt := result_lt
	io.result.bits.eq := result_eq
	io.result.bits.gt := result_gt
	io.result.bits.exceptions := positDivSqrtCore.io.exceptions

	io.result.valid := result_valid
}