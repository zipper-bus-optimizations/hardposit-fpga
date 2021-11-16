package hardposit

import chisel3._
import chisel3.util._

class POSIT_Locality(debug: Boolean) extends Module {
  val io = IO(new PositLocalityTopInterface)

	// This part is assumed as a perfectly wrapped blackbox
	val pe = Module(new Posit(Params.Nbits, Params.ES)(true))


	// declare data structure
	val rb = RegInit(new ReorderBuffer, 0.U.asTypeOf(new ReorderBuffer))

 // increment counter every clock cycle if there is input
	val new_input_log = Wire(Bool())
	val entry_idx = io.request.bits.wr_addr
	new_input_log := io.request.valid && (rb.entries(entry_idx).written || !rb.entries(entry_idx).valid)
	
	// When new input comes in
	io.request.ready := rb.entries(entry_idx).written || (!rb.entries(entry_idx).valid)
	when(new_input_log){
		printf("written new entry\n")
		rb.entries(entry_idx).completed := false.B
		rb.entries(entry_idx).valid := true.B
		rb.entries(entry_idx).written := false.B
		rb.entries(entry_idx).wr_addr := io.request.bits.wr_addr
		rb.entries(entry_idx).request.inst := io.request.bits.inst
		rb.entries(entry_idx).request.mode := io.request.bits.mode
		for(i <- 0 until Params.NumOperand){
			printf("op%d: mode: %d value: %d\n",i.asUInt,io.request.bits.operands(i).mode,io.request.bits.operands(i).value)
			rb.entries(entry_idx).request.operands(i).value := io.request.bits.operands(i).value
			rb.entries(entry_idx).request.operands(i).mode := io.request.bits.operands(i).mode
		}
		rb.entries(entry_idx).result := 0.U.asTypeOf(new PositResult(Params.Nbits, Params.ES))
	}


	// wb logic
	val wbCountOn = Wire(Bool())
	val (wbCntrVal, _) = Counter(wbCountOn, Params.NumRBEntries)
	when(io.mem_write.ready && rb.entries(wbCntrVal).completed && (~rb.entries(wbCntrVal).written)){
		wbCountOn := true.B
		rb.entries(wbCntrVal).written := true.B
	}.otherwise{
		wbCountOn := false.B
	}

	// Connect the output
	io.mem_write.valid := rb.entries(wbCntrVal).completed && (~rb.entries(wbCntrVal).written)
	io.mem_write.bits.wr_addr := rb.entries(wbCntrVal).wr_addr
	io.mem_write.bits.result <> rb.entries(wbCntrVal).result



	val dispatchArb = Module(new DispatchArbiter(Params.NumRBEntries))
	
	// determine the dispatch logic: every mode is 0

	// validity of ops
	val opsValidVec = Wire(Vec(Params.NumRBEntries, Bool()))
	val singleOpValidVec = Wire(Vec(Params.NumRBEntries* Params.NumOperand, Bool()))

	for(i <- 0 until Params.NumRBEntries){
		singleOpValidVec(i*Params.NumOperand)  := !rb.entries(i).request.operands(0).mode
		for(j <- 1 until Params.NumOperand){
			singleOpValidVec(i*Params.NumOperand+j) := singleOpValidVec(i*Params.NumOperand+j-1) && (rb.entries(i).request.operands(j).mode === 0.U)
		}
		opsValidVec(i) := singleOpValidVec(i*Params.NumOperand+Params.NumOperand-1) 
	}
	val waitingForDispatchVec = Wire(Vec(Params.NumRBEntries, Bool()))
	for(i <- 0 until Params.NumRBEntries){
		waitingForDispatchVec(i) := opsValidVec(i) & rb.entries(i).valid & (!rb.entries(i).dispatched)
	}

	// connect to the dispatch arbiter
	dispatchArb.io.validity := waitingForDispatchVec.asUInt
	dispatchArb.io.priority := wbCountOn
	val chosen = dispatchArb.io.chosen

	for(i <- 0 until Params.NumRBEntries){
		when(entry_idx === i.U && new_input_log){
			rb.entries(i).dispatched := false.B
		}.otherwise{
			rb.entries(i).dispatched := rb.entries(i).dispatched || (chosen === i.asUInt && dispatchArb.io.hasChosen && pe.io.request.ready)
		}
	}
	// connect the input to pe
	when(dispatchArb.io.hasChosen & pe.io.request.ready){
		pe.io.request.valid := true.B
	}.otherwise{
		pe.io.request.valid := false.B
	}
	pe.io.in_idx := chosen

