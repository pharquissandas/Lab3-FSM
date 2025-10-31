module lfsr_7 (
    input   logic       clk,
    input   logic       rst,
    input   logic       en,
    output  logic [6:0] data_out
);

always_ff @(posedge clk) begin
    if (rst)
        data_out <= 7'b1;
    else if (en)
        data_out <= {data_out[5:0], data_out[6] ^ data_out[2]};
end

endmodule
