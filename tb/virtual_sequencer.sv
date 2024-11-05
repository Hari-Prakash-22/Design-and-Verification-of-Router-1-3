class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item) ;
   
      // Factory Registration
	`uvm_component_utils(virtual_sequencer)

   // Declare handles for master_sequencer and slave_sequencer

	master_agent_sequencer m_seqrh;
	slave_agent_sequencer s_seqrh[];
	env_config env_cfg;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "virtual_sequencer",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

   // Define Constructor new() function
function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
function void virtual_sequencer::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"can;t get the env config in v seqrh")
	/*foreach(env_cfg.no_of_destinations[i])
	begin
		s_seqrh[i]=slave_agent_sequencer::type_id::create($sformatf("s_seqrh[%0d]",i),this);
	end
	m_seqrh=master_agent_sequencer::type_id::create("m_seqrh",this);*/
	s_seqrh=new[env_cfg.no_of_destinations];
endfunction		


