// DELETE THIS OR FIX IT OR MERGE 'EN' OPTION INTO OTHER MODULE






`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module array_shift_en_delay # (
  parameter int LEN = 8,
  parameter int DW  = 16
)(
  input                         clk         ,
  input                         rst         ,
  input   logic signed [DW-1:0] d_in        ,
  input   logic                 d_in_val    ,
  input   logic                 shift_en    ,
  output  logic signed [DW-1:0] d_out       ,
  output  logic                 d_out_val
);

  logic signed [DW-1:0] d_delay [LEN-1:0] = '{default:'0};
  logic [LEN-1:0] val_delay;

  always_ff @(posedge clk) begin 
    if (shift_en) begin
      d_delay   <= {d_delay[LEN-2:0], d_in};
      val_delay <= {val_delay[LEN-2:0], d_in_val};
    end
    if (&val_delay[LEN-2:0])  d_out_val <= d_in_val;
  end 

  assign d_out      = d_delay[LEN-1];
  //assign d_out_val  = val_delay[LEN-1];


endmodule
/*

  array_shift_en_delay # (
    .LEN  (),
    .DW   ()
  ) array_shift_en_delay (
    .clk        ()   ,
    .rst        ()   ,
    .d_in       ()   ,
    .d_in_val   ()   ,
    .shift_en   ()   ,
    .d_out      ()   ,
    .d_out_val  ()
  );

  array_shift_en_delay # (
    .LEN(), .DW()
  ) array_shift_en_delay (
    .clk(clk), .rst(rst),
    .d_in     (),
    .d_in_val (),
    .shift_en (),
    .d_out    (),
    .d_out_val()
  );


*/