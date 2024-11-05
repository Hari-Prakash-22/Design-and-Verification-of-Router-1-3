///*************************SLAVE AGENT***************************//

class slave_agent extends uvm_agent;

	//component reg
	`uvm_component_utils(slave_agent)
	// handle for configuration class
	slave_agent_config sac_cfg;
	//handles for the components inside the agent
	slave_agent_monitor sam_h;
	slave_agent_driver sad_h;
	slave_agent_sequencer sas_h;
	//env_config env_cfg;

	



	//methods
	extern function new(string name = "slave_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass
//new constructor

function slave_agent::new(string name = "slave_agent",uvm_component parent);
	super.new(name,parent);
endfunction


//build phase
function void slave_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//get the slave agent config class from the db
	if(!uvm_config_db#(slave_agent_config)::get(this,"","slave_agent_config",sac_cfg))
		`uvm_fatal(get_type_name(),"can't get slave agent config");
	//create the monitor 
	sam_h=slave_agent_monitor::type_id::create("sam_h",this);

	//foreach(env_cfg.no_of_destinations[i])
	
	if(sac_cfg.is_active==UVM_ACTIVE)
	begin
	sad_h=slave_agent_driver::type_id::create("sad_h",this);
	sas_h=slave_agent_sequencer::type_id::create("sas_h",this);
	end
endfunction

// connect phase

function void slave_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	// if it is an active agent then connect the sequencer and driver
	if(sac_cfg.is_active==UVM_ACTIVE)
	begin
		sad_h.seq_item_port.connect(sas_h.seq_item_export);
	end
endfunction
