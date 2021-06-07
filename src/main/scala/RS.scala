package hardposit

import chisel3._
import chisel3.util._

/*
RS Entry
------------------------------------------------------------------------------------------
|completed(bool) | valid(bool) | written(bool) | wr_addr(48nit) |				 operand				|
																																|	addr(nbits/48) | mode |
------------------------------------------------------------------------------------------
*/


class RSEntry[T <: Bundle]（result_type:=> Bundle） extends RequestOperandEntry{
	val completed = Bool()
	val valid = Bool()
	val written = Bool()
	val wr_addr = UInt(48.W)
	val req = new PositLocalityTopRequest
	val result = new result_type
}
class ReservationStation[T <: Bundle](result_type:=> Bundle) extends Bundle{
	val entries = Vec(new RSEntry(result_type), Params.NumRSEntries)
}
