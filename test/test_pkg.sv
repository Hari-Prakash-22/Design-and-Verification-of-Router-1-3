package test_pkg;


	//import uvm_pkg.sv
	
	import uvm_pkg::*;
	

		
	//include uvm_macros.sv
	//include all other files
	`include "uvm_macros.svh"
	`include "tb_defs.sv"
	`include "write_xtn.sv"
	`include "master_agent_config.sv"
	`include "slave_agent_config.sv"
	`include "env_config.sv"
	`include "master_agent_driver.sv"
	`include "master_agent_monitor.sv"
	`include "master_agent_sequencer.sv"
	`include "master_agent.sv"
	`include "master_agent_top.sv"
	`include "master_agent_seqs.sv"

	`include "read_xtn.sv"
	`include "slave_agent_monitor.sv"
	`include "slave_agent_sequencer.sv"
	`include "slave_agent_seqs.sv"
	`include "slave_agent_driver.sv"
	`include "slave_agent.sv"
	`include "slave_agent_top.sv"

	`include "virtual_sequencer.sv"
	`include "virtual_seqs.sv"
	`include "scoreboard.sv"

	`include "tb.sv"


	`include "test_lib.sv"
	
endpackage
