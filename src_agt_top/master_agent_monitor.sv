//************************************MASTER MONITOR******************************//
class master_agent_monitor extends uvm_monitor;
//registery
	`uvm_component_utils(master_agent_monitor)
	
	master_agent_config mac_cfg;
	// declare the virtual interface handle
	virtual router_if.SRC_MON vif;
	// declare tlm analysis fifo for sample the data from the monitor and send to scoreboard
	uvm_analysis_port#(write_xtn)wr_mon_ap;
	write_xtn data_sent;
	




//methods
	extern function new(string name = "master_agent_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass

//new constructor
function master_agent_monitor::new(string name = "master_agent_monitor",uvm_component parent);
	super.new(name,parent);
	wr_mon_ap=new("wr_mon_ap",this);
endfunction
//build phase
function void master_agent_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(master_agent_config)::get(this,"","master_agent_config",mac_cfg))
		`uvm_fatal(get_type_name(),"can't get the config in master monitor")
endfunction
//connect phase

function void master_agent_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=mac_cfg.vif;
endfunction

//run_phase

task master_agent_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever
		begin
			collect_data();
		end
endtask

//collect data

task master_agent_monitor::collect_data();

		data_sent=write_xtn::type_id::create("data_sent");

		@(vif.src_mon_cb);
		while((vif.src_mon_cb.pkt_valid!==1'b1)||(vif.src_mon_cb.busy===1))
		@(vif.src_mon_cb);

	//	$display("+++++++++++++++++++++++++++++++++++++++++++++++");
	//while(vif.src_mon_cb.busy)
//		@(vif.src_mon_cb);
		data_sent.header=vif.src_mon_cb.data_in;

	//	$display("++++++++++------------------------------------");
		@(vif.src_mon_cb);
		data_sent.payload=new[data_sent.header[7:2]];

	//	$display("-------------------------------------------------");

		foreach(data_sent.payload[i])
		begin
			while(vif.src_mon_cb.busy===1)
			@(vif.src_mon_cb);
			data_sent.payload[i]=vif.src_mon_cb.data_in;
			@(vif.src_mon_cb);

		end
	//$display("+jjjjjjjjjjjjjjjjjjjjj+++++++++++++++++++++++++++++++++++++++++++hhhhhhhhhhhhhhhhhhhhhh");

			while((vif.src_mon_cb.pkt_valid===1'b1)||(vif.src_mon_cb.busy===1))
				@(vif.src_mon_cb);
	
			data_sent.parity=vif.src_mon_cb.data_in;
	//	$display("+jjjjjjjjjjjjjjjjjjjjj+++++++++++++++++++++++++++++++++++++++++++");
`uvm_info(get_type_name(),"monitors sampled transcations",UVM_LOW)

//	repeat(2)
		@(vif.src_mon_cb);
	wr_mon_ap.write(data_sent);	
                 data_sent.print();
 
	


endtask


//report phase
function void master_agent_monitor::report_phase(uvm_phase phase);
	super.report_phase(phase);
endfunction

