//author Mohd. Faizaan Qureshi

module alu1 (

	input [15:0] a,b,
	input carry_flag, zero_flag,
	input [2:0] alu_control,
	output [15:0] alu_result,
	output reg zero, carry, modify_reg_write
);

reg [15:0] result;

//always @(*)
//begin
//	carry <= carry_flag;
//	modify_reg_write <= 1'b0;
//	case(alu_control)
//		3'b000: {carry,result} <= $signed(a)+$signed(b);	//ADD
//		3'b010:
//			begin
//				{carry,result} <= $signed(a)+$signed(b);	//ADC
//				if(carry_flag)
//					modify_reg_write <= 1'b0;
//					//new_reg_write_sig <= 1'b0;	//not needed, direct apply 0 to mux
//				else
//					modify_reg_write <= 1'b1;	//means , make reg_write to 0, we are not writing into reg, since condition fails
//					//new_reg_write_sig <= 1'b0;
//			end
//		3'b001:
//			begin
//				{carry,result} <= $signed(a)+$signed(b);	//ADZ
//				if(zero_flag)
//					modify_reg_write <= 1'b0;
//					//new_reg_write_sig <= 1'b0;	//not needed, direct apply 0 to mux
//				else
//					modify_reg_write <= 1'b1;
//					//new_reg_write_sig <= 1'b0;
//			end
//		3'b011: {carry, result} <= $signed(a)+$signed(b << 1);	//ADL
//		3'b100: result <= ~(a & b);	//NDU
//		3'b110:
//			begin
//				result <= ~(a & b);	//NDC
//				if(carry_flag)
//					modify_reg_write <= 1'b0;
//				else
//					modify_reg_write <= 1'b1;
//			end
//		3'b101:
//			begin
//				result <= ~(a & b);	//NDZ
//				if(zero_flag)
//					modify_reg_write <= 1'b0;
//				else
//					modify_reg_write <= 1'b1;
//			end
//		3'b111: result <= $signed(a)-$signed(b);	//sub
//		
//		default: result <= $signed(a)+$signed(b);
//	endcase
//end

always @(*)
begin
	carry <= carry_flag;
	modify_reg_write <= 1'b0;
	case(alu_control)
		3'b000: {carry,result} <= a + b;	//ADD
		3'b010:
			begin
				{carry,result} <= a + b;	//ADC
				if(carry_flag)
					modify_reg_write <= 1'b0;
					//new_reg_write_sig <= 1'b0;	//not needed, direct apply 0 to mux
				else
					modify_reg_write <= 1'b1;	//means , make reg_write to 0, we are not writing into reg, since condition fails
					//new_reg_write_sig <= 1'b0;
			end
		3'b001:
			begin
				{carry,result} <= a + b;	//ADZ
				if(zero_flag)
					modify_reg_write <= 1'b0;
					//new_reg_write_sig <= 1'b0;	//not needed, direct apply 0 to mux
				else
					modify_reg_write <= 1'b1;
					//new_reg_write_sig <= 1'b0;
			end
		3'b011: {carry, result} <= a + (b << 1);	//ADL
		3'b100: result <= ~(a & b);	//NDU
		3'b110:
			begin
				result <= ~(a & b);	//NDC
				if(carry_flag)
					modify_reg_write <= 1'b0;
				else
					modify_reg_write <= 1'b1;
			end
		3'b101:
			begin
				result <= ~(a & b);	//NDZ
				if(zero_flag)
					modify_reg_write <= 1'b0;
				else
					modify_reg_write <= 1'b1;
			end
		3'b111: result <= a - b;	//sub
		
		default: result <= a + b;
	endcase
end


//assign zero = (result==0) ? 1'b1 : 1'b0;
//always @(*)
//	if (~(& alu_control))
//		if(result==0)
//			zero <= 1'b1;
//		else
//			zero <= 1'b0;
//	else
//		zero <= zero_flag;
always @(*)
	if(result==0)
		zero <= 1'b1;
	else
		zero <= 1'b0;

assign alu_result = result;

endmodule 