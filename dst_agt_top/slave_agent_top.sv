//****************************************slave agent top********************************//
class slave_agent_top extends uvm_env;

   // Factory Registration
	`uvm_component_utils(slave_agent_top)
    
   //Declare the agent handle as agnth
    slave_agent s_agent_h[];
    env_config env_cfg;
   // slave_agent_config sac_cfg[];
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "slave_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	
endclass
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function slave_agent_top::new(string name = "slave_agent_top" , uvm_component parent);
	super.new(name,parent);
endfunction

    
//-----------------  build() phase method  -------------------//
function void slave_agent_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
	// Create the instance of slave_agent
	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"can't get env config")
	
	s_agent_h=new[env_cfg.no_of_destinations];
	foreach(s_agent_h[i])
	begin
   	s_agent_h[i]=slave_agent::type_id::create($sformatf("s_agent_h[%0d]",i),this);
	uvm_config_db#(slave_agent_config)::set(this,$sformatf("s_agent_h[%0d]*",i),"slave_agent_config",env_cfg.sac_cfg[i]);
	end
	
endfunction


//-----------------  run() phase method  -------------------//
// Print the topology
task slave_agent_top::run_phase(uvm_phase phase);
	//uvm_top.print_topology;
endtask   


