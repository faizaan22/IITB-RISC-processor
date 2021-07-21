module register_file (
	
	input clk, rst, reg_write_en,
	input [2:0] reg_write_dest,
	input [15:0] reg_write_data,
	input [2:0] reg_read_addr_1,
	output [15:0] reg_read_data_1,
	input [2:0] reg_read_addr_2,
	output [15:0] reg_read_data_2
);

reg [15:0] reg_array [0:7];
integer i = 0;

assign  reg_read_data_1 = reg_array[reg_read_addr_1];
assign  reg_read_data_2 = reg_array[reg_read_addr_2];

initial
begin
	for(i=0;i<8;i=i+1)
			reg_array[i] = 0;
	
//	reg_array[1] = 3;
//	reg_array[2] = 14;
//	reg_array[3] = 15;
//	reg_array[4] = 20;

//	reg_array[1] = 3;
//	reg_array[2] = 7;
//	reg_array[3] = 15;
//	reg_array[4] = 20;
end

always @(posedge clk, posedge rst)
begin
	if (rst)
		for(i=0;i<8;i=i+1)
			reg_array[i] = 0;
	else
		if (reg_write_en == 1)
			reg_array[reg_write_dest] <= reg_write_data;
//		if (reg_write_en == 1 && reg_write_dest != 0)		// when R0 content is important , not to change
//			reg_array[reg_write_dest] <= reg_write_data;
end


endmodule 