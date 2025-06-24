// file read - ADC data. auto detect hex ("0x"), otherwise signed decimal
module file_read #(
  parameter int DATA_WIDTH = 16,
  parameter bit CLKLESS = 0,
  parameter time PERIOD_NS = 10ns,
  parameter string FILE_NAME = "adc_data.txt"
)(
  input  logic clk,  // Used only if CLKLESS = 0
  output logic signed [DATA_WIDTH-1:0] data_out,
  output logic valid
);

  typedef logic signed [DATA_WIDTH-1:0] data_t;
  data_t mem[$];  // Dynamic array to store samples

  int fd;
  string line;
  int val;
  int lineno = 0;
  int is_hex = 0;


  // Load file once at start
  initial begin
    $display("Reading file: %s", FILE_NAME);
    fd = $fopen(FILE_NAME, "r");
    if (!fd) begin
      $error("Failed to open file: %s", FILE_NAME);
      $stop;
    end
//    int is_hex = 0;
    line = "";

    // Detect format from first non-empty line
    do begin
      void'($fgets(line, fd));
      line = tolower(line);
      line = trim(line);  // We'll define this next
    end while (line == "" && !$feof(fd));

    if (line.len() >= 2 && line.substr(0,2) == "0x") begin
      is_hex = 1;
      void'($sscanf(line, "%x", val));
    end else begin
      is_hex = 0;
      void'($sscanf(line, "%d", val));
    end
    mem.push_back(data_t'(val));
    lineno++;

    // Read the remaining lines using the detected format
    while (!$feof(fd)) begin
      line = "";
      void'($fgets(line, fd));
      line = trim(line);
      if (line == "") continue;

      if (is_hex)
        void'($sscanf(line, "%x", val));
      else
        void'($sscanf(line, "%d", val));

      mem.push_back(data_t'(val));
      lineno++;
    end

    $fclose(fd);
    $display("Loaded %0d samples from %s (%s format)",
             lineno, FILE_NAME, is_hex ? "hex" : "decimal");
  end

  // Clock-less mode output
  if (CLKLESS) begin : clkless_mode
    initial begin
      valid = 0;
      data_out = '0;
      foreach (mem[i]) begin
        #(PERIOD_NS);
        data_out = mem[i];
        valid = 1;
        #(1ns);  // Valid pulse
        valid = 0;
      end
    end
  end

  // Clocked mode output
  else begin : clk_mode
    int idx = 0;
    always_ff @(posedge clk) begin
      if (idx < mem.size()) begin
        data_out <= mem[idx];
        valid <= 1;
        idx++;
      end else begin
        valid <= 0;
      end
    end
  end


function string trim(input string s);
  int i;
  int first = 0, last = s.len() - 1;

  // Find first non-whitespace
  for (i = 0; i < s.len(); i++) begin
    if (s[i] != " " && s[i] != "\t" && s[i] != "\n" && s[i] != "\r") begin
      first = i;
      break;
    end
  end

  // Find last non-whitespace
  for (i = s.len() - 1; i >= 0; i--) begin
    if (s[i] != " " && s[i] != "\t" && s[i] != "\n" && s[i] != "\r") begin
      last = i;
      break;
    end
  end

  return s.substr(first, last - first + 1);
endfunction

function string tolower(input string s);
  string result = s;
  int i;
  for (i = 0; i < s.len(); i++) begin
    byte c = s[i];
    if (c >= "A" && c <= "Z") begin
      result[i] = c + 32;  // Convert to lowercase
    end
  end
  return result;
endfunction

endmodule

//-------------------------------------------------------------------------------------------------
// inst template
//-------------------------------------------------------------------------------------------------
/*

file_read #(
  .DATA_WIDTH(12),
  .CLKLESS(0),
  .PERIOD_NS(20ns),
  .FILE_NAME("/mnt/TDG_512/projects/2_zub_msk_udp_dma/sub/common/hdl/tb/adc_data.txt")
//  .FILE_NAME("adc_data.txt")
) file_read0 (
  .clk(clk),
  .data_out(adc_data),
  .valid(adc_valid)
);

*/