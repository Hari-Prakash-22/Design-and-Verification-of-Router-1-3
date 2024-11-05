//************************************SLAVE MONITOR******************************//
class slave_agent_monitor extends uvm_monitor;
//registery
	`uvm_component_utils(slave_agent_monitor)
	virtual router_if.DST_MON vif;
	slave_agent_config s_cfg;
	uvm_analysis_port#(read_xtn)rd_mon_ap;
	read_xtn xtn;



//methods
	extern function new(string name = "slave_agent_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass

//new constructor
function slave_agent_monitor::new(string name = "slave_agent_monitor",uvm_component parent);
	super.new(name,parent);
endfunction
//build phase
function void slave_agent_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	rd_mon_ap=new("rd_mon_ap",this);
	if(!uvm_config_db#(slave_agent_config)::get(this,"","slave_agent_config",s_cfg))
		`uvm_fatal(get_type_name(),"can't get the monitor config from the config db")
endfunction
//connect phase

function void slave_agent_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=s_cfg.vif;
endfunction

//run_phase

task slave_agent_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	collect_data();
endtask

//collect data

task slave_agent_monitor::collect_data();
	xtn=read_xtn::type_id::create("xtn",this);
	@(vif.dst_mon_cb);

	while(vif.dst_mon_cb.read_enb!==1)
		@(vif.dst_mon_cb);

		@(vif.dst_mon_cb);
//		@(vif.dst_mon_cb);

	xtn.header=vif.dst_mon_cb.data_out;
	xtn.payload=new[xtn.header[7:2]];
	@(vif.dst_mon_cb);

//$display("ershobjuuuuuuuuuuuuuuuuuuuuuuuuuuuuuraewijk");

	foreach(xtn.payload[i])
	begin
//	@(vif.dst_mon_cb);

	while(vif.dst_mon_cb.read_enb!==1)
		@(vif.dst_mon_cb);
//$display("ershobjraewijk");

		xtn.payload[i]=vif.dst_mon_cb.data_out;
		@(vif.dst_mon_cb);
	end

//	while(!vif.dst_mon_cb.read_enb)
//		@(vif.dst_mon_cb);

	xtn.parity=vif.dst_mon_cb.data_out;
repeat(2)
		@(vif.dst_mon_cb);
	rd_mon_ap.write(xtn);
		`uvm_info(get_type_name(),"destination monitor transcation",UVM_LOW)
	xtn.print();


endtask


//report phase
function void slave_agent_monitor::report_phase(uvm_phase phase);
	super.report_phase(phase);
endfunction

