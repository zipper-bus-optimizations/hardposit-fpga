package hardposit

import chisel3._

object PositFPGA extends App{
    chisel3.Driver.execute(args, () => new POSIT_Locality(false))
}