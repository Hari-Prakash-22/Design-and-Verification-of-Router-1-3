module top;
	//import the router test pkg
	import test_pkg::*;
	// import the uvm pkg
	import uvm_pkg::*;

	//include the macros
	`include "uvm_macros.svh"
	// genterate the clock signal
	bit clock;
	always #10 clock=~clock;
 // Instantiate router_if with clock as input

	router_if src_in0(clock);
	router_if dst_in0(clock);
	router_if dst_in1(clock);
	router_if dst_in2(clock);
	
   // Instantiate rtl router_chip and pass the interface instance as argument
	router_top duv( .clock(clock),
			.resetn(src_in0.resetn),
			.packet_valid(src_in0.pkt_valid),
			.read_enb_0(dst_in0.read_enb),
			.read_enb_1(dst_in1.read_enb),
			.read_enb_2(dst_in2.read_enb),
			.data(src_in0.data_in),
			.busy(src_in0.busy),
			.err(src_in0.err),
			.vld_out_0(dst_in0.vld_out),
			.vld_out_1(dst_in1.vld_out),
			.vld_out_2(dst_in2.vld_out),
			.data_out_0(dst_in0.data_out),
			.data_out_1(dst_in1.data_out),
			.data_out_2(dst_in2.data_out));
	

	initial 
	begin
	
		`ifdef VCS
        	 $fsdbDumpvars(0, top);
        	`endif	

		//set the virtual interface using the uvm_config_db
		uvm_config_db #(virtual router_if)::set(null,"*","vif",src_in0);
		uvm_config_db #(virtual router_if)::set(null,"*","vif0",dst_in0);
		uvm_config_db #(virtual router_if)::set(null,"*","vif1",dst_in1);
		uvm_config_db #(virtual router_if)::set(null,"*","vif2",dst_in2);
		// Call run_test
		run_test();
	end
	// checks for vaild out condition
/*	property pt_vaild;
		@(posedge clock) (src_in0.pkt_valid)|->##3 (dst_in0.vld_out||dst_in1.vld_out||dst_in2.vld_out);
	endproperty
	p1: assert property (pt_vaild)
		$display($time,"\t@@                                       pt_vaild is success                              @@");
	else	
		$display($time,"\t@@                                       pt_vaild is failure                              @@");
	property vd_out;
		@(posedge clock) (dst_in0.vld_out||dst_in1.vld_out||dst_in2.vld_out)|->##[1:29](dst_in0.read_enb||dst_in1.read_enb||dst_in2.read_enb);
	endproperty
	p2: assert property (vd_out)
		$display($time,"\t@@                                        valid_out is success                            @@");
	else	
		$display($time,"\t@@                                        vaild_out is failure                            @@");
	property rst;
		@(posedge clock) (src_in0.resetn)|->(!dst_in0.data_out||!dst_in1.data_out||!dst_in2.data_out);
	endproperty
	p3: assert property (rst)
		$display($time,"\t@@                                         reset is success                               @@");
	else	
		$display($time,"\t@@                                         reset is failure                               @@");
	property busy_sig;
		@(posedge clock) (src_in0.busy)|->$stable(src_in0.data_in);
	endproperty
	p4: assert property (busy_sig)
		$display($time,"\t@@                                         busy is verified success                        @@");
	else	
		$display($time,"\t@@                                         busy sig is  failure                            @@");

	property rst;
		@(posedge clock) (src_in0.resetn)|->(!dst_in0.data_out||!dst_in1.data_out||!dst_in2.data_out);
	endproperty
	p3: assert property (rst)
		$display("reset is success");
	else	
		$display("reset is failure");


*/


endmodule



