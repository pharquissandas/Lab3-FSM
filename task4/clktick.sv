module clktick #(
    parameter WIDTH = 24
)(
    input  logic             clk,
    input  logic             rst,
    input  logic             en,
    input  logic [WIDTH-1:0] N,
    output logic             tick
);

logic [WIDTH-1:0] count;

always_ff @(posedge clk) begin
    if (rst) begin
        count <= N;
        tick  <= 0;
    end else if (en) begin
        if (count == 0) begin
            count <= N;
            tick  <= 1;
        end else begin
            count <= count - 1;
            tick  <= 0;
        end
    end else
        tick <= 0;
end

endmodule
