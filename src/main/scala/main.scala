package hardposit
import java.io.{File, FileWriter}

import chisel3._

object PositFPGA extends App{
  val dir = new File(args(0)) ; dir.mkdirs

    val coalesce_verilog = new FileWriter(new File(dir, s"POSIT_Locality_coalesce.v"))
    coalesce_verilog write chisel3.Driver.emitVerilog(new POSIT_Locality(true))
    coalesce_verilog.close

    val nocoalesce_verilog = new FileWriter(new File(dir, s"POSIT_Locality_nocoalesce.v"))
    nocoalesce_verilog write chisel3.Driver.emitVerilog(new POSIT_Locality(false))
    nocoalesce_verilog.close
}