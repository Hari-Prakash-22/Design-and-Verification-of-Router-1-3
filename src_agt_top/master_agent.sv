//************************************MASTER AGENT**********************************************//
class master_agent extends uvm_agent;

//factory reg
	`uvm_component_utils(master_agent)
	//declare the handle for the confif class
	master_agent_config mac_cfg;
	//declare the handles for components inside the agent
	master_agent_monitor mam_h;
	master_agent_driver mad_h;
	master_agent_sequencer mas_h;
	//------------------------------------------------------------
	//------------------METHODS----------------------------------//
	//------------------------------------------------------------	


	extern function new(string name = "master_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass
//new constructor

function master_agent::new(string name = "master_agent",uvm_component parent);
	super.new(name,parent);
endfunction


//build phase
function void master_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//get the configuration class from the uvm db
	if(!uvm_config_db#(master_agent_config)::get(this,"","master_agent_config",mac_cfg))
		`uvm_fatal(get_type_name(),"can't get the config for the the master agent config")
	//create the monitor componenet
	
	mam_h=master_agent_monitor::type_id::create("mam_h",this);
	//if agent is active then create the other componenets
	if(mac_cfg.is_active==UVM_ACTIVE)
	begin
	mad_h=master_agent_driver::type_id::create("mad_h",this);
	mas_h=master_agent_sequencer::type_id::create("mas_h",this);
	end
endfunction

// connect phase

function void master_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	//if it is an active agent then connect the monitor and sequencer
	if(mac_cfg.is_active==UVM_ACTIVE)
	begin
	mad_h.seq_item_port.connect(mas_h.seq_item_export);
	end
endfunction
