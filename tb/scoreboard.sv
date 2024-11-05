class scoreboard extends uvm_scoreboard;

    // Declare handles for uvm_tlm_analysis_fifos parameterized by read & write transactions as fifo_rdh & fifo_wrh respectively
	
	uvm_tlm_analysis_fifo #(read_xtn) fifo_dsth[];
   	uvm_tlm_analysis_fifo #(write_xtn) fifo_srch[];

	env_config env_cfg;

//      	int  wr_xtns_in, rd_xtns_in , xtns_compared ,xtns_dropped;	

       
	// Factory registration
	 `uvm_component_utils(scoreboard)

	// Declare an Associative array as a reference model 
         	// Type logic [63:0] and index type int

		//logic [63:0] ref_data [bit[31:0]];
	// Declare handles of type write_xtn & read_xtn to store the tlm_analysis_fifo data 	
		write_xtn src_data;
		read_xtn dst_data;
      		read_xtn read_cov_data;
		write_xtn write_cov_data;	
		covergroup cg1;
		//src_rd:coverpoint cov.
		src_addr:coverpoint write_cov_data.header[1:0]{
						bins b0={2'b00};
						bins b1={2'b01};
						bins b2={2'b10};
						illegal_bins b4={2'b11};}
		src_payload:coverpoint write_cov_data.header[7:2]{
						bins c0={[1:13]};
						bins c1={14};
						bins c2={16};
						bins c3={17};
						bins c4={[18:45]};
						bins c5={[46:63]};}
		src_addrXsrc_payload:cross src_addr,src_payload;
		endgroup
		covergroup cg2;
		dst_addr:coverpoint read_cov_data.header[1:0]{
						bins d0={2'b00};
						bins d1={2'b01};
						bins d2={2'b10};
						illegal_bins d4={2'b11};}
		dst_payload:coverpoint read_cov_data.header[7:2]{
						bins e0={[1:13]};
						bins e1={14};
						bins e2={16};
						bins e3={17};
						bins e4={[18:45]};
						bins e5={[46:63]};}
		dst_addrXdst_payload:cross dst_addr,dst_payload;
		/*no_of_cycles:coverpoint read_cov_data.no_of_cycles{
						bins f0={[0:29]};
						bins f1={>30};}*/
		endgroup
//------------------------------------------
// Methods
//------------------------------------------
	
// Standard UVM Methods:
extern function new(string name="scoreboard",uvm_component parent);
extern function void build_phase(uvm_phase phase);

extern task run_phase(uvm_phase phase);
extern task user_compare(write_xtn xtn1,read_xtn xtn2);
//extern function void check_data(read_xtn rd);
//extern function void report_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//
       // Add Constructor function
           // Create instances of uvm_tlm_analysis fifos inside the constructor
           // using new("fifo_h", this)
    function scoreboard::new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
		cg1=new;
		cg2=new;
		
		// fifo_dsth = new("fifo_dsth", this);
   		 //fifo_srch= new("fifo_srch", this);
          		 
	endfunction

function void scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"can't get env config")
	fifo_srch=new[env_cfg.no_of_source];
	fifo_dsth=new[env_cfg.no_of_destinations];
	foreach(fifo_srch[i])
	begin
		fifo_srch[i]=new($sformatf("fifo_srch[%0d]",i),this);
	end
	foreach(fifo_dsth[i])
	begin
		fifo_dsth[i]=new($sformatf("fifo_dsth[%0d]",i),this);
	end

endfunction

task scoreboard::run_phase(uvm_phase phase);
	super.run_phase(phase);
	begin
	forever
	begin
		fork
		begin

	//`uvm_info(get_type_name(),"scorboard is working fine",UVM_LOW)
			fifo_srch[0].get(src_data);
			write_cov_data=src_data;
			cg1.sample();
			$display("--------------------------------------------------");
			$display("------------SRC COV-------------------------------");
			$display("--------The source coverage = %p-------",cg1.get_coverage());
			$display("--------------------------------------------------");


		end
	
		begin


			fork
			fifo_dsth[0].get(dst_data);
			fifo_dsth[1].get(dst_data);
			fifo_dsth[2].get(dst_data);
			join_any
			disable fork;
			read_cov_data=dst_data;
			cg2.sample();
			$display("--------------------------------------------------");
			$display("------------DST COV-------------------------------");
			$display("the destination coverage = %p",cg2.get_coverage());
			$display("--------------------------------------------------");
		end
		join




	user_compare(src_data,dst_data);
	end



end


endtask


task scoreboard::user_compare(write_xtn xtn1,read_xtn xtn2);
//	src_data xtn1;
//	dst_data xtn2;
begin
	xtn1=write_xtn::type_id::create("xtn1",this);
	xtn2=read_xtn::type_id::create("xtn2",this);
	//`uvm_info(get_type_name(),"scorboard is working fine",UVM_LOW)
	//xtn1.print()
	$display("------------------------------------------------------------------------------------------------------------");
	$display("-----------------------------------SCORE BOARD REPORT-------------------------------------------------------");
	`uvm_info(get_type_name(),"the scoreboard data is ",UVM_LOW)
	if(xtn1.header==xtn2.header)
	begin
		`uvm_info(get_type_name(),"The header field matched",UVM_LOW)
		if(xtn1.payload==xtn2.payload)
		begin
			`uvm_info(get_type_name(),"The payload data fields matched",UVM_LOW)
			if(xtn1.parity==xtn2.parity)
				`uvm_info(get_type_name(),"The parity field matched",UVM_LOW)
			else
				`uvm_error(get_type_name(),"There is an mismatch is parity")
		end
		else
			`uvm_error(get_type_name(),"The payload data field is mismatched")
	end
	else
		`uvm_error(get_type_name(),"The header field is not matched")
	$display("-----------------------------------------------------------------------------------------------------------");
end
endtask

