//author Mohd. Faizaan Qureshi

module register_file1 (
	
	input clk, rst, reg_write_en,
	input [2:0] reg_write_dest,
	input [15:0] reg_write_data,
	input [2:0] reg_read_addr_1,
	output [15:0] reg_read_data_1,
	input [2:0] reg_read_addr_2,
	output [15:0] reg_read_data_2,
	input pc_enable_value,
	output [15:0] pc_value_out,
	input condition1, condition2, condition3, condition4, condition5, condition6, condition7, condition8, condition9,
	input [15:0] value1, value2, value3, value4, value5, value6, value7, value8, value9, value10
);

reg [15:0] reg_array [0:7];
integer i = 0;

assign  reg_read_data_1 = reg_array[reg_read_addr_1];
assign  reg_read_data_2 = reg_array[reg_read_addr_2];

assign pc_value_out = reg_array[7];

initial
begin
	for(i=0;i<8;i=i+1)
			reg_array[i] = 0;
	
//	reg_array[1] = 3;
//	reg_array[2] = 14;
//	reg_array[3] = 15;
//	reg_array[4] = 20;
end

//always @(posedge clk, posedge rst)
//begin
//	if (rst)
//		for(i=0;i<8;i=i+1)
//			reg_array[i] = 0;
//	else begin
//		if (pc_enable_value)
//			//reg_array[7] <= pc_value;
//			if (match_sig)
//				reg_array[7] <= bta;
//			else if (condition1)
//				reg_array[7] <= value1;
//			else if (condition2)
//				reg_array[7] <= value2;
//			else if (reg_write_en1)
//				reg_array[7] <= value4;
//			else
//				reg_array[7] <= value3;
//		if (reg_write_en & (~ (& reg_write_dest)))
//			reg_array[reg_write_dest] <= reg_write_data;
//	end
//end

always @(posedge clk, posedge rst)
begin
	if (rst)
		for(i=0;i<8;i=i+1)
			reg_array[i] = 0;
	else begin
		if (pc_enable_value)
			if (condition1)
				reg_array[7] <= value1;
			else if (condition2)
				reg_array[7] <= value2;
			else if (condition3)
				reg_array[7] <= value3;
			else if (condition4)
				reg_array[7] <= value4;
			else if (condition5)
				reg_array[7] <= value5;
			else if (condition6)
				reg_array[7] <= value6;
			else if (condition7)
				reg_array[7] <= value7;
			else if (condition8)
				reg_array[7] <= value8;
			else if (condition9)
				reg_array[7] <= value9;
			else
				reg_array[7] <= value10;
		if (reg_write_en & (~ (& reg_write_dest)))
			reg_array[reg_write_dest] <= reg_write_data;
	end
end


endmodule 