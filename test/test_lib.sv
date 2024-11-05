class base_test extends uvm_test;

   // Factory Registration
	`uvm_component_utils(base_test)

  
    // Declare the handles env, env_config, master_agent_config and
    // slave_agent_config as envh, m_cfg, s_cfg & env_cfg       	
    	env env_h;
	env_config env_cfg;
	master_agent_config m_cfg;
	slave_agent_config s_cfg[];
 
    // Declare has_ragent=1 & has_wagent=1 as int
    bit has_ragent = 1;
    bit has_wagent = 1;
    int no_of_destinations=3;
	int no_of_source=1;
	bit [1:0]addr;

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
    extern function void config_router();
 endclass
//-----------------  constructor new method  -------------------//
function base_test::new(string name = "base_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  config_ram() method  -------------------//

function void base_test::config_router();
    if (has_wagent)
		begin 
			//for write agent
			// set is_active to UVM_ACTIVE 
			m_cfg.is_active = UVM_ACTIVE;
			// Get the virtual interface from the config database
			if(!uvm_config_db #(virtual router_if)::get(this,"","vif",m_cfg.vif))
			`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")  
			//assign m_wr_cfg to env_cfg.m_cfg*/
			env_cfg.mac_cfg = m_cfg;

		end

    if(has_ragent) 
		begin
			//for read agent
			s_cfg=new[no_of_destinations];
			env_cfg.sac_cfg=new[no_of_destinations];
			// Get the virtual interface from the config database
			foreach(s_cfg[i])
			begin
			s_cfg[i]=slave_agent_config::type_id::create($sformatf("s_cfg[%0d]",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("vif%0d",i),s_cfg[i].vif))
			`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")  
			// set is_active to UVM_ACTIVE 
            		s_cfg[i].is_active = UVM_ACTIVE;
			//assign m_rd_cfg to m_tb_cfg.m_rd_cfg*/
			env_cfg.sac_cfg[i] = s_cfg[i];
			end
        end
		// setting the env parameters
        env_cfg.has_wagent = has_wagent;
        env_cfg.has_ragent = has_ragent;
        env_cfg.no_of_destinations=no_of_destinations;
	env_cfg.no_of_source=no_of_source;
		// set the config object into UVM config DB  
		uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);


endfunction
	

//-----------------  build() phase method  -------------------//
            
function void base_test::build_phase(uvm_phase phase);
	// Create the instance for ram_env_config
 	env_cfg=env_config::type_id::create("env_cfg");

    if(has_wagent)
		// Create the instance for  master_agent_config 
        m_cfg=master_agent_config::type_id::create("m_cfg");

	//call function config_router()
    config_router();
 
    super.build_phase(phase);
	// create the instance for env
	env_h=env::type_id::create("env_h", this);
	addr=$urandom%3;
	uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction



// extending the test form the base class
class small_test extends base_test;
	`uvm_component_utils(small_test)

	// Declare the handle for sequence
    //small_pkt small_seq_h;//src seq
//	small_rd_pkt slave_seq_h;//dst seq
	v_seq_1 v_seq1;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "small_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function small_test::new(string name ="small_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void small_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task small_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);
	v_seq1=v_seq_1::type_id::create("v_seq1");
	v_seq1.start(env_h.v_seqrh);

	phase.drop_objection(this);
endtask
	
class medium_test extends base_test;
	`uvm_component_utils(medium_test)

	// Declare the handle for sequence
    medium_pkt medium_seq_h;
	medium_rd_pkt medium_rd_seq_h;
	v_seq_2 v_seq2;

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "medium_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function medium_test::new(string name ="medium_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void medium_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task medium_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);
	phase.raise_objection(this);
	v_seq2=v_seq_2::type_id::create("v_seq2");
	v_seq2.start(env_h.v_seqrh);
	

	phase.drop_objection(this);
endtask

class large_test extends base_test;
	`uvm_component_utils(large_test)

	// Declare the handle for sequence
    large_pkt large_seq_h;
	large_rd_pkt large_rd_pkt_seq;

	v_seq_3 v_seq3;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "large_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function large_test::new(string name ="large_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void large_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task large_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);
	v_seq3=v_seq_3::type_id::create("v_seq3");
	v_seq3.start(env_h.v_seqrh);
#500;
	phase.drop_objection(this);
endtask