	pe.io.result.ready := io.mem_write.ready
	pe.io.request.bits.num1 := rb.entries(chosen).request.operands(0).value(Params.Nbits-1,0)
	pe.io.request.bits.num2 := rb.entries(chosen).request.operands(1).value(Params.Nbits-1,0)
	pe.io.request.bits.num3 := rb.entries(chosen).request.operands(2).value(Params.Nbits-1,0)
	pe.io.request.bits.mode := rb.entries(chosen).request.mode
	pe.io.request.bits.inst := rb.entries(chosen).request.inst

	val result_idx = Wire(UInt(log2Ceil(Params.NumRBEntries).W))
	result_idx := pe.io.out_idx
	when(pe.io.result.ready && pe.io.result.valid){
		rb.entries(result_idx).result <> pe.io.result.bits
		rb.entries(result_idx).completed := true.B
	}

	// update operands
	for(i <- 0 until Params.NumRBEntries){
		for(j <- 0 until Params.NumOperand){
			when(rb.entries(i).request.operands(j).mode === 1.U){
				when(rb.entries(rb.entries(i).request.operands(j).value).completed){
					rb.entries(i).request.operands(j).value := 
						rb.entries(rb.entries(i).request.operands(j).value).result.out
					rb.entries(i).request.operands(j).mode := 0.U	
				}
			}
		}
	}

	// mem read logic
	when(io.mem_read.resp_valid){
		for(i <- 0 until Params.NumRBEntries){
			for(j <- 0 until Params.NumOperand){
				when(rb.entries(i).request.operands(j).mode === 2.U){
					when(rb.entries(i).request.operands(j).value === io.mem_read.resp_tag){
						rb.entries(i).request.operands(j).value := io.mem_read.data
						rb.entries(i).request.operands(j).mode := 0.U
					}
				}
			}
		}
	}

	val waitingToBeFetched = Wire(Vec(Params.NumOperand* Params.NumRBEntries, Bool()))
	val fetchOffSet = Wire(Vec(Params.NumOperand* Params.NumRBEntries, UInt(48.W)))
	val crnt_inFetch = Wire(Vec(Params.NumOperand* Params.NumRBEntries, Bool()))
	val inFetch = Wire(Vec(Params.NumOperand* Params.NumRBEntries, Bool()))
	for(i <- 0 until Params.NumRBEntries){
		for(j <- 0 until Params.NumOperand){
			waitingToBeFetched(i*Params.NumOperand+j) := 
				rb.entries(i).valid && (rb.entries(i).request.operands(j).mode === 2.U) && (!rb.entries(i).request.inFetch(j))
			fetchOffSet(i*Params.NumOperand+j) := rb.entries(i).request.operands(j).value
		}
	}

	val fetchArb = Module(new DispatchArbiter(Params.NumRBEntries*Params.NumOperand))
	fetchArb.io.validity := waitingToBeFetched.asUInt
	fetchArb.io.priority := wbCountOn

	for(i <- 0 until Params.NumRBEntries){
		for(j <- 0 until Params.NumOperand){
			crnt_inFetch(i*Params.NumOperand+j) := rb.entries(i).request.inFetch(j)
		}
	}
	when(fetchArb.io.hasChosen){
		inFetch := (crnt_inFetch.asUInt ^ (UIntToOH(fetchArb.io.chosen)(Params.NumRBEntries*Params.NumOperand-1,0))).asBools
		io.mem_read.req_valid := true.B
		io.mem_read.req_addr := fetchOffSet(fetchArb.io.chosen)
	}.otherwise{
		inFetch := crnt_inFetch
		io.mem_read.req_valid := false.B
		io.mem_read.req_addr := fetchOffSet(fetchArb.io.chosen)
	}
	for(i <- 0 until Params.NumRBEntries){
		when(entry_idx === i.U && new_input_log){
			rb.entries(i.U).request.inFetch := 0.U(Params.NumOperand.W).asBools
		}.otherwise{
			for(j <- 0 until Params.NumOperand){
				rb.entries(i).request.inFetch(j) := inFetch(i*Params.NumOperand+j)
			}
		}
	}

