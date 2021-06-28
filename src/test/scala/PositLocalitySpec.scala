import hardposit._
import scala.collection.mutable.ArrayBuffer
import chisel3._
import chisel3.util._
import chisel3.iotesters._

class PositLocalitySpec extends ChiselFlatSpec {

  private class PositLocalityTest(c: POSIT_Locality) extends PeekPokeTester(c) {
    var num_remaining_req = 6
    var num_remaining_result = 6
    val read_list:ArrayBuffer[Int] = ArrayBuffer(0x23,76,72,0x20)
    val write_buffer: ArrayBuffer[Int] = ArrayBuffer(0,0,0,0,0,0)

    // while(num_remaining_req > 0 || num_remaining_result > 0){
    //   if(peek(c.io.request.ready) == BigInt(1)){

    //   }else{  

    //   }
    // }
    var num_req_to_issue = 3
    var num_result_to_receive = 3
    val num_op = ArrayBuffer(64,2,3,0,2,1,1,1,3)
    val num_mode = ArrayBuffer(0,2,2,1,2,0,0,1,2)
    val inst =  ArrayBuffer(1,1,3)
    val startCount: ArrayBuffer[Int] = ArrayBuffer()
    val mem_read_loc: ArrayBuffer[Int] = ArrayBuffer()

    var max_num = 100
    poke(c.io.request.ready, true)
    while(num_result_to_receive> 0&& max_num>0){
      if(num_req_to_issue > 0 && peek(c.io.request.ready).intValue == 1){
        poke(c.io.request.valid, true)
        poke(c.io.request.bits.inst, inst(3-num_req_to_issue))
        poke(c.io.request.bits.mode, 0)
        poke(c.io.request.bits.wr_addr, 3-num_req_to_issue)
        poke(c.io.request.bits.operands(0).value,  num_op(3*(3-num_req_to_issue)))
        poke(c.io.request.bits.operands(0).mode, num_mode(3*(3-num_req_to_issue)))
        poke(c.io.request.bits.operands(1).value, num_op(3*(3-num_req_to_issue)+1))
        poke(c.io.request.bits.operands(1).mode, num_mode(3*(3-num_req_to_issue)+1))
        poke(c.io.request.bits.operands(2).value,  num_op(3*(3-num_req_to_issue)+2))
        poke(c.io.request.bits.operands(2).mode, num_mode(3*(3-num_req_to_issue)+2))
        poke(c.io.mem_write.ready, true)
        num_req_to_issue -= 1
      }else{
        poke(c.io.request.valid, false)
      }

      if(peek(c.io.mem_read.req_valid) == BigInt(1)){
        startCount += 10
        mem_read_loc += peek(c.io.mem_read.req_addr).intValue
      }
      var loc_to_pass = startCount.size
      for(i <- (startCount.size-1) to 0 by -1){
        if(startCount(i) > 0){
          startCount(i) -=1
        }else{
          loc_to_pass = i
        }
      }
      if(loc_to_pass < startCount.size){
        poke(c.io.mem_read.resp_valid, true)
        poke(c.io.mem_read.data, read_list(mem_read_loc(loc_to_pass)))
        poke(c.io.mem_read.resp_tag, mem_read_loc(loc_to_pass))
        startCount.remove(loc_to_pass)
        mem_read_loc.remove(loc_to_pass)
      }else{
        poke(c.io.mem_read.resp_valid, false)
      }
      if(peek(c.io.mem_write.valid).intValue == 1){
        write_buffer(peek(c.io.mem_write.bits.wr_addr).intValue) = peek(c.io.mem_write.bits.result.out).intValue
        num_result_to_receive -= 1
      }
      step(1)
      max_num -= 1
      poke(c.io.mem_write.ready, true)
    }
  }

  private def test(): Boolean = {
    chisel3.iotesters.Driver(() => new POSIT_Locality(true)) {
      c => new PositLocalityTest(c)
    }
  }

  assert(test())
}
