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
	val in_idx = Input(UInt(log2Ceil(Params.NumRBEntries).W))
	val out_idx = Output(UInt(log2Ceil(Params.NumRBEntries).W))
}

class Posit(val nbits: Int, val es: Int)(debug: Boolean) extends Module with HasHardPositParams {

  val io = IO(new PositInterface(nbits, es))
	val positAddCore = Module(new PositAddCore(nbits, es))
	val positCompare = Module(new PositCompare(nbits,es))
	val positFMACore = Module(new PositFMACore(nbits, es))
	val positDivSqrtCore = Module(new PositDivSqrtCore(nbits, es))
	val positMulCore = Module(new PositMulCore(nbits, es))


	val init_num1 = RegInit(UInt(nbits.W), 0.U)
	val init_num2 = RegInit(UInt(nbits.W), 0.U)
	val init_num3 = RegInit(UInt(nbits.W), 0.U)
	val init_input_valid = RegInit(Bool(), false.B)
	val init_inst = RegInit(UInt(3.W), 0.U)
	val init_mode = RegInit(UInt(2.W), 0.U)
	val init_valid = RegInit(Bool(), false.B)
	val init_idx = RegInit(UInt(log2Ceil(Params.NumRBEntries).W), 0.U)

	val result_valid = RegInit(Bool(), false.B)
	val exec_valid = RegInit(Bool(), false.B)

