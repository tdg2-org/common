// Verilog wrapper

module data_stream_gen_wrapper #(
    // Length of the binary stream.
    parameter integer STREAM_LEN  = 8,
    // The binary stream, declared as a bit vector.
    parameter [STREAM_LEN-1:0] BIT_STREAM = 8'b10101010,
    // Number of clock cycles to hold each bit.
    parameter integer HOLD_CYCLES = 10,
    // If set to 1, the stream loops automatically.
    // If 0, the stream stops at the last bit and waits for a manual restart.
    parameter LOOP  = 1
)(
    input  clk,
    input  reset,
    // Manual cycle start trigger (only used if LOOP==0)
    input  start_in,
    output data_out
);
///////////////////////////////////////////////////////////////////////////////////////////////////

  data_stream_gen #(
    .STREAM_LEN   (STREAM_LEN),
    .BIT_STREAM   (BIT_STREAM),
    .HOLD_CYCLES  (HOLD_CYCLES),
    .LOOP         (LOOP)
  ) data_stream_gen_inst (
    .clk          (clk),   
    .reset        (reset),   
    .start_in     (start_in),   
    .data_out     (data_out)
  );


endmodule