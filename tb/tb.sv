//******************************************environment****************************************//
class env extends uvm_env;
// registor as component
	`uvm_component_utils(env)

	//declare the handles for wr and rd agent top 
	master_agent_top mat_h;
	slave_agent_top sat_h;
	//slave_agent s_a;
	//declare the handles of virtual sequencer
	virtual_sequencer v_seqrh;
	//master_agent_sequencer m_seqrh;
	//declare the handles for sb
	scoreboard sb_h;
	//declare the handles for env config
	env_config env_cfg;
//	slave_agent_config sac_cfg[];
//	master_agent_config mas_cfg;
//-----------------------------------------
//--------------------METHODS----------------//
//----------------------------------------
	extern function new(string name = "env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass
//function new 
function env::new(string name = "env",uvm_component parent);
	super.new(name,parent);
endfunction
//build phase
function void env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"can't get config")
	//get the env config from the db
	if(env_cfg.has_ragent==1)
	begin
		sat_h=slave_agent_top::type_id::create("sat_h",this);
	end

	//if env_config has wagent then set the config to the master agent
	
	if(env_cfg.has_wagent==1)
	begin
	//	uvm_config_db#(master_agent_config)::set(this,"*","master_agent_config",env_cfg.mac_cfg);
		mat_h=master_agent_top::type_id::create("mat_h",this);
	end
	// if env_config has scoreboard then create the scoreboard
	if(env_cfg.has_scoreboard==1)
	begin
		sb_h=scoreboard::type_id::create("sb_h",this);
	end
	// if env_config has virtual sequencer then create instance for virtual sequencer
	if(env_cfg.has_virtual_sequencer==1)
	begin
		v_seqrh=virtual_sequencer::type_id::create("v_seqrh",this);
	end

endfunction
//connect_phase
function void env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(env_cfg.has_scoreboard)
		mat_h.m_agent_h.mam_h.wr_mon_ap.connect(sb_h.fifo_srch[0].analysis_export);
	for(int i=0;i<3;i++)
	begin
		sat_h.s_agent_h[i].sam_h.rd_mon_ap.connect(sb_h.fifo_dsth[i].analysis_export);
	end
		

 	if(env_cfg.has_virtual_sequencer==1)
	begin
		if(env_cfg.has_ragent)
			v_seqrh.m_seqrh=mat_h.m_agent_h.mas_h;
		if(env_cfg.has_wagent)
		for(int i=0;i<3;i++)
			v_seqrh.s_seqrh[i]=sat_h.s_agent_h[i].sas_h;
	end

endfunction
