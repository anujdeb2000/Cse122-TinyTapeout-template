# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    #Reset 
    dut._log.info("Resetting the module")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0  # Reset active low
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1  # Reset released

    #INIT CHECK
    dut._log.info("Check for INIT state")
    # uo_out[0] = wingame, uo_out[1] = losegame
    assert int(dut.uo_out.value) == 0

    #start signal
    dut._log.info("Triggering start signal")
    dut.ui_in.value = 1 # ui_in[0] is start
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 0
    
    # Wait till sequence is loaded
    await ClockCycles(dut.clk, 10)

    #game check
    dut._log.info("Making sure game is still ongoing")
    assert int(dut.uo_out.value) == 0

    #Input signal
    dut._log.info("Input button 1")
    dut.ui_in.value = 4 # 0100 binary (ui_in[2])
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0
    
    # Wait for logic to process
    await ClockCycles(dut.clk, 5)
    
    current_status = int(dut.uo_out.value)
    dut._log.info(f"Final output value: {current_status}")
    
    dut._log.info("Simulation Finished successfully")
