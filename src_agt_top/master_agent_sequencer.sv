//*************************************MASTER AGENT SEQUENCER*******************************//
class master_agent_sequencer extends uvm_sequencer #(write_xtn);

	// Factory registration using `uvm_component_utils
	`uvm_component_utils(master_agent_sequencer)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "master_agent_sequencer",uvm_component parent);
endclass

//-----------------  constructor new method  -------------------//
function master_agent_sequencer::new(string name="master_agent_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
