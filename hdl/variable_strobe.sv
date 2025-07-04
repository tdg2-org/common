


module variable_strobe # (
  //parameter WID = 20,
  parameter PTR = 0
)(
  input   clk,
  input   rst,
  input   en_i, 
  output  stb_o
);

  int pntr = PTR; // gives ability to force in simulation

  int cnt=0;
  logic [19:0] sr='0;
  logic cnt_stb='0, sym_val_dbg;

  always_ff @(posedge clk) begin
    if (en_i) begin 
      cnt_stb <= '0;
      if (cnt == 19) begin 
        cnt     <= 0;
        cnt_stb <= '1;
      end else cnt <= cnt + 1;
      sr <= {sr[18:0],cnt_stb};
    end 
  end
  
  assign stb_o =(pntr == 0)  ? sr[0] :
                (pntr == 1)  ? sr[1] :
                (pntr == 3)  ? sr[3] :
                (pntr == 4)  ? sr[4] :
                (pntr == 5)  ? sr[5] :
                (pntr == 6)  ? sr[6] :
                (pntr == 7)  ? sr[7] :
                (pntr == 8)  ? sr[8] :
                (pntr == 9)  ? sr[9] :
                (pntr == 10) ? sr[10] :
                (pntr == 11) ? sr[11] :
                (pntr == 12) ? sr[12] :
                (pntr == 13) ? sr[13] :
                (pntr == 14) ? sr[14] :
                (pntr == 15) ? sr[15] :
                (pntr == 16) ? sr[16] :
                (pntr == 17) ? sr[17] :
                (pntr == 18) ? sr[18] :
                (pntr == 19) ? sr[19] : '0;


endmodule
/*

variable_strobe # (
  .PTR()
) variable_strobe_inst (
  .clk    (),
  .rst    (),
  .en_i   (),
  .stb_o  ()
);


variable_strobe # (.PTR()) 
variable_strobe_inst (
  .clk(clk),.rst(rst),
  .en_i(),
  .stb_o());


*/