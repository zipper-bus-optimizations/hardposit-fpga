package hardposit

import chisel3._
import chisel3.util._

/*
RB Entry
------------------------------------------------------------------------------------------
|completed(bool) | valid(bool) | written(bool) | wr_addr(48nit) |				 operand				|
																																|	addr(nbits/48) | mode |
------------------------------------------------------------------------------------------
*/

class RBRequest extends PositLocalityTopRequest{
	val inFetch = Vec(Params.NumOperand, Bool())
}
class RBEntry[T <: Bundle]（result_type:=> Bundle） extends RequestOperandEntry{
	val completed = Bool()
	val valid = Bool()
	val dispatched = Bool()
	val written = Bool()
	val wr_addr = UInt(48.W)
	val request = new RBRequest
	val result = new result_type
}
class ReorderBuffer[T <: Bundle](result_type:=> Bundle) extends Bundle{
	val entries = Vec(Params.NumRBEntries, new RBEntry(result_type))
}
