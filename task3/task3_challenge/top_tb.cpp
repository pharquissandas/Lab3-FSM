#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"

#include "vbuddy.cpp" //include vbuddy code
#define MAX_SIM_CYC 1000000
#define ADDRES_WIDTH 8
#define ROM_SZ = 256

int main(int argc, char **argv, char **env)
{
    int simcyc; // simulation clock count
    int tick;   // each clk cycle has two ticks for two edges

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtop *top = new Vtop;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top_tb.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("F1 Lights");
    // vbdSetMode(1);        // Flag mode set to one-shot

    // initialise simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->en = 1;
    top->N = vbdValue();

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }
        top->en = vbdFlag(); // enable signal
        top->N = vbdValue();
        // plot ROM output and print cycle count
        vbdBar(top->data_out & 0xFF);
        vbdCycle(simcyc);

        // either simulation finished, or 'q' is pressed
        if ((Verilated::gotFinish()) || (vbdGetkey() == 'q'))
            exit(0);
    }

    vbdClose();
    tfp->close();
    exit(0);
}