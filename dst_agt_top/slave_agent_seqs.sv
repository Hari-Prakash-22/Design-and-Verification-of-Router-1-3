//************************SLAVE AGENT SEQUENCE***********************************//
class slave_seq extends uvm_sequence #(read_xtn);  
	
  // Factory registration using `uvm_object_utils

	`uvm_object_utils(slave_seq)  
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
    extern function new(string name ="slave_seq");
	
endclass

//-----------------  constructor new method  -------------------//
function slave_seq::new(string name ="slave_seq");
	super.new(name);
endfunction

class small_rd_pkt extends slave_seq;

	// factory regristation using object utils
	`uvm_object_utils(small_rd_pkt)
	//---------------------------------------------------
	//METHODS
	//---------------------------------------------------
	extern function new(string name= "small_rd_pkt");
	extern task body();
endclass

function small_rd_pkt::new(string name="small_rd_pkt");
	super.new(name);
endfunction


task small_rd_pkt::body();
	//repeat(5)
	begin
		req=read_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {no_of_cycles==1;});
		finish_item(req);
	end
endtask
 
class medium_rd_pkt extends slave_seq;

	// factory regristation using object utils
	`uvm_object_utils(medium_rd_pkt)
	//---------------------------------------------------
	//METHODS
	//---------------------------------------------------
	extern function new(string name= "small_rd_pkt");
	extern task body();
endclass

function medium_rd_pkt::new(string name="small_rd_pkt");
	super.new(name);
endfunction


task medium_rd_pkt::body();
//	repeat(5)
		req=read_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {no_of_cycles inside {[15:32]};});
		finish_item(req);
endtask
class large_rd_pkt extends slave_seq;

	// factory regristation using object utils
	`uvm_object_utils(large_rd_pkt)
	//---------------------------------------------------
	//METHODS
	//---------------------------------------------------
	extern function new(string name= "large_rd_pkt");
	extern task body();
endclass

function large_rd_pkt::new(string name="large_rd_pkt");
	super.new(name);
endfunction


task large_rd_pkt::body();
	//repeat(5)
		req=read_xtn::type_id::create("req");
		start_item(req);
	//	assert(req.randomize() with {no_of_cycles inside {[14:63]};});
		assert(req.randomize() with {no_of_cycles==1;});

		finish_item(req);
endtask
