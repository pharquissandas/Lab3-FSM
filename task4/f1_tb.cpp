#include "Vf1_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp" // include your Vbuddy library

int main(int argc, char **argv, char **env)
{
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    Vf1_top *top = new Vf1_top;
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("f1_top.vcd");

    if (vbdOpen() != 1)
        return -1;
    vbdHeader("F1 Lights Reaction Test");

    top->clk = 0;
    top->rst = 1;
    top->trigger = 0;
    for (int i = 0; i < 10; i++)
    {
        top->clk ^= 1;
        top->eval();
        tfp->dump(i);
    }
    top->rst = 0;

    bool stopwatch_running = false;
    int ms = 0;

    for (int sim_time = 0; sim_time < 200000; sim_time++)
    {
        top->clk ^= 1;
        top->eval();

        // User input: simulate button press via Vbuddy switch
        int sw = vbdFlag(); // 1 = button pressed
        top->trigger = sw;

        // Display LEDs on Vbuddy bar
        vbdBar(top->data_out);

        // Start stopwatch when lights go off
        if (top->time_out && !stopwatch_running)
        {
            vbdInitWatch();
            stopwatch_running = true;
        }

        // When user reacts (presses button after time_out)
        if (stopwatch_running && sw)
        {
            ms = vbdElapsed();
            vbdHex(ms);
            vbdSetCursor(1, 1);
            vbdPrintf("Reaction: %d ms", ms);
            stopwatch_running = false;
        }

        tfp->dump(sim_time);
        if (Verilated::gotFinish())
            break;
    }

    vbdClose();
    tfp->close();
    delete top;
    delete tfp;
    return 0;
}
