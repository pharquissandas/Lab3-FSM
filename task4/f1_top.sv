module f1_top (
    input  logic       clk,
    input  logic       rst,
    input  logic       trigger,
    output logic [7:0] data_out,
    output logic       time_out
);

logic tick;
logic cmd_seq, cmd_delay;
logic [6:0] rand_val;

// random delay generator
lfsr_7 LFSR (
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .data_out(rand_val)
);

// clock divider (tick pulse)
clktick #(.WIDTH(24)) CLKDIV (
    .clk(clk),
    .rst(rst),
    .en(cmd_seq),
    .N(24'd5_000_000), // adjust for your clock freq
    .tick(tick)
);

// main FSM
f1_fsm FSM (
    .rst(rst),
    .clk(clk),
    .en(tick),
    .trigger(trigger),
    .data_out(data_out),
    .cmd_seq(cmd_seq),
    .cmd_delay(cmd_delay)
);

// random delay block
delay #(.WIDTH(10)) DELAY (
    .clk(clk),
    .rst(rst),
    .trigger(cmd_delay),
    .n({3'b000, rand_val}),
    .time_out(time_out)
);

endmodule

