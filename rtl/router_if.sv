interface router_if(input bit clock);
	logic [7:0]data_in;
	logic resetn;
	logic pkt_valid;
	logic busy;
	logic err;
	logic [7:0]data_out;
	logic vld_out;
	logic read_enb;
// source driver clocking block
clocking src_drv_cb@(posedge clock);
	default input #1 output #0;
	output data_in;
	output resetn;
	output pkt_valid;
	input err;
	input busy;
endclocking:src_drv_cb
//source monitor clocking block
clocking src_mon_cb@(posedge clock);
	default input #1 output #0;
	input data_in;
	input resetn;
	input pkt_valid;
	input busy;
	input err;
endclocking:src_mon_cb
//destination driver clocking bock
clocking dst_drv_cb@(posedge clock);
	default input #1 output #0;
	input vld_out;
	output read_enb;
endclocking:dst_drv_cb
//destination monitor clocking block
clocking dst_mon_cb@(posedge clock);
	default input #1 output #0;
	input data_out;
	input read_enb;
endclocking:dst_mon_cb

// source driver clocking modport
modport SRC_DRV(clocking src_drv_cb);

// source monitor clocking modport
modport SRC_MON(clocking src_mon_cb);

// destination driver clocking modport
modport DST_DRV(clocking dst_drv_cb);

// destination driver clocking modport
modport DST_MON(clocking dst_mon_cb);



endinterface:router_if


