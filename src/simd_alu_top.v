module simd_alu_top (
    input clk,
    input rst_n,
    input [7:0] ui_in,
    output [7:0] uo_out
);

// Registered opcode (important)
reg [2:0] op;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) op <= 0;
    else op <= {ui_in[7:6], ui_in[0]};
end

// -------- Scrambled Inputs --------
wire [7:0] d0 = ui_in;
wire [7:0] d1 = ui_in ^ 8'hA5;
wire [7:0] d2 = ui_in ^ 8'h3C;
wire [7:0] d3 = {ui_in[3:0], ui_in[7:4]};
wire [7:0] d4 = ~ui_in;
wire [7:0] d5 = {ui_in[6:0], ui_in[7]};
wire [7:0] d6 = {ui_in[0], ui_in[7:1]};
wire [7:0] d7 = ui_in ^ 8'hFF;

// -------- SIMD blocks --------
wire [7:0] y0,y1,y2,y3,y4,y5,y6,y7;

simd_block B0(d0,op,y0);
simd_block B1(d1,op,y1);
simd_block B2(d2,op,y2);
simd_block B3(d3,op,y3);
simd_block B4(d4,op,y4);
simd_block B5(d5,op,y5);
simd_block B6(d6,op,y6);
simd_block B7(d7,op,y7);

// -------- Reduction --------
wire [7:0] mix1 = y0 ^ y1 ^ y2 ^ y3;
wire [7:0] mix2 = y4 ^ y5 ^ y6 ^ y7;

wire [7:0] sum  = mix1 + mix2;
wire [7:0] mix3 = (y0 + y3) ^ (y4 + y7);

// -------- Pipeline --------
reg [7:0] p1,p2,p3,p4,p5;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        p1<=0; p2<=0; p3<=0; p4<=0; p5<=0;
    end else begin
        p1 <= sum ^ mix3;
        p2 <= p1 + mix1;
        p3 <= p2 ^ mix2;
        p4 <= p3 ^ p1;
        p5 <= p4 + mix1;
    end
end

// -------- FSM --------
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) state <= 0;
    else state <= state + 1;
end

// -------- Output --------
assign uo_out = (state==2'b00) ? p5 :
                (state==2'b01) ? (p5 ^ 8'hAA) :
                (state==2'b10) ? (p5 + 8'h33) :
                                 (p5 ^ (p1>>1));

endmodule
