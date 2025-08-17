// for verifying 'axis_stim_syn' only. 

`timescale 1ns / 1ps  // <time_unit>/<time_precision>
  // time_unit: measurement of delays / simulation time (#10 = 10<time_unit>)
  // time_precision: how delay values are rounded before being used in simulation (degree of accuracy of the time unit)

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

module axis_stim_syn_tb ;

  logic clk=0, rstn=0, rst;

  //always #2 clk = ~clk; // 250mhz period = 4ns, invert every 2ns
  always #5 clk = ~clk; // 100mhz 

  initial begin
    rstn <= 0;
    #20;
    rstn <= 1;
  end
  assign rst = !rstn;


//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------
logic en,cyc,clr,cont,trdy;

axis_stim_syn #
(
  .TDATA_NUM_BYTES(8),
  .FIXED(56'hAFE6_0000_6600)
) axis_stim_syn (
  .clk		        (clk    ) ,
  .rst            (rst    ) ,
  .en             (en     ) ,
  .clr            (clr    ) ,
  .cycle          (cyc    ) ,
  .cont           (cont   ) ,
  .M_AXIS_tdata   (       ) ,
  .M_AXIS_tdest   (       ) ,
  .M_AXIS_tkeep   (       ) ,
  .M_AXIS_tlast   (       ) ,
  .M_AXIS_tready  (trdy     ) ,
  .M_AXIS_tvalid  (       )
);

initial begin 
  en = '0; cyc = '0; clr = '0; cont='0; trdy=0;
  wait (rst == '0);
  #10us;trdy = '1;
  #10000ns;
  @(posedge clk);en = '1;
  #20000ns;@(posedge clk);trdy = '1;
  #60000ns;en = '0;
  @(posedge clk);en = '1;
  #60000ns;en = '0;
  @(posedge clk);en = '1;cyc='1;
  #60000ns;en = '0;
  @(posedge clk);en = '1;cyc='1;cont = '1;
  #40us;
  @(posedge clk);en = '1;cyc='1;cont = '0;
end


endmodule