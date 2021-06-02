package hardposit

import chisel3._
import chisel3.util._

class ReservationStation[T <: Bundle]
	(size_buffer:Int, input_type: Bundle, result_type: Bundle){
	val completed = Reg(Vec(Bool(), size_buffer))
	val valid = Reg(Vec(Bool(), size_buffer))
	val written = Reg(Vec(Bool(), size_buffer))
	val wr_addr = Reg(Vec(UInt(48.W), size_buffer))
	val request_operand = Reg(new input_type, size_buffer))
	val result = Reg(Vec(new result_type, size_buffer))
}
