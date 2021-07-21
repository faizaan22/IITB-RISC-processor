//author Mohd. Faizaan Qureshi

module instruction_memory (

	input [15:0] pc,
	output [15:0] instruction 
);

reg [15:0] ROM [0:20];

initial
begin
//	$readmemb("test_prog1.hex", ROM);
//	$readmemb("test_prog2.hex", ROM);
//	$readmemb("test_prog3.hex", ROM);
//	$readmemb("test_prog4.hex", ROM);
//	$readmemb("test_prog5.hex", ROM);
//	$readmemb("test_prog6.hex", ROM);
//	$readmemb("test_prog7.hex", ROM);
//	$readmemb("test_prog8.hex", ROM);
	$readmemb("test_prog9.hex", ROM);

end

assign instruction = ROM[pc];
endmodule 