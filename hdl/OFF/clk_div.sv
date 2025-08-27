
module clk_div #(
  parameter DIV = 2
)(
  input   clk_i,
  output  clk_o
);

  BUFGCE_DIV #(
    .BUFGCE_DIVIDE(DIV), // 1-8
    // Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
    .IS_CE_INVERTED(1'b0), // Optional inversion for CE
    .IS_CLR_INVERTED(1'b0), // Optional inversion for CLR
    .IS_I_INVERTED(1'b0), // Optional inversion for I
    .SIM_DEVICE("ULTRASCALE_PLUS") // ULTRASCALE, ULTRASCALE_PLUS
  ) BUFGCE_DIV_inst (
    .O(clk_o), // 1-bit output: Buffer
    .CE('1), // 1-bit input: Buffer enable
    .CLR('0), // 1-bit input: Asynchronous clear
    .I(clk_i) // 1-bit input: Buffer
  );


endmodule