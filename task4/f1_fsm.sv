module f1_fsm (
    input   logic       rst,
    input   logic       en,          // tick from clktick
    input   logic       trigger,     // start signal (user or delay)
    input   logic       clk,
    output  logic [7:0] data_out,    // LED outputs
    output  logic       cmd_seq,     // high during sequencing
    output  logic       cmd_delay    // pulse when all LEDs ON
);

typedef enum logic [3:0] {
    S0, S1, S2, S3, S4, S5, S6, S7, S8
} state_t;

state_t current_state, next_state;
logic run;
logic prev_trigger;
logic cmd_delay_r;

always_ff @(posedge clk) begin
    if (rst) begin
        current_state <= S0;
        prev_trigger  <= 1'b0;
        run           <= 1'b0;
        cmd_delay_r   <= 1'b0;
    end else begin
        prev_trigger <= trigger;

        // rising edge of trigger starts run
        if (trigger && !prev_trigger && !run)
            run <= 1'b1;

        // advance FSM on tick when running
        if (en && run)
            current_state <= next_state;

        // when sequence done (S8 reached)
        if (en && run && current_state == S8) begin
            cmd_delay_r <= 1'b1;
            run <= 1'b0;
        end else
            cmd_delay_r <= 1'b0;
    end
end

always_comb begin
    case (current_state)
        S0: next_state = S1;
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S4;
        S4: next_state = S5;
        S5: next_state = S6;
        S6: next_state = S7;
        S7: next_state = S8;
        S8: next_state = S0;
        default: next_state = S0;
    endcase
end

assign cmd_seq   = run;
assign cmd_delay = cmd_delay_r;
assign data_out  = (8'b11111111) >> (8 - current_state);

endmodule
