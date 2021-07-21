module processor3 (
	input clk, reset
);

reg [15:0] pc_current = 16'd0;
reg pc_enable = 1'b1;

wire [15:0] IWR, pc_1, alu3_src2_value, alu3_out, sign_extended_6_id, sign_extended_9_id;
wire [15:0] T1, T2, alu1_out, sign_extended_6_ex, sign_extended_9_ex, T3, alu1_src2_4, T4;
wire [15:0] lhi_format;

reg [15:0] reg_addr1, pc_2, alu1_src2_value, pc_3, rfd3;

wire [2:0] temp_addr, alu_control_signal;
reg [2:0] rfa3;

wire t3_sel, branch, jump, load, sig_multiple, sig_all, mem_read, mem_write, reg_write;
wire [1:0] alu1_src, alu1_op, jump_type, reg_src1, reg_write_data_sel, reg_write_addr_sel;

reg carry_flag, zero_flag;

wire carry, zero, modify_reg_write, new_reg_write;


wire stall_condition_sp;
wire r_type_id, sw_id, br_id, sig_mult_or_all_id, adi_instr, store_multiple_id, store_all_id; 

wire [2:0] ra_id, ra_ex, ra_mem, ra_wb, rb_id, rb_ex, rb_mem, rb_wb, rc_ex, rc_mem, rc_wb;

wire r_type_ex, r_type_mem, r_type_wb;

wire condition1_t1_r1, condition1_t1_r2, condition1_t1_r;
wire condition2_t1_r1, condition2_t1_r2, condition2_t1_r;
wire condition3_t1_r1, condition3_t1_r2, condition3_t1_r;

wire condition1_t2_r1, condition1_t2_r2, condition1_t2_r3, condition1_t2_r;
wire condition2_t2_r1, condition2_t2_r2, condition2_t2_r3, condition2_t2_r;
wire condition3_t2_r1, condition3_t2_r2, condition3_t2_r3, condition3_t2_r;

wire [15:0] value_from_ex_to_id_r, value_from_mem_to_id_r, value_from_wb_to_id_r;

wire lw_lhi_ex, lw_lhi_mem, lw_lhi_wb;

wire stall_condition_t1_lw_lhi1, stall_condition_t1_lw_lhi2, stall_condition_t1_lw_lhi;
wire condition1_t1_lw_lhi1, condition1_t1_lw_lhi2, condition1_t1_lw_lhi;
wire condition2_t1_lw_lhi1, condition2_t1_lw_lhi2, condition2_t1_lw_lhi;

wire stall_condition_t2_lw_lhi1, stall_condition_t2_lw_lhi2, stall_condition_t2_lw_lhi3, stall_condition_t2_lw_lhi;
wire condition1_t2_lw_lhi1, condition1_t2_lw_lhi2, condition1_t2_lw_lhi3, condition1_t2_lw_lhi;
wire condition2_t2_lw_lhi1, condition2_t2_lw_lhi2, condition2_t2_lw_lhi3, condition2_t2_lw_lhi;

wire [15:0] value_from_mem_to_id_lw_lhi, value_from_wb_to_id_lw_lhi;

wire jal_jlr_ex, jal_jlr_mem, jal_jlr_wb;
wire condition1_t1_jal_jlr1, condition1_t1_jal_jlr2, condition1_t1_jal_jlr;
wire condition2_t1_jal_jlr1, condition2_t1_jal_jlr2, condition2_t1_jal_jlr;
wire condition3_t1_jal_jlr1, condition3_t1_jal_jlr2, condition3_t1_jal_jlr;
wire condition1_t2_jal_jlr1, condition1_t2_jal_jlr2, condition1_t2_jal_jlr3, condition1_t2_jal_jlr;
wire condition2_t2_jal_jlr1, condition2_t2_jal_jlr2, condition2_t2_jal_jlr3, condition2_t2_jal_jlr;
wire condition3_t2_jal_jlr1, condition3_t2_jal_jlr2, condition3_t2_jal_jlr3, condition3_t2_jal_jlr;
wire [15:0] value_from_ex_to_id_jal_jlr, value_from_mem_to_id_jal_jlr, value_from_wb_to_id_jal_jlr;

wire lm_ex, lm_mem;
wire condition1_t1_lm1, condition1_t1_lm2, condition1_t1_lm;
wire condition2_t1_lm1, condition2_t1_lm2,  condition2_t1_lm3, condition2_t1_lm4, condition2_t1_lm;
wire condition1_t2_lm1, condition1_t2_lm2, condition1_t2_lm3, condition1_t2_lm;
wire condition2_t2_lm1, condition2_t2_lm2, condition2_t2_lm3, condition2_t2_lm4, condition2_t2_lm5, condition2_t2_lm6, condition2_t2_lm;
wire [15:0] value_from_mem_to_id_lm, value_from_wb_to_id_lm;

wire la_ex, la_mem;
wire condition1_t1_la1, condition1_t1_la2, condition1_t1_la;
wire condition2_t1_la1, condition2_t1_la2, condition2_t1_la3, condition2_t1_la4, condition2_t1_la;
wire condition1_t2_la1, condition1_t2_la2, condition1_t2_la3, condition1_t2_la;
wire condition2_t2_la1, condition2_t2_la2, condition2_t2_la3, condition2_t2_la4, condition2_t2_la5, condition2_t2_la6, condition2_t2_la;

wire [15:0] value_from_mem_to_id_la, value_from_wb_to_id_la;

wire adi_ex, adi_mem, adi_wb;
wire condition1_t1_adi1, condition1_t1_adi2, condition1_t1_adi;
wire condition2_t1_adi1, condition2_t1_adi2, condition2_t1_adi;
wire condition3_t1_adi1, condition3_t1_adi2, condition3_t1_adi;
wire condition1_t2_adi1, condition1_t2_adi2, condition1_t2_adi3, condition1_t2_adi;
wire condition2_t2_adi1, condition2_t2_adi2, condition2_t2_adi3, condition2_t2_adi;
wire condition3_t2_adi1, condition3_t2_adi2, condition3_t2_adi3, condition3_t2_adi;
wire [15:0] value_from_ex_to_id_adi, value_from_mem_to_id_adi, value_from_wb_to_id_adi;


/////
wire store_all_ex, store_all_mem;
/////

////////////////////////
reg [2:0] reg_addr2, counter_store_multiple, counter_store_all, k_multiple, k_all;
reg counter_store_multiple_en, counter_store_all_en, k_multiple_en, k_all_en, reg_write_sp;
reg shift_reg_store_en, mem_write_sp, shift_reg_load_en, counter_load_multiple_en, counter_load_all_en;
reg [7:0] shift_reg_store, shift_reg_load;
reg [2:0] counter_load, counter_load_multiple, counter_load_all;
wire [15:0] alu1_src1_value;
wire alu1_extra_control_sig;

//////////////////////

reg flush_condition_ex;
wire flush_condition_id;

reg [15:0] T1_new, T2_new;

reg reg_if_id_en = 1'b1;
reg reg_id_ex_en = 1'b1;
reg reg_ex_mem_en = 1'b1;
reg reg_mem_wb_en = 1'b1;

reg [48:0] IF_ID_reg = 49'b0;
reg [115:0] ID_EX_reg = 116'b0;
reg [79:0] EX_MEM_reg = 80'b0;
reg [77:0] MEM_WB_reg = 78'b0;

reg [33:0] look_up_table_branch [0:7];
reg [2:0] look_up_table_branch_top;

reg [1:0] fsm_table [0:7];

reg flag1, flag2, flag3, match_sig;
//reg [2:0] i;
integer i;
integer i_var;
reg [15:0] bta;

