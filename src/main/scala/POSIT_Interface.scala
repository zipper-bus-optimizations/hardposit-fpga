package hardposit

import chisel3._
import chisel3.util._
class PositLocalityTopRequest(nbits: Int, es: Int) extends Bundle{
	val num1_addr = Input(UInt(nbits.W))
	val num2_addr = Input(UInt(nbits.W))
	val num3_addr = Input(UInt(nbits.W))
//0 for immediate, 1 for immediate value, 2 for relative distance
	val addr_mod1 = Input(UInt(2.W))
	val addr_mod2 = Input(UInt(2.W)) 
	val addr_mod3 = Input(UInt(2.W)) 
	val inst = Input(UInt(3.W))
	val mode = Input(UInt(2.W))
}

class PositLocalityTopResult(nbits: Int, es: Int) extends Bundle{
	val isZero = Output(Bool())
	val isNaR  = Output(Bool())
	val out    = Output(UInt(nbits.W))
	val lt = Output(Bool())
	val eq = Output(Bool())
	val gt = Output(Bool())
	val exceptions    = Output(UInt(5.W))
}

class PositLocalityTopInterface(nbits: Int, es: Int) extends Bundle{
	val request = new PositTopRequest(nbits, es)
	val result = new PositTopResult(nbits, es)

	val wr_addr = Input(UInt(48.W))
	val out_wr_addr = Output(UInt(48.W))

	val input_valid = Input(Bool())
	val input_ready = Output(Bool())


	val output_valid = Output(Bool())
	val output_ready = Input(Bool())
}

class PositCacheTopRequest(nbits: Int, es: Int) extends Bundle{
	val num1_addr = Input(UInt(nbits.W))
	val num2_addr = Input(UInt(nbits.W))
	val num3_addr = Input(UInt(nbits.W))
	val inst = Input(UInt(3.W))
	val mode = Input(UInt(2.W))
}

class PositCacheTopResult(nbits: Int, es: Int) extends Bundle{
	val isZero = Output(Bool())
	val isNaR  = Output(Bool())
	val out    = Output(UInt(nbits.W))
	val lt = Output(Bool())
	val eq = Output(Bool())
	val gt = Output(Bool())
	val exceptions    = Output(UInt(5.W))
}

class PositCacheTopInterface(nbits: Int, es: Int) extends Bundle{
	val request = new PositTopRequest(nbits, es)
	val result = new PositTopResult(nbits, es)

	val wr_addr = Input(UInt(48.W))
	val out_wr_addr = Output(UInt(48.W))

	val input_valid = Input(Bool())
	val input_ready = Output(Bool())


	val output_valid = Output(Bool())
	val output_ready = Input(Bool())
}