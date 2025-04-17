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
//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------
  localparam int numBytes = DATA_WIDTH / 8;
  localparam int DWRem = DATA_WIDTH % 8;
  initial if (DWRem != 0) $fatal(1, "ERROR: Parameter DATA_WIDTH (%0d) is not divisible by 8.", DATA_WIDTH);

  int bit_index, byteCntClk, byteCntDat;
  logic [DATA_WIDTH-1:0] data_val;
  //logic [DATA_WIDTH-1:0] data_val = DATA_VALUE;
  //logic [DATA_WIDTH:0] data_val = {DATA_VALUE, 1'b0};
  //logic [DATA_WIDTH:0] data_val = (MSB_FIRST) ? {DATA_VALUE, 1'b0} : {1'b0, DATA_VALUE};

  typedef enum {
    IDLE,DATAST,ACK
  } i2c_sm_type;

  i2c_sm_type I2C_SM=IDLE, CLK_SM=IDLE,DAT_SM=IDLE;

//-------------------------------------------------------------------------------------------------
// clk
//-------------------------------------------------------------------------------------------------
always begin
  case (CLK_SM)
    IDLE: begin 
      byteCntClk = numBytes;
      // init
      ser_clk  = 1;
      ser_data_tri   = 1;
      @(posedge start_tx);
      ser_data_tri   = 0;
      //start cond
      #(CLK_PERIOD/2);
      ser_clk  = 0;
      CLK_SM = DATAST;
    end 
    
    DATAST: begin 
      //data start
      #(CLK_PERIOD/2);
      ser_clk  = 1;
      for (int idx = 0; idx <7; idx++) begin 
        #(CLK_PERIOD/2);
        ser_clk  = 0;
        #(CLK_PERIOD/2);
        ser_clk  = 1;
      end 
      // ack
      #(CLK_PERIOD/2);
      ser_data_tri = 1;
      ser_clk  = 0;
      #(CLK_PERIOD/2);
      ser_clk  = 1;
      #(CLK_PERIOD/2);
      ser_data_tri = 0;
      ser_clk  = 0;
      if (byteCntClk > 1) begin 
        byteCntClk--;
        CLK_SM = DATAST;
      end else CLK_SM = ACK;
    
    end

    ACK: begin 
      // end
      #(CLK_PERIOD/2);
      ser_clk  = 1;
      CLK_SM = IDLE;
    end
  endcase
end

//-------------------------------------------------------------------------------------------------
// data
//-------------------------------------------------------------------------------------------------
always begin
  case (DAT_SM)
    IDLE: begin 
      byteCntDat = numBytes;
      //init
      ser_data = 1;
      @(posedge start_tx);
      // start cond
      #(CLK_PERIOD/4);
      ser_data = 0; 
      DAT_SM = DATAST;
    end 
    
    DATAST: begin 
      // data start
      #(CLK_PERIOD/2);
      //for (int idx1 = 23; idx1 >=16; idx1--)
      //for (int idx1 = 15; idx1 >=8; idx1--)
      //for (int idx1 = 7; idx1 >=0; idx1--) begin 
      for (int idx1 = (byteCntDat*8)-1; idx1 >= ((byteCntDat-1)*8); idx1--) begin 
        ser_data = DATA_VALUE[idx1];
        #(CLK_PERIOD);
      end
      // ack
      ser_data = 0; 
      #(CLK_PERIOD/2);
      if (byteCntDat > 1) begin
        byteCntDat--;
        DAT_SM = DATAST;
      end else DAT_SM = ACK;
    
    end 
    
    ACK: begin 
      // stop cond
      #(CLK_PERIOD);
      ser_data = 1;
      DAT_SM = IDLE; 
    end 
  endcase
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

