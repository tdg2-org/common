// simulation only, not synthesizable
// designed for i2c testing, this simulates a master i2c, for testing a synthesizable slave i2c

`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module serial_data_gen_i2c_master_sim #(
  parameter int DATA_WIDTH  = 8,
  // The serial data to be transmitted.
  parameter logic [DATA_WIDTH-1:0] DATA_VALUE = 8'hA5,
  // Clock period (simulation time units)
  parameter int CLK_PERIOD  = 20
)(
  input  logic start_tx,     // Assert to start a transmission
  input  logic repeat_tx,    // If high, repeat transmission after each frame
  output logic ser_clk,      // Serial clock output aligned to the data
  output logic ser_data,      // Serial data output
  output logic ser_data_tri   // Serial data output t=1, INPUT, t=0 OUTPUT
  
);

  int bit_index;
  logic [DATA_WIDTH-1:0] data_val = DATA_VALUE;
  //logic [DATA_WIDTH:0] data_val = {DATA_VALUE, 1'b0};
  //logic [DATA_WIDTH:0] data_val = (MSB_FIRST) ? {DATA_VALUE, 1'b0} : {1'b0, DATA_VALUE};


  // This initial block is intended only for simulation (testbench use).
  initial begin
    // Set initial output values.
    ser_clk  = 1;
    ser_data = 1;
    ser_data_tri   = 1;
    // Wait for a rising edge on start_tx.
    @(posedge start_tx);
    
    ser_data_tri = 0;
    
    ser_data = 0;
    #(CLK_PERIOD/2);

    // Transmission loop (runs once if repeat_tx is low)
    do begin
      // Transmit from MSB (DATA_WIDTH-1) downto LSB (0)
      //for (bit_index = DATA_WIDTH-1; bit_index >= 0; bit_index--) begin
      for (bit_index = DATA_WIDTH-1; bit_index >= 0; bit_index--) begin
        // Data updates in the middle of the low phase.
        // First, complete the high phase.
        ser_clk = 1;
        #(CLK_PERIOD/2);
        // Now falling edge starts the low phase.
        ser_clk = 0;
        if (bit_index == 0) ser_data_tri = 1;
        // Wait a quarter cycle (half of the low phase) before updating data.
        #(CLK_PERIOD/4);
        ser_data = data_val[bit_index];
        // Complete the low phase.
        #(CLK_PERIOD/4);
      end
      
      // ACK is 9th clock every time, slave will now have control of data for this one period
      
      ser_clk  = 1;
      #(CLK_PERIOD/2);
      ser_clk = 0;
      ser_data_tri = 0;

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
  .CLK_PERIOD   (100    )        
) serial_data_gen_inst (
  .start_tx     (       ),
  .repeat_tx    (       ),
  .ser_clk      (       ),
  .ser_data     (       )
);

*/

