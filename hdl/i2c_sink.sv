

`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module i2c_sink (
  input   clk   ,
  input   rst   ,
  input   scl_i ,
  input   scl_t ,
  output  scl_o ,
  input   sda_i ,
  output  sda_o ,
  input   sda_t 
);

  assign sda_o = '1;
  assign scl_o = '1;


endmodule
