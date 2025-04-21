

`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module i2c_top (
  input       clk     ,
  input       clk12     ,
  input       rst     ,
  output [63:0] git_hash_top,
  output [31:0] timestamp_top,
  input  [16:0] i2c_send_data_i,
  input       scl0_i  ,
  input       scl0_t  ,
  output      scl0_o  ,
  input       sda0_i  ,
  output      sda0_o  ,
  input       sda0_t  ,
  input       scl1_i  ,
  input       scl1_t  ,
  output      scl1_o  ,
  input       sda1_i  ,
  output      sda1_o  ,
  input       sda1_t  
//  input       S_BSCAN_drck        ,
//  input       S_BSCAN_shift       ,
//  input       S_BSCAN_tdi         ,
//  input       S_BSCAN_update      ,
//  input       S_BSCAN_sel         ,
//  output      S_BSCAN_tdo         ,
//  input       S_BSCAN_tms         ,
//  input       S_BSCAN_tck         ,
//  input       S_BSCAN_runtest     ,
//  input       S_BSCAN_reset       ,
//  input       S_BSCAN_capture     ,
//  input       S_BSCAN_bscanid_en  
);

`ifndef QUESTA
`ifndef MODELSIM
  user_init_64b top_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_top)
  );

  user_init_32b top_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_top)
  );
`endif
`endif 

(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "TRUE" *) i2c_sink i2c_sink_inst (
    .clk            (clk                  ),
    .clk12          (clk12                ),
    .rst            (rst                  ),
    .data_send_en_i (i2c_send_data_i[16]  ),
    .data_send_i    (i2c_send_data_i[15:0]),
    .scl_i          (scl0_i               ),
    .scl_t          (scl0_t               ),
    .scl_o          (scl0_o               ),
    .sda_i          (sda0_i               ),
    .sda_o          (sda0_o               ),
    .sda_t          (sda0_t               )
  );
  
//(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "TRUE" *) i2c_sink i2c_sink_inst2 (
//    .clk    (clk    ),
//    .rst    (rst    ),
//    .scl_i  (scl1_i ),
//    .scl_t  (scl1_t ),
//    .scl_o  (scl1_o ),
//    .sda_i  (sda1_i ),
//    .sda_o  (sda1_o ),
//    .sda_t  (sda1_t )
//  );

/*
  logic scl,sda, scl_re,scl_fe,sda_re,sda_fe, clk12, scl_o, sda_o;
  logic [1:0] scl_sr, sda_sr;
  logic [4:0] cnt, sm_dbg;

//  clk_div #(
//    .DIV(8)
//  ) clk_div_inst (
//    .clk_i (clk100),
//    .clk_o (clk12) // 12.5M
//  );

  typedef enum {
    IDLE, SCLRE, CNTST, DLY
  } i2c_sm_type;

  i2c_sm_type I2C_SM;


  assign scl_re = (scl_sr == 2'b01) ? 1:0;
  assign sda_re = (sda_sr == 2'b01) ? 1:0;
  assign scl_fe = (scl_sr == 2'b10) ? 1:0;
  assign sda_fe = (sda_sr == 2'b10) ? 1:0;

  always_ff @(posedge clk12) begin 
    scl_sr <= {scl_sr[0], scl1_t};
    sda_sr <= {sda_sr[0], sda1_t};
    //if (scl_re) begin
    //  if (cnt == 9) cnt <= 0;
    //  else cnt <= cnt + 1;
    //end
  end

  always_ff @(posedge clk12) begin 
    case (I2C_SM) 
      IDLE: begin 
        cnt <= 0; 
        if (sda_fe) I2C_SM <= SCLRE;
      end
      SCLRE: if (scl_fe) I2C_SM <= CNTST; 
      CNTST: begin 
        if (scl_re) begin
          //if (cnt == 9) I2C_SM <= DLY;
          if (cnt == 18) I2C_SM <= DLY;
          else cnt <= cnt + 1;
        end
      end
      DLY: if (scl_sr==2'b11 && sda_sr==2'b11)  I2C_SM <= IDLE;
    endcase
  end


  always_comb begin
    if (scl1_t) scl <= '1;
    else        scl <= '0;

    if (sda1_t) sda <= '1;
    else        sda <= '0;

  end
  
  // T = high -> output buffer DISABLED

  //assign sda_o = sda_i;
  //assign scl_o = scl_i;

  //assign sda1_o = sda;
  assign sda_o = (cnt == 8 || cnt == 9 || cnt == 17 || cnt == 18) ? 0 : sda;
  assign scl_o = scl;

  assign sda1_o = sda_o;
  assign scl1_o = scl_o;

//logic responder_scl_drive_low=1;
//logic responder_sda_drive_low=1;
//
//// Emulate open-drain using logical AND (active low):
//assign scl = (scl1_t ? 1'b1 : scl1_i) & (responder_scl_drive_low ? 1'b0 : 1'b1);
//assign sda = (sda1_t ? 1'b1 : sda1_i) & (responder_sda_drive_low ? 1'b0 : 1'b1);

assign sm_dbg = (I2C_SM == IDLE)  ? 1 : 
                (I2C_SM == SCLRE) ? 2 : 
                (I2C_SM == CNTST) ? 3 :
                (I2C_SM == DLY)   ? 4 : 0;


`ifndef QUESTA
`ifndef MODELSIM
ila2 ila2 (
	.clk(clk12), // input wire clk
	.probe0({3'b0,cnt}    ),  // input wire [7:0]  probe0  
	.probe1({2'b0,sm_dbg,scl_sr} ),  // input wire [7:0]  probe1
	.probe2({0,0,scl1_i,scl1_t,scl_o,sda1_i,sda_o,sda1_t} ),  // input wire [7:0]  probe1
  .probe3(scl_re        ),
  .probe4('0            )
);
`endif
`endif 

*/

endmodule

