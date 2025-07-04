
// on data_val:
// sr shifts in per bit
// srh shifts in per 4-bits

module shifter_viewer # (
  parameter WIDTH = 32
)(
  input clk,
  input rst,
  input data_i,
  input data_val_i
  //output [WIDTH-1:0] sr_o, srh_o
);

  int cnt = 0;
  logic [WIDTH-1:0] sr, srh0='0, srh1='0, srh2='0, srh3='0;
  logic nibble, full;

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

  //assign sr_o = sr;
  //assign srh_o = srh;

endmodule
/*

shifter_viewer # (
  .WIDTH(64)
) shifter_viewer_inst (
  .clk      (),
  .rst      (),
  .data     (),
  .data_val (),
  .sr_o     (),
  .srh_o    ()
);

*/