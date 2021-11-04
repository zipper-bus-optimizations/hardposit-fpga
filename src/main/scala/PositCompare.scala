package hardposit

import chisel3._

class PositCompare(nbits: Int, es: Int) extends Module {
  val io = IO(new Bundle {
    val num1 = Input(SInt(nbits.W))
    val num2 = Input(SInt(nbits.W))
    val lt = Output(Bool())
    val eq = Output(Bool())
    val gt = Output(Bool())
    val validIn = Input(Bool())
    val validOut = Output(Bool())
  })
  io.validOut := io.validIn
  io.lt := (io.num1 < io.num2)
  io.eq := (io.num1 === io.num2)
  io.gt := (!io.lt && !io.eq)
}
