//***************************************SLAVE DRIVER*****************************************//
class slave_agent_driver extends uvm_driver #(read_xtn);

//fac registeriation
	`uvm_component_utils(slave_agent_driver)

	virtual router_if.DST_DRV vif;
	slave_agent_config s_cfg;







//methods
	extern function new(string name = "slave_agent_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(read_xtn duv_xtn);
	extern function void report_phase(uvm_phase phase);
endclass
//function new
function slave_agent_driver::new(string name = "slave_agent_driver",uvm_component parent);
	super.new(name,parent);
endfunction
//build phase

function void slave_agent_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(slave_agent_config)::get(this,"","slave_agent_config",s_cfg))
		`uvm_fatal(get_type_name(),"can't get the interface to the driver")
endfunction
//connect phase
function void slave_agent_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=s_cfg.vif;
endfunction

//run_phase

task slave_agent_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end	
endtask


//send to dut

task slave_agent_driver::send_to_dut(read_xtn duv_xtn);
	@(vif.dst_drv_cb);
	@(vif.dst_drv_cb);


	while(vif.dst_drv_cb.vld_out===0)
		@(vif.dst_drv_cb);

	repeat(duv_xtn.no_of_cycles)
		@(vif.dst_drv_cb);
		$display("hi");

		@(vif.dst_drv_cb);
		@(vif.dst_drv_cb);
	vif.dst_drv_cb.read_enb<=1'b1;
		@(vif.dst_drv_cb);

	while(vif.dst_drv_cb.vld_out===1)
		@(vif.dst_drv_cb);

	vif.dst_drv_cb.read_enb<=1'b0;

	repeat(2)
	@(vif.dst_drv_cb);

	`uvm_info(get_type_name(),"this is the duv driver data",UVM_LOW)
	duv_xtn.print();

endtask



function void slave_agent_driver::report_phase(uvm_phase phase);
	super.report_phase(phase);

endfunction
