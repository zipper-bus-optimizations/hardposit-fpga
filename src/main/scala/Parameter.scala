package hardposit

import chisel3._
import chisel3.util._

object Params{
	val Nbits = 64
	val EntryWidth = if(Nbits>48) Nbits else 48
	val NumRBEntries = 8
	val NumOperand = 3
	val ES = 4
}
