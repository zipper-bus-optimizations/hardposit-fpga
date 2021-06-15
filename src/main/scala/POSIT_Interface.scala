package hardposit

import chisel3._
import chisel3.util._

class PositTopMemRead() extends Bundle{
	val rdTag = Input(UInt())
	val rdData = Input(UInt())
	val rdValid = Input(Bool())

	val rdReady= Input(Bool())
	val rdAck = Input(UInt())
	val rdEnable = Output(Bool())
	val rdAddr = Output(Bool())
}

class PositTopMemWrite() extends Bundle{

}

class RequestOperand extends Bundle{
	val value = UInt(Params.EntryWidth.W)
//0 for immediate, 1 for immediate value, 2 for relative distance
	val mode = UInt(2.W)
}
class RequestOperandEntry extends Bundle{
	val operands = Vec(Params.NumOperand, new RequestOperand)
}

class PositLocalityTopRequest extends Bundle{
	val operands = Input(new RequestOperandEntry)
	val inst = Input(UInt(3.W))
	val mode = Input(UInt(2.W))
}

class PositLocalityTopResult extends Bundle{
	val isZero = Output(Bool())
	val isNaR  = Output(Bool())
	val out    = Output(UInt(Params.EntryWidth.W))
	val lt = Output(Bool())
	val eq = Output(Bool())
	val gt = Output(Bool())
	val exceptions    = Output(UInt(5.W))
}

class MemRead extends Bundle{
	val req_valid = Output(Bool())
	val req_addr = Output(UInt(48.W))
	val data = Input(UInt(Params.EntryWidth.W))
	val resp_valid = Input(Bool())
	val resp_tag = Input(UInt(48.W))
}
class PositLocalityTopInterface extends Bundle{
	val request = Flipped(DecoupledIO(new PositLocalityTopRequest))
	val result = DecoupledIO(new PositLocalityTopResult)

	val wr_addr = Input(UInt(48.W))
	val out_wr_addr = Output(UInt(48.W))
	val op_mem_read = new MemRead
}

class PositCacheTopRequest extends Bundle{
	val num1_addr = Input(UInt(Params.EntryWidth.W))
	val num2_addr = Input(UInt(Params.EntryWidth.W))
	val num3_addr = Input(UInt(Params.EntryWidth.W))
	val inst = Input(UInt(3.W))
	val mode = Input(UInt(2.W))
}

class PositCacheTopResult extends Bundle{
	val isZero = Output(Bool())
	val isNaR  = Output(Bool())
	val out    = Output(UInt(Params.EntryWidth.W))
	val lt = Output(Bool())
	val eq = Output(Bool())
	val gt = Output(Bool())
	val exceptions    = Output(UInt(5.W))
}

class PositCacheTopInterface extends Bundle{
	val request = new PositTopRequest
	val result = new PositTopResult

	val wr_addr = Input(UInt(48.W))
	val out_wr_addr = Output(UInt(48.W))

	val input_valid = Input(Bool())
	val input_ready = Output(Bool())


	val output_valid = Output(Bool())
	val output_ready = Input(Bool())
}