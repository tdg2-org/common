`timescale 1ns / 1ps  // <time_unit>/<time_precision>

// on data_val:
// sr shifts in per bit
// srh shifts in per 4-bits

module shifter_viewer # (
  parameter int             FDW = '0,
  parameter logic [FDW-1:0] FIXED_DATA = '0,
  parameter int             WIDTH = 32
)(
  input clk,
  input rst,
  input data_i,
  input data_val_i,
  output [WIDTH-1:0] sr_o
);

  int cnt = 0;
  logic [WIDTH-1:0] sr, srh0='0, srh1='0, srh2='0, srh3='0;
  logic nibble, full;
  logic [7:0]  sr8  ;
  logic [15:0] sr16 ;
  logic [31:0] sr32 ;

  always_ff @(posedge clk) begin 
    if (rst) begin 
      cnt     <= 0;
      sr      <= '0;
      nibble  <= '0;
      full    <= '0;
    end else if (data_val_i) begin 
      sr <= {sr[WIDTH-2:0],data_i};
      if (cnt < (WIDTH-1)) begin 
        cnt   <= cnt + 1;
        full  <= '0;
      end else begin 
        cnt   <= 0;
        full  <= '1; // strobe every max fill
      end
      
      nibble <= '0;
      if (cnt % 4 == 0) begin 
        nibble <= '1;
        srh0 <= {srh0[WIDTH-4:0],sr[3:0]};
        srh1 <= {srh1[WIDTH-4:0],sr[4:1]};
        srh2 <= {srh2[WIDTH-4:0],sr[5:2]};
        srh3 <= {srh3[WIDTH-4:0],sr[6:3]};
      end
    end
  end

  assign sr8  = sr[7:0]   ;
  assign sr16 = sr[15:0]  ;
  assign sr32 = sr[31:0]  ;

  assign sr_o = sr;

//-------------------------------------------------------------------------------------------------
// check against FIXED_DATA
//-------------------------------------------------------------------------------------------------
  localparam logic [FDW*2 - 1:0] FIXED_WRAP = {FIXED_DATA, FIXED_DATA}; // Doubled for wraparound matching
  localparam DATA_CHECK_EN = (FIXED_DATA == '0 && FDW =='0) ? '0 : '1;
  //localparam int FIXED_WIDTH = $bits(FIXED_DATA);

generate if (DATA_CHECK_EN) begin 
  
    logic [127:0] srh [3:0];
    logic [3:0] pattern_match, pattern_match_raw;
    
    assign srh[0] = srh0;
    assign srh[1] = srh1;
    assign srh[2] = srh2;
    assign srh[3] = srh3;

    always_comb begin
      for (int n = 0; n <= 3; n++) begin 
        pattern_match_raw[n] = 1'b0;
        for (int i = 0; i <= 256; i++) begin
          if (srh[n] == FIXED_WRAP[255+i -: 128]) begin
            pattern_match_raw[n] = 1'b1;
          end
        end
      end
    end

    always_ff @(posedge clk) begin
      for (int n = 0; n <= 3; n++)  pattern_match[n] <= pattern_match_raw[n];
    end

end endgenerate

endmodule
/*

shifter_viewer # (
  .CHECK_DATA (0),
  .FDW        (),
  .FIXED_DATA (),
  .WIDTH      (64)
) shifter_viewer_inst (
  .clk      (),
  .rst      (),
  .data     (),
  .data_val (),
  .sr_o     ()
);

*/