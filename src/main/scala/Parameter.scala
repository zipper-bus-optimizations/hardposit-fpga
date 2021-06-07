package hardposit

import chisel3._
import chisel3.util._

object Params{
	val Nbits = 64
	val EntryWidth = if(Nbits>48) Nbits else 48
	val NumRSEntries = 8
	val NumOperand = 2
	val ES = 4
}