	when(io.request.valid && io.request.ready){
		init_num1 := io.request.bits.num1
		init_num2 := io.request.bits.num2
		init_num3 := io.request.bits.num3
		init_valid := io.request.valid
		init_inst := io.request.bits.inst
		init_mode := io.request.bits.mode
		init_idx := io.in_idx
	}.elsewhen((!result_valid) && !exec_valid && init_valid){
		init_valid := false.B
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
	val exec_idx = RegInit(UInt(log2Ceil(Params.NumRBEntries).W), 0.U)
	val dispatched = RegInit(Bool(), false.B)

	val default_unpacked = Wire(new unpackedPosit(nbits, es))

	val result_out = RegInit(new unpackedPosit(nbits, es), 0.U.asTypeOf(new unpackedPosit(nbits,es)))
	val result_stickyBit = RegInit(Bool(), 0.U)
	val result_trailingBits = RegInit(UInt(trailingBitCount.W), 0.U)
	val result_lt = RegInit(Bool(), false.B)
	val result_eq = RegInit(Bool(), false.B)
	val result_gt = RegInit(Bool(), false.B)
	val result_idx = RegInit(UInt(log2Ceil(Params.NumRBEntries).W), 0.U)

	io.request.ready := ~init_valid 
	default_unpacked .sign := false.B
	default_unpacked.exponent := 0.S
	default_unpacked.fraction := 0.U
	default_unpacked.isZero := false.B
	default_unpacked.isNaR := false.B
	val new_result_valid = Wire(Bool())

	when( (!result_valid) && !exec_valid && init_valid){
		comp_num1 := init_num1
		comp_num2 := init_num2
		exec_num1 := num1Extractor.io.out
		exec_num2 := num2Extractor.io.out
		exec_num3 := num3Extractor.io.out
		exec_valid := init_valid
		exec_inst := init_inst
		exec_mode := init_mode
		exec_idx := init_idx
	}.elsewhen(new_result_valid){
		exec_valid := false.B
	}

	when(new_result_valid){
		dispatched := false.B
	}.elsewhen(exec_valid){
		dispatched := true.B
	}

	positAddCore.io.num1 := exec_num1
	positAddCore.io.num2 := exec_num2
	positAddCore.io.sub := exec_mode(0)
	positAddCore.io.input_valid := exec_valid && exec_inst === Instruction.addsub && (!dispatched)

	positCompare.io.num1 := comp_num1.asSInt
	positCompare.io.num2 := comp_num2.asSInt
	positCompare.io.validIn := exec_valid && exec_inst === Instruction.cmp && (!dispatched)

	positFMACore.io.num1 := exec_num1
	positFMACore.io.num2 := exec_num2
	positFMACore.io.num3 := exec_num3
	positFMACore.io.sub := exec_mode(0)
	positFMACore.io.negate := exec_mode(1)
	positFMACore.io.input_valid := exec_valid && exec_inst === Instruction.fma && (!dispatched)


	positDivSqrtCore.io.num1 := exec_num1
	positDivSqrtCore.io.num2 := exec_num2
	positDivSqrtCore.io.sqrtOp := exec_mode(0)
	positDivSqrtCore.io.validIn := exec_valid && exec_inst === Instruction.sqrtdiv && (!dispatched)


	positMulCore.io.num1 := exec_num1
	positMulCore.io.num2 := exec_num2
	positMulCore.io.validIn := exec_valid && exec_inst === Instruction.mul && (!dispatched)


	new_result_valid := positCompare.io.validOut | positMulCore.io.validOut|
			positDivSqrtCore.io.validOut_div | 
			positDivSqrtCore.io.validOut_sqrt | positFMACore.io.output_valid |positAddCore.io.output_valid
	
	when(io.result.ready){
		// if(debug){
		// 	printf("moving from exec to result\n")
		// }
		result_valid := new_result_valid
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
		result_idx := exec_idx
	}


	val positGenerator = Module(new PositGenerator(nbits, es))
	positGenerator.io.in           := result_out
	positGenerator.io.trailingBits := result_trailingBits
	positGenerator.io.stickyBit    := result_stickyBit

	if(debug){
		val positGeneratoraddsub = Module(new PositGenerator(nbits, es))
		val positGeneratorfma = Module(new PositGenerator(nbits, es))
		val positGeneratormul = Module(new PositGenerator(nbits, es))
		val positGeneratorsqrtdiv = Module(new PositGenerator(nbits, es))

		positGeneratoraddsub.io.in           := positAddCore.io.out
		positGeneratoraddsub.io.trailingBits := positAddCore.io.trailingBits
		positGeneratoraddsub.io.stickyBit    := positAddCore.io.stickyBit
	
		positGeneratorfma.io.in           := positFMACore.io.out
		positGeneratorfma.io.trailingBits := positFMACore.io.trailingBits
		positGeneratorfma.io.stickyBit    := positFMACore.io.stickyBit

		positGeneratormul.io.in           := positMulCore.io.out
		positGeneratormul.io.trailingBits := positMulCore.io.trailingBits
		positGeneratormul.io.stickyBit    := positMulCore.io.stickyBit

		positGeneratorsqrtdiv.io.in           := positDivSqrtCore.io.out
		positGeneratorsqrtdiv.io.trailingBits := positDivSqrtCore.io.trailingBits
		positGeneratorsqrtdiv.io.stickyBit    := positDivSqrtCore.io.stickyBit
		// when(result_valid){
		// 	printf("pe result addsub: %b\n", positGeneratoraddsub.io.out)
		// 	printf("pe result fma: %b\n", positGeneratorfma.io.out)
		// 	printf("pe result mul: %b\n", positGeneratormul.io.out)
		// 	printf("pe result sqrtdiv: %b\n", positGeneratorsqrtdiv.io.out)
		// 	printf("pe result: %b\n",positGenerator.io.out)
		// }

	
		when(io.request.valid && io.request.ready){
			printf("Init:\n")
			printf("\tinit_valid: %d\n",io.request.valid)
			printf("\tinit_inst: %d\n",io.request.bits.inst)
			printf("\tidx: %d\n",io.in_idx)

		}.elsewhen((!result_valid) && !exec_valid && init_valid){
			printf("\tinit_valid: %d\n",false.B)
		}
		when(new_result_valid){
			printf("new results!\n")
		}
		when( (!result_valid) && !exec_valid && init_valid){
			printf("Exec:\n")
			printf("\t exec_valid: %d\n", init_valid)
			printf("\t exec_inst: %d\n", init_inst)
			printf("\t exec_idx: %d\n", init_idx)
		}.elsewhen(new_result_valid){
			printf("\t exec_valid: %d\n", false.B)
		}

		when(new_result_valid){
			printf("\tdispatched: %d\n",false.B)
		}.elsewhen(exec_valid){
			printf("\tdispatched: %d\n",true.B)
		}

		when(io.result.valid){
			printf("valid idx: %d\n", io.out_idx)
		}
	}


	io.result.bits.isZero := result_out.isZero | isZero(positGenerator.io.out)
	io.result.bits.isNaR  := result_out.isNaR  | isNaR(positGenerator.io.out)
	io.result.bits.out    := positGenerator.io.out
	io.result.bits.lt := result_lt
	io.result.bits.eq := result_eq
	io.result.bits.gt := result_gt
	io.result.bits.exceptions := positDivSqrtCore.io.exceptions
	io.out_idx := result_idx
	
	io.result.valid := result_valid
}