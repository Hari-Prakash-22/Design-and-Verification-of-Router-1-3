class write_xtn extends uvm_sequence_item;
  
	// UVM Factory Registration Macro
	`uvm_object_utils(write_xtn)
	// properties of the class
	rand bit [7:0]header;
	rand bit [7:0]payload[];
	bit [7:0]parity;
	bit error;
	
	// constraints
	constraint c1 {header[1:0]!=11;
		       header[7:2] inside {[1:63]};
			payload.size==header[7:2];}

	

	extern function new(string name = "write_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();

endclass:write_xtn

	//-----------------  constructor new method  -------------------//
	//Add code for new()

function write_xtn::new(string name = "write_xtn");
	super.new(name);
endfunction:new
	  

//-----------------  do_print method  -------------------//
//Use printer.print_field for integral variables
//Use printer.print_generic for enum variables
function void write_xtn::do_print (uvm_printer printer);
	super.do_print(printer);

   
    //              	srting name   		        bitstream value            size         radix for printing
    printer.print_field( "header", 			this.header, 	    	    64,		 UVM_DEC		);
    printer.print_field( "address", 		        this.header[1:0], 	    12,		 UVM_DEC		);
	foreach(payload[i])
    printer.print_field( $sformatf("payload[%0d]",i), 			this.payload[i], 	    64,		 UVM_DEC		);
    printer.print_field( "parity", 		        this.parity,                64,		 UVM_DEC		);
  
endfunction:do_print

function void write_xtn::post_randomize();
	parity=header^8'b0;
	foreach(payload[i])
	begin
		parity=parity^payload[i];
	end
endfunction
