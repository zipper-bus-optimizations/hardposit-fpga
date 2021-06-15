package hardposit

import chisel3._
import chisel3.util._

class DispatchArbiter(numBits: Int) extends Module{
	val io = IO(new Bundle{
		val validity = Input(Vec(numBits, Bool()))
		val priority = Input(UInt(log2ceil(numBits).W))
		val chosen = Output(UInt(log2Ceil(numBits).W))
		val hasChosen = Output(Bool())
	})

	val afterPriority = 
		validity.map(if(i.asUInt>priority) _ else false.B)
	val beforePriority = 
		validity.map(if(i.asUInt<priority) _ else false.B)

  val afterPriorityChosen = (numBits-1).asUInt
  val beforePriorityChosen = (numBits-1).asUInt

  for (i <- numBits-2 to 0 by -1) {
    when (afterPriority(i)) {
      afterPriorityChosen := i.asUInt
    }
		when(beforePriority(i)){	
			beforePriority := i.asUInt
		}
  }
	val afterPriorityExist = afterPriority.exists(x=>x)
	val beforePriorityExist = beforePriority.exists(x=>x)
	io.hasChosen := afterPriorityExist | beforePriority
	io.chosen := if(afterPriorityExist) afterPriorityChosen else beforePriorityChosen
}