

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

  logic scl,sda;

  always_comb begin
    if (scl_t)  scl <= '1;
    else        scl <= '0;

    if (sda_t)  sda <= '1;
    else        sda <= '0;

  end
  
  // T = high -> output buffer DISABLED

  //assign sda_o = sda_i;
  //assign scl_o = scl_i;

  assign sda_o = sda;
  assign scl_o = scl;


endmodule
