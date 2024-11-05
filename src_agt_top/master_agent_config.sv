//***********************************MASTER AGENT CONFIG***********************//
class master_agent_config extends uvm_object;

	// UVM Factory Registration Macro
	`uvm_object_utils(master_agent_config)	

	// Declare the virtual interface handle for router_if as "vif"
	virtual router_if vif;

	//------------------------------------------
	// Data Members
	//------------------------------------------
	// Declare parameter is_active of type uvm_active_passive_enum and assign it to UVM_ACTIVE
	uvm_active_passive_enum is_active=UVM_ACTIVE;

	// Declare the mon_rcvd_xtn_cnt as static int and initialize it to zero  
	static int mon_received_data_count = 0;

	// Declare the drv_data_sent_cnt as static int and initialize it to zero 
	
	static int drv_data_sent_count = 0;


	//------------------------------------------
	// Methods
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "master_agent_config");

endclass: master_agent_config

//-----------------  constructor new method  -------------------//
function master_agent_config::new(string name = "master_agent_config");
	super.new(name);
endfunction

