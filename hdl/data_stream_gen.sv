module data_stream_gen #(
    // Length of the binary stream.
    parameter integer STREAM_LEN    = 8,
    // The binary stream, declared as a bit vector.
    parameter bit [STREAM_LEN-1:0] BIT_STREAM = 8'b10101010,
    // Number of clock cycles to hold each bit.
    parameter integer HOLD_CYCLES   = 10,
    // If set to 1, the stream loops automatically.
    // If 0, the stream stops at the last bit and waits for a manual restart.
    parameter bit LOOP              = 1
)(
    input  logic clk,
    input  logic reset,
    // Manual cycle start trigger (only used if LOOP==0)
    input  logic start_in,
    output logic data_out
);

  // Counter to count clock cycles within each bit period.
  logic [$clog2(HOLD_CYCLES)-1:0] hold_counter;
  // Counter to select the current bit in BIT_STREAM.
  logic [$clog2(STREAM_LEN)-1:0] index_counter;

  logic start_sr;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      hold_counter  <= '0;
      index_counter <= '0;
    end else begin
      start_sr <= start_in;
      if (hold_counter == HOLD_CYCLES - 1) begin
        hold_counter <= '0;
        // Check if we are at the end of the stream.
        if (index_counter == STREAM_LEN - 1) begin
          if (LOOP) begin
            // Loop automatically.
            index_counter <= '0;
          end else begin
            // Hold the last bit until a manual start pulse is received.
            if (start_in && !start_sr) // rising edge
              index_counter <= '0;
            else
              index_counter <= index_counter;  // Remain at the last bit.
          end
        end else begin
          index_counter <= index_counter + 1;
        end
      end else begin
        hold_counter <= hold_counter + 1;
      end
    end
  end

  // Output the current bit from the BIT_STREAM.
  assign data_out = BIT_STREAM[index_counter];

endmodule
