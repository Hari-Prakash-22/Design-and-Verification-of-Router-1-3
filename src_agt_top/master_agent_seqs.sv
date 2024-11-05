class master_seq extends uvm_sequence #(write_xtn);  
	
  // Factory registration using `uvm_object_utils

	`uvm_object_utils(master_seq)  
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	bit[1:0]addr;

    extern function new(string name ="master_seq");
	extern function void build_phase(uvm_phase phase);	
endclass

//-----------------  constructor new method  -------------------//
function master_seq::new(string name ="master_seq");
	super.new(name);
endfunction
function void master_seq::build_phase(uvm_phase phase);
//	super.build_phase(phase);
	if(!uvm_config_db#(bit[1:0])::get(null,"get_full_name()","bit",addr))
		`uvm_fatal(get_type_name(),"can't get the bit in the master seq")
endfunction
// extend test sequence form the master sequence
class small_pkt extends master_seq;

	// factory regristation using object utils
	`uvm_object_utils(small_pkt)
	//---------------------------------------------------
	//METHODS
	//---------------------------------------------------
	extern function new(string name= "small_pkt");
	extern task body();
endclass

function small_pkt::new(string name="small_pkt");
	super.new(name);
endfunction


task small_pkt::body();
	//repeat(5)
		req=write_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { header[1:0]==addr; header[7:2] inside {[1:13]};});
		finish_item(req);
endtask
class medium_pkt extends master_seq;

	// factory regristation using object utils
	`uvm_object_utils(medium_pkt)
	//---------------------------------------------------
	//METHODS
	//---------------------------------------------------
	extern function new(string name= "medium_pkt");
	extern task body();
endclass

function medium_pkt::new(string name="medium_pkt");
	super.new(name);
endfunction


task medium_pkt::body();
	//repeat(5)
		req=write_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { header[1:0]==addr; header[7:2] inside {[13:45]};});
		finish_item(req);
endtask

class large_pkt extends master_seq;

	// factory regristation using object utils
	`uvm_object_utils(large_pkt)
	//---------------------------------------------------
	//METHODS
	//---------------------------------------------------
	extern function new(string name= "large_pkt");
	extern task body();
endclass

function large_pkt::new(string name="large_pkt");
	super.new(name);
endfunction


task large_pkt::body();
	//repeat(5)
		req=write_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { header[1:0]==addr; header[7:2] inside {[45:63]};});
		finish_item(req);
endtask
