
module diff_ibuf_bufg #(
  parameter DIV = 2
)(
  input   clk_n,
  input   clk_p,
  output  clk_o
);


  IBUFDS IBUFDS_inst (
     .O(clk),   // 1-bit output: Buffer output
     .I(clk_p),   // 1-bit input: Diff_p buffer input (connect directly to top-level port)
     .IB(clk_n)  // 1-bit input: Diff_n buffer input (connect directly to top-level port)
  );

  BUFG BUFG_inst (
     .O(clk_o), // 1-bit output: Clock output.
     .I(clk)  // 1-bit input: Clock input.
  );



endmodule