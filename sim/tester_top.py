import cocotb
from cocotb.triggers import FallingEdge, Timer

CLK_PERIOD_NS = 83 # 1000/12 is 83.333...

async def generate_clock(dut):
    """Generate clock pulses."""

    while(True):
        dut.clk.value = 1
        await Timer(CLK_PERIOD_NS/2, units="ns")
        dut.clk.value = 0
        await Timer(CLK_PERIOD_NS/2, units="ns")

@cocotb.test()
async def mytest_register(dut):

    await cocotb.start(generate_clock(dut))  # controls dut.clk.value, runs the clock "in the background"

    await Timer(64*3*24*15*CLK_PERIOD_NS, units="ns")  # wait a bit


