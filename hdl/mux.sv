module mux #(
  parameter N = 4
)(
  input   clk,
  input   rst,
  input   logic [N-1:0]         data_i  ,
  input   logic [$clog2(N)-1:0] sel_i   ,   
  output  logic                 out
);

  //always_comb begin
  //  case (sel_i)
  //    default: out = data_i[0]; // Default case for safety
  //    foreach (data_i[i]) out = (sel_i == i) ? data_i[i] : out;
  //  endcase
  //end

  always_comb begin
    out = data_i[0]; // Default value
    for (int i = 0; i < N; i++) begin
      if (sel_i == i)
        out = data_i[i];
    end
  end

//---------------------------------------------------------------------
  logic [7:0] dsr, dsr_o;
  
  always_ff @(clk) begin
    if (rst) dsr  <= '0;
    else dsr      <= {dsr[6:0],data_i[0]};
  end

  assign dsr_o = dsr;

endmodule