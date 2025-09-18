
//   X[k] = SUM{n=0 to N-1} x[n] * e(-j * 2pi/N * k * n), k=0,1,...,N-1 

// twiddle factor
//  e(-j * 2*pi/N * k *n) = W{N,kn} = cos(2pi/N * k * n) - j * sin(2pi/N * k * n)


module sin_gen_mdl #(
  parameter int N   = 64  ,
  parameter int SW  = 16    
)(
  input             rst     ,
  input             clk     ,
  output [SW-1:0]   sin_o   ,
  output [SW-1:0]   cos_o   ,
  output            val     
);

///////////////////////////////////////////////////////////////////////////////////////////////////
  //localparam int N = 32;
  localparam real PI = 3.141592653589793;
  real theta [0:N-1];

  initial begin
    for (int i = 0; i < N; i++) begin
      theta[i] = (2.0 * PI * i) / N;
    end
  end

///////////////////////////////////////////////////////////////////////////////////////////////////
  localparam int FRAC_BITS  = 15;
  localparam int SCALE      = (1 << FRAC_BITS) - 1;
  
  logic signed [15:0] sin_table [0:N-1]; // Q1.15 fixed-point
  logic signed [15:0] cos_table [0:N-1]; // Q1.15 fixed-point

  initial begin 
    real theta, cval, sval;
    int sfixed, cfixed;
    for (int i = 0; i < N; i++) begin
      theta = (2.0 * PI * i) / N;
      sval   = $sin(theta);
      cval   = $cos(theta);
      sfixed = $rtoi(sval * SCALE); // scale & convert
      cfixed = $rtoi(cval * SCALE); // scale & convert
      sin_table[i] = sfixed;      // store in Q1.15
      cos_table[i] = cfixed;      // store in Q1.15
    end
  end

  logic [SW-1:0] sin_pre='0, cos_pre=32767;
  int cnt2=0;
  logic val_pre = 0;
  always_ff @( posedge clk ) begin 
    sin_pre <= sin_table[cnt2];
    cos_pre <= cos_table[cnt2];
    if (cnt2 == (N-1)) cnt2 <= 0;
    else cnt2 <= cnt2 + 1;
    val_pre <= 1;
  end

  assign sin_o = sin_pre;
  assign cos_o = cos_pre;
  assign val = val_pre;


endmodule

/*

  sin_gen_mdl sin_gen_mdl_i(
    .rst    (rst  ),
    .clk    (clk  ),
    .sin_o  (     ),
    .cos_o  (     ),
    .x      (     ),
    .wren_i (     ),
    .led_o  (     ) 
  );

*/