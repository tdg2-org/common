// Verilog wrapper

module led_cnt_wrapper (
  input         rst,
  input         clk100,
  input   [4:0] div_i,
  output        led_o
);
///////////////////////////////////////////////////////////////////////////////////////////////////


  led_cnt led_cnt_inst (
    .rst    (rst      ),
    .clk100 (clk100   ),
    .div_i  (div_i    ),
    .wren_i (1'b0     ),
    .led_o  (led_o    )
  );
/*

  led_cnt_vhd08 led_cnt_vhd08_inst(
    .rst        (rst    ),
    .clk        (clk100 ),
    .div_i      (div_i  ),
    .wren_i     (1'b0   ),
    .led_o      (led_o  )
  );


  led_cnt_vhd19 led_cnt_vhd19_inst(
    .rst        (rst    ),
    .clk        (clk100 ),
    .div_i      (div_i  ),
    .wren_i     (1'b0   ),
    .led_o      (led_o  )
  );
*/

endmodule