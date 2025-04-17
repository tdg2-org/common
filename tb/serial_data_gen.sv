// simulation only, not synthesizable

`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module serial_data_gen #(
  parameter int DATA_WIDTH  = 8,
  // The serial data to be transmitted.
  parameter logic [DATA_WIDTH-1:0] DATA_VALUE = 8'hA5,
  // Clock period (simulation time units)
  parameter int CLK_PERIOD  = 20,
  // When 1 update data on the rising edge; when 0, update on the falling edge.
  parameter bit TRANS_EDGE  = 1,
  // When 1, transmit MSB first; when 0, transmit LSB first.
  parameter bit MSB_FIRST = 1,
  // When 1, update data in the middle of a half-cycle rather than on the edge.
  parameter bit MID_CYCLE = 0
)(
  input  logic start_tx,     // Assert to start a transmission
  input  logic repeat_tx,    // If high, repeat transmission after each frame
  output logic ser_clk,      // Serial clock output aligned to the data
  output logic ser_data      // Serial data output
);

  int bit_index;


  // This initial block is intended only for simulation (testbench use).
  initial begin
    // Set initial output values.
    ser_clk  = 1;
    ser_data = 1;
    
    // Wait for a rising edge on start_tx.
    @(posedge start_tx);

    // Transmission loop (runs once if repeat_tx is low)
    do begin
      if (MSB_FIRST) begin
        // Transmit from MSB (DATA_WIDTH-1) downto LSB (0)
        for (bit_index = DATA_WIDTH-1; bit_index >= 0; bit_index--) begin
          if (!MID_CYCLE) begin
            // Standard edge-based transition.
            if (TRANS_EDGE) begin
              // Update on rising edge.
              ser_clk = 0;
              #(CLK_PERIOD/2);
              ser_data = DATA_VALUE[bit_index];
              ser_clk = 1;
              #(CLK_PERIOD/2);
            end else begin
              // Update on falling edge.
              ser_clk = 1;
              #(CLK_PERIOD/2);
              ser_data = DATA_VALUE[bit_index];
              ser_clk = 0;
              #(CLK_PERIOD/2);
            end
          end else begin
            // Mid-cycle data update.
            if (TRANS_EDGE) begin
              // Data updates in the middle of the high phase.
              // First, complete the low phase.
              ser_clk = 0;
              #(CLK_PERIOD/2);
              // Now rising edge starts the high phase.
              ser_clk = 1;
              // Wait a quarter cycle (half of the high phase) before updating data.
              #(CLK_PERIOD/4);
              ser_data = DATA_VALUE[bit_index];
              // Complete the high phase.
              #(CLK_PERIOD/4);
            end else begin
              // Data updates in the middle of the low phase.
              // First, complete the high phase.
              ser_clk = 1;
              #(CLK_PERIOD/2);
              // Now falling edge starts the low phase.
              ser_clk = 0;
              // Wait a quarter cycle (half of the low phase) before updating data.
              #(CLK_PERIOD/4);
              ser_data = DATA_VALUE[bit_index];
              // Complete the low phase.
              #(CLK_PERIOD/4);
            end
          end
        end
      end else begin
        // LSB first transmission (bits from 0 to DATA_WIDTH-1)
        for (int bit_index = 0; bit_index < DATA_WIDTH; bit_index++) begin
          if (!MID_CYCLE) begin
            // Standard edge-based transition.
            if (TRANS_EDGE) begin
              ser_clk = 0;
              #(CLK_PERIOD/2);
              ser_data = DATA_VALUE[bit_index];
              ser_clk = 1;
              #(CLK_PERIOD/2);
            end else begin
              ser_clk = 1;
              #(CLK_PERIOD/2);
              ser_data = DATA_VALUE[bit_index];
              ser_clk = 0;
              #(CLK_PERIOD/2);
            end
          end else begin
            // Mid-cycle data update.
            if (TRANS_EDGE) begin
              ser_clk = 0;
              #(CLK_PERIOD/2);
              ser_clk = 1;
              #(CLK_PERIOD/4);
              ser_data = DATA_VALUE[bit_index];
              #(CLK_PERIOD/4);
            end else begin
              ser_clk = 1;
              #(CLK_PERIOD/2);
              ser_clk = 0;
              #(CLK_PERIOD/4);
              ser_data = DATA_VALUE[bit_index];
              #(CLK_PERIOD/4);
            end
          end
        end
      end
      
      // Optional idle period between transmissions.
      #(CLK_PERIOD);
      
    end while (repeat_tx);
    
    // End of transmission: final outputs are held.
  end

endmodule

/*

serial_data_gen #(
  .DATA_WIDTH   (8      ),           
  .DATA_VALUE   ('h85   ),           
  .CLK_PERIOD   (100    ),           
  .TRANS_EDGE   (1      ), 
  .MSB_FIRST    (1      ),
  .MID_CYCLE    (0       )
) serial_data_gen_inst (
  .start_tx     (       ),
  .repeat_tx    (       ),
  .ser_clk      (       ),
  .ser_data     (       )
);

*/

