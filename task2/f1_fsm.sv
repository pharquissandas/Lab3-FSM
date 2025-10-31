module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    output  logic [7:0] data_out
);

// Define our states
typedef enum {S0, S1, S2, S3, S4, S5, S6, S7, S8} my_state;
my_state current_state, next_state;

// State registers
always_ff @(posedge clk, posedge rst) begin
    if (rst)  current_state <= S0;
    else if (en) current_state <= next_state;
end

// Next state logic
always_comb begin
    case (current_state)
        S0:   next_state = S1;
        S1:   next_state = S2;
        S2:   next_state = S3;
        S3:   next_state = S4;
        S4:   next_state = S5;
        S5:   next_state = S6;
        S6:   next_state = S7;
        S7:   next_state = S8;
        S8:   next_state = S0;
        default: next_state = S0;
    endcase
end

// Output logic
assign data_out = (8'b11111111) >> (8-current_state);

endmodule