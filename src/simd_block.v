module simd_block (
    input [7:0] d,
    input [2:0] op,
    output [7:0] y
);

wire [1:0] y0,y1,y2,y3;

lane_alu L0(d[1:0], d[3:2], op, y0);
lane_alu L1(d[3:2], d[5:4], op, y1);
lane_alu L2(d[5:4], d[7:6], op, y2);
lane_alu L3(d[7:6], d[1:0], op, y3);

assign y = {y3,y2,y1,y0};

endmodule
