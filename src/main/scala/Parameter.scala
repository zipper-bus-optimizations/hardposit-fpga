package hardposit

import chisel3._
import chisel3.util._
import scala.math._
object Params{
	val debug = true
	val reuse = true
	val outoforder = true
	val Nbits = 32
	val EntryWidth = if(Nbits>8) Nbits else 8
	val NumOperand = 3
	val ES = 2
	val NumFPGAEntries = if(outoforder) 8 else 1
	val NumOperandEntries  = pow(2,log2Ceil(NumOperand*NumFPGAEntries)).toInt
	val WriteGranularity = 64
	val OperandGranularity = 4
	val SizeOfCacheline = 64
	val ReadGranularity = 8
	val NumOperandPerCacheline =  SizeOfCacheline/ReadGranularity
	val NumCacheline = NumOperandEntries / NumOperandPerCacheline
	val BitsForOffset = log2Ceil(NumOperandPerCacheline)
	val BitsForCacheline = NumCacheline
	val BitsForId = 1
}
