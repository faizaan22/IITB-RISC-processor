//author Mohd. Faizaan Qureshi

module alu_adder(

	input [15:0] a,b,
	output [15:0] alu_result
);

assign alu_result = a + b;

endmodule 