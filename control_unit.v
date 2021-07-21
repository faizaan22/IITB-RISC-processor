//author Mohd. Faizaan Qureshi

module control_unit (
	input reset,
	input [3:0] opcode,
	output reg t3_sel, branch, jump, load, sig_multiple, sig_all, mem_read, mem_write, reg_write, mem_write_sig, reg_write_sig,
	output reg [1:0] alu1_src, alu1_op, jump_type, reg_src1, reg_write_data_sel, reg_write_addr_sel
);

always @(reset, opcode)
begin
	if (reset)
	begin
		alu1_src <= 2'b00;
		alu1_op <= 2'b00;
		t3_sel <= 1'b0;
		load <= 1'b0;
		sig_multiple <= 1'b0;
		sig_all <= 1'b0;
		branch <= 1'b0;
		jump <= 1'b0;
		jump_type <= 2'b00;
		reg_src1 <= 2'b00;
		mem_read <= 1'b0;
		mem_write <= 1'b0;
		mem_write_sig <= 1'b0;
		reg_write <= 1'b0;
		reg_write_sig <= 1'b0;
		reg_write_data_sel <= 2'b00;
		reg_write_addr_sel <= 2'b00;
	end
	else
	begin
		case (opcode)
			// ADD like inst
			4'b0001:
				begin
					alu1_src <= 2'b00;
					alu1_op <= 2'b00;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b1;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b10;
				end
			// ADI
			4'b0000:
				begin
					alu1_src <= 2'b01;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b1;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b00;
				end
			// NDU like inst
			4'b0010:
				begin
					alu1_src <= 2'b00;
					alu1_op <= 2'b01;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b1;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b10;
				end
			// LHI
			4'b0011:
				begin
					alu1_src <= 2'b00;
					alu1_op <= 2'b10;
					t3_sel <= 1'b1;
					load <= 1'b1;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b1;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b1;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b01;
					reg_write_addr_sel <= 2'b01;
				end
			// LW
			4'b0100:
				begin
					alu1_src <= 2'b01;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b1;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b01;
					mem_read <= 1'b1;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b1;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b01;
					reg_write_addr_sel <= 2'b01;
				end
			// SW
			4'b0101:
				begin
					alu1_src <= 2'b01;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b1;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b0;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b00;
				end
			// LM
			4'b1100:
				begin
					alu1_src <= 2'b11;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b1;
					sig_multiple <= 1'b1;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b1;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b0;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b11;
					reg_write_addr_sel <= 2'b11;
				end
			// SM
			4'b1101:
				begin
					alu1_src <= 2'b11;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b1;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b0;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b00;
				end
			// LA
			4'b1110:
				begin
					alu1_src <= 2'b11;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b1;
					sig_multiple <= 1'b0;
					sig_all <= 1'b1;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b1;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b0;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b11;
					reg_write_addr_sel <= 2'b11;
				end
			// SA
			4'b1111:
				begin
					alu1_src <= 2'b11;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b1;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b0;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b00;
				end
			// BEQ
			4'b1000:
				begin
					alu1_src <= 2'b00;
					alu1_op <= 2'b11;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b1;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b0;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b00;
				end
			// JAL
			4'b1001:
				begin
					alu1_src <= 2'b00;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b1;
					jump_type <= 2'b01;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b1;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b10;
					reg_write_addr_sel <= 2'b01;
				end
			// JLR
			4'b1010:
				begin
					alu1_src <= 2'b00;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b1;
					jump_type <= 2'b10;
					reg_src1 <= 2'b01;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b1;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b10;
					reg_write_addr_sel <= 2'b01;
				end
			// JRI
			4'b1011:
				begin
					alu1_src <= 2'b10;
					alu1_op <= 2'b10;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b1;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b0;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b00;
				end
			default:
				begin
					alu1_src <= 2'b00;
					alu1_op <= 2'b00;
					t3_sel <= 1'b0;
					load <= 1'b0;
					sig_multiple <= 1'b0;
					sig_all <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					jump_type <= 2'b00;
					reg_src1 <= 2'b00;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					mem_write_sig <= 1'b0;
					reg_write <= 1'b0;
					reg_write_sig <= 1'b0;
					reg_write_data_sel <= 2'b00;
					reg_write_addr_sel <= 2'b00;
				end
		endcase
	end
end

endmodule 