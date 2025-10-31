module top #(
  parameter WIDTH = 16
)(
  // interface signals
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    input   logic [WIDTH-1:0] N,
    output  logic [7:0] data_out
);

  logic       tick;    // interconnect wire

clktick myClock (
  .clk (clk),
  .rst (rst),
  .en (en),
  .N (N),
  .tick (tick)
);

f1_fsm myFsm (
  .rst (rst),
  .en (tick),
  .clk (clk),
  .data_out (data_out)
);

endmodule
