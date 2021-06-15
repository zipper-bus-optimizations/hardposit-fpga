package hardposit

import chisel3._
import chisel3.util._

class POSIT_Locality(debug: Boolean) extends Module {
  val io = IO(new PositLocalityTopInterface)

	// This part is assumed as a perfectly wrapped blackbox
	val PE = Module(new Posit(Params.EntryWidth, Params.ES))

	// This part, we create a set of wire as external IO abstraction
	val pe_req = Wire(new PositRequest(nbits, es))
	val pe_result = Wire(new PositResult(bits, es))
	val pe_input_valid = Wire(Bool())
	val pe_output_ready = Wire(Bool())

	pe_req <> PE.io.request
	pe_result <> PE.io.result
	PE.io.request.valid := pe_input_valid
	PE.io.result.ready := pe_output_ready


	// declare data structure
	val rb = Reg(new ReorderBuffer)

 // increment counter every clock cycle if there is input
	val new_input_log = Wire(Bool())
	val (validCntrVal, _) = Counter(new_input_log, Params.NumRBEntries)
	new_input_log := io.request.valid
				&& (rb.entries(validCntrVal).written || !rb.entries(validCntrVal).valid)
	
	// When new input comes in
	io.request.ready := written(validCntrVal)
	when(new_input_log){
		rb.entries(validCntrVal).completed := false.B
		rb.entries(validCntrVal).valid := true.B
		rb.entries(validCntrVal).written := false.B
		rb.entries(validCntrVal).wr_addr := io.wr_addr
		rb.entries(validCntrVal).request <> io.request
		rb.entries(validCntrVal).result := 0.U
	}


	// wb logic
	val wbCountOn = Wire(Bool())
	val (wbCntrVal, _) = Counter(wbCountOn, Params.NumRBEntries)
	when(io.result.ready && rb.entries(wbCntrVal).completed){
		wbCountOn := true.B
		rb.entries(wbCntrVal).written := true.B
	}.otherwise{
		wbCountOn := false.B
	}

	// Connect the output
	io.result.valid := rb.entries(wbCntrVal).completed
	io.out_wr_addr := rb.entries(wbCntrVal).wr_addr
	io.result.bits <> rb.entries(wbCntrVal).result

	// When the output has been written
	when(wbCountOn){
		rb.entries(wbCntrVal).written := true.B
	}

	val processQueue = 
			Module(new Queue(UInt(log2Ceil(Params.NumRBEntries).W), 
												Params.NumRBEntries, true, true))
	val dispatchArb = Module(new DispatchArbiter(Params.NumRBEntries))
	
	// determine the dispatch logic: every mode is 0

	// validity of ops
	val opsValidVec = Wire(Vec(Params.NumRBEntries, Bool()))
	for(i <- 0 until Params.NumRBEntries){
		opsValidVec(i) := false.B
		for(j <- 0 until Params.NumOperand){
			opsValidVec(i) := opsValidVec(i)| rb.entries(i).request(j).mode
		}
		opsValidVec(i) := !opsValidVec(i)
	}
	val waitingForDispatchVec = Wire(Vec(Params.NumRBEntries, Bool()))
	for(i <- 0 until Params.NumRBEntries){
		waitingForDispatchVec(i) := opsValidVec(i) & rb.entries(i).valid & (!rb.entries(i).dispatched)
	}

	// connect to the dispatch arbiter
	dispatchArb.io.validity := waitingForDispatchVec
	dispatchArb.io.priority := wbCountOn
	val chosen = dispatchArb.io.chosen

	// connect the input to pe
	when(dispatchArb.io.hasChosen & pe.io.request.ready){
		pe.io.request.valid := true.B
		processQueue.enque(chosen)
	}.otherwise{
		pe.io.request.valid := false.B
	}
	pe.io.request.bits.num1 := rb.entries(chosen).request.operands(0).value
	pe.io.request.bits.num2 := rb.entries(chosen).request.operands(1).value
	pe.io.request.bits.num3 := rb.entries(chosen).request.operands(2).value
	pe.io.request.bits.mode := rb.entries(chosen).request.mode
	pe.io.request.bits.inst := rb.entries(chosen).request.inst

	val result_idx = Wire(UInt(log2Ceil(Params.NumRBEntries).W))
	when(pe.io.result.ready && pe.io.esult.valid){
		result_idx := processQueue.deque
		rb.entries(result_idx).result <> pe.io.result
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
	when(io.op_mem_read.resp_valid){
		for(i <- 0 until Params.NumRBEntries){
			for(j <- 0 until Params.NumOperand){
				when(rb.entries(i).request.operands(j).mode === 2.U){
					when(rb.entries(j).request.operands(j).value === io.op_mem_read.resp_tag){
						rb.entries(j).request.operands(j).value := io.op_mem_read.data
						rb.entries(i).request.operands(j).mode := 0.U
					}
				}
			}
		}
	}

	val waitingToBeFetched = Wire(Vec(Params.NumOperand* Params.NumRBEntries, Bool()))
	val fetchOffSet = Wire(Vec(Params.NumOperand* Params.NumRBEntries, UInt(48.W)))
	val inFetch = Wire(Vec(Params.NumOperand* Params.NumRBEntries, Bool()))

	for(i <- 0 until Params.NumRBEntries){
		for(j <- 0 until Params.NumOperand){
			waitingToBeFetched(i*Params.NumRBEntries+j) := 
				rb.entries(i).valid && (rb.entries(i).request.operands(j).mode === 2.U)
					&& (!rb.entries(i).request.inFetch(j))
			fetchOffSet(i*Params.NumRBEntries+j) := rb.entries(i).request.operands(j).value
		}
	}

	val fetchArb = Module(new DispatchArbiter(Params.NumRBEntries*arams.NumOperand))
	fetchArb.io.validity := waitingToBeFetched
	fetchArb.io.priority := wbCountOn

	for(i <- 0 until Params.NumRBEntries){
		for(j <- 0 until Params.NumOperand){
			inFetch(i*Params.NumRBEntries+j) := rb.entries(i).request.inFetch(j)
		}
	}
	when(fetchArb.hasChosen){
		inFetch := inFetch ^ UIntToOH(fetchArb.chosen)
		io.op_mem_read.req_valid := true.B
		io.op_mem_read.req_addr := fetchOffSet(fetchArb.chosen)
	}.otherwise{
		io.op_mem_read.req_valid := false.B
		io.op_mem_read.req_addr := fetchOffSet(fetchArb.chosen)
	}
	for(i <- 0 until Params.NumRBEntries){
		for(j <- 0 until Params.NumOperand){
			rb.entries(i).request.inFetch(j) := inFetch(i*Params.NumRBEntries+j)
		}
	}
}
