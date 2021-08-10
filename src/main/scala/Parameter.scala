package hardposit

import chisel3._
import chisel3.util._

object Params{
	val Nbits = 32
	val EntryWidth = if(Nbits>8) Nbits else 8
	val NumRBEntries = 8
	val NumOperand = 3
	val ES = 2
}
