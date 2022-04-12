package hardposit

import chisel3._
import chisel3.util._
import hardposit.Params._

class PositTopMemWrite() extends Bundle{
	val result = new PositLocalityTopResult
	val wr_addr = UInt(8.W)
}

class RequestOperand extends Bundle{
	val value = UInt(EntryWidth.W)
//0 for immediate, 1 for immediate value, 2 for relative distance
	val mode = UInt(2.W)
}
class RequestOperandEntry extends Bundle{
	val operands = Vec(NumOperand, new RequestOperand)
}

class PositLocalityTopRequest extends RequestOperandEntry{
	val inst = UInt(3.W)
	val mode = UInt(2.W)
	val wr_addr = UInt(8.W)
}

class PositLocalityTopResult extends Bundle{
	val isZero = Bool()
	val isNaR  = Bool()
	val out    = UInt(EntryWidth.W)
	val lt = Bool()
	val eq = Bool()
	val gt = Bool()
	val exceptions    = UInt(5.W)
}

class MemRead extends Bundle{
	val req_valid = Output(Bool())
	val req_addr = Output(UInt(42.W))
	val req_tag = Output(UInt(16.W))
	val data = Input(UInt(512.W))
	val resp_valid = Input(Bool())
	val resp_tag = Input(UInt(8.W))
}
class PositLocalityTopInterface extends Bundle{
	val request = Flipped(DecoupledIO(new PositLocalityTopRequest))
	val mem_write = Decoupled(new PositTopMemWrite)
	val mem_read = new MemRead
}
