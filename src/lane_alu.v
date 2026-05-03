module lane_alu (
    input [1:0] a,
    input [1:0] b,
    input [2:0] op,
    output reg [1:0] y
);

wire [1:0] add = a + b;
wire [1:0] sub = a - b;
wire [1:0] xorv = a ^ b;
wire [1:0] andv = a & b;
wire [1:0] orv  = a | b;
wire [1:0] shl  = {a[0],1'b0};
wire [1:0] shr  = {1'b0,a[1]};
wire [1:0] inv  = ~a;

always @(*) begin
    case(op)
        3'b000: y = add;
        3'b001: y = sub;
        3'b010: y = xorv;
        3'b011: y = andv;
        3'b100: y = orv;
        3'b101: y = shl;
        3'b110: y = shr;
        default: y = inv;
    endcase
end

endmodule
