package hardposit

import chisel3._
import chisel3.util._

class POSIT_Locality(debug: Boolean) extends Module {
  val io = IO(new PositLocalityTopInterface)

	// This part is assumed as a perfectly wrapped blackbox
	val PE = new Posit(Params.EntryWidth, Params.ES)

	// This part, we create a set of wire as external IO abstraction
	val pe_req = Wire(new PositRequest(nbits, es))
	val pe_result = Wire(new PositResult(bits, es))
	val pe_input_valid = Wire(Bool())
	val pe_input_ready = Wire(Bool())
	val pe_output_valid = Wire(Bool())
	val pe_output_ready = Wire(Bool())

	pe_req <> PE.io.request
	pe_result <> PE.io.result
	PE.io.input_valid := pe_input_valid
	PE.io.output_ready := pe_output_ready
	pe_input_ready := PE.io.input_ready
	pe_output_valid := PE.io.output_valid

	// declare data structure
	val RS = Reg(new ReservationStation)
	// When new input comes in
	val new_input_log = io.input_valid
				&& (rs.entries(validCntrVal).written || !rs.entries(validCntrVal).valid)
	
	when(new_input_log){
		RS.entries(validCntrVal).completed := false.B
		RS.entries(validCntrVal).valid := true.B
		RS.entries(validCntrVal).completed := false.B
	}

 // increment counter every clock cycle if there is input
	val (validCntrVal, _) = Counter(new_input_log, size_buffer)
	io.input_ready := written(validCntrVal)
	
	val wbCountOn = Wire(Bool())
	val (wbCntrVal, _) = Counter(wbCountOn, size_buffer)
	wbCountOn := io.output_ready && completed(wbCntrVal)
	io.output_valid := completed(wbCntrVal)
}
