class master_agent_top extends uvm_env;

   // Factory Registration
	`uvm_component_utils(master_agent_top)
    
   //Declare the agent handle as agnth
    master_agent m_agent_h;
	env_config env_cfg;
	master_agent_config mac_cfg;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "master_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	
endclass
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function master_agent_top::new(string name = "master_agent_top" , uvm_component parent);
	super.new(name,parent);
endfunction

    
//-----------------  build() phase method  -------------------//
function void master_agent_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"can't get config ")
	// Create the instance of ram_wr_agent
	
   	m_agent_h=master_agent::type_id::create("m_agent_h",this);
	uvm_config_db#(master_agent_config)::set(this,"*","master_agent_config",env_cfg.mac_cfg);

endfunction


//-----------------  run() phase method  -------------------//
// Print the topology
task master_agent_top::run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask   


