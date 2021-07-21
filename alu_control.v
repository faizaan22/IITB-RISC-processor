//author Mohd. Faizaan Qureshi

module alu_control (

	input [1:0] aluop,
	input [1:0] condition_cz,
	output reg [2:0] alu_control
);

always @(*)
	case(aluop)
		2'b00: alu_control <= {1'b0, condition_cz};	//for add type inst
		2'b01: alu_control <= {1'b1, condition_cz};	// for nand type inst
		2'b10: alu_control <= 3'b000;	//addition
		2'b11: alu_control <= 3'b111;	//subtraction
		default: alu_control <= 3'b000;
	endcase

endmodule 