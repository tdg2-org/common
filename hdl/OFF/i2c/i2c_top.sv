

`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module i2c_top (
  input       clk     ,
  input       rst     ,
  input [9:0] bscan_i ,
  output      tdo_o   ,  
  input       scl0_i  ,
  input       scl0_t  ,
  output      scl0_o  ,
  input       sda0_i  ,
  output      sda0_o  ,
  input       sda0_t  ,
  input       scl1_i  ,
  input       scl1_t  ,
  output      scl1_o  ,
  input       sda1_i  ,
  output      sda1_o  ,
  input       sda1_t 
);

(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "TRUE" *) i2c_sink i2c_sink_inst (
    .clk    (clk    ),
    .rst    (rst    ),
    .scl_i  (scl0_i ),
    .scl_t  (scl0_t ),
    .scl_o  (scl0_o ),
    .sda_i  (sda0_i ),
    .sda_o  (sda0_o ),
    .sda_t  (sda0_t )
  );
  
//(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "TRUE" *) i2c_sink i2c_sink_inst2 (
//    .clk    (clk    ),
//    .rst    (rst    ),
//    .scl_i  (scl1_i ),
//    .scl_t  (scl1_t ),
//    .scl_o  (scl1_o ),
//    .sda_i  (sda1_i ),
//    .sda_o  (sda1_o ),
//    .sda_t  (sda1_t )
//  );

`ifndef QUESTA
`ifndef MODELSIM
debug_bridge_RM debug_bridge_RM_inst (
  .clk                (clk                ), // input wire clk
  .S_BSCAN_bscanid_en (0                  ), // input wire S_BSCAN_bscanid_en
  .S_BSCAN_capture    (bscan_i[9]         ), // input wire S_BSCAN_capture
  .S_BSCAN_drck       (bscan_i[8]         ), // input wire S_BSCAN_drck
  .S_BSCAN_reset      (bscan_i[7]         ), // input wire S_BSCAN_reset
  .S_BSCAN_runtest    (bscan_i[6]         ), // input wire S_BSCAN_runtest
  .S_BSCAN_sel        (bscan_i[5]         ), // input wire S_BSCAN_sel
  .S_BSCAN_shift      (bscan_i[4]         ), // input wire S_BSCAN_shift
  .S_BSCAN_tck        (bscan_i[3]         ), // input wire S_BSCAN_tck
  .S_BSCAN_tdi        (bscan_i[2]         ), // input wire S_BSCAN_tdi
  .S_BSCAN_tms        (bscan_i[1]         ), // input wire S_BSCAN_tms
  .S_BSCAN_update     (bscan_i[0]         ), // input wire S_BSCAN_update
  .S_BSCAN_tdo        (tdo_o              )  // output wire S_BSCAN_tdo
);
`endif
`endif 

endmodule