`timescale 1ns / 1ps  // <time_unit>/<time_precision>

/* file read

Vivado 2025.1: file read operation ($fopen) occurs from the 'PROJECT/PROJECT.sim/sim_1/bevah/xsim' directory

  directory structure:
    repo/VIVADO_PROJECT/VIVADO_PROJECT.sim/sim_1/bevah/xsim

  read file path:
    repo/FILE_DIR/FILE_NAME

    {"../../../../../", FILE_DIR, FILE_NAME}


-----------------------------------------------------------
QUESTA/MODELSIM, add the following, to be updated later:
  need to make this universal to vivado/questa

  ifdef/ifndef

`ifndef QUESTA
  `ifndef MODELSIM
    //code to igore in simulation automatically in questa/modelsim
  `endif
`endif

`ifdef QUESTA
  //questa stuff
`elsif MODELSIM
  //modelsim stuff
`else 
  //xilinx stuff
`endif

*/
module file_read_simple #(
  parameter int DATA_WIDTH = 16,
  parameter bit CLKLESS = 0,
  parameter time PERIOD_NS = 10ns,
  parameter time START_DELAY = 200ns,
  parameter string DATA_FORMAT = "hex", // hex,dec,bin
  parameter string FILE_DIR = "sub/common/hdl/tb/data/", // must have trailing slash
  parameter string FILE_NAME = "adc_data.dat"
)(
  input  clk,  // Used only if CLKLESS = 0
  input  rst,
  output logic signed [DATA_WIDTH-1:0] data_out,
  output logic data_val
);

  integer fid, sid; 
  logic [DATA_WIDTH-1:0] data=0;
  logic valid = 0;

  if (!(DATA_FORMAT == "hex" || DATA_FORMAT == "dec" || DATA_FORMAT == "bin")) begin
    $fatal(1, "Invalid DATA_FORMAT: '%s'. Must be 'hex', 'dec', or 'bin'.", DATA_FORMAT);
  end

  logic [1:0] fmt;
  assign fmt =  (DATA_FORMAT == "hex") ? 'h0 : 
                (DATA_FORMAT == "bin") ? 'h1 : 
                (DATA_FORMAT == "dec") ? 'h2 : 'h3; // 3 wont happen

  
  `ifdef QUESTA
    localparam string FNAME = {"../", FILE_DIR, FILE_NAME}; // questa/modelsim
  `elsif MODELSIM
    localparam string FNAME = {"../", FILE_DIR, FILE_NAME}; // questa/modelsim
  `else 
    localparam string FNAME = {"../../../../../", FILE_DIR, FILE_NAME}; // xilinx sim
  `endif

  string dummy="";              
  initial begin
    wait (rst == 1);
    #(START_DELAY);
    fid = $fopen(FNAME, "r");
    if (!fid) begin
      $display("data_file handle was NULL");
      $finish;
    end
    void'($fgets(dummy, fid));     // NEW: read & discard the first line
  end

  if (CLKLESS) begin 
    initial begin 
      valid = 0;
      wait (rst == 1);
      #(START_DELAY);
      wait (fid != 0); // wait til valid to avoid errors/warnings
      $display("fid open1");
      wait (dummy != "");
      #(PERIOD_NS);
      while (!$feof(fid)) begin
        case (fmt) 
          'h0 : sid = $fscanf(fid, "%x\n", data);    
          'h1 : sid = $fscanf(fid, "%b\n", data);
          'h2 : sid = $fscanf(fid, "%d\n", data);
          default: $fatal(1, "DUMMY: %s", DATA_FORMAT);
        endcase 
        valid = 1;
        #(PERIOD_NS);
      end
      //valid = 0;// comment this out to leave valid high forever
    end 
  end else begin   
    always @(posedge clk) begin
      //if (!$feof(fid)) begin
      if (fid != 0) begin 
        if ((!$feof(fid)) && (dummy != "")) begin // after file open and first comment line is done. valid aligned to first data sample
          case (fmt) 
            'h0 : sid = $fscanf(fid, "%x\n", data);    
            'h1 : sid = $fscanf(fid, "%b\n", data);
            'h2 : sid = $fscanf(fid, "%d\n", data);
            default: $fatal(1, "DUMMY: %s", DATA_FORMAT);
          endcase 
          valid <= 1;
        end else begin
          //valid <= 0; // comment this out to leave valid high forever
        end
      end
    end  
  end 

  assign data_val = valid;
  assign data_out = data;

endmodule

//-------------------------------------------------------------------------------------------------
// inst template
//-------------------------------------------------------------------------------------------------
/*

file_read_simple #(
  .DATA_WIDTH(12),
  .CLKLESS(0),
  .PERIOD_NS(),
  .START_DELAY(),
  .DATA_FORMAT("hex"),
  .FILE_DIR("sub/common/hdl/tb"),
//  .FILE_NAME("/mnt/TDG_512/projects/2_zub_msk_udp_dma/sub/common/hdl/tb/adc_data.txt")
  .FILE_NAME("adc_data.txt")
) file_read0 (
  .rst(),
  .clk(),
  .data_out(),
  .valid()
);

*/