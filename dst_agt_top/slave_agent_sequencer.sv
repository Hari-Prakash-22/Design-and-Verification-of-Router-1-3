//*************************************SLAVE AGENT SEQUENCER*********************************//
class slave_agent_sequencer extends uvm_sequencer #(read_xtn);

	// Factory registration using `uvm_component_utils
	`uvm_component_utils(slave_agent_sequencer)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "slave_agent_sequencer",uvm_component parent);
endclass

//-----------------  constructor new method  -------------------//
function slave_agent_sequencer::new(string name="slave_agent_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
