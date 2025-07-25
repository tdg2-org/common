`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module array_shift_delay_simple # (
  parameter int LEN = 8,
  parameter int DW  = 16
)(
  input                         clk         ,
  input   logic signed [DW-1:0] d_in        ,
  output  logic signed [DW-1:0] d_out       
);

  logic signed [DW-1:0] d_delay [LEN-1:0] = '{default:'0};

  always_ff @(posedge clk) begin 
    d_delay   <= {d_delay[LEN-2:0], d_in};
  end 

  assign d_out      = d_delay[LEN-1];

endmodule
/*

array_shift_delay_simple # (
  .LEN  (8),
  .DW   (16)
)array_shift_delay_simple(
  .clk    (clk) ,
  .d_in   (d_in)  ,
  .d_out  (d_out)    
);

array_shift_delay_simple # (.LEN(8),.DW(16)) array_shift_delay_simple (clk,d_in,d_out);


*/