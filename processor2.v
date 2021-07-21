module processor2 (
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

//wire [2:0] ra_id_rr, rb_id_rr, rc_ex_rr, rc_mem_rr, rc_wb_rr;
//
//wire condition1_ra_rr, condition1_rb_rr, condition2_ra_rr, condition2_rb_rr, condition3_ra_rr, condition3_rb_rr;
//
//wire [15:0] value_from_ex_to_id_rr, value_from_mem_to_id_rr, value_from_wb_to_id_rr;
//wire wb_inst_ex, wb_inst_mem, wb_inst_wb;
//
//wire load_sig_id, load_sig_ex, load_sig_mem, load_sig_wb;
//
//
//wire [2:0] ra_id_rl, rb_id_rl, ra_ex_rl, ra_mem_rl, ra_wb_rl;
//wire stall_condition_ra_rl, stall_condition_rb_rl, condition1_ra_rl, condition1_rb_rl, condition2_ra_rl, condition2_rb_rl;
//wire [15:0] value_from_mem_to_id_rl, value_from_wb_to_id_rl;
//
//
//
//wire [2:0] r_id_sm, r_ex_sm, r_mem_sm, r_wb_sm;
//wire condition1_r_sm, condition2_r_sm, condition3_r_sm;
//wire [15:0] value_from_ex_to_id_sm, value_from_mem_to_id_sm, value_from_wb_to_id_sm;
//wire store_multiple_id, store_multiple_ex, store_multiple_mem, store_multiple_wb;
//
//
//wire [2:0] r_id_sa, r_ex_sa, r_mem_sa, r_wb_sa;
//wire store_all_id, store_all_ex, store_all_mem, store_all_wb;
//wire condition1_r_sa, condition2_r_sa, condition3_r_sa;
//wire [15:0] value_from_ex_to_id_sa, value_from_mem_to_id_sa, value_from_wb_to_id_sa;
//
//wire sig_mul_all_ex, sig_mul_all_mem, sig_mul_all_wb;
//
//
//wire [2:0] ra_id_lm, rb_id_lm;
//wire load_mult_ex, load_mult_mem, load_mult_wb;
//wire condition1_ra_lm, condition1_rb_lm, condition2_ra_lm, condition2_rb_lm;
//wire [15:0] value_from_mem_to_id_lm, value_from_wb_to_id_lm;
//
//
//wire [2:0] ra_id_la, rb_id_la;
//wire load_all_ex, load_all_mem, load_all_wb;
//wire condition1_ra_la, condition1_rb_la, condition2_ra_la, condition2_rb_la;
//wire [15:0] value_from_mem_to_id_la, value_from_wb_to_id_la;

////////////////////

wire stall_condition_sp;
wire r_type_id, sw_id, br_id, sig_mult_or_all_id, adi_instr, store_multiple_id, store_all_id; 

wire [2:0] ra_id, ra_ex, ra_mem, ra_wb, rb_id, rc_ex, rc_mem, rc_wb;

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

wire flush_condition_ex, flush_condition_id;

reg [15:0] T1_new, T2_new;

reg reg_if_id_en = 1'b1;
reg reg_id_ex_en = 1'b1;
reg reg_ex_mem_en = 1'b1;
reg reg_mem_wb_en = 1'b1;

reg [47:0] IF_ID_reg = 48'b0;
reg [98:0] ID_EX_reg = 99'b0;
reg [79:0] EX_MEM_reg = 80'b0;
reg [77:0] MEM_WB_reg = 78'b0;

initial
begin
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


//always @(*)
//	if (condition1_ra_rl)
//		T1_new <= value_from_mem_to_id_rl;
//	else if (condition2_ra_rl)
//		T1_new <= value_from_wb_to_id_rl;
//	else if (condition1_ra_rr)
//		T1_new <= value_from_ex_to_id_rr;
//	else if (condition2_ra_rr)
//		T1_new <= value_from_mem_to_id_rr;
//	else if (condition3_ra_rr)
//		T1_new <= value_from_wb_to_id_rr;
//	else
//		T1_new <= T1;

//always @(*)
//	if (condition1_ra_rl)
//		T1_new <= value_from_mem_to_id_rl;
//	else if (condition2_ra_rl)
//		T1_new <= value_from_wb_to_id_rl;
//	else if (condition1_ra_lm)
//		T1_new <= value_from_mem_to_id_lm;
//	else if (condition2_ra_lm)
//		T1_new <= value_from_wb_to_id_lm;
//	else if (condition1_ra_rr)
//		T1_new <= value_from_ex_to_id_rr;
//	else if (condition2_ra_rr)
//		T1_new <= value_from_mem_to_id_rr;
//	else if (condition3_ra_rr)
//		T1_new <= value_from_wb_to_id_rr;
//	else
//		T1_new <= T1;

//always @(*)
//	if (condition1_ra_rl)
//		T1_new <= value_from_mem_to_id_rl;
//	else if (condition2_ra_rl)
//		T1_new <= value_from_wb_to_id_rl;
//	else if (condition1_ra_lm)
//		T1_new <= value_from_mem_to_id_lm;
//	else if (condition2_ra_lm)
//		T1_new <= value_from_wb_to_id_lm;
//	else if (condition1_ra_la)
//		T1_new <= value_from_mem_to_id_la;
//	else if (condition2_ra_la)
//		T1_new <= value_from_wb_to_id_la;
//	else if (condition1_ra_rr)
//		T1_new <= value_from_ex_to_id_rr;
//	else if (condition2_ra_rr)
//		T1_new <= value_from_mem_to_id_rr;
//	else if (condition3_ra_rr)
//		T1_new <= value_from_wb_to_id_rr;
//	else
//		T1_new <= T1;

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
	else if (condition1_t1_jal_jlr)
		T1_new <= value_from_ex_to_id_jal_jlr;
	else if (condition2_t1_jal_jlr)
		T1_new <= value_from_mem_to_id_jal_jlr;
	else if (condition3_t1_jal_jlr)
		T1_new <= value_from_wb_to_id_jal_jlr;
	else
		T1_new <= T1;

//always @(*)
//	if (condition1_rb_rl)
//		T2_new <= value_from_mem_to_id_rl;
//	else if (condition2_rb_rl)
//		T2_new <= value_from_wb_to_id_rl;
//	else if (condition1_rb_rr)
//		T2_new <= value_from_ex_to_id_rr;
//	else if (condition2_rb_rr)
//		T2_new <= value_from_mem_to_id_rr;
//	else if (condition3_rb_rr)
//		T2_new <= value_from_wb_to_id_rr;
//	else
//		T2_new <= T2;
//always @(*)
//	if (condition1_rb_rl)
//		T2_new <= value_from_mem_to_id_rl;
//	else if (condition2_rb_rl)
//		T2_new <= value_from_wb_to_id_rl;
//	else if (condition1_rb_rr)
//		T2_new <= value_from_ex_to_id_rr;
//	else if (condition2_rb_rr)
//		T2_new <= value_from_mem_to_id_rr;
//	else if (condition3_rb_rr)
//		T2_new <= value_from_wb_to_id_rr;
//	else if (condition1_r_sm)
//		T2_new <= value_from_ex_to_id_sm;
//	else if (condition2_r_sm)
//		T2_new <= value_from_mem_to_id_sm;
//	else if (condition3_r_sm)
//		T2_new <= value_from_wb_to_id_sm;
//	else
//		T2_new <= T2;
//always @(*)
//	if (condition1_rb_rl)
//		T2_new <= value_from_mem_to_id_rl;
//	else if (condition2_rb_rl)
//		T2_new <= value_from_wb_to_id_rl;
//	else if (condition1_r_sm)
//		T2_new <= value_from_ex_to_id_sm;
//	else if (condition2_r_sm)
//		T2_new <= value_from_mem_to_id_sm;
//	else if (condition3_r_sm)
//		T2_new <= value_from_wb_to_id_sm;
//	else if (condition1_r_sa)
//		T2_new <= value_from_ex_to_id_sa;
//	else if (condition2_r_sa)
//		T2_new <= value_from_mem_to_id_sa;
//	else if (condition3_r_sa)
//		T2_new <= value_from_wb_to_id_sa;
//	else if (condition1_rb_rr)
//		T2_new <= value_from_ex_to_id_rr;
//	else if (condition2_rb_rr)
//		T2_new <= value_from_mem_to_id_rr;
//	else if (condition3_rb_rr)
//		T2_new <= value_from_wb_to_id_rr;
//	else
//		T2_new <= T2;

//always @(*)
//	if (condition1_rb_rl)
//		T2_new <= value_from_mem_to_id_rl;
//	else if (condition2_rb_rl)
//		T2_new <= value_from_wb_to_id_rl;
//	else if (condition1_rb_lm)
//		T2_new <= value_from_mem_to_id_lm;
//	else if (condition2_rb_lm)
//		T2_new <= value_from_wb_to_id_lm;
//	else if (condition1_r_sm)
//		T2_new <= value_from_ex_to_id_sm;
//	else if (condition2_r_sm)
//		T2_new <= value_from_mem_to_id_sm;
//	else if (condition3_r_sm)
//		T2_new <= value_from_wb_to_id_sm;
//	else if (condition1_r_sa)
//		T2_new <= value_from_ex_to_id_sa;
//	else if (condition2_r_sa)
//		T2_new <= value_from_mem_to_id_sa;
//	else if (condition3_r_sa)
//		T2_new <= value_from_wb_to_id_sa;
//	else if (condition1_rb_rr)
//		T2_new <= value_from_ex_to_id_rr;
//	else if (condition2_rb_rr)
//		T2_new <= value_from_mem_to_id_rr;
//	else if (condition3_rb_rr)
//		T2_new <= value_from_wb_to_id_rr;
//	else
//		T2_new <= T2;

//always @(*)
//	if (condition1_rb_rl)
//		T2_new <= value_from_mem_to_id_rl;
//	else if (condition2_rb_rl)
//		T2_new <= value_from_wb_to_id_rl;
//	else if (condition1_rb_lm)
//		T2_new <= value_from_mem_to_id_lm;
//	else if (condition2_rb_lm)
//		T2_new <= value_from_wb_to_id_lm;
//	else if (condition1_rb_la)
//		T2_new <= value_from_mem_to_id_la;
//	else if (condition2_rb_la)
//		T2_new <= value_from_wb_to_id_la;
//	else if (condition1_r_sm)
//		T2_new <= value_from_ex_to_id_sm;
//	else if (condition2_r_sm)
//		T2_new <= value_from_mem_to_id_sm;
//	else if (condition3_r_sm)
//		T2_new <= value_from_wb_to_id_sm;
//	else if (condition1_r_sa)
//		T2_new <= value_from_ex_to_id_sa;
//	else if (condition2_r_sa)
//		T2_new <= value_from_mem_to_id_sa;
//	else if (condition3_r_sa)
//		T2_new <= value_from_wb_to_id_sa;
//	else if (condition1_rb_rr)
//		T2_new <= value_from_ex_to_id_rr;
//	else if (condition2_rb_rr)
//		T2_new <= value_from_mem_to_id_rr;
//	else if (condition3_rb_rr)
//		T2_new <= value_from_wb_to_id_rr;
//	else
//		T2_new <= T2;

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

assign flush_condition_id = (jump & (jump_type[0] ^ jump_type[1]));

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
				ID_EX_reg[98:83] <= T1_new;	//T1
				ID_EX_reg[82:67] <= T2_new;	//T2
				ID_EX_reg[66:51] <= pc_2;	//pc_2
				ID_EX_reg[50:35] <= IF_ID_reg[31:16];	//pc_1
				
//				if (~(sig_multiple ^ sig_all) & (stall_condition_ra_rl | stall_condition_rb_rl))
//					ID_EX_reg[34:0] <= 35'd0;
//				else
				if (~(sig_multiple ^ sig_all) & (stall_condition_t1_lw_lhi | stall_condition_t2_lw_lhi))
					ID_EX_reg[34:0] <= 35'd0;
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

assign flush_condition_ex = ((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(| ID_EX_reg[8:7])));

///////// pc_updation ///////////////

//always @(posedge clk)
//	if(pc_enable)
//		if(jump & (jump_type[0] ^ jump_type[1]))	// jump and jumptype jal, jlr
//			pc_current <= pc_2;
//		else if(ID_EX_reg[12] | (ID_EX_reg[11] & ~(ID_EX_reg[10] | ID_EX_reg[9])))
//			pc_current <= pc_3;
//		else
//			pc_current <= pc_1;

always @(posedge clk)
	if(pc_enable)
		if(jump & (jump_type[0] ^ jump_type[1]))	// jump and jumptype jal, jlr
			pc_current <= pc_2;
		else if((ID_EX_reg[10] & zero) | (ID_EX_reg[9] & ~(ID_EX_reg[8] | ID_EX_reg[7])))
			pc_current <= pc_3;
		else
			pc_current <= pc_1;
		
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


//// Detection of (R-R), (St-R), (B-R) dependency (right one is I1, left is next)
//
//assign ra_id_rr = IF_ID_reg[11:9]; //IWR(11:9)
//assign rb_id_rr = IF_ID_reg[8:6];	//IWR(8:6)
//assign rc_ex_rr = ID_EX_reg[24:22];	//IWR(5:3)
//assign rc_mem_rr = EX_MEM_reg[21:19];
//assign rc_wb_rr = MEM_WB_reg[19:17];
//assign load_sig_id = load;
//
//assign r_type_ex = ~ID_EX_reg[16];
//assign r_type_mem = ~EX_MEM_reg[15];
//assign r_type_wb = ~MEM_WB_reg[13];
//
//assign r_type_id = ~alu1_op[1];
//assign sw_id = mem_write;
//assign br_id = branch;
//assign condition_id_rsb = (r_type_id | sw_id | br_id);
//
////assign condition1_ra_rr = ((ra_id_rr === rc_ex_rr) && (load_sig_ex !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_rb_rr = ((rb_id_rr === rc_ex_rr) && (load_sig_ex !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_ra_rr = ((ra_id_rr === rc_mem_rr) && (load_sig_mem !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_rb_rr = ((rb_id_rr === rc_mem_rr) && (load_sig_mem !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_ra_rr = ((ra_id_rr === rc_wb_rr) && (load_sig_wb !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_rb_rr = ((rb_id_rr === rc_wb_rr) && (load_sig_wb !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//
////assign condition1_ra_rr = ((ra_id_rr === rc_ex_rr) && (load_sig_ex !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_rb_rr = ((rb_id_rr === rc_ex_rr) && (store_multiple_id !== 1'b1) && (load_sig_ex !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_ra_rr = ((ra_id_rr === rc_mem_rr) && (load_sig_mem !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_rb_rr = ((rb_id_rr === rc_mem_rr) && (store_multiple_id !== 1'b1) && (load_sig_mem !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_ra_rr = ((ra_id_rr === rc_wb_rr) && (load_sig_wb !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_rb_rr = ((rb_id_rr === rc_wb_rr) && (store_multiple_id !== 1'b1) && (load_sig_wb !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//
////assign condition1_ra_rr = ((ra_id_rr === rc_ex_rr) && (load_sig_ex !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_rb_rr = ((rb_id_rr === rc_ex_rr) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (load_sig_ex !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_ra_rr = ((ra_id_rr === rc_mem_rr) && (load_sig_mem !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_rb_rr = ((rb_id_rr === rc_mem_rr) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (load_sig_mem !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_ra_rr = ((ra_id_rr === rc_wb_rr) && (load_sig_wb !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_rb_rr = ((rb_id_rr === rc_wb_rr) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (load_sig_wb !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//
////assign condition1_ra_rr = ((ra_id_rr === rc_ex_rr) && (load_sig_ex !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_rb_rr = ((rb_id_rr === rc_ex_rr) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (load_sig_ex !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_ra_rr = ((ra_id_rr === rc_mem_rr) && (load_sig_mem !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_rb_rr = ((rb_id_rr === rc_mem_rr) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (load_sig_mem !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_ra_rr = ((ra_id_rr === rc_wb_rr) && (load_sig_wb !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_rb_rr = ((rb_id_rr === rc_wb_rr) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (load_sig_wb !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//
////assign condition1_ra_rr = ((ra_id_rr === rc_ex_rr) && (r_type_ex === 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_rb_rr = ((rb_id_rr === rc_ex_rr) && (r_type_ex === 1'b1) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_ra_rr = ((ra_id_rr === rc_mem_rr) && (r_type_mem === 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_rb_rr = ((rb_id_rr === rc_mem_rr) && (r_type_mem === 1'b1) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_ra_rr = ((ra_id_rr === rc_wb_rr) && (r_type_wb === 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_rb_rr = ((rb_id_rr === rc_wb_rr) && (r_type_wb === 1'b1) && (store_multiple_id !== 1'b1) && (store_all_id !== 1'b1) && (jump != 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//
//assign condition1_ra_rr = ((ra_id_rr === rc_ex_rr) && (r_type_ex === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_rb_rr = ((rb_id_rr === rc_ex_rr) && (r_type_ex === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_ra_rr = ((ra_id_rr === rc_mem_rr) && (r_type_mem === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_rb_rr = ((rb_id_rr === rc_mem_rr) && (r_type_mem === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition3_ra_rr = ((ra_id_rr === rc_wb_rr) && (r_type_wb === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition3_rb_rr = ((rb_id_rr === rc_wb_rr) && (r_type_wb === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//
//
//assign value_from_ex_to_id_rr = T3;
//assign value_from_mem_to_id_rr = EX_MEM_reg[63:48]; //it's also T3 in mem
//assign value_from_wb_to_id_rr = MEM_WB_reg[77:62]; //it's also T3 in wb
//
//// Detection of (R-L), (S-L), (B-L) dependency
//
//assign ra_id_rl = IF_ID_reg[11:9];	//IWR(11:9)
//assign rb_id_rl = IF_ID_reg[8:6];	//IWR(8:6)
//assign ra_ex_rl = ID_EX_reg[30:28];	//IWR(11:9)
//assign ra_mem_rl = EX_MEM_reg[27:25];
//assign ra_wb_rl = MEM_WB_reg[25:23];
//
//assign load_sig_ex = ID_EX_reg[13];
//assign load_sig_mem = EX_MEM_reg[13];
//assign load_sig_wb = MEM_WB_reg[11];
//
////assign stall_condition_ra_rl = ((ra_id_rl === ra_ex_rl) && (load_sig_ex === 1'b1)) ? 1'b1 : 1'b0;
////assign stall_condition_rb_rl = ((rb_id_rl === ra_ex_rl) && (load_sig_ex === 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_ra_rl = ((ra_id_rl === ra_mem_rl) && (load_sig_mem === 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_rb_rl = ((rb_id_rl === ra_mem_rl) && (load_sig_mem === 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_ra_rl = ((ra_id_rl === ra_wb_rl) && (load_sig_wb === 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_rb_rl = ((rb_id_rl === ra_wb_rl) && (load_sig_wb === 1'b1)) ? 1'b1 : 1'b0;
//
//
////assign stall_condition_ra_rl = ((ra_id_rl === ra_ex_rl) && (load_sig_ex === 1'b1) && (sig_mul_all_ex === 1'b1)) ? 1'b1 : 1'b0;
////assign stall_condition_rb_rl = ((rb_id_rl === ra_ex_rl) && (load_sig_ex === 1'b1) && (sig_mul_all_ex === 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_ra_rl = ((ra_id_rl === ra_mem_rl) && (load_sig_mem === 1'b1) && (sig_mul_all_mem === 1'b1)) ? 1'b1 : 1'b0;
////assign condition1_rb_rl = ((rb_id_rl === ra_mem_rl) && (load_sig_mem === 1'b1) && (sig_mul_all_mem === 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_ra_rl = ((ra_id_rl === ra_wb_rl) && (load_sig_wb === 1'b1) && (sig_mul_all_wb === 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_rb_rl = ((rb_id_rl === ra_wb_rl) && (load_sig_wb === 1'b1) && (sig_mul_all_wb === 1'b1)) ? 1'b1 : 1'b0;
//
//assign stall_condition_ra_rl = ((ra_id_rl === ra_ex_rl) && (load_sig_ex === 1'b1) && (sig_mul_all_ex === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign stall_condition_rb_rl = ((rb_id_rl === ra_ex_rl) && (load_sig_ex === 1'b1) && (sig_mul_all_ex === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_ra_rl = ((ra_id_rl === ra_mem_rl) && (load_sig_mem === 1'b1) && (sig_mul_all_mem === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_rb_rl = ((rb_id_rl === ra_mem_rl) && (load_sig_mem === 1'b1) && (sig_mul_all_mem === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_ra_rl = ((ra_id_rl === ra_wb_rl) && (load_sig_wb === 1'b1) && (sig_mul_all_wb === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_rb_rl = ((rb_id_rl === ra_wb_rl) && (load_sig_wb === 1'b1) && (sig_mul_all_wb === 1'b1) && (condition_id_rsb === 1'b1)) ? 1'b1 : 1'b0;
//
//
//assign value_from_mem_to_id_rl = T4;  //T4
//assign value_from_wb_to_id_rl = MEM_WB_reg[61:46];	//it's also T4 in wb
//
//// Dependency SM instr with next R-types
//
//assign ra_id_sm = IF_ID_reg[11:9]; //IWR(11:9)
//assign rb_id_sm = counter_store_multiple;	//generally it is rb, go to T2
//assign rc_ex_sm = ID_EX_reg[24:22];	//IWR(5:3)
//assign rc_mem_sm = EX_MEM_reg[21:19];
//assign rc_wb_sm = MEM_WB_reg[19:17];
//
//assign store_multiple_id = (~load) & sig_multiple;
//assign store_multiple_ex = (~ID_EX_reg[13]) & ID_EX_reg[12];
//assign store_multiple_mem = (~EX_MEM_reg[13]) & EX_MEM_reg[12];
//assign store_multiple_wb = (~MEM_WB_reg[11]) & MEM_WB_reg[10];
//
////assign condition1_r_sm = ((r_id_sm === r_ex_sm) && (store_multiple_id === 1'b1) && (store_multiple_ex !== 1'b1) && (load_sig_ex !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition2_r_sm = ((r_id_sm === r_mem_sm) && (store_multiple_id === 1'b1) && (store_multiple_mem !== 1'b1) && (load_sig_mem !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
////assign condition3_r_sm = ((r_id_sm === r_wb_sm) && (store_multiple_id === 1'b1) && (store_multiple_wb !== 1'b1) && (load_sig_wb !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//
//assign condition1_ra_sm_r = ((ra_id_sm === rc_ex_sm) && (store_multiple_id === 1'b1) && (r_type_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_rb_sm_r = ((rb_id_sm === rc_ex_sm) && (store_multiple_id === 1'b1) && (r_type_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_ra_sm_r = ((ra_id_sm === rc_mem_sm) && (store_multiple_id === 1'b1) && (r_type_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_rb_sm_r = ((rb_id_sm === rc_mem_sm) && (store_multiple_id === 1'b1) && (r_type_mem === 1'b1)) ? 1'b1 : 1'b0;
//assign condition3_ra_sm_r = ((ra_id_sm === rc_wb_sm) && (store_multiple_id === 1'b1) && (r_type_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition3_rb_sm_r = ((rb_id_sm === rc_wb_sm) && (store_multiple_id === 1'b1) && (r_type_wb === 1'b1)) ? 1'b1 : 1'b0;
//
//assign value_from_ex_to_id_sm_r = T3;
//assign value_from_mem_to_id_sm_r = EX_MEM_reg[63:48]; //it's also T3 in mem
//assign value_from_wb_to_id_sm_r = MEM_WB_reg[77:62]; //it's also T3 in wb
//
//// Dependency SM instr with next instr
//
//assign ra_ex_sm = ID_EX_reg[30:28];	//IWR(11:9)
//assign ra_mem_sm = EX_MEM_reg[27:25];
//assign ra_wb_sm = MEM_WB_reg[25:23];
//
//assign sig_mul_all_ex = (ID_EX_reg[12] ^ ID_EX_reg[11]);
//assign sig_mul_all_mem = (EX_MEM_reg[12] ^ EX_MEM_reg[11]);
//assign sig_mul_all_wb = (MEM_WB_reg[10] ^ MEM_WB_reg[9]);
//
//assign jal_and_jlr_ex = ID_EX_reg[9] & (^ ID_EX_reg[8:7]);
//assign jal_and_jlr_mem = EX_MEM_reg[9] & (^ EX_MEM_reg[8:7]);
//assign jal_and_jlr_wb = MEM_WB_reg[7] & (^ MEM_WB_reg[6:5]);
//
//assign condition1_ra_sm_rest = ((ra_id_sm === ra_ex_sm) && (store_multiple_id === 1'b1) && (((load_sig_ex === 1'b1) && (sig_mul_all_ex !== 1'b1)) || (jal_and_jlr_ex === 1'b1))) ? 1'b1 : 1'b0;
//assign condition1_rb_sm_rest = ((rb_id_sm === ra_ex_sm) && (store_multiple_id === 1'b1) && (((load_sig_ex === 1'b1) && (sig_mul_all_ex !== 1'b1)) || (jal_and_jlr_ex === 1'b1))) ? 1'b1 : 1'b0;
//assign condition2_ra_sm_rest = ((ra_id_sm === ra_mem_sm) && (store_multiple_id === 1'b1) && (((load_sig_mem === 1'b1) && (sig_mul_all_mem !== 1'b1)) || (jal_and_jlr_mem === 1'b1))) ? 1'b1 : 1'b0;
//assign condition2_rb_sm_rest = ((rb_id_sm === ra_mem_sm) && (store_multiple_id === 1'b1) && (((load_sig_mem === 1'b1) && (sig_mul_all_mem !== 1'b1)) || (jal_and_jlr_mem === 1'b1))) ? 1'b1 : 1'b0;
//assign condition3_ra_sm_rest = ((ra_id_sm === ra_wb_sm) && (store_multiple_id === 1'b1) && (((load_sig_wb === 1'b1) && (sig_mul_all_wb !== 1'b1)) || (jal_and_jlr_wb === 1'b1))) ? 1'b1 : 1'b0;
//assign condition3_rb_sm_rest = ((rb_id_sm === ra_wb_sm) && (store_multiple_id === 1'b1) && (((load_sig_wb === 1'b1) && (sig_mul_all_wb !== 1'b1)) || (jal_and_jlr_wb === 1'b1))) ? 1'b1 : 1'b0;
//
//assign value_from_ex_to_id_sm_r = T3;
//assign value_from_mem_to_id_sm_r = EX_MEM_reg[63:48]; //it's also T3 in mem
//assign value_from_wb_to_id_sm_r = MEM_WB_reg[77:62]; //it's also T3 in wb
//
//
//// Dependency SA instr with previous R-types
//
//assign r_id_sa = counter_store_all;	//generally it is rb
//assign r_ex_sa = ID_EX_reg[26:24];	//IWR(5:3)
//assign r_mem_sa = EX_MEM_reg[17:15];
//assign r_wb_sa = MEM_WB_reg[14:12];
//
//assign store_all_id = (~load) & sig_all;
//assign store_all_ex = (~ID_EX_reg[15]) & ID_EX_reg[13];
//assign store_all_mem = (~EX_MEM_reg[11]) & EX_MEM_reg[9];
//assign store_all_wb = (~MEM_WB_reg[8]) & MEM_WB_reg[6];
//
//assign condition1_r_sa = ((r_id_sa === r_ex_sa) && (store_all_id === 1'b1) && (store_all_ex !== 1'b1) && (load_sig_ex !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_r_sa = ((r_id_sa === r_mem_sa) && (store_all_id === 1'b1) && (store_all_mem !== 1'b1) && (load_sig_mem !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//assign condition3_r_sa = ((r_id_sa === r_wb_sa) && (store_all_id === 1'b1) && (store_all_wb !== 1'b1) && (load_sig_wb !== 1'b1) && (load_sig_id !== 1'b1)) ? 1'b1 : 1'b0;
//
//assign value_from_ex_to_id_sa = T3;
//assign value_from_mem_to_id_sa = EX_MEM_reg[59:44]; //it's also T3 in mem
//assign value_from_wb_to_id_sa = MEM_WB_reg[72:57]; //it's also T3 in wb
//
//// Dependency LM inst
//
//assign ra_id_lm = IF_ID_reg[11:9];	//IWR(11:9)
//assign rb_id_lm = IF_ID_reg[8:6];	//IWR(8:6)
//
//assign load_mult_ex = ID_EX_reg[15] & ID_EX_reg[14];
//assign load_mult_mem = EX_MEM_reg[11] & EX_MEM_reg[10];
//assign load_mult_wb = MEM_WB_reg[8] & MEM_WB_reg[7];
//
////assign stall_condition_ra_lm = ((ra_id_lm === 3'b111) && (load_mult_ex === 1'b1)) ? 1'b1 : 1'b0;
////assign stall_condition_rb_lm = ((rb_id_lm === 3'b111) && (load_mult_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_ra_lm = ((ra_id_lm === 3'b111) && (load_mult_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_rb_lm = ((rb_id_lm === 3'b111) && (load_mult_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_ra_lm = ((ra_id_lm === 3'b110) && (load_mult_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_rb_lm = ((rb_id_lm === 3'b110) && (load_mult_ex === 1'b1)) ? 1'b1 : 1'b0;
//
//assign value_from_mem_to_id_lm = T4;	
//assign value_from_wb_to_id_lm = MEM_WB_reg[56:41];	//it's also T4 in wb
//
//// Dependency LA inst
//
//assign ra_id_la = IF_ID_reg[11:9];	//IWR(11:9)
//assign rb_id_la = IF_ID_reg[8:6];	//IWR(8:6)
//
//assign load_all_ex = ID_EX_reg[15] & ID_EX_reg[13];
//assign load_all_mem = EX_MEM_reg[11] & EX_MEM_reg[9];
//assign load_all_wb = MEM_WB_reg[8] & MEM_WB_reg[6];
//
//assign condition1_ra_la = ((ra_id_la === 3'b110) && (load_all_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition1_rb_la = ((rb_id_la === 3'b110) && (load_all_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_ra_la = ((ra_id_la === 3'b101) && (load_all_ex === 1'b1)) ? 1'b1 : 1'b0;
//assign condition2_rb_la = ((rb_id_la === 3'b101) && (load_all_ex === 1'b1)) ? 1'b1 : 1'b0;
//
//assign value_from_mem_to_id_la = T4;	
//assign value_from_wb_to_id_la = MEM_WB_reg[56:41];	//it's also T4 in wb

endmodule 