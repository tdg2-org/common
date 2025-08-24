


`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module axis_stim_syn #
(
  parameter int                         TDATA_NUM_BYTES   = 4,
  parameter [(TDATA_NUM_BYTES*8)-17:0]  FIXED             = 'h0
)(
  input                               clk		        ,
  input                               rst           ,
  input                               en            ,
  input                               clr           ,
  input                               cycle_i       ,
  input                               cont_i        , //continuous cycle no delay between packets
  input [7:0]                         frame_len     ,  
  output [(TDATA_NUM_BYTES*8)-1 : 0]  M_AXIS_tdata  ,
  output [3:0]                        M_AXIS_tdest  ,
  output [(TDATA_NUM_BYTES)-1 : 0]    M_AXIS_tkeep  ,
  output                              M_AXIS_tlast  ,
  input                               M_AXIS_tready ,
  output                              M_AXIS_tvalid
);

  localparam DATA_WIDTH = TDATA_NUM_BYTES*8;

  generate if (DATA_WIDTH % 8 != 0)
    initial $fatal("ERROR: %m DATA_WIDTH (%0d) must be a multiple of 8", DATA_WIDTH);
  endgenerate

  logic [7:0] cnt_max;
  assign cnt_max = (frame_len == '0) ? 8'hFF : frame_len;

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

logic [DATA_WIDTH-1 : 0]     tdata      , tdata2=0 ;
logic [3:0]                  tdest      , tdest2=0 ;
logic [(DATA_WIDTH/8)-1 : 0] tkeep='1   , tkeep2='1 ;
logic                        tlast      , tlast2=0;
logic                        tready     , tready2;
logic                        tvalid     , tvalid2=0;

assign M_AXIS_tdata   = tdata2 ;
assign M_AXIS_tdest   = tdest2 ;
assign M_AXIS_tkeep   = tkeep2 ;
assign M_AXIS_tlast   = tlast2 ;
assign M_AXIS_tvalid  = tvalid2;
assign tready = M_AXIS_tready;

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

  logic [7:0] cntr = 0, hiCnt=0;
  logic tdest_i = 1, en_stb, done=0, pkt_en=0, en_set,en_re, cont=0, cycle=0;
  logic [1:0] en_sr='0;

  always_ff @(posedge clk) begin 
    if (cntr == (cnt_max)) begin 
      cont <= cont_i;
      cycle <= cycle_i;
    end
  end

  always_ff @(posedge clk) begin 
    if (rst || !pkt_en || (cntr == cnt_max)) begin
      cntr    <= 0;
    end else if (tready) begin
      cntr <= cntr + 1;
      //if (cntr == (cnt_max)) begin 
      //  hiCnt <= hiCnt + 1; // not clearable
      //end
    end
  end

  always_ff @(posedge clk) begin 
    if (cntr == (cnt_max)) begin 
      hiCnt <= hiCnt + 1; // not clearable
    end
  end

  always_ff @(posedge clk) begin 
    if ((!cycle && cntr == cnt_max) || clr) begin 
      pkt_en <= '0;
    end else if (tready && ((cycle && en) || (!cycle && en_stb))) begin
      pkt_en <= '1;
    end
  end

  // changes on packet boundaries only
  always_ff @(posedge clk) begin 
    en_sr <= {en_sr[0],en};
    if (en_re) en_set <= '1;
    else if (en_set && cntr == cnt_max) en_set <= '0;
    //if (en_set && cntr == '0 && tready) en_stb <= '1;
    if (en_re && cntr == '0 && tready) en_stb <= '1;
    else en_stb <= '0;
  end

  assign en_re  = ((en_sr == 2'b01))? '1: '0; // rising edge detect
  //assign en_stb = ((en_sr == 2'b01))? '1: '0; // RE strobe

  assign tdata  = (!rst)? {FIXED,hiCnt,cntr}:'0;
  //assign tlast  = (tvalid && (cntr == cnt_max))? '1:0;
  assign tlast  = (pkt_en && (cntr == cnt_max))? '1:0;
  assign tdest  = {3'h0,tdest_i};
  //assign tvalid = (cycle && !cont && (hiCnt[0] == '0))? '0 : pkt_en;

  assign tvalid = (pkt_en && !cycle) || (pkt_en && cont && cycle) ||
                  (pkt_en && !cont && cycle && (hiCnt[0] == '0)) ? '1 : '0;
  
// Register signals before sending to IP!!!!!
// without this, there were issues with last word of frame
  always @(posedge clk) begin 
    if (tready) begin
      tdata2   <= tdata ;
      tdest2   <= tdest ;
      tkeep2   <= tkeep ;
      tlast2   <= tlast ;
      tvalid2  <= tvalid;
    end
  end

endmodule

/*

axis_stim_syn #
(
  .TDATA_NUM_BYTES(8),
  .FIXED()
) axis_stim_syn (
  .clk		        ()  ,
  .rst            ()  ,
  .en             ()  ,
  .clr            ()  ,
  .cycle          ()  , 
  .cont           ()  ,
  .M_AXIS_tdata   ()  ,
  .M_AXIS_tdest   ()  ,
  .M_AXIS_tkeep   ()  ,
  .M_AXIS_tlast   ()  ,
  .M_AXIS_tready  ()  ,
  .M_AXIS_tvalid  ()
);

*/