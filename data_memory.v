//author Mohd. Faizaan Qureshi

module data_memory (
	
	input clk,
	input [15:0] mem_access_addr,
	input [15:0] mem_write_data,
	input mem_write_en, mem_read,
	output [15:0] mem_read_data
);


reg [15:0] ram_array [0:63];

initial begin

//////////////// this is for test_prog 1, 2, 3, 6 //////////////////////
//	ram_array[0] = 1;
//	ram_array[1] = 3;
//	ram_array[2] = 5;
//	ram_array[3] = 7;
//	ram_array[4] = 9;
//	ram_array[5] = 11;
//	ram_array[6] = 13;
//	ram_array[7] = 7;
//	ram_array[8] = 17;
//	ram_array[9] = 19;
//	ram_array[10] = 21;
//	ram_array[11] = 23;

//////////////// this is for test_prog 8 //////////////////////
//	ram_array[0] = 1;
//	ram_array[1] = 5;
//	ram_array[2] = 5;
//	ram_array[3] = 7;
//	ram_array[4] = 9;
//	ram_array[5] = 11;
//	ram_array[6] = 13;
//	ram_array[7] = 15;
//	ram_array[8] = 17;
//	ram_array[9] = 19;
//	ram_array[10] = 21;
//	ram_array[11] = 23;
//	ram_array[12] = 20;
	
////////////////// this data is for test_prog 4 //////////////////
//	ram_array[1] = 2;
//	ram_array[2] = 3;
//	ram_array[3] = 15;
	
/////////////////// this data is for test_prog 7 ///////////////////
//	ram_array[1] = 1;
//	ram_array[2] = 15;
	
//////////////////// this data is for test_prog 5 //////////////////
//	ram_array[0] = 16'h0008;
//	ram_array[1] = 16'h0009;
//	ram_array[2] = 16'h0003;
//	ram_array[3] = 16'h0004;
//	ram_array[4] = 16'h001A;
//	ram_array[5] = 16'h0006;
//	ram_array[6] = 16'h0007;
//	ram_array[7] = 16'h0008;
//	ram_array[8] = 16'h0009;
//	ram_array[9] = 16'h000A;
//	ram_array[10] = 16'h000B;

////////////////// this data is for test_prog 9 //////////////////
	ram_array[1] = 1;
	ram_array[2] = 5;
	ram_array[3] = 3;
	ram_array[4] = 5;
	ram_array[5] = 1;
	ram_array[6] = 2;
	ram_array[7] = 4;
end
			
//always @(*)
//	if (mem_write_en)
//		ram_array[mem_access_addr] <= mem_write_data;
always @(posedge clk)
	if (mem_write_en)
		ram_array[mem_access_addr] <= mem_write_data;
//always @(posedge mem_write_en)
//	ram_array[mem_access_addr] <= mem_write_data;
//always @(posedge clk, posedge mem_write_en)
//	if (mem_write_en)
//		ram_array[mem_access_addr] <= mem_write_data;


//always @(*)
//	if (mem_read)
//		mem_read_data <= ram_array[mem_access_addr];
assign mem_read_data = (mem_read==1'b1) ? ram_array[mem_access_addr] : 16'd0;

endmodule 