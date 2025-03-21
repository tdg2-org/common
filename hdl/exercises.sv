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
  
  always_ff @(posedge clk) begin
    if (rst) dsr  <= '0;
    else dsr      <= {dsr[6:0],data_i[0]};
  end

  assign dsr_o = dsr;

endmodule

module demux #(
  parameter N = 4
)(
  input   clk,
  input   rst,
  output  logic [N-1:0]         data_o  ,
  input   logic [$clog2(N)-1:0] sel_i   ,   
  input   logic                 data_i
);

  logic [N-1:0] data_out='0; 

  always_comb begin
    for (int i = 0; i < N; i++) begin
      if (sel_i == i)
        data_out[i] = data_i;
    end
  end

  assign data_o = data_out;

endmodule

module cnt #(
  parameter N = 4
)(
  input   clk,
  input   rst,
  input   en,
  output  logic [N-1:0] count  
);

  logic [N-1:0] cnt;

  always_ff @(posedge clk) begin
    if (rst) cnt <= '0;
    else if (en) cnt <= cnt + 1;
  end

  assign count = cnt;

endmodule

module pwm #(
  parameter PERIOD    = 10,
  parameter DUTYCYCLE = 4
)(
  input   clk   ,
  input   rst   ,
  input   en    ,
  output  sig  
);

  logic [$clog2(PERIOD)-1:0] cnt;

  always_ff @(posedge clk) begin
    if (rst) cnt <= '0;
    else begin 
      if (en) begin 
        if (cnt == PERIOD-1) cnt <= '0;
        else cnt <= cnt + 1;
      end 
    end 
  end 

  assign sig = (cnt < DUTYCYCLE) ? 1:0;


endmodule

module priority_encoder #(
  parameter N = 4
)(
  input   clk,
  input   rst,
  input   logic [N-1:0]         data_i  , // must be one-hot
  output  logic [$clog2(N)-1:0] data_o   
);

  assign data_o[1] = data_i[2] || data_i[3];
  assign data_o[0] = data_i[1] || data_i[3];


endmodule

module debounce #(
  parameter N = 4
)(
  input   clk,
  input   rst,
  input   sig_i,
  output  sig_o
);

  logic [N-1:0] cnt;

  always_ff @(posedge clk) begin
    if (rst) begin 
      cnt <= 0;
    end else begin 
      if (sig_i && !(&cnt)) cnt <= cnt + 1;
      else if (!sig_i)      cnt <= 0;
    end
  end 

  assign sig_o = &cnt;

endmodule


import exercise_pkg::*;

module traffic #(
  parameter Num = 4
)(
  input   clk,
  input   rst,
  input   sens_type   sensors,
  output  tlight_type lightE,
  output  tlight_type lightW,
  output  tlight_type lightN,
  output  tlight_type lightS
);


//sm
  typedef enum {
    IDLE,S,N,E,W,GRN,YEL,RED
  } traf_sm_type;

  traf_sm_type TSM;
  sens_type sens;
  tlight_type le,lw,ln,ls;

  assign sens = sensors;

  logic grn_done, yel_done, yel_en, grn_en;

  always_ff @(posedge clk) begin 
    if (rst) begin 
      ls.grn <= '0;ln.grn <= '0;lw.grn <= '0;le.grn <= '0;
      ls.yel <= '0;ln.yel <= '0;lw.yel <= '0;le.yel <= '0;
      ls.red <= '1;ln.red <= '1;lw.red <= '1;le.red <= '1;
    end else begin 
      case (TSM) 
        default : TSM <= IDLE;
        IDLE : begin 
          if      (sens.e) TSM <= E;
          else if (sens.w) TSM <= W;
          else if (sens.n) TSM <= N;
          else if (sens.s) TSM <= S;
        end
        E : begin 
          le.grn <= '1;le.red <= '0;
          if ((grn_done) && (sens.s || sens.w || sens.n)) begin 
            le.grn  <= '0;
            le.yel  <= '1;
            yel_en  <= '1;
            if (yel_done) begin 
              le.red  <= '1;
              le.yel  <= '0;
              yel_en  <= '0;grn_en  <= '0;
              if      (sens.s) TSM <= S;
              else if (sens.w) TSM <= W;
              else if (sens.n) TSM <= N;
            end 
          end else 
            grn_en <= '1;
        end
        W : begin 
          lw.grn <= '1;lw.red <= '0;
          if ((grn_done) && (sens.e || sens.s || sens.n)) begin 
            lw.grn  <= '0;
            lw.yel  <= '1;
            yel_en  <= '1;
            if (yel_done) begin 
              lw.red  <= '1;
              lw.yel  <= '0;
              yel_en  <= '0;grn_en  <= '0;
              if      (sens.e) TSM <= E;
              else if (sens.s) TSM <= S;
              else if (sens.n) TSM <= N;
            end
          end else 
            grn_en <= '1;
        end
        N : begin 
          ln.grn <= '1;ln.red <= '0;
          if ((grn_done) && (sens.e || sens.w || sens.s)) begin 
            ln.grn  <= '0;
            ln.yel  <= '1;
            yel_en  <= '1;
            if (yel_done) begin 
              ln.red  <= '1;
              ln.yel  <= '0;
              yel_en  <= '0;grn_en  <= '0;
              if      (sens.s) TSM <= S;
              else if (sens.w) TSM <= W;
              else if (sens.e) TSM <= E;
            end
          end else 
            grn_en <= '1;
        end
        S : begin 
          ls.grn <= '1;ls.red <= '0;
          if ((grn_done) && (sens.e || sens.w || sens.n)) begin 
            ls.grn  <= '0;
            ls.yel  <= '1;
            yel_en  <= '1;
            if (yel_done) begin 
              ls.red  <= '1;
              ls.yel  <= '0;
              yel_en  <= '0;grn_en  <= '0;
              if      (sens.e) TSM <= E;
              else if (sens.w) TSM <= W;
              else if (sens.n) TSM <= N;
            end
          end else 
            grn_en <= '1;
        end

      endcase
    end
  end

  int cnt,cnty;

  always_ff @(posedge clk) begin 
    if (rst) begin 
      grn_done  <= 0;
      yel_done  <= 0;
      cnt <= 0;
      cnty <= 0;
    end else begin 
      if (grn_en) begin 
        if (cnt == 20)  grn_done <= 1;
        else            cnt <= cnt + 1;
      end else begin 
        cnt       <= 0;
        grn_done  <= 0;
      end

      if (yel_en) begin  
        if (cnty == 6)  yel_done  <= 1;
        else            cnty <= cnty + 1;
      end else begin 
        cnty      <= 0;
        yel_done  <= 0;
      end
    end
  end

endmodule

