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
class PositRequest(nbits: Int, es: Int) extends Bundle{
	val num1 = Input(UInt(nbits.W))
	val num2 = Input(UInt(nbits.W))
	val num3 = Input(UInt(nbits.W))
	val inst = Input(UInt(3.W))
	val mode = Input(UInt(2.W))
}

class PositResult(nbits: Int, es: Int) extends Bundle{
	val isZero = Output(Bool())
	val isNaR  = Output(Bool())
	val out    = Output(UInt(nbits.W))
	val lt = Output(Bool())
	val eq = Output(Bool())
	val gt = Output(Bool())
	val exceptions    = Output(UInt(5.W))
}


class PositInterface(nbits: Int, es: Int) extends Bundle{
	val request = Flipped(DecoupledIO(new PositRequest(nbits, es)))
	val result = Decoupled(new PositResult(nbits, es))

}

class Posit(nbits: Int, es: Int) extends Module {

  val io = IO(new PositInterface(nbits, es))

	io.request.ready := io.result.ready && positDivSqrtCore.io.readyIn

	val positAddCore = Module(new PositAddCore(nbits, es))
	val positCompare = Module(new PositCompare(nbits,es))
	val positFMACore = Module(new PositFMACore(nbits, es))
	val positDivSqrtCore = Module(new PositDivSqrtCore(nbits, es))
	val positMulCore = Module(new PositMulCore(nbits, es))

	val init_num1 = Reg(UInt(nbits.W))
	val init_num2 = Reg(UInt(nbits.W))
	val init_num3 = Reg(UInt(nbits.W))
	val init_input_valid = Reg(Bool())
	val init_inst = Reg(UInt(3.W))
	val init_mode = Reg(UInt(2.W))
	val init_valid = Reg(Bool())
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

	val exec_num1 = Reg(unpackedPosit(nbits, es))
	val exec_num2 = Reg(unpackedPosit(nbits, es))
	val exec_num3 = Reg(unpackedPosit(nbits, es))
	val exec_input_valid = Reg(Bool())
	val exec_inst = Reg(UInt(3.W))
	val exec_mode = Reg(UInt(2.W))
	val exec_valid = Reg(Bool())
	when(io.result.ready && positDivSqrtCore.io.readyIn){
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

	positCompare.io.num1 := exec_num1
	positCompare.io.num2 := exec_num2

	positFMACore.io.num1 := exec_num1
	positFMACore.io.num2 := exec_num2
	positFMACore.io.sub := exec_mode(0)
	positFMACore.io.neg := exec_mode(1)

	positDivSqrtCore.io.num1 := exec_num1
	positDivSqrtCore.io.num2 := exec_num2
	positDivSqrtCore.io.sqrtOp := exec_mode(0)
	positDivSqrtCore.io.validIn := exec_valid

	positMulCore.io.num1 := exec_num1
	positMulCore.io.num2 := exec_num2

	val result_out = Reg(unpackedPosit(nbits, es))
	val result_stickyBit = Reg(unpackedPosit(nbits, es))
	val result_trailingBits = Reg(unpackedPosit(nbits, es))
	val result_valid = Reg(Bool())
	val result_lt = Reg(Bool())
	val result_eq = Reg(Bool())
	val result_gt = Reg(Bool())


	when(io.output_ready && positDivSqrtCore.io.readyIn){
		result_out := MuxLookup( inst, 0.U, Array(
				Instruction.addsub -> positAddCore.out,
				Instruction.fma -> positFMACore.out,
				Instruction.mul -> positMulCore.out,
				Instruction.sqrtdiv -> positDivSqrtCore.out
			)
		)

		result_stickyBit := MuxLookup( exec_inst, 0.U, Array(
				Instruction.addsub -> positAddCore.stickyBit,
				Instruction.fma -> positFMACore.stickyBit,
				Instruction.mul -> positMulCore.stickyBit,
				Instruction.sqrtdiv -> positDivSqrtCore.stickyBit
			)
		)

		result_trailingBits := MuxLookup( exec_inst, 0.U, Array(
				Instruction.addsub -> positAddCore.trailingBits,
				Instruction.fma -> positFMACore.trailingBits,
				Instruction.mul -> positMulCore.trailingBits,
				Instruction.sqrtdiv -> positDivSqrtCore.trailingBits
			)
		)
		result_lt := positCompare.lt
		result_eq := positCompare.eq
		result_gt := positCompare.gt
		result_valid := 
			(exec_valid && (exec_inst =/= Instruction.sqrtdiv)) 
				| positDivSqrtCore.io.validOut_div
				| positDivSqrtCore.io.validOut_sqrt
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