module PC_control(C, I, F, PC_in, PC_out);

input [2:0] C, F;
input [8:0] I;
input [15:0] PC_in;

output [15:0] PC_out;

wire [8:0] I_shift;
wire [15:0] branch_take, normal_pc, I_input;

assign I_shift = I << 1;

assign I_input = (I_shift[8]==1'b0) ? {7'b0000000, I_shift} :
				 (I_shift[8]==1'b1)	? {7'b1111111, I_shift} :
				 16'h0000;

add_16bit INC_PC(.Sum(normal_pc), .A(PC_in), .B(16'h0002));
add_16bit BRANCH_PC(.Sum(branch_take), .A(normal_pc), .B(I_input));

assign PC_out = (C==3'b000 && F[0]==1'b0) ? branch_take : 
				(C==3'b001 && F[0]==1'b1) ? branch_take : 
				(C==3'b010 && F[0]==1'b0 && F[2]==1'b0) ? branch_take : 
				(C==3'b011 && F[2]==1'b1) ? branch_take :
				(C==3'b100 && (F[0]==1'b1 || (F[0]==1'b0 && F[2]==1'b0))) ? branch_take :
				(C==3'b101 && (F[0]==1'b1 || F[2]==1'b1)) ? branch_take : 
				(C==3'b110 && F[1]==1'b1) branch_take :
				(C==3'b111) branch_take :
				normal_pc;

endmodule