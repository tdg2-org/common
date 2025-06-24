// file read - ADC data. auto detect hex ("0x"), otherwise signed decimal
module file_read_simple #(
  parameter int DATA_WIDTH = 16,
  parameter bit CLKLESS = 0,
  parameter time PERIOD_NS = 10ns,
  parameter string DATA_FORMAT = "hex", // hex,dec,bin
  parameter string FILE_NAME = "adc_data.txt"
)(
  input  logic clk,  // Used only if CLKLESS = 0
  output logic signed [DATA_WIDTH-1:0] data_out,
  output logic valid
);

  integer fid, sid; 
  logic [DATA_WIDTH-1:0] captured_data=0;

  if (!(DATA_FORMAT == "hex" || DATA_FORMAT == "dec" || DATA_FORMAT == "bin")) begin
    $fatal(1, "Invalid DATA_FORMAT: '%s'. Must be 'hex', 'dec', or 'bin'.", DATA_FORMAT);
  end

  logic [1:0] fmt;
  assign fmt =  (DATA_FORMAT == "hex") ? 'h0 : 
                (DATA_FORMAT == "bin") ? 'h1 : 
                (DATA_FORMAT == "dec") ? 'h2 : 'h3; // 3 wont happen
                
  initial begin
    fid = $fopen(FILE_NAME, "r");
    if (!fid) begin
      $display("data_file handle was NULL");
      $finish;
    end
  end

  always @(posedge clk) begin
    case (fmt) 
      'h0 : sid = $fscanf(fid, "%x\n", data_out);    
      'h1 : sid = $fscanf(fid, "%b\n", data_out);
      'h2 : sid = $fscanf(fid, "%d\n", data_out);
      default: $fatal(1, "DUMMY: %s", DATA_FORMAT);
    endcase 
    if (!$feof(fid)) begin
      //use captured_data as you would any other wire or reg value;
    end
  end

  //assign data_out = captured_data;

endmodule

//-------------------------------------------------------------------------------------------------
// inst template
//-------------------------------------------------------------------------------------------------
/*

file_read_simple #(
  .DATA_WIDTH(12),
  .CLKLESS(0),
  .PERIOD_NS(20ns),
  .DATA_FORMAT("hex"),
  .FILE_NAME("/mnt/TDG_512/projects/2_zub_msk_udp_dma/sub/common/hdl/tb/adc_data.txt")
//  .FILE_NAME("adc_data.txt")
) file_read0 (
  .clk(clk),
  .data_out(adc_data),
  .valid(adc_valid)
);

*/