# Pre-silicon simulation of the YANG model implementation

You can use a cocotb/iverilog simulation of a single *top*

The cocotb simulation after initialization and reset of the design instantiated in [tester_top.v](tester_top.v)

Start a simulation in this directory with the [run.sh](run.sh) wrapper script that invokes a cocotb python simulation environment:

```
./run.sh
```


Inspect the simulation results:

```
gtkwave sim_build/tester_top.fst
```