initial
begin
	for(i=0; i<8; i=i+1)
		look_up_table_branch[i] = 0;
	
	look_up_table_branch_top = 0;
	
	fsm_table[0] = 2'b00;
	fsm_table[1] = 2'b01;
	fsm_table[2] = 2'b00;
	fsm_table[3] = 2'b11;
	fsm_table[4] = 2'b00;
	fsm_table[5] = 2'b11;
	fsm_table[6] = 2'b10;
	fsm_table[7] = 2'b11;
	
	pc_current = 0;
	IF_ID_reg = 0;
	ID_EX_reg = 0;
	EX_MEM_reg = 0;
	MEM_WB_reg = 0;
	carry_flag = 0;
	zero_flag = 0;
	
	counter_load_all = 0;
	counter_load_multiple = 0;
	counter_store_all = 0;
	counter_store_multiple = 0;
	k_multiple = 0;
	k_all = 0;
	
	counter_load_all_en = 1'b0;
	counter_load_multiple_en = 1'b0;
	counter_store_all_en = 1'b0;
	counter_store_multiple_en = 1'b0;
	k_multiple_en = 1'b0;
	k_all_en = 1'b0;
end

/////////////////// in instruction fetch (IF) state ////////////////

instruction_memory imem (
								.pc(pc_current),
								.instruction(IWR));

