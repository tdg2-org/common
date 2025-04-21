

`timescale 1ns / 1ps  // <time_unit>/<time_precision>
  // time_unit: measurement of delays / simulation time (#10 = 10<time_unit>)
  // time_precision: how delay values are rounded before being used in simulation (degree of accuracy of the time unit)

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

module i2c_top_tb ;

  logic clk=0,clk25=0, rstn=0, rst;

  //always #2 clk = ~clk; // 250mhz period = 4ns, invert every 2ns
  always #5 clk = ~clk; // 100mhz 
  always #20 clk25 = ~clk25; 

  initial begin
    rstn <= 0;
    #20;
    rstn <= 1;
  end
  assign rst = !rstn;


i2c_top i2c_top_inst (
  .clk    (clk        ),
  .rst    (rst        ),
  .i2c_send_data_i (0),
  .scl0_i (i2c0_scl_o ),
  .scl0_t (i2c0_scl_o ), // t=1, INPUT, t=0 OUTPUT
  .scl0_o (i2c0_scl_i ),
  .sda0_i (i2c0_sda_o ),
  .sda0_o (i2c0_sda_i ),
  .sda0_t (i2c0_sda_o ),
  .scl1_i (i2c1_scl_o ),
  .scl1_t (i2c1_scl_t ),
  .scl1_o (i2c1_scl_i ),
  .sda1_i (i2c1_sda_o ),
  .sda1_o (i2c1_sda_i ),
  .sda1_t (i2c1_sda_t )
);

logic start_tx=0,loop=0;

localparam int DW = 32;
//logic [DW-1:0]  data = 'h4512ffff;
logic RW = 0;//1=RD, 0=WR
logic [DW-1:0]  data = {7'h51,RW,24'h7aa534};

serial_data_gen_i2c_master_sim #(
  .DATA_WIDTH   (DW      ),           
//  .DATA_VALUE   (data   ),           
  .CLK_PERIOD   (100    )
) serial_data_gen_inst (
  .DATA_VALUE   (data     ),
  .start_tx     (start_tx ),
  .repeat_tx    (loop     ),
  .ser_clk      (i2c0_scl_o),
  .ser_data     (i2c0_sda_o)
);


//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

initial begin 
  wait (rst == 0);
  #50ns;
  start_tx = '1;#50ns;start_tx = '0;
  #5000ns;
  data = {7'h55,1'b1,24'h0};
  start_tx = '1;#50ns;start_tx = '0;

end 




endmodule