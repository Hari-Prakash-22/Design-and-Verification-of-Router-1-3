//***************************************MASTER DRIVER*****************************************//
class master_agent_driver extends uvm_driver #(write_xtn);

//fac registeriation
	`uvm_component_utils(master_agent_driver)

	virtual router_if.SRC_DRV vif;
	master_agent_config mac_cfg;


//methods
	extern function new(string name = "master_agent_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(write_xtn xtn);
	extern function void report_phase(uvm_phase phase);
endclass
//function new
function master_agent_driver::new(string name = "master_agent_driver",uvm_component parent);
	super.new(name,parent);

endfunction
//build phase

function void master_agent_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(master_agent_config)::get(this,"","master_agent_config",mac_cfg))
		`uvm_fatal(get_type_name(),"can't get config in the master agent driver")
endfunction
//connect phase
function void master_agent_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=mac_cfg.vif;
endfunction

//run_phase

task master_agent_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);
	//wait for the clocking event
	//make reset
	@(vif.src_drv_cb);
		vif.src_drv_cb.resetn<=1'b0;
	//repeat(2)
	@(vif.src_drv_cb);
		vif.src_drv_cb.resetn<=1'b1;
	// starting the handshaking mechanism
	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask


//send to dut

task master_agent_driver::send_to_dut(write_xtn xtn);
		`uvm_info(get_type_name(),"this is the driver transcations",UVM_LOW)
	
	xtn.print();
	//wait for an clocking event
	//@(vif.src_drv_cb);
	while(vif.src_drv_cb.busy===1)
		@(vif.src_drv_cb);
	//drive the header and payload and make packet vaild high
//	@(vif.src_drv_cb);

	vif.src_drv_cb.pkt_valid<=1'b1;
	vif.src_drv_cb.data_in<=xtn.header;
	@(vif.src_drv_cb);

	foreach(xtn.payload[i])
	begin
		while(vif.src_drv_cb.busy===1)
			@(vif.src_drv_cb);
		vif.src_drv_cb.data_in<=xtn.payload[i];
		@(vif.src_drv_cb);
	end
	// wait for the clocking event and drive the parity and make the packet valid low
	while(vif.src_drv_cb.busy===1)
		@(vif.src_drv_cb);
	vif.src_drv_cb.pkt_valid<=1'b0;
	vif.src_drv_cb.data_in<=xtn.parity;
	

	mac_cfg.drv_data_sent_count+=1;
	// wait for clocking event
	repeat(2)
			@(vif.src_drv_cb);	


	

endtask



function void master_agent_driver::report_phase(uvm_phase phase);
	super.report_phase(phase);

endfunction