always @(*) begin
	flag3 = 0;
	for (i=0; i<8; i=i+1)
		if(flag3 != 1) begin
			if ((look_up_table_branch[i][33:18] == pc_current) && (look_up_table_branch[i][1] == 1'b1)) begin
				bta <= look_up_table_branch[i][17:2];
				match_sig <= 1'b1;
				flag3 = 1;
			end
			else begin
				bta <= 16'd0;
				match_sig <= 1'b0;
			end
		end
end
			
			
								
alu_adder alu2 (.a(pc_current),
						.b(16'd1),
						.alu_result(pc_1));

/////////////////// end of if ////////////////////////

//always @(posedge clk)
//	begin
//		if (reg_if_id_en)
//			begin
//				IF_ID_reg[47:32] <= pc_current;
//				IF_ID_reg[31:16] <= pc_1;
//				IF_ID_reg[15:0] <= IWR;
//			end
//		//pc_current <= pc_1;
//	end

always @(posedge clk)
	begin
		if (reg_if_id_en)
			begin
				if (flush_condition_id | flush_condition_ex)
					IF_ID_reg <= 0;
				else begin
					IF_ID_reg[48] <= match_sig;
					IF_ID_reg[47:32] <= pc_current;
					IF_ID_reg[31:16] <= pc_1;
					IF_ID_reg[15:0] <= IWR;
				end
			end
		//pc_current <= pc_1;
	end

/////////////////// in instruction decode and register read (ID-OF) state //////////////

control_unit cu (
					.reset( reset ),
					.opcode( IF_ID_reg[15:12] ),
					.alu1_src( alu1_src ),
					.alu1_op( alu1_op ),
					.t3_sel( t3_sel ),
					.load( load ),
					.sig_multiple( sig_multiple ),
					.sig_all( sig_all ),
					.branch( branch ),
					.jump( jump ),
					.jump_type( jump_type ),
					.reg_src1( reg_src1 ),
					.mem_read( mem_read ),
					.mem_write( mem_write ),
					.reg_write( reg_write ),
					.reg_write_data_sel( reg_write_data_sel ),
					.reg_write_addr_sel( reg_write_addr_sel )
					);
				
					
alu_adder alu3 (
					.a( IF_ID_reg[47:32] ),		//pc_current
					.b( alu3_src2_value ),		//alu3_src2
					.alu_result( alu3_out )		//alu3_out
					);

// se6 of IWR(5:0)					
assign sign_extended_6_id = {{10{IF_ID_reg[5]}}, IF_ID_reg[5:0]};

// se9 of IWR(8:0)
assign sign_extended_9_id = {{7{IF_ID_reg[8]}}, IF_ID_reg[8:0]};

// control signal is jump_type ans branch
assign alu3_src2_value = (~branch & jump) ? sign_extended_9_id : sign_extended_6_id;

//register_file reg_file (
//								.clk( clk ),
//								.rst( reset ),
//								.reg_write_en( reg_write_sp ),
//								.reg_read_addr_1( reg_addr1 ),		//rf_a1
//								.reg_read_data_1( T1 ),		//rf_d1
//								.reg_read_addr_2( IF_ID_reg[8:6] ),		//rf_a2 = IWR(8:6)
//								.reg_read_data_2( T2 ),		//rf_d2
//								.reg_write_dest( rfa3 ),		//rf_a3
//								.reg_write_data( rfd3 )			//rf_d3
//								);
register_file reg_file (
								.clk( clk ),
								.rst( reset ),
								.reg_write_en( reg_write_sp ),
								.reg_read_addr_1( reg_addr1 ),		//rf_a1
								.reg_read_data_1( T1 ),		//rf_d1
								.reg_read_addr_2( reg_addr2 ),		//rf_a2 = IWR(8:6)
								.reg_read_data_2( T2 ),		//rf_d2
								.reg_write_dest( rfa3 ),		//rf_a3
								.reg_write_data( rfd3 )			//rf_d3
								);


//always @(posedge clk)
//	if (counter_store_multiple == 7)
//		counter_store_multiple_en <= 1'b0;
//	else if (sig_multiple)
//		counter_store_multiple_en <= 1'b1;
always @(posedge clk)
	if ((counter_store_multiple == 7) | (k_multiple == 7))
		counter_store_multiple_en <= 1'b0;
	else if (sig_multiple & (~load))
		counter_store_multiple_en <= 1'b1;
	

//always @(posedge clk)
//	if (counter_store_multiple_en)
//		counter_store_multiple <= counter_store_multiple + 1;

//always @(posedge clk)
//	if (counter_store_multiple_en | (~load & sig_multiple))
//		counter_store_multiple <= counter_store_multiple + 1;
always @(posedge clk)
	if ((counter_store_multiple_en | (~load & sig_multiple)) & (|(k_multiple ^ 3'b111)))
		counter_store_multiple <= counter_store_multiple + 1;


//always @(posedge clk)
//	if (counter_store_all == 6)
//		counter_store_all_en <= 1'b0;
//	else if (sig_all)
//		counter_store_all_en <= 1'b1;
always @(posedge clk)
	if ((counter_store_all == 6) | (k_all == 6))
		counter_store_all_en <= 1'b0;
	else if (sig_all & (~load))
		counter_store_all_en <= 1'b1;
	

//always @(posedge clk)
//	if (counter_store_all_en) begin
//		counter_store_all <= counter_store_all + 1;
//		if (counter_store_all == 6)
//			counter_store_all <= 0;
//	end
//always @(posedge clk)
//	if (counter_store_all_en | (~load & sig_all)) begin
//		counter_store_all <= counter_store_all + 1;
//		if (counter_store_all == 6)
//			counter_store_all <= 0;
//	end
always @(posedge clk)
	if ((counter_store_all_en | (~load & sig_all)) & (|(k_all ^ 3'b110))) begin
		counter_store_all <= counter_store_all + 1;
		if (counter_store_all == 6)
			counter_store_all <= 0;
	end

always @(*)
	if (~load & sig_multiple)
		reg_addr2 <= counter_store_multiple;
	else if (~load & sig_all)
		reg_addr2 <= counter_store_all;
	else
		reg_addr2 <= IF_ID_reg[8:6];

always @(*)
	case (reg_src1)
		2'b00: reg_addr1 <= IF_ID_reg[11:9];
		2'b01: reg_addr1 <= IF_ID_reg[8:6];
		default: reg_addr1 <= IF_ID_reg[11:9];
	endcase

always @(*)
	if ((branch == 1'b1) || (jump_type == 2'b01))
		pc_2 <= alu3_out;
	else if (jump_type == 2'b10)
		pc_2 <= T1;
	else
		pc_2 <= 16'bz;

////
		
always @(posedge clk)
	if (k_multiple == 7)
		k_multiple_en <= 1'b0;
	else if (sig_multiple)
		k_multiple_en <= 1'b1;
	

always @(posedge clk)
	if (k_multiple_en)
		k_multiple <= k_multiple + 1;

always @(posedge clk)
	if (k_all == 6)
		k_all_en <= 1'b0;
	else if (sig_all)
		k_all_en <= 1'b1;

//always @(posedge clk)
//	if ((k_all == 6) | (counter_load_all == 6))
//		k_all_en <= 1'b0;
//	else if (sig_all)
//		k_all_en <= 1'b1;
//	
		
always @(posedge clk)
	if (k_all_en) begin
		k_all <= k_all + 1;
		if (k_all == 6)
			k_all <= 0;
	end
		
////		

//////// Correction of Violation //////////////////

assign stall_condition_sp = (((sig_multiple == 1'b1) && (k_multiple < 7)) || ((sig_all == 1'b1) && (k_all < 6))) ? 1'b1 : 1'b0;
//assign stall_condition_sp = (((sig_multiple == 1'b1) && (k_multiple < 6)) || ((sig_all == 1'b1) && (k_all < 5))) ? 1'b1 : 1'b0;

//always @(*)
//	if (stall_condition_ra_rl | stall_condition_rb_rl | stall_condition_sp) begin
//		pc_enable <= 1'b0;
//		reg_if_id_en <= 1'b0;
//	end
//	else begin
//		pc_enable <= 1'b1;
//		reg_if_id_en <= 1'b1;
//	end

always @(*)
	if (stall_condition_t1_lw_lhi | stall_condition_t2_lw_lhi | stall_condition_sp) begin
		pc_enable <= 1'b0;
		reg_if_id_en <= 1'b0;
	end
	else begin
		pc_enable <= 1'b1;
		reg_if_id_en <= 1'b1;
	end
	

always @(*)
	if (condition1_t1_lw_lhi)
		T1_new <= value_from_mem_to_id_lw_lhi;
	else if (condition2_t1_lw_lhi)
		T1_new <= value_from_wb_to_id_lw_lhi;
	else if (condition1_t1_lm)
		T1_new <= value_from_mem_to_id_lm;
	else if (condition2_t1_lm)
		T1_new <= value_from_wb_to_id_lm;
	else if (condition1_t1_la)
		T1_new <= value_from_mem_to_id_la;
	else if (condition2_t1_la)
		T1_new <= value_from_wb_to_id_la;
	else if (condition1_t1_r)
		T1_new <= value_from_ex_to_id_r;
	else if (condition2_t1_r)
		T1_new <= value_from_mem_to_id_r;
	else if (condition3_t1_r)
		T1_new <= value_from_wb_to_id_r;
	else if (condition1_t1_adi)
		T1_new <= value_from_ex_to_id_adi;
	else if (condition2_t1_adi)
		T1_new <= value_from_mem_to_id_adi;
	else if (condition3_t1_adi)
		T1_new <= value_from_wb_to_id_adi;
	else if (condition1_t1_jal_jlr)
		T1_new <= value_from_ex_to_id_jal_jlr;
	else if (condition2_t1_jal_jlr)
		T1_new <= value_from_mem_to_id_jal_jlr;
	else if (condition3_t1_jal_jlr)
		T1_new <= value_from_wb_to_id_jal_jlr;
	else
		T1_new <= T1;

always @(*)
	if (condition1_t2_lw_lhi)
		T2_new <= value_from_mem_to_id_lw_lhi;
	else if (condition2_t2_lw_lhi)
		T2_new <= value_from_wb_to_id_lw_lhi;
	else if (condition1_t2_lm)
		T2_new <= value_from_mem_to_id_lm;
	else if (condition2_t2_lm)
		T2_new <= value_from_wb_to_id_lm;
	else if (condition1_t2_la)
		T2_new <= value_from_mem_to_id_la;
	else if (condition2_t2_la)
		T2_new <= value_from_wb_to_id_la;
	else if (condition1_t2_r)
		T2_new <= value_from_ex_to_id_r;
	else if (condition2_t2_r)
		T2_new <= value_from_mem_to_id_r;
	else if (condition3_t2_r)
		T2_new <= value_from_wb_to_id_r;
	else if (condition1_t2_adi)
		T2_new <= value_from_ex_to_id_adi;
	else if (condition2_t2_adi)
		T2_new <= value_from_mem_to_id_adi;
	else if (condition3_t2_adi)
		T2_new <= value_from_wb_to_id_adi;
	else if (condition1_t2_jal_jlr)
		T2_new <= value_from_ex_to_id_jal_jlr;
	else if (condition2_t2_jal_jlr)
		T2_new <= value_from_mem_to_id_jal_jlr;
	else if (condition3_t2_jal_jlr)
		T2_new <= value_from_wb_to_id_jal_jlr;
	else
		T2_new <= T2;


///////////////////////////////////////////////////////////

// flush condition

//assign flush_condition_id = (jump & (jump_type[0] ^ jump_type[1]));

assign flush_condition_id = ((jump & (jump_type[0] ^ jump_type[1])) && (~IF_ID_reg[48])) ? 1'b1 : 1'b0;

//////////////////

/////////////////// end of id-of ///////////////////////////////////
	
//always @(posedge clk)
//	if (reg_id_ex_en)
//		begin
//			ID_EX_reg[98:83] <= T1;	//T1
//			ID_EX_reg[82:67] <= T2;	//T2
//			ID_EX_reg[66:51] <= pc_2;	//pc_2
//			ID_EX_reg[50:35] <= IF_ID_reg[31:16];	//pc_1
//			ID_EX_reg[34:19] <= IF_ID_reg[15:0];	//IWR
//			
//			ID_EX_reg[18:17] <= alu1_src;
//			ID_EX_reg[16:15] <= alu1_op;
//			ID_EX_reg[14] <= t3_sel;
//			ID_EX_reg[13] <= load;
//			ID_EX_reg[12] <= branch;
//			ID_EX_reg[11] <= jump;
//			ID_EX_reg[10:9] <= jump_type;
//													//removing reg_src1;
//			ID_EX_reg[8] <= mem_read;
//			ID_EX_reg[7] <= mem_write;
//			ID_EX_reg[6] <= mem_write_sig;
//			ID_EX_reg[5] <= reg_write;
//			ID_EX_reg[4] <= reg_write_sig;
//			ID_EX_reg[3:2] <= reg_write_data_sel;
//			ID_EX_reg[1:0] <= reg_write_addr_sel;
//		end

//always @(posedge clk)
//	if (reg_id_ex_en)
//		begin
//			ID_EX_reg[100:85] <= T1_new;	//T1
//			ID_EX_reg[84:69] <= T2_new;	//T2
//			ID_EX_reg[68:53] <= pc_2;	//pc_2
//			ID_EX_reg[52:37] <= IF_ID_reg[31:16];	//pc_1
//			
//			if (~(sig_multiple ^ sig_all) & (stall_condition_ra_rl | stall_condition_rb_rl))
//				ID_EX_reg[36:0] <= 37'd0;
//			else
//			begin
//				ID_EX_reg[36:21] <= IF_ID_reg[15:0];	//IWR
//				
//				ID_EX_reg[20:19] <= alu1_src;
//				ID_EX_reg[18:17] <= alu1_op;
//				ID_EX_reg[16] <= t3_sel;
//				ID_EX_reg[15] <= load;
//				ID_EX_reg[14] <= sig_multiple;
//				ID_EX_reg[13] <= sig_all;
//				ID_EX_reg[12] <= branch;
//				ID_EX_reg[11] <= jump;
//				ID_EX_reg[10:9] <= jump_type;
//														//removing reg_src1;
//				ID_EX_reg[8] <= mem_read;
//				ID_EX_reg[7] <= mem_write;
//				ID_EX_reg[6] <= mem_write_sig;
//				ID_EX_reg[5] <= reg_write;
//				ID_EX_reg[4] <= reg_write_sig;
//				ID_EX_reg[3:2] <= reg_write_data_sel;
//				ID_EX_reg[1:0] <= reg_write_addr_sel;
//			end
//		end

always @(posedge clk)
	if (reg_id_ex_en)
		begin
			if (flush_condition_ex)
				ID_EX_reg <= 0;
			else begin
				ID_EX_reg[115] <= IF_ID_reg[48];	//match_sig
				ID_EX_reg[114:99] <= IF_ID_reg[47:32];	//pc_current
				
				ID_EX_reg[98:83] <= T1_new;	//T1
				ID_EX_reg[82:67] <= T2_new;	//T2
				ID_EX_reg[66:51] <= pc_2;	//pc_2
				ID_EX_reg[50:35] <= IF_ID_reg[31:16];	//pc_1
				
//				if (~(sig_multiple ^ sig_all) & (stall_condition_ra_rl | stall_condition_rb_rl))
//					ID_EX_reg[34:0] <= 35'd0;
//				else
				if (~(sig_multiple ^ sig_all) & (stall_condition_t1_lw_lhi | stall_condition_t2_lw_lhi)) begin
					ID_EX_reg[34:0] <= 35'd0;
					
					ID_EX_reg[115:35] <= 0;
				end
				else
				begin
					ID_EX_reg[34:19] <= IF_ID_reg[15:0];	//IWR
					
					ID_EX_reg[18:17] <= alu1_src;
					ID_EX_reg[16:15] <= alu1_op;
					ID_EX_reg[14] <= t3_sel;
					ID_EX_reg[13] <= load;
					ID_EX_reg[12] <= sig_multiple;
					ID_EX_reg[11] <= sig_all;
					ID_EX_reg[10] <= branch;
					ID_EX_reg[9] <= jump;
					ID_EX_reg[8:7] <= jump_type;
															//removing reg_src1;
					ID_EX_reg[6] <= mem_read;
					ID_EX_reg[5] <= mem_write;
					ID_EX_reg[4] <= reg_write;
					ID_EX_reg[3:2] <= reg_write_data_sel;
					ID_EX_reg[1:0] <= reg_write_addr_sel;
				end
			end
		end

/////////////////// in execution state (EX) state ////////////////

alu_control alu_control_dut (
										.aluop( ID_EX_reg[16:15] ),
										.condition_cz( ID_EX_reg[20:19] ),
										.alu_control( alu_control_signal )
										);
										
//alu1 alu1_dut (
//					.a( ID_EX_reg[100:85] ),
//					.b( alu1_src2_value ),
//					.carry_flag( carry_flag ),
//					.zero_flag( zero_flag ),
//					.alu_control( alu_control_signal ),
//					.alu_result( alu1_out ),
//					.zero( zero ),
//					.carry( carry ),
//					.modify_reg_write( modify_reg_write )
//					);
alu1 alu1_dut (
					.a( alu1_src1_value ),
					.b( alu1_src2_value ),
					.carry_flag( carry_flag ),
					.zero_flag( zero_flag ),
					.alu_control( alu_control_signal ),
					.alu_result( alu1_out ),
					.zero( zero ),
					.carry( carry ),
					.modify_reg_write( modify_reg_write )
					);

					
//T3 sel
assign T3 = (ID_EX_reg[14]) ? lhi_format : alu1_out;

assign lhi_format = {ID_EX_reg[27:19], 7'b0};

//SE6 of IWR(5:0)					
assign sign_extended_6_ex = {{10{ID_EX_reg[24]}}, ID_EX_reg[24:19]};

//SE6 of IWR(8:0)
assign sign_extended_9_ex = {{7{ID_EX_reg[27]}}, ID_EX_reg[27:19]};

always @(*)
	case (ID_EX_reg[18:17])	//alu1_src
		2'b00: alu1_src2_value <= ID_EX_reg[82:67];	//T2
		2'b01: alu1_src2_value <= sign_extended_6_ex;	//se IWR(5:0)
		2'b10: alu1_src2_value <= sign_extended_9_ex;	//se IWR(8:0)
		2'b11: alu1_src2_value <= alu1_src2_4;		//temp
	endcase

//
assign alu1_src2_4 = (alu1_extra_control_sig) ? 16'd1 : 16'd0;
assign alu1_src1_value = (alu1_extra_control_sig) ? EX_MEM_reg[63:48] : ID_EX_reg[98:83];// ? T3 : T1

///////////////// alert change this according to pipeline reg/////
assign alu1_extra_control_sig = (((sig_multiple ^ sig_all) == 1'b1) && ((k_multiple_en==1'b1 && k_multiple > 0) || (k_all_en==1'b1 && k_all > 0)));
	
//modify_reg_write
assign new_reg_write = (modify_reg_write) ? 1'b0 : ID_EX_reg[4];	//reg_write

// pc_3
always @(*)
	if (ID_EX_reg[10])	//branch
		if (zero)
			pc_3 <= ID_EX_reg[66:51];	// taken (to pc_2)
		else
			pc_3 <= ID_EX_reg[50:35];	//not taken (go to pc_1)
	else if ((ID_EX_reg[9] == 1'b1) && (ID_EX_reg[8:7] == 2'b00))	//jump, jump_type
		pc_3 <= T3;	//T3
	else
		pc_3 <= ID_EX_reg[50:35];	//pc_1
		
///////////////
// flush condition

//assign flush_condition_ex = ((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(| ID_EX_reg[8:7])));

always @(*)
	if (ID_EX_reg[115])		//match_sig in EX
		if (((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(| ID_EX_reg[8:7]))))
			flush_condition_ex <= 1'b0;
		else
			flush_condition_ex <= 1'b1;
	else
		if (((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(| ID_EX_reg[8:7]))))
			flush_condition_ex <= 1'b1;
		else
			flush_condition_ex <= 1'b0;

///////// pc_updation ///////////////

//always @(posedge clk)
//	if(pc_enable)
//		if(jump & (jump_type[0] ^ jump_type[1]))	// jump and jumptype jal, jlr
//			pc_current <= pc_2;
//		else if(ID_EX_reg[12] | (ID_EX_reg[11] & ~(ID_EX_reg[10] | ID_EX_reg[9])))
//			pc_current <= pc_3;
//		else
//			pc_current <= pc_1;

//always @(posedge clk)
//	if(pc_enable)
//		if(jump & (jump_type[0] ^ jump_type[1]))	// jump and jumptype jal, jlr
//			pc_current <= pc_2;
//		else if((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7])))
//			pc_current <= pc_3;
//		else
//			pc_current <= pc_1;

//always @(posedge clk)
//	if(pc_enable)
//		if(match_sig)
//			pc_current <= bta;
//		else if(jump & (jump_type[0] ^ jump_type[1]))	// jump and jumptype jal, jlr
//			pc_current <= pc_2;
//		else if((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7])))
//			pc_current <= pc_3;
//		else
//			pc_current <= pc_1;

always @(posedge clk)
	if(pc_enable)
		if(match_sig)
			pc_current <= bta;
		else if(~IF_ID_reg[48] & (jump & (jump_type[0] ^ jump_type[1])))	// jump and jumptype jal, jlr
			pc_current <= pc_2;
//		else if(ID_EX_reg[115] ^ ((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7]))))
//			pc_current <= pc_3;
		else if ((ID_EX_reg[10] & (ID_EX_reg[115] ^ zero)) | (~ID_EX_reg[115] & (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7]))))		// (branch & (taken ^ match_sig)) | (~match_sig & jump condition)
			pc_current <= pc_3;
		else
			pc_current <= pc_1;
		
		
///////////look_up_table updation //////////////////

always @(posedge clk) begin
	if (jump & (jump_type[0] ^ jump_type[1])) begin		// jump and jumptype jal, jlr
		flag1 = 0;
		for(i=0; i<8; i=i+1)
			if(look_up_table_branch[i][33:18] == IF_ID_reg[47:32])	// match with pc of instr
				flag1 = 1;
		if (flag1 == 0) begin
			look_up_table_branch[look_up_table_branch_top] <= {IF_ID_reg[47:32], pc_2, 2'b11};	//pc, bta, hb
			look_up_table_branch_top <= look_up_table_branch_top + 1;
		end
	end
	else if ((ID_EX_reg[10]) | (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7]))) begin
		flag2 = 0;
		for(i=0; i<8; i=i+1)
			if(look_up_table_branch[i][33:18] == ID_EX_reg[114:99]) begin	// match with pc of instr
				flag2 = 1;
				i_var = i;
				$display("time = %0t, i = %d",$time, i);
			end
		if (flag2 == 0) begin
			//look_up_table_branch[look_up_table_branch_top] <= {ID_EX_reg[114:99], ID_EX_reg[66:51], ((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7]))), ~((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7])))};	//pc, bta, hb
			look_up_table_branch_top <= look_up_table_branch_top + 1;
			if (ID_EX_reg[10])
				look_up_table_branch[look_up_table_branch_top] <= {ID_EX_reg[114:99], ID_EX_reg[66:51], (ID_EX_reg[10] & zero), ~(ID_EX_reg[10] & zero)};	//pc, bta, hb
			else
				look_up_table_branch[look_up_table_branch_top] <= {ID_EX_reg[114:99], T3, 2'b11};	//pc, bta, hb
		end
		else begin
//			if (ID_EX_reg[10] & zero) begin	//branch and zero i.e. taken
//				if (look_up_table_branch[i][1:0] == )
//			end
//			else begin	// not taken
//				//
//			end
			
			look_up_table_branch[i_var][1:0] <= fsm_table[{look_up_table_branch[i_var][1:0], ((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7])))}];
		end
	end
end

/////////////////// end of ex ////////////////////////////////////

always @(posedge clk)
	if (reg_ex_mem_en)
		begin
			carry_flag <= carry;
			
			EX_MEM_reg[79:64] <= ID_EX_reg[82:67];	//T2
			EX_MEM_reg[63:48] <= T3;	//T3
			EX_MEM_reg[47:32] <= ID_EX_reg[50:35];	//pc_1
			EX_MEM_reg[31:16] <= ID_EX_reg[34:19];	//IWR
			
			//control signals
															// removing alu1_src;
			EX_MEM_reg[15:14] <= ID_EX_reg[16:15];			// alu1_op;
															//removing t3_sel;
			EX_MEM_reg[13] <= ID_EX_reg[13];		//load;
			EX_MEM_reg[12] <= ID_EX_reg[12];			//sig_multiple
			EX_MEM_reg[11] <= ID_EX_reg[11];			//sig_all
			EX_MEM_reg[10] <= ID_EX_reg[10];				// branch;
			EX_MEM_reg[9] <= ID_EX_reg[9];				// jump;
			EX_MEM_reg[8:7] <= ID_EX_reg[8:7];				// jump_type;
													//removing reg_src1;
			EX_MEM_reg[6] <= ID_EX_reg[6];		//mem_read;
			EX_MEM_reg[5] <= ID_EX_reg[5];		//mem_write;
			EX_MEM_reg[4] <= new_reg_write;		//reg_write;
			EX_MEM_reg[3:2] <= ID_EX_reg[3:2];	//reg_write_data_sel;
			EX_MEM_reg[1:0] <= ID_EX_reg[1:0];	//reg_write_addr_sel;
		end

//always @(posedge clk)
//	if (reg_ex_mem_en)
//		begin
//			if (flush_condition_ex)
//				EX_MEM_reg <= 0;
//			else begin
//				carry_flag <= carry;
//				
//				EX_MEM_reg[75:60] <= ID_EX_reg[84:69];	//T2
//				EX_MEM_reg[59:44] <= T3;	//T3
//				EX_MEM_reg[43:28] <= ID_EX_reg[52:37];	//pc_1
//				EX_MEM_reg[27:12] <= ID_EX_reg[36:21];	//IWR
//				
//				//control signals
//																// removing alu1_src;
//																// removing alu1_op;
//																//removing t3_sel;
//				EX_MEM_reg[11] <= ID_EX_reg[15];		//load;
//				EX_MEM_reg[10] <= ID_EX_reg[14];			//sig_multiple
//				EX_MEM_reg[9] <= ID_EX_reg[13];			//sig_all
//															//removing branch;
//															//removing jump;
//															// removing jump_type;
//														//removing reg_src1;
//				EX_MEM_reg[8] <= ID_EX_reg[8];		//mem_read;
//				EX_MEM_reg[7] <= ID_EX_reg[7];		//mem_write;
//				EX_MEM_reg[6] <= ID_EX_reg[6];		//mem_write_sig;
//				EX_MEM_reg[5] <= new_reg_write;		//reg_write;
//				EX_MEM_reg[4] <= ID_EX_reg[4];		//reg_write_sig;
//				EX_MEM_reg[3:2] <= ID_EX_reg[3:2];	//reg_write_data_sel;
//				EX_MEM_reg[1:0] <= ID_EX_reg[1:0];	//reg_write_addr_sel;
//			end
//		end
	
always @(posedge clk)
	if (ID_EX_reg[12])	//sig_multiple
		shift_reg_store_en <= 1'b1;
	else
		shift_reg_store_en <= 1'b0;

always @(posedge clk)
	if (shift_reg_store_en)
		shift_reg_store <= shift_reg_store << 1;
	else if (ID_EX_reg[12])		//sig_multiple
		shift_reg_store <= ID_EX_reg[26:19];		//IWR(7:0)

/////////////////// in Memory Access (MEM) state /////////////////

//always @(*)
//	if (EX_MEM_reg[10] & (~EX_MEM_reg[11]))		//sig_multiple and not load
//		mem_write_sp <= shift_reg_store[7];
//	else if (EX_MEM_reg[9] & (~EX_MEM_reg[11]))		//sig_all and not load
//		mem_write_sp <= 1'b1;
//	else
//		mem_write_sp <= EX_MEM_reg[7];

//always @(*)
//	if (EX_MEM_reg[10] & (~EX_MEM_reg[11]))		//sig_multiple and not load
//		mem_write_sp <= shift_reg_store[7];
//	else if ((EX_MEM_reg[9] & (~EX_MEM_reg[11])) & (ID_EX_reg[13] & (~ID_EX_reg[15])))		//sig_all and not load from ID/EX
//		mem_write_sp <= 1'b1;
//	else
//		mem_write_sp <= EX_MEM_reg[7];

always @(*)
	if (EX_MEM_reg[12] & (~EX_MEM_reg[13]))		//sig_multiple and not load
		mem_write_sp <= shift_reg_store[7];
	else if (store_all_ex & store_all_mem)		//sig_all and not load from ID/EX
		mem_write_sp <= 1'b1;
	else
		mem_write_sp <= EX_MEM_reg[5];	//mem_write

data_memory data_memory_dut (
										.clk(clk),
										.mem_access_addr( EX_MEM_reg[63:48] ),	//T3
										.mem_write_data( EX_MEM_reg[79:64] ),			//T2
										.mem_write_en( mem_write_sp ),
										.mem_read( EX_MEM_reg[6] ),
										.mem_read_data( T4 )			//T4
										);

/// updation of zero_flag

always @(posedge clk)
	if (EX_MEM_reg[13])		//load
		zero_flag <= (T4 == 16'd0) ? 1'b1 : 1'b0;
	else
		zero_flag <= zero;
										
/////////////////// end of mem /////////////////////////////////

always @(posedge clk)
	if (reg_mem_wb_en)
		begin
			MEM_WB_reg[77:62] <= EX_MEM_reg[63:48];		//T3
			MEM_WB_reg[61:46] <= T4;		//T4
			MEM_WB_reg[45:30] <= EX_MEM_reg[47:32];		//pc_1
			MEM_WB_reg[29:14] <= EX_MEM_reg[31:16];		//IWR
		
			//control signals
															// removing alu1_src;
			MEM_WB_reg[13:12] <= EX_MEM_reg[15:14];			// alu1_op;
															//removing t3_sel;
			MEM_WB_reg[11] <= EX_MEM_reg[13];		//load;
			MEM_WB_reg[10] <= EX_MEM_reg[12];			// sig_multiple
			MEM_WB_reg[9] <= EX_MEM_reg[11];			// sig_all
			MEM_WB_reg[8] <= EX_MEM_reg[10];				// branch;
			MEM_WB_reg[7] <= EX_MEM_reg[9];				// jump;
			MEM_WB_reg[6:5] <= EX_MEM_reg[8:7];				// jump_type;
													//removing reg_src1;
													// removing mem_read;
													// removing mem_write;
			MEM_WB_reg[4] <= EX_MEM_reg[4];		//reg_write;
			MEM_WB_reg[3:2] <= EX_MEM_reg[3:2];		//reg_write_data_sel;
			MEM_WB_reg[1:0] <= EX_MEM_reg[1:0];		//reg_write_addr_sel;
		end

always @(posedge clk)
	if (EX_MEM_reg[12])	//sig_multiple
		shift_reg_load_en <= 1'b1;
		//shift_reg_load <= EX_MEM_reg[17:10];	//IWR(7:0)
	else
		shift_reg_load_en <= 1'b0;

always @(posedge clk)
	if (shift_reg_load_en)
		shift_reg_load <= shift_reg_load << 1;
	else if (EX_MEM_reg[12])	//sig_multiple
		shift_reg_load <= EX_MEM_reg[23:16];	//IWR(7:0)
		
always @(posedge clk)
	if (counter_load_multiple == 7)
		counter_load_multiple_en <= 1'b0;
	else if (EX_MEM_reg[13] & (EX_MEM_reg[12]))	//load and sig_multiple
		counter_load_multiple_en <= 1'b1;


always @(posedge clk)
	if (counter_load_multiple_en)
		counter_load_multiple <= counter_load_multiple + 1;

always @(posedge clk)
	if (counter_load_all == 6)
		counter_load_all_en <= 1'b0;
	else if (EX_MEM_reg[13] & EX_MEM_reg[11])	//load and sig_all
		counter_load_all_en <= 1'b1;
	

always @(posedge clk)
	if (counter_load_all_en) begin
		counter_load_all <= counter_load_all + 1;
		if (counter_load_all == 6)
			counter_load_all <= 0;
	end

/////////////////// in writeback (WB) state ///////////////////////

//always @(*)
//	if (MEM_WB_reg[7] & MEM_WB_reg[8])		//sig_multiple
//		reg_write_sp <= shift_reg_load[7];
//	else if (MEM_WB_reg[6] & MEM_WB_reg[8])		//sig_all
//		reg_write_sp <= 1'b1;
//	else
//		reg_write_sp <= MEM_WB_reg[5];

always @(*)
	if (MEM_WB_reg[11] & MEM_WB_reg[10])		//load and sig_multiple
		reg_write_sp <= shift_reg_load[7];
	else if ((MEM_WB_reg[11] & MEM_WB_reg[9]) & (EX_MEM_reg[13] & EX_MEM_reg[11]))		//load and sig_all
		reg_write_sp <= 1'b1;
	else
		reg_write_sp <= MEM_WB_reg[4];	//reg_write

always @(*)
	if (MEM_WB_reg[11] & MEM_WB_reg[10])	//load and sig_multiple
		counter_load <= counter_load_multiple;
	else if (MEM_WB_reg[11] & MEM_WB_reg[9])			//load and sig_all
		counter_load <= counter_load_all;
	else
		counter_load <= 0;

always @(*)
	case (MEM_WB_reg[3:2])	//reg_write_data_sel
		2'b00: rfd3 <= MEM_WB_reg[77:62];	//T3
		2'b01: rfd3 <= MEM_WB_reg[61:46];	//T4
		2'b10: rfd3 <= MEM_WB_reg[45:30];	//pc_1
		2'b11: rfd3 <= MEM_WB_reg[61:46];	//tmp = T4
	endcase
	
always @(*)
	case (MEM_WB_reg[1:0])	//reg_write_addr_sel
		2'b00: rfa3 <= MEM_WB_reg[22:20];	//IWR(8:6)
		2'b01: rfa3 <= MEM_WB_reg[25:23];	//IWR(11:9)
		2'b10: rfa3 <= MEM_WB_reg[19:17];	//IWR(5:3)
		2'b11: rfa3 <= counter_load;	//tmp
	endcase

/////////////////// end of wb ////////////////////////////////////

////////////////// Detection ////////////////////////////////

//assign r_type_id = ~alu1_op[1];
assign r_type_id = (~alu1_op[1]) & reg_write;	//alu1_op msb and reg_write
assign sw_id = mem_write;
assign br_id = branch;
assign sig_mult_or_all_id = sig_multiple ^ sig_all;
assign adi_instr = (reg_write & (~load) & (~jump));
//assign load_sig_id = load;
assign store_multiple_id = (~load) & sig_multiple;
assign store_all_id = (~load) & sig_all;

assign store_all_ex = (~ID_EX_reg[13]) & ID_EX_reg[11];
assign store_all_mem = (~EX_MEM_reg[13]) & EX_MEM_reg[11];
//assign store_all_wb = (~MEM_WB_reg[11]) & MEM_WB_reg[9];

assign ra_id = IF_ID_reg[11:9]; //IWR(11:9)
assign ra_ex = ID_EX_reg[30:28];	//IWR(11:9)
assign ra_mem = EX_MEM_reg[27:25];	//IWR(11:9)
assign ra_wb = MEM_WB_reg[25:23];	//IWR(11:9)
assign rb_id = IF_ID_reg[8:6];	//IWR(8:6)
assign rb_ex = ID_EX_reg[27:25];	//IWR(8:6)
assign rb_mem = EX_MEM_reg[24:22];		//IWR(8:6)
assign rb_wb = MEM_WB_reg[22:20];		//IWR(8:6)
assign rc_ex = ID_EX_reg[24:22];	//IWR(5:3)
assign rc_mem = EX_MEM_reg[21:19];	//IWR(5:3)
assign rc_wb = MEM_WB_reg[19:17];	//IWR(5:3)

//////////// first instr is Rtype //////////////////////

//assign r_type_ex = ~ID_EX_reg[16];
//assign r_type_mem = ~EX_MEM_reg[15];
//assign r_type_wb = ~MEM_WB_reg[13];

assign r_type_ex = (~ID_EX_reg[16]) & ID_EX_reg[4];	//(not of msb of alu1_op) & reg_write;
assign r_type_mem = (~EX_MEM_reg[15]) & EX_MEM_reg[4];
assign r_type_wb = (~MEM_WB_reg[13]) & MEM_WB_reg[4];

//t1
assign condition1_t1_r1 = ((ra_id === rc_ex) && (r_type_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_r2 = ((rb_id === rc_ex) && (r_type_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_r = (condition1_t1_r1 | condition1_t1_r2);

assign condition2_t1_r1 = ((ra_id === rc_mem) && (r_type_mem === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_r2 = ((rb_id === rc_mem) && (r_type_mem === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_r = (condition2_t1_r1 | condition2_t1_r2);

assign condition3_t1_r1 = ((ra_id === rc_wb) && (r_type_wb === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t1_r2 = ((rb_id === rc_wb) && (r_type_wb === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t1_r = (condition3_t1_r1 | condition3_t1_r2);

//t2
assign condition1_t2_r1 = ((rb_id === rc_ex) && (r_type_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_r2 = ((counter_store_multiple === rc_ex) && (r_type_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_r3 = ((counter_store_all === rc_ex) && (r_type_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_r = (condition1_t2_r1 | condition1_t2_r2 | condition1_t2_r3);

assign condition2_t2_r1 = ((rb_id === rc_mem) && (r_type_mem === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_r2 = ((counter_store_multiple === rc_mem) && (r_type_mem === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_r3 = ((counter_store_all === rc_mem) && (r_type_mem === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_r = (condition2_t2_r1 | condition2_t2_r2 | condition2_t2_r3);

assign condition3_t2_r1 = ((rb_id === rc_wb) && (r_type_wb === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_r2 = ((counter_store_multiple === rc_wb) && (r_type_wb === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_r3 = ((counter_store_all === rc_wb) && (r_type_wb === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_r = (condition3_t2_r1 | condition3_t2_r2 | condition3_t2_r3);

assign value_from_ex_to_id_r = T3;
assign value_from_mem_to_id_r = EX_MEM_reg[63:48]; //it's also T3 in mem
assign value_from_wb_to_id_r = MEM_WB_reg[77:62]; //it's also T3 in wb

//////////// first instr is lw/lhi //////////////////////

assign lw_lhi_ex = ID_EX_reg[13] & ~(ID_EX_reg[12] ^ ID_EX_reg[11]);
assign lw_lhi_mem = EX_MEM_reg[13] & ~(EX_MEM_reg[12] ^ EX_MEM_reg[11]);
assign lw_lhi_wb = MEM_WB_reg[11] & ~(MEM_WB_reg[10] ^ MEM_WB_reg[9]);

//t1
assign stall_condition_t1_lw_lhi1 = ((ra_id === ra_ex) && (lw_lhi_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign stall_condition_t1_lw_lhi2 = ((rb_id === ra_ex) && (lw_lhi_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign stall_condition_t1_lw_lhi = (stall_condition_t1_lw_lhi1 | stall_condition_t1_lw_lhi2);

assign condition1_t1_lw_lhi1 = ((ra_id === ra_mem) && (lw_lhi_mem === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_lw_lhi2 = ((rb_id === ra_mem) && (lw_lhi_mem === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_lw_lhi = (condition1_t1_lw_lhi1 | condition1_t1_lw_lhi2);

assign condition2_t1_lw_lhi1 = ((ra_id === ra_wb) && (lw_lhi_wb === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_lw_lhi2 = ((rb_id === ra_wb) && (lw_lhi_wb === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_lw_lhi = (condition2_t1_lw_lhi1 | condition2_t1_lw_lhi2);

//t2
assign stall_condition_t2_lw_lhi1 = ((rb_id === ra_ex) && (lw_lhi_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign stall_condition_t2_lw_lhi2 = ((counter_store_multiple === ra_ex) && (lw_lhi_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign stall_condition_t2_lw_lhi3 = ((counter_store_all === ra_ex) && (lw_lhi_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign stall_condition_t2_lw_lhi = (stall_condition_t2_lw_lhi1 | stall_condition_t2_lw_lhi2 | stall_condition_t2_lw_lhi3);

assign condition1_t2_lw_lhi1 = ((rb_id === ra_mem) && (lw_lhi_mem === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_lw_lhi2 = ((counter_store_multiple === ra_mem) && (lw_lhi_mem === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_lw_lhi3 = ((counter_store_all === ra_mem) && (lw_lhi_mem === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_lw_lhi = (condition1_t2_lw_lhi1 | condition1_t2_lw_lhi2 | condition1_t2_lw_lhi3);

assign condition2_t2_lw_lhi1 = ((rb_id === ra_wb) && (lw_lhi_wb === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_lw_lhi2 = ((counter_store_multiple === ra_wb) && (lw_lhi_wb === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_lw_lhi3 = ((counter_store_all === ra_wb) && (lw_lhi_wb === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_lw_lhi = (condition2_t2_lw_lhi1 | condition2_t2_lw_lhi2 | condition2_t2_lw_lhi3);

assign value_from_mem_to_id_lw_lhi = T4;  //T4
assign value_from_wb_to_id_lw_lhi = MEM_WB_reg[61:46];	//it's also T4 in wb

//////////// first instr is jal/jlr/////////////////////////

assign jal_jlr_ex = (^ ID_EX_reg[8:7]);
assign jal_jlr_mem = (^ EX_MEM_reg[8:7]);
assign jal_jlr_wb = (^ MEM_WB_reg[6:5]);

//t1
assign condition1_t1_jal_jlr1 = ((ra_id === ra_ex) && (jal_jlr_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_jal_jlr2 = ((rb_id === ra_ex) && (jal_jlr_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_jal_jlr = (condition1_t1_jal_jlr1 | condition1_t1_jal_jlr2);

assign condition2_t1_jal_jlr1 = ((ra_id === ra_mem) && (jal_jlr_mem === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_jal_jlr2 = ((rb_id === ra_mem) && (jal_jlr_mem === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_jal_jlr = (condition2_t1_jal_jlr1 | condition2_t1_jal_jlr2);

assign condition3_t1_jal_jlr1 = ((ra_id === ra_wb) && (jal_jlr_wb === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t1_jal_jlr2 = ((rb_id === ra_wb) && (jal_jlr_wb === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t1_jal_jlr = (condition3_t1_jal_jlr1 | condition3_t1_jal_jlr2);

//t2
assign condition1_t2_jal_jlr1 = ((rb_id === ra_ex) && (jal_jlr_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_jal_jlr2 = ((counter_store_multiple === ra_ex) && (jal_jlr_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_jal_jlr3 = ((counter_store_all === ra_ex) && (jal_jlr_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_jal_jlr = (condition1_t2_jal_jlr1 | condition1_t2_jal_jlr2 | condition1_t2_jal_jlr3);

assign condition2_t2_jal_jlr1 = ((rb_id === ra_mem) && (jal_jlr_mem === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_jal_jlr2 = ((counter_store_multiple === ra_mem) && (jal_jlr_mem === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_jal_jlr3 = ((counter_store_all === ra_mem) && (jal_jlr_mem === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_jal_jlr = (condition2_t2_jal_jlr1 | condition2_t2_jal_jlr2 | condition2_t2_jal_jlr3);

assign condition3_t2_jal_jlr1 = ((rb_id === ra_wb) && (jal_jlr_wb === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_jal_jlr2 = ((counter_store_multiple === ra_wb) && (jal_jlr_wb === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_jal_jlr3 = ((counter_store_all === ra_wb) && (jal_jlr_wb === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_jal_jlr = (condition3_t2_jal_jlr1 | condition3_t2_jal_jlr2 | condition3_t2_jal_jlr3);

assign value_from_ex_to_id_jal_jlr = ID_EX_reg[50:35];	//pc_1 in ex
assign value_from_mem_to_id_jal_jlr = EX_MEM_reg[47:32]; //pc_1 in mem
assign value_from_wb_to_id_jal_jlr = MEM_WB_reg[45:30]; //pc_1 in wb

////////////////////first instr is lm///////////////////////

assign lm_ex = ID_EX_reg[13] & ID_EX_reg[12];
assign lm_mem = EX_MEM_reg[13] & EX_MEM_reg[12];
//assign lm_wb = MEM_WB_reg[11] & MEM_WB_reg[10];

////t1
//assign condition1_t1_lm1 = ((ra_id === 3'b111) && (lm_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_t1_lm2 = ((rb_id === 3'b111) && (lm_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_t1_lm = (condition1_t1_lm1 | condition1_t1_lm2);
//
//assign condition2_t1_lm1 = ((ra_id === 3'b110) && (lm_mem === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_t1_lm2 = ((rb_id === 3'b110) && (lm_mem === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_t1_lm3 = 
//assign condition2_t1_lm = (condition2_t1_lm1 | condition2_t1_lm2);
//
////t2
//assign condition1_t2_lm1 = ((rb_id === 3'b111) && (lm_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_t2_lm2 = ((counter_store_multiple === 3'b111) && (lm_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_t2_lm3 = ((counter_store_all === 3'b111) && (lm_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_t2_lm = (condition1_t2_lm1 | condition1_t2_lm2 | condition1_t2_lm3);
//
//assign condition2_t2_lm1 = ((rb_id === 3'b110) && (lm_mem === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_t2_lm2 = ((counter_store_multiple === 3'b110) && (lm_mem === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_t2_lm3 = ((counter_store_all === 3'b110) && (lm_mem === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_t2_lm = (condition2_t2_lm1 | condition2_t2_lm2 | condition2_t2_lm3);
//
//assign value_from_mem_to_id_lm = T4;	
//assign value_from_wb_to_id_lm = MEM_WB_reg[61:46];	//it's also T4 in wb

//t1
assign condition1_t1_lm1 = ((ra_id === 3'b111) && (lm_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_lm2 = ((rb_id === 3'b111) && (lm_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_lm = (condition1_t1_lm1 | condition1_t1_lm2);

assign condition2_t1_lm1 = ((ra_id === 3'b110) && (lm_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_lm2 = ((rb_id === 3'b110) && (lm_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_lm3 = ((ra_id === 3'b111) && (lm_mem === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_lm4 = ((rb_id === 3'b111) && (lm_mem === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;

assign condition2_t1_lm = (condition2_t1_lm1 | condition2_t1_lm2 | condition2_t1_lm3 | condition2_t1_lm4);

//t2
assign condition1_t2_lm1 = ((rb_id === 3'b111) && (lm_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_lm2 = ((counter_store_multiple === 3'b111) && (lm_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_lm3 = ((counter_store_all === 3'b111) && (lm_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;

assign condition1_t2_lm = (condition1_t2_lm1 | condition1_t2_lm2 | condition1_t2_lm3);

assign condition2_t2_lm1 = ((rb_id === 3'b110) && (lm_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_lm2 = ((counter_store_multiple === 3'b110) && (lm_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_lm3 = ((counter_store_all === 3'b110) && (lm_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_lm4 = ((rb_id === 3'b111) && (lm_mem === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_lm5 = ((counter_store_multiple === 3'b111) && (lm_mem === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_lm6 = ((counter_store_all === 3'b111) && (lm_mem === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;

assign condition2_t2_lm = (condition2_t2_lm1 | condition2_t2_lm2 | condition2_t2_lm3 | condition2_t2_lm4 | condition2_t2_lm5 | condition2_t2_lm6);

assign value_from_mem_to_id_lm = T4;	
assign value_from_wb_to_id_lm = MEM_WB_reg[61:46];	//it's also T4 in wb

////////////////////first instr is la///////////////////////

assign la_ex = ID_EX_reg[13] & ID_EX_reg[11];
assign la_mem = EX_MEM_reg[13] & EX_MEM_reg[11];

//t1
assign condition1_t1_la1 = ((ra_id === 3'b110) && (la_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_la2 = ((rb_id === 3'b110) && (la_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_la = (condition1_t1_la1 | condition1_t1_la2);

assign condition2_t1_la1 = ((ra_id === 3'b101) && (la_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_la2 = ((rb_id === 3'b101) && (la_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_la3 = ((ra_id === 3'b110) && (la_mem === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_la4 = ((rb_id === 3'b110) && (la_mem === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;

assign condition2_t1_la = (condition2_t1_la1 | condition2_t1_la2 | condition2_t1_la3 | condition2_t1_la4);

//t2
assign condition1_t2_la1 = ((rb_id === 3'b110) && (la_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_la2 = ((counter_store_multiple === 3'b110) && (la_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_la3 = ((counter_store_all === 3'b110) && (la_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;

assign condition1_t2_la = (condition1_t2_la1 | condition1_t2_la2 | condition1_t2_la3);

assign condition2_t2_la1 = ((rb_id === 3'b101) && (la_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_la2 = ((counter_store_multiple === 3'b101) && (la_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_la3 = ((counter_store_all === 3'b101) && (la_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_la4 = ((rb_id === 3'b110) && (la_mem === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_la5 = ((counter_store_multiple === 3'b110) && (la_mem === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_la6 = ((counter_store_all === 3'b110) && (la_mem === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;

assign condition2_t2_la = (condition2_t2_la1 | condition2_t2_la2 | condition2_t2_la3 | condition2_t2_la4 | condition2_t2_la5 | condition2_t2_la6);

assign value_from_mem_to_id_la = T4;	
assign value_from_wb_to_id_la = MEM_WB_reg[61:46];	//it's also T4 in wb

//////////// first instr is ADI //////////////////////

assign adi_ex = ID_EX_reg[4] & (~ID_EX_reg[13]) & (~ID_EX_reg[9]);	//reg_write & (not load) & (not jump)
assign adi_mem = EX_MEM_reg[4] & (~EX_MEM_reg[13]) & (~EX_MEM_reg[9]);
assign adi_wb = MEM_WB_reg[4] & (~MEM_WB_reg[11]) & (~MEM_WB_reg[7]);

//t1
assign condition1_t1_adi1 = ((ra_id === rb_ex) && (adi_ex === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_adi2 = ((rb_id === rb_ex) && (adi_ex === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t1_adi = (condition1_t1_adi1 | condition1_t1_adi2);

assign condition2_t1_adi1 = ((ra_id === rb_mem) && (adi_mem === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_adi2 = ((rb_id === rb_mem) && (adi_mem === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t1_adi = (condition2_t1_adi1 | condition2_t1_adi2);

assign condition3_t1_adi1 = ((ra_id === rb_wb) && (adi_wb === 1'b1) && ((r_type_id | sw_id | br_id | (jump & ~(| jump_type)) | sig_mult_or_all_id | adi_instr) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t1_adi2 = ((rb_id === rb_wb) && (adi_wb === 1'b1) && (((load & (~t3_sel)) | (jump & jump_type[1] & (~jump_type[0]))) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t1_adi = (condition3_t1_adi1 | condition3_t1_adi2);

//t2
assign condition1_t2_adi1 = ((rb_id === rb_ex) && (adi_ex === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_adi2 = ((counter_store_multiple === rb_ex) && (adi_ex === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_adi3 = ((counter_store_all === rb_ex) && (adi_ex === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition1_t2_adi = (condition1_t2_adi1 | condition1_t2_adi2 | condition1_t2_adi3);

assign condition2_t2_adi1 = ((rb_id === rb_mem) && (adi_mem === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_adi2 = ((counter_store_multiple === rb_mem) && (adi_mem === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_adi3 = ((counter_store_all === rb_mem) && (adi_mem === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition2_t2_adi = (condition2_t2_adi1 | condition2_t2_adi2 | condition2_t2_adi3);

assign condition3_t2_adi1 = ((rb_id === rb_wb) && (adi_wb === 1'b1) && ((r_type_id | sw_id | br_id) === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_adi2 = ((counter_store_multiple === rb_wb) && (adi_wb === 1'b1) && (store_multiple_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_adi3 = ((counter_store_all === rb_wb) && (adi_wb === 1'b1) && (store_all_id === 1'b1)) ? 1'b1 : 1'b0;
assign condition3_t2_adi = (condition3_t2_adi1 | condition3_t2_adi2 | condition3_t2_adi3);

assign value_from_ex_to_id_adi = T3;
assign value_from_mem_to_id_adi = EX_MEM_reg[63:48]; //it's also T3 in mem
assign value_from_wb_to_id_adi = MEM_WB_reg[77:62]; //it's also T3 in wb

endmodule 