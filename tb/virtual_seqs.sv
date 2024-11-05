class vbase_seq extends uvm_sequence #(uvm_sequence_item);

	
  // Factory registration
	`uvm_object_utils(vbase_seq)  
  // Declare handles for master sequencer, slave sequencer and virtual sequencer
    master_agent_sequencer m_seqrh;
    slave_agent_sequencer s_seqrh[];
    virtual_sequencer v_seqrh;
	env_config env_cfg;
	bit[1:0]addr;
  // Handles for all the sequences

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "vbase_seq");
	extern task body();
	endclass : vbase_seq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function vbase_seq::new(string name ="vbase_seq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//


task vbase_seq::body();
	if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg))
		`uvm_fatal(get_type_name(),"can't get the env_cfg ")
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal(get_type_name(),"can't get the addr ")
  assert($cast(v_seqrh,m_sequencer)) else begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end
	s_seqrh=new[env_cfg.no_of_destinations];
	foreach(s_seqrh[i])
	begin	
		s_seqrh[i] = v_seqrh.s_seqrh[i];
	end

  m_seqrh = v_seqrh.m_seqrh;
endtask: body
class v_seq_1 extends vbase_seq;
	`uvm_object_utils(v_seq_1)
	small_pkt v_small_seq;
	small_rd_pkt v_small_rd_seq;
//----------------------------------------------
//-----------METHODS---------------------------
//--------------------------------------------

	extern function new(string name="v_seq_1");
	extern task body();
endclass

function v_seq_1::new(string name="v_seq_1");
	super.new(name);
endfunction

task v_seq_1::body();
	super.body();
	v_small_seq=small_pkt::type_id::create("small_pkt");
	v_small_rd_seq=small_rd_pkt::type_id::create("small_rd_pkt");
fork
	begin
	v_small_seq.start(m_seqrh);
	end

	begin
		if(addr==2'b00)
			v_small_rd_seq.start(s_seqrh[0]);
		else if(addr==2'b01)
			v_small_rd_seq.start(s_seqrh[1]);
		else if(addr==2'b10)
			v_small_rd_seq.start(s_seqrh[2]);
	end
join
endtask

class v_seq_2 extends vbase_seq;
	`uvm_object_utils(v_seq_2)
	medium_pkt v_medium_seq;
	medium_rd_pkt v_medium_rd_seq;
//----------------------------------------------
//-----------METHODS---------------------------
//--------------------------------------------

	extern function new(string name="v_seq_2");
	extern task body();
endclass

function v_seq_2::new(string name="v_seq_2");
	super.new(name);
endfunction

task v_seq_2::body();
	super.body();
	v_medium_seq=medium_pkt::type_id::create("medium_pkt");
	v_medium_rd_seq=medium_rd_pkt::type_id::create("medium_rd_pkt");
fork
	begin
	v_medium_seq.start(m_seqrh);
	end

	begin
		if(addr==2'b00)
			v_medium_rd_seq.start(s_seqrh[0]);
		else if(addr==2'b01)
			v_medium_rd_seq.start(s_seqrh[1]);
		else if(addr==2'b10)
			v_medium_rd_seq.start(s_seqrh[2]);
	end
join
endtask
class v_seq_3 extends vbase_seq;
	`uvm_object_utils(v_seq_3)
	large_pkt v_large_seq;
	large_rd_pkt v_large_rd_seq;
//----------------------------------------------
//-----------METHODS---------------------------
//--------------------------------------------

	extern function new(string name="v_seq_3");
	extern task body();
endclass

function v_seq_3::new(string name="v_seq_3");
	super.new(name);
endfunction

task v_seq_3::body();
	super.body();
	v_large_seq=large_pkt::type_id::create("large_pkt");
	v_large_rd_seq=large_rd_pkt::type_id::create("large_rd_pkt");
fork
	begin
	v_large_seq.start(m_seqrh);
	end

	begin
		if(addr==2'b00)
			v_large_rd_seq.start(s_seqrh[0]);
		 if(addr==2'b01)
			v_large_rd_seq.start(s_seqrh[1]);
		if(addr==2'b10)
			v_large_rd_seq.start(s_seqrh[2]);
	end
join
endtask
