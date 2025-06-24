// file read - ADC data. auto detect hex ("0x"), otherwise signed decimal
module file_read_tb;

  logic clk=0;

  always #2.5ns clk = ~clk; // 5 ns period (200 MHz)

file_read_simple #(
  .DATA_WIDTH(16),
  .CLKLESS(1),
  .PERIOD_NS(20ns),
  .DATA_FORMAT("hex"),
  .FILE_NAME("/mnt/TDG_512/projects/2_zub_msk_udp_dma/sub/common/hdl/tb/adc_data.txt")
//  .FILE_NAME("adc_data.txt")
) file_read0 (
  .clk(clk),
  .data_out(),
  .data_val()
);

file_read_simple #(
  .DATA_WIDTH(16),
  .CLKLESS(0),
  .PERIOD_NS(20ns),
  .DATA_FORMAT("dec"),
  .FILE_NAME("/mnt/TDG_512/projects/2_zub_msk_udp_dma/sub/common/hdl/tb/adc_data_d.txt")
//  .FILE_NAME("adc_data.txt")
) file_read0d (
  .clk(clk),
  .data_out(),
  .data_val()
);

file_read_simple #(
  .DATA_WIDTH(16),
  .CLKLESS(0),
  .PERIOD_NS(20ns),
  .DATA_FORMAT("bin"),
  .FILE_NAME("/mnt/TDG_512/projects/2_zub_msk_udp_dma/sub/common/hdl/tb/adc_data_b.txt")
//  .FILE_NAME("adc_data.txt")
) file_read0b (
  .clk(clk),
  .data_out(),
  .data_val()
);


endmodule
