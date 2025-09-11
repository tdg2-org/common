// for verifying 'axis_stim_syn' only. 

`timescale 1ns / 1ps  // <time_unit>/<time_precision>
  // time_unit: measurement of delays / simulation time (#10 = 10<time_unit>)
  // time_precision: how delay values are rounded before being used in simulation (degree of accuracy of the time unit)

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

module dft_tb ;

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

  logic signed [15:0] x;

  dft_mdl dft_mdl_i(
    .rst    (rst  ),
    .clk    (clk  ),
    .x      (x    ),
    .wren_i (     ),
    .led_o  (     ) 
  );

  sin_gen_mdl #(
    .N(7)
  ) sin_gen_mdl_i (
    .rst    (rst  ),
    .clk    (clk  ),
    .sin_o  (x    ),
    .cos_o  (     ),
    .val    (xval  )
  );

  dft_bin_real_mdl #(
    .N(1024   ) ,
    .K(7      )
  ) dft_bin_real_mdl_inst (
    .clk            (clk  ),
    .rst            (rst  ),
    .sample_valid   (xval ),
    .x              (x    ),           // real input sample
    .bin_done       (),
    .X_re           (),
    .X_im           ()
  );



/*
logic en,cyc,clr,cont,trdy;

axis_stim_syn #
(
  .TDATA_NUM_BYTES  (128),
  .FIXED            (1016'h0)
) axis_stim_syn (
  .clk		        (clk    ) ,
  .rst            (rst    ) ,
  .en             (en     ) ,
  .clr            (clr    ) ,
  .cycle_i        (cyc    ) ,
  .cont_i         (cont   ) ,
  .frame_len      (8'd32     ) ,
  .M_AXIS_tdata   (       ) ,
  .M_AXIS_tdest   (       ) ,
  .M_AXIS_tkeep   (       ) ,
  .M_AXIS_tlast   (       ) ,
  .M_AXIS_tready  (trdy   ) ,
  .M_AXIS_tvalid  (       )
);

initial begin 
  en = '0; cyc = '0; clr = '0; cont='0; trdy=0;
  wait (rst == '0);
  #10us;@(posedge clk);trdy = '1;en = '1;
  
  #0.08us;@(posedge clk);trdy = '0;
  #10us;@(posedge clk);trdy = '1;
  
  #20us;@(posedge clk);en='0;@(posedge clk);en='1;
  
  #20us;@(posedge clk);cyc=1;cont=1;en=0;@(posedge clk);en=1;
  #30us;@(posedge clk);cont=0;
  #30us;@(posedge clk);cyc=0;

  
 // @(posedge clk);en = '1;
 // #20000ns;@(posedge clk);trdy = '1;
 // #60000ns;en = '0;
 // @(posedge clk);en = '1;
 // #60000ns;en = '0;
 // @(posedge clk);en = '1;cyc='1;
 // #60000ns;en = '0;
 // @(posedge clk);en = '1;cyc='1;cont = '1;
 // #40us;
 // @(posedge clk);en = '1;cyc='1;cont = '0;
  
  
  
  
  
end
*/

endmodule