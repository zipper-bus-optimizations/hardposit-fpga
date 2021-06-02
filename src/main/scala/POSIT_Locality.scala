package hardposit

import chisel3._
import chisel3.util._

class POSIT_Locality(debug: Boolean, nbits: Int, es: Int, size_buffer: Int) extends Module {
  val io = IO(new PositTopInterface(nbits, es))

	// This part is assumed as a perfectly wrapped blackbox
	val PE = new Posit(nbits, es)

	// This part, we create a set of wire as external IO abstraction
	val pe_req = Wire(new PositRequest(nbits, es))
	val pe_result = Wire(new PositResult(bits, es))
	val pe_input_valid = Wire(Bool())
	val pe_input_ready = Wire(Bool())
	val pe_output_valid = Wire(Bool())
	val pe_output_ready = Wire(Bool())

	pe_req <> PE.io.request
	pe_result <> PE.io.result

 // increment counter every clock cycle if there is input
	val validCountOn = Wire(Bool())
	val (validCntrVal, _) = Counter(validCountOn, size_buffer)
	validCountOn := io.input_valid && written(validCntrVal)
	io.input_ready := written(validCntrVal)
	
	val wbCountOn = Wire(Bool())
	val (wbCntrVal, _) = Counter(wbCountOn, size_buffer)
	wbCountOn := io.output_ready && completed(wbCntrVal)
	io.output_valid := completed(wbCntrVal)
}
