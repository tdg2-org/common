`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module array_shift_delay # (
  parameter int DELAY_LEN = 8,
  parameter int DW        = 16
)(
  input                         clk         ,
  input                         rst         ,
  input   logic signed [DW-1:0] d_in        ,
  input   logic                 d_in_val    ,
  output  logic signed [DW-1:0] d_out       ,
  output  logic                 d_out_val
);

  logic signed [DW-1:0] d_delay [DELAY_LEN-1:0] = '{default:'0};
  logic [DELAY_LEN-1:0] val_delay;

  always_ff @(posedge clk) begin 
    d_delay   <= {d_delay[DELAY_LEN-2:0], d_in};
    val_delay <= {val_delay[DELAY_LEN-2:0], d_in_val};
  end 

  assign d_out      = d_delay[DELAY_LEN-1];
  assign d_out_val  = val_delay[DELAY_LEN-1];


endmodule
/*

  array_shift_delay # (
    .DELAY_LEN  ()   ,
    .DW         ()
  ) array_shift_delay (
    .clk        ()   ,
    .rst        ()   ,
    .d_in       ()   ,
    .d_in_val   ()   ,
    .d_out      ()   ,
    .d_out_val  ()
  );

*/