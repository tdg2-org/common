
module fifo #(
  parameter DWIDTH  = 32,
  parameter DEPTH   = 32,
  parameter FWFT    = 1
)(
  input   logic               clk     ,
  input   logic               rst     ,
  
  input   logic [DWIDTH-1:0]  data_i  ,
  input   logic               wr      ,
  output  logic               full_o  ,
  
  output  logic [DWIDTH-1:0]  data_o  ,
  input   logic               rd      ,
  output  logic               empty_o
);

  logic [DWIDTH-1:0] data_mem [DEPTH-1:0];
  logic [DWIDTH-1:0] data_out;
  logic full,empty,full2,full_stb;

  int wr_idx=0,rd_idx=0,mem_used;

  always_ff @(posedge clk) begin 
    if (rst) begin 
      wr_idx <= 0;
      rd_idx <= 0;
    end else begin 

      if (wr && !full) begin 
        if (wr_idx == (DEPTH-1)) wr_idx <= 0;
        else wr_idx <= wr_idx + 1;
      end 

      if (rd && !empty) begin 
        if (rd_idx == (DEPTH-1)) rd_idx <= 0;
        else rd_idx <= rd_idx + 1;
      end 

      if (wr && !full)        mem_used <= mem_used + 1;
      else if (rd && !empty)  mem_used <= mem_used - 1;

    end
  end

  always_comb begin
    if (wr && !full) data_mem[wr_idx] <= data_i;
  end

  assign full     = (mem_used == (DEPTH)) ? 1:0;
  assign empty    = ((wr_idx == rd_idx) && !full) ? 1:0;
  assign data_out = (!empty) ? data_mem[rd_idx] : data_out;

  assign full_o   = full;
  assign empty_o  = empty;
  assign data_o   = data_out;

endmodule
