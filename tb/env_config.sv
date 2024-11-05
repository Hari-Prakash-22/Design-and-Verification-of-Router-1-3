//********************************env_config******************//
class env_config extends uvm_object;


// UVM Factory Registration Macro
`uvm_object_utils(env_config)

//------------------------------------------
// Data Members
//------------------------------------------
// Whether env analysis components are used:
bit has_functional_coverage = 0;
bit has_wagent_functional_coverage = 0;
bit has_scoreboard = 1;
// Whether the various agents are used:
bit has_wagent = 1;
bit has_ragent = 1;
// Whether the virtual sequencer is used:
bit has_virtual_sequencer = 1;
// Configuration handles for the sub_components
master_agent_config mac_cfg;
slave_agent_config sac_cfg[];

int no_of_destinations;
int no_of_source;




//------------------------------------------
// Methods
//------------------------------------------
// Standard UVM Methods:
extern function new(string name = "env_config");

endclass: env_config
//-----------------  constructor new method  -------------------//

function env_config::new(string name = "env_config");
  super.new(name);
endfunction