	if(debug){
		when(io.mem_read.req_valid | io.mem_read.resp_valid){
			printf("\t-mem_read:\n")
			printf("\t\t-req_valid: %b\n",io.mem_read.req_valid)
			printf("\t\t-req_addr: %x\n",io.mem_read.req_addr)
			printf("\t\t-resp_valid: %b\n",io.mem_read.resp_valid)
			printf("\t\t-data: %x\n",io.mem_read.data)
			printf("\t\t-resp_tag: %x\n",io.mem_read.resp_tag)
		}
		when(io.mem_write.valid){
			printf("\t-mem_write:\n")
			printf("\t\t-valid: %b\n",io.mem_write.valid)
			printf("\t\t-ready: %b\n",io.mem_write.ready)
			printf("\t\t-bits:\n")
			printf("\t\t\t-wr_addr: %x\n", io.mem_write.bits.wr_addr)
			printf("\t\t\t-result: \n")
			printf("\t\t\t\t-isZero: %b\n", io.mem_write.bits.result.isZero)
			printf("\t\t\t\t-isNaR: %b\n", io.mem_write.bits.result.isNaR)
			printf("\t\t\t\t-lt: %b\n", io.mem_write.bits.result.lt)
			printf("\t\t\t\t-eq: %b\n", io.mem_write.bits.result.eq)
			printf("\t\t\t\t-gt: %b\n", io.mem_write.bits.result.gt)
			printf("\t\t\t\t-exceptions: %x\n", io.mem_write.bits.result.exceptions)
			printf("\t\t\t\t-out: %b\n", io.mem_write.bits.result.out)
		}
		// when(io.request.valid || waitingForDispatchVec.asUInt > 0.U || io.mem_write.valid){
		when(io.request.valid || io.mem_write.valid || pe.io.result.valid){
			printf("top level io:\n")
			printf("\t-request:\n")
			printf("\t\t-valid: %b\n",io.request.valid)
			printf("\t\t-ready: %b\n",io.request.ready)
			printf("\t\t-bits:\n")
			printf("\t\t\t-inst: %x\n", io.request.bits.inst)
			printf("\t\t\t-mode: %x\n", io.request.bits.mode)
			printf("\t\t\t-wr_addr: %x\n", io.request.bits.wr_addr)
			for(i <- 0 until Params.NumOperand){
				printf(s"\t\t\t-operand${i}:\n")
				printf(s"\t\t\t\t-value: %x\n",io.request.bits.operands(i).value)
				printf(s"\t\t\t\t-mode: %x\n",io.request.bits.operands(i).mode)
			}

			printf("\t-fetchArb:\n")
			printf("\t\t-validity:%b\n", fetchArb.io.validity)
			printf("\t\t-priority:%x\n", fetchArb.io.priority)
			printf("\t\t-chosen:%x\n", fetchArb.io.chosen)
			printf("\t\t-hasChosen:%b\n", fetchArb.io.hasChosen)

			printf("\t-dispatchArb\n")
			printf("\t\t-validity:%b\n", dispatchArb.io.validity)
			printf("\t\t-priority:%x\n", dispatchArb.io.priority)
			printf("\t\t-chosen:%x\n", dispatchArb.io.chosen)
			printf("\t\t-hasChosen:%b\n", dispatchArb.io.hasChosen)

			printf("rb data: \n")
			printf("idx | completed | valid | dispatched | writtern | wr_addr| inst | mode | num0 | mode0 | infetch0 | num1 | mode1 | infetch1 | num2 | mode2 | infetch2 | isZero | isNar | out | lt | eq | gt | exceptions\n")
			for(i <- 0 until Params.NumRBEntries){
				val crnt_entry = rb.entries(i)
				val fetched = rb.entries(i).request.inFetch
				val request = rb.entries(i).request
				val operands = request.operands
				val result = rb.entries(i).result
				printf("%d | %b | %b | %b | %b | %x | %x | %x | %x | %x | %b | %x | %x | %b | %x | %x | %b | %b | %b | %x | %b | %b | %b | %x\n",
						i.asUInt, crnt_entry.completed, crnt_entry.valid, crnt_entry.dispatched, crnt_entry.written, crnt_entry.wr_addr, request.inst, request.mode, 
						operands(0).value, operands(0).mode, fetched(0),operands(1).value,operands(1).mode, fetched(1), operands(2).value,operands(2).mode, fetched(2),result.isZero, result.isNaR, result.out,result.lt,
						result.eq,result.gt,result.exceptions )
			}

			printf("pe: \n")
			val request = pe.io.request
			val result = pe.io.result

			printf("request: valid | ready | num 1 | num2 | num3 | inst | mode\n")
			printf("\t %b | %b | %b | %b | %b | %x | %x\n", request.valid, request.ready, request.bits.num1, request.bits.num2, request.bits.num3, request.bits.inst, request.bits.mode)
			printf("result: valid | ready | isZero | isNar | out | lt | eq | gt | exceptions\n")

			printf("\t %b | %b | %b | %b | %x | %b | %b | %b | %x\n", result.valid, result.ready, result.bits.isZero, result.bits.isNaR, result.bits.out,result.bits.lt,
						result.bits.eq, result.bits.gt, result.bits.exceptions)

		}
	}
}
