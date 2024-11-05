class read_xtn extends uvm_sequence_item;
  
	// UVM Factory Registration Macro
    `uvm_object_utils(read_xtn)
	bit [7:0]header;
	bit [7:0]payload[];
	bit [7:0]parity;
	rand bit [5:0]no_of_cycles;
	extern function new(string name = "read_xtn");


	extern function void do_print(uvm_printer printer);


endclass:read_xtn

//-----------------  constructor new method  -------------------//
//Add code for new()

function read_xtn::new(string name = "read_xtn");
	super.new(name);
endfunction:new
//-----------------  do_print method  -------------------//
//Use printer.print_field for integral variables
//Use printer.print_generic for enum variables
function void  read_xtn::do_print (uvm_printer printer);
	super.do_print(printer);
   
    //                   srting name   	bitstream value     size    radix for printing
    printer.print_field( "header", 		this.header, 	    	64,		 UVM_DEC		);
  //  printer.print_field( "address", 	this.payload[1:0], 	    12,		 UVM_DEC		);
	foreach(payload[i])
    printer.print_field( $sformatf("payload [%0d]",i), 		this.payload[i], 	    	64,		 UVM_DEC		);
    printer.print_field( "parity", 	this.parity,     65,		 UVM_DEC		);
    printer.print_field("no_of_cycles",    this.no_of_cycles,           64 ,    UVM_DEC);


endfunction:do_print
    

 

