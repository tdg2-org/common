// for verifying 'axis_stim_syn' only. 

`timescale 1ns / 1ps  // <time_unit>/<time_precision>
  // time_unit: measurement of delays / simulation time (#10 = 10<time_unit>)
  // time_precision: how delay values are rounded before being used in simulation (degree of accuracy of the time unit)

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

module fir_tb ;

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

  
//  @(posedge clk);en = '1;
//  #20000ns;@(posedge clk);trdy = '1;
//  #60000ns;en = '0;
//  @(posedge clk);en = '1;
//  #60000ns;en = '0;
//  @(posedge clk);en = '1;cyc='1;
//  #60000ns;en = '0;
//  @(posedge clk);en = '1;cyc='1;cont = '1;
//  #40us;
//  @(posedge clk);en = '1;cyc='1;cont = '0;
  
    
end
*/


logic val='0,rdy, frdy, fval; 
logic signed [15:0] dat = '0, fdat;

initial begin 
  wait (rdy == '1);#5us;

  //forever begin 
  repeat (50) begin
    wait (rdy == '1);
    @(posedge clk);
    val = '1;
    dat = signed'(-8191);
    wait (rdy == '1);
    @(posedge clk);
    dat = signed'(8191);
  end 

  repeat (50) begin
    wait (rdy == '1);
    @(posedge clk);
    val = '1;
    dat = signed'(-2730);
    wait (rdy == '1);
    @(posedge clk);
    dat = signed'(2730);
  end 



end 

axis_fifo_32k fifo32k (
  .s_axis_aresetn (rstn),  // input wire s_axis_aresetn
  .s_axis_aclk    (clk),        // input wire s_axis_aclk
  .s_axis_tvalid  (val),    // input wire s_axis_tvalid
  .s_axis_tready  (rdy),    // output wire s_axis_tready
  .s_axis_tdata   (dat),      // input wire [15 : 0] s_axis_tdata
  .m_axis_tvalid  (fval),    // output wire m_axis_tvalid
  .m_axis_tready  (frdy),    // input wire m_axis_tready
  .m_axis_tdata   (fdat)      // output wire [15 : 0] m_axis_tdata
);


/*
rrc_float_signleRate_fp_0 rrc_float (
  .aclk               (clk  ),                  // input wire aclk
  .s_axis_data_tvalid (fval  ),  // input wire s_axis_data_tvalid
  .s_axis_data_tready (frdy  ),  // output wire s_axis_data_tready
  .s_axis_data_tdata  (fdat  ),  // input wire [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid (   ),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata  (   )   // output wire [39 : 0] m_axis_data_tdata
);

fir_compiler_0 rrc_int (
  .aclk               (clk  ),                  // input wire aclk
  .s_axis_data_tvalid (fval  ),  // input wire s_axis_data_tvalid
  .s_axis_data_tready (frdy  ),  // output wire s_axis_data_tready
  .s_axis_data_tdata  (fdat  ),  // input wire [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid (   ),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata  (   )   // output wire [39 : 0] m_axis_data_tdata
);
*/

logic [31:0] fdo;
logic signed [13:0] fd;

fir_rrc_float_0 fir_rrc_float (
  .aclk               (clk  ),                  // input wire aclk
  .s_axis_data_tvalid (fval  ),  // input wire s_axis_data_tvalid
  .s_axis_data_tready (frdy  ),  // output wire s_axis_data_tready
  .s_axis_data_tdata  (fdat  ),  // input wire [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid (     ),    // output wire m_axis_data_tvalid
  .m_axis_data_tdata  (fdo  )     // output wire [31 : 0] m_axis_data_tdata
);

assign fd = $signed(fdo[26:13]);

//rrc_float_0 rrc_float_0 (
//  .aclk               (clk  ),                  // input wire aclk
//  .s_axis_data_tvalid (fval  ),  // input wire s_axis_data_tvalid
//  .s_axis_data_tready (frdy  ),  // output wire s_axis_data_tready
//  .s_axis_data_tdata  (fdat  ),  // input wire [15 : 0] s_axis_data_tdata
//  .m_axis_data_tvalid (   ),  // output wire m_axis_data_tvalid
//  .m_axis_data_tdata  (   )   // output wire [39 : 0] m_axis_data_tdata
//);


endmodule